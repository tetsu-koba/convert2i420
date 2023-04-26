const std = @import("std");
const testing = std.testing;
const yuyvToI420 = @import("from_yuyv.zig").yuyvToI420;

test "YUYV to YUV420 conversion" {
    const yuyv_data: [8]u8 = .{ 16, 128, 17, 80, 18, 129, 19, 81 };
    var yuv420_data: [6]u8 = undefined;

    yuyvToI420(yuyv_data[0..], yuv420_data[0..], 2, 2);

    const expected_y_plane: [4]u8 = .{ 16, 17, 18, 19 };
    const expected_u_plane: [1]u8 = .{128};
    const expected_v_plane: [1]u8 = .{80};

    try testing.expectEqualSlices(u8, expected_y_plane[0..], yuv420_data[0..4]);
    try testing.expectEqualSlices(u8, expected_u_plane[0..], yuv420_data[4..5]);
    try testing.expectEqualSlices(u8, expected_v_plane[0..], yuv420_data[5..6]);
}

test "YUYV to YUV420 conversion 2" {
    const yuyv_data: [16]u8 = .{
        16, 0x80, 17, 0x50, 18, 0x81, 19, 0x51,
        20, 0x82, 21, 0x52, 22, 0x83, 23, 0x53,
    };
    var yuv420_data: [12]u8 = undefined;

    yuyvToI420(yuyv_data[0..], yuv420_data[0..], 4, 2);

    const expected_y_plane: [8]u8 = .{ 16, 17, 18, 19, 20, 21, 22, 23 };
    const expected_u_plane: [2]u8 = .{ 0x80, 0x81 };
    const expected_v_plane: [2]u8 = .{ 0x50, 0x51 };

    try testing.expectEqualSlices(u8, expected_y_plane[0..], yuv420_data[0..8]);
    try testing.expectEqualSlices(u8, expected_u_plane[0..], yuv420_data[8..10]);
    try testing.expectEqualSlices(u8, expected_v_plane[0..], yuv420_data[10..12]);
}

test "YUYV to YUV420 conversion with diverse data" {
    const yuyv_data: [32]u8 = .{
        50,  200, 60,  210, 70,  220, 80,  230,
        90,  240, 100, 250, 110, 210, 120, 220,
        130, 230, 140, 240, 150, 250, 160, 210,
        170, 220, 180, 230, 190, 240, 200, 250,
    };
    var yuv420_data: [48]u8 = undefined;

    yuyvToI420(yuyv_data[0..], yuv420_data[0..], 4, 4);

    const expected_y_plane: [16]u8 = .{
        50,  60,  70,  80,
        90,  100, 110, 120,
        130, 140, 150, 160,
        170, 180, 190, 200,
    };
    const expected_u_plane: [4]u8 = .{ 200, 220, 230, 250 };
    const expected_v_plane: [4]u8 = .{ 210, 230, 240, 210 };

    try testing.expectEqualSlices(u8, expected_y_plane[0..], yuv420_data[0..16]);
    try testing.expectEqualSlices(u8, expected_u_plane[0..], yuv420_data[16..20]);
    try testing.expectEqualSlices(u8, expected_v_plane[0..], yuv420_data[20..24]);
}
