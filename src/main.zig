const std = @import("std");
const fs = std.fs;
const mem = std.mem;
const testing = std.testing;
const expect = std.testing.expect;

const yuyv = @import("from_yuyv.zig");
const nv12 = @import("from_nv12.zig");
const i422a = @import("from_i422.zig");
const pip = @import("set_pipe_size.zig");

pub fn main() !void {
    var isPipe = false;
    const alc = std.heap.page_allocator;
    const args = try std.process.argsAlloc(alc);
    defer std.process.argsFree(alc, args);

    if (args.len < 5) {
        std.debug.print("Usage: {s} input_file output_file width height pixelformat\n", .{args[0]});
        std.os.exit(1);
    }
    var infile = try std.fs.cwd().openFile(args[1], .{});
    defer infile.close();
    var outfile = try std.fs.cwd().createFile(args[2], .{});
    defer outfile.close();
    if (try pip.isPipe(outfile.handle)) {
        isPipe = true;
        try pip.setPipeMaxSize(outfile.handle);
    }

    const width = try std.fmt.parseInt(u32, args[3], 10);
    const height = try std.fmt.parseInt(u32, args[4], 10);
    const pixel_format = args[5];

    var output_data = try alc.alloc(u8, width * height * 3 / 2);
    defer alc.free(output_data);

    var fmt = try alc.alloc(u8, pixel_format.len);
    defer alc.free(fmt);
    fmt = std.ascii.upperString(fmt, pixel_format);
    var f: *const fn ([]const u8, []u8, u32, u32) void = undefined;
    var input_data: []u8 = undefined;

    if (std.mem.eql(u8, fmt, "YUYV")) {
        input_data = try alc.alloc(u8, width * height * 2);
        f = yuyv.yuyvToI420;
    } else if (std.mem.eql(u8, fmt, "NV12")) {
        input_data = try alc.alloc(u8, width * height * 3 / 2);
        f = nv12.nv12ToI420;
    } else if (std.mem.eql(u8, fmt, "YUV422") or std.mem.eql(u8, fmt, "I422")) {
        input_data = try alc.alloc(u8, width * height * 2);
        f = i422a.i422ToI420;
    } else {
        std.log.err("Doesn't support {s}", .{pixel_format});
        std.os.exit(1);
    }
    defer alc.free(input_data);

    while (true) {
        if (try infile.readAll(input_data) != input_data.len) {
            break;
        }
        f(input_data, output_data, width, height);
        outfile.writeAll(output_data) catch |err| {
            if (err == error.BrokenPipe) {
                break;
            } else {
                return err;
            }
        };
    }
}
