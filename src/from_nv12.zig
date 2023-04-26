const std = @import("std");

pub fn nv12ToI420(nv12_data: []const u8, yuv420_data: []u8, width: u32, height: u32) void {
    const Y_size = width * height;
    const UV_size = Y_size / 2;

    // Copy the Y plane
    const Y_plane = yuv420_data[0..Y_size];
    std.mem.copy(u8, Y_plane, nv12_data[0..Y_size]);

    // Separate the U and V planes
    var i: usize = 0;
    var j: usize = Y_size;

    while (i < UV_size) {
        yuv420_data[Y_size + i / 2] = nv12_data[j]; // U plane
        yuv420_data[Y_size + UV_size / 2 + i / 2] = nv12_data[j + 1]; // V plane

        i += 2;
        j += 2;
    }
}
