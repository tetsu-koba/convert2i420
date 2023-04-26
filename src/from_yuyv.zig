const std = @import("std");

pub fn yuyvToI420(yuyv_data: []const u8, i420_data: []u8, width: u32, height: u32) void {
    std.debug.assert(width & 1 == 0);
    std.debug.assert(height & 1 == 0);
    std.debug.assert(yuyv_data.len >= width * height * 2);
    std.debug.assert(i420_data.len >= (width * height * 3) / 2);

    const y_plane = i420_data[0..(width * height)];
    const u_plane = i420_data[(width * height)..(width * height + width * height / 4)];
    const v_plane = i420_data[(width * height + width * height / 4)..];

    var uv_idx: usize = 0;
    var y: usize = 0;
    while (y < height) : (y += 1) {
        var x: usize = 0;
        while (x < width) : (x += 2) {
            const yuyv_idx = (y * width + x) * 2;

            y_plane[y * width + x] = yuyv_data[yuyv_idx];
            y_plane[y * width + x + 1] = yuyv_data[yuyv_idx + 2];
            if (y & 1 == 0) {
                u_plane[uv_idx] = yuyv_data[yuyv_idx + 1];
                v_plane[uv_idx] = yuyv_data[yuyv_idx + 3];
                uv_idx += 1;
            }
        }
    }
}
