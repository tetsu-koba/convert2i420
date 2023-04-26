const std = @import("std");

pub fn i422ToI420(i422_data: []const u8, i420_data: []u8, width: u32, height: u32) void {
    std.debug.assert(width & 1 == 0);
    std.debug.assert(height & 1 == 0);
    std.debug.assert(i422_data.len >= (width * height * 3) / 2);
    std.debug.assert(i420_data.len >= (width * height * 3) / 2);

    const Y_size = width * height;

    // Copy the Y plane
    std.mem.copy(u8, i420_data[0..Y_size], i422_data[0..Y_size]);

    // Copy the U and V planes
    const u_plane = i420_data[Y_size..(Y_size + Y_size / 4)];
    const v_plane = i420_data[(Y_size + Y_size / 4)..];
    const i422_u_plane = i422_data[Y_size..(Y_size + Y_size / 2)];
    const i422_v_plane = i422_data[(Y_size + Y_size / 2)..];

    var y: usize = 0;
    while (y < height) : (y += 2) {
        var i: usize = 0;
        while (i < width) : (i += 1) {
            u_plane[i] = i422_u_plane[i];
        }
    }
    y = 0;
    while (y < height) : (y += 2) {
        var i: usize = 0;
        while (i < width) : (i += 1) {
            v_plane[i] = i422_v_plane[i];
        }
    }
}
