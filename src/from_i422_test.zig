const std = @import("std");
const expect = std.testing.expect;
const from_i422 = @import("from_i422.zig");

test "i422ToI420" {
    // Image dimensions
    const width: u32 = 4;
    const height: u32 = 4;

    // I422 input data
    const i422_data = &[_]u8{
        0x80, 0x81, 0x82, 0x83,
        0x84, 0x85, 0x86, 0x87,
        0x88, 0x89, 0x8A, 0x8B,
        0x8C, 0x8D, 0x8E, 0x8F,
        0x40, 0x41, 0x42, 0x43,
        0x44, 0x45, 0x46, 0x47,
        0xA0, 0xA1, 0xA2, 0xA3,
        0xA4, 0xA5, 0xA6, 0xA7,
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
    from_i422.i422ToI420(i422_data, &i420_data, width, height);

    // Check if the conversion was successful
    for (i420_data, 0..) |value, i| {
        //std.debug.print("i420_data: i={d} value={x}\n", .{ i, value });
        try expect(value == expected_i420_data[i]);
    }
}
