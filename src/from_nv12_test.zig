const std = @import("std");
const expect = std.testing.expect;
const from_nv12 = @import("from_nv12.zig");

test "nv12ToI420" {
    // Image dimensions
    const width: u32 = 4;
    const height: u32 = 4;

    // NV12 input data
    const nv12_data = &[_]u8{
        0x80, 0x81, 0x82, 0x83,
        0x84, 0x85, 0x86, 0x87,
        0x88, 0x89, 0x8A, 0x8B,
        0x8C, 0x8D, 0x8E, 0x8F,
        0x40, 0xA0, 0x41, 0xA1,
        0x42, 0xA2, 0x43, 0xA3,
    };

    // Expected I420 output data
    const expected_i420_data = &[_]u8{
        0x80, 0x81, 0x82, 0x83,
        0x84, 0x85, 0x86, 0x87,
        0x88, 0x89, 0x8A, 0x8B,
        0x8C, 0x8D, 0x8E, 0x8F,
        0x40, 0x41, 0x42, 0x43,
        0xA0, 0xA1, 0xA2, 0xA3,
    };

    // Allocate buffer for the converted data
    var i420_data = [_]u8{0} ** (width * height * 3 / 2);

    // Call the conversion function
    from_nv12.nv12ToI420(nv12_data, &i420_data, width, height);

    // Check if the conversion was successful
    for (i420_data, 0..) |value, i| {
        //std.debug.print("i420_data: i={d} value={x}\n", .{i, value});
        try expect(value == expected_i420_data[i]);
    }
}
