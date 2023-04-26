const std = @import("std");

pub fn yuyvToI420(yuyv_data: []const u8, yuv420_data: []u8, width: u32, height: u32) void {
    if (width & 1 != 0 or height & 1 != 0) {
        std.log.err("width and hight must be even number: width={d}, height={d}", .{ width, height });
        unreachable;
    }
    const y_plane = yuv420_data[0..(width * height)];
    const u_plane = yuv420_data[(width * height)..(width * height + width * height / 4)];
    const v_plane = yuv420_data[(width * height + width * height / 4)..];

    var uv_idx: usize = 0;

    var y: usize = 0;
    while (y < height) : (y += 2) {
        var x: usize = 0;
        while (x < width) : (x += 2) {
            const yuyv_idx = (y * width + x) * 2;

            y_plane[y * width + x] = yuyv_data[yuyv_idx];
            y_plane[y * width + x + 1] = yuyv_data[yuyv_idx + 2];
            y_plane[(y + 1) * width + x] = yuyv_data[yuyv_idx + width * 2];
            y_plane[(y + 1) * width + x + 1] = yuyv_data[yuyv_idx + width * 2 + 2];

            u_plane[uv_idx] = yuyv_data[yuyv_idx + 1];
            v_plane[uv_idx] = yuyv_data[yuyv_idx + 3];
            uv_idx += 1;
        }
    }
}
