const std = @import("std");

pub fn nv12ToI420(nv12_data: []const u8, i420_data: []u8, width: u32, height: u32) void {
    std.debug.assert(width & 1 == 0);
    std.debug.assert(height & 1 == 0);
    std.debug.assert(nv12_data.len >= (width * height * 3) / 2);
    std.debug.assert(i420_data.len >= (width * height * 3) / 2);

    const Y_size = width * height;
    const UV_size = Y_size / 2;

    // Copy the Y plane
    std.mem.copy(u8, i420_data[0..Y_size], nv12_data[0..Y_size]);

    // Separate the U and V planes
    const u_plane = i420_data[Y_size..(Y_size + Y_size / 4)];
    const v_plane = i420_data[(Y_size + Y_size / 4)..];
    const nv12_uv_plane = nv12_data[Y_size..];

    @setRuntimeSafety(false);
    var i: usize = 0;
    while (i < UV_size) : (i += 2) {
        u_plane[i / 2] = nv12_uv_plane[i];
        v_plane[i / 2] = nv12_uv_plane[i + 1];
    }
}
