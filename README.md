# Video format converter to I420
Utilities written in Zig to convert camera output to I420 video format.
I420 is Planar YUV 4:2:0.

## Supported input video format

- YUYV (YUYV 4:2:2)
- NV12 (Y/CbCr 4:2:0)
- I422 (Planar YUV 4:2:2)

## Caveat

This is optimized for a video stream from a video camera.
Video width and height must be an even number. Each line has no padding.

## How to use

See test files.

## ToDo

Make this into a package when the official zig package manager is released.
