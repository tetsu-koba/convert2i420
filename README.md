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

## Example

```
#!/bin/sh -eux

WIDTH=320
HEIGHT=240
FRAMERATE=15

v4l2capture /dev/video0 /dev/stdout $WIDTH $HEIGHT $FRAMERATE YUYV | \
convert2i420 /dev/stdin /dev/stdout $WIDTH $HEIGHT YUYV | \
ffplay -f rawvideo -pixel_format yuv420p -video_size ${WIDTH}x${HEIGHT} /dev/stdin
```

## ToDo

Make this into a package when the official zig package manager is released.
