# Statz

A statistical functions library written in Zig.

## Features

- Linear Regression (compute slope and y-intercept)
- Statistical Measures
  - Mean (arithmetic average)
  - Median (middle value)
  - Mode (most frequent value)
  - Standard Deviation
- Utility Functions
  - Sum of Consecutive Numbers

## Installation

Add this library to your `build.zig.zon`:

```zig
.{
    .name = "your-project",
    .version = "0.1.0",
    .dependencies = .{
        .statz = .{
            .url = "https://github.com/your-username/statz/archive/refs/tags/v0.1.0.tar.gz",
        },
    },
}
```

Then in your `build.zig`, add:

```zig
const statz_dep = b.dependency("statz", .{
    .target = target,
    .optimize = optimize,
});
exe.addModule("statz", statz_dep.module("statz"));
```

## Usage

```zig
const std = @import("std");
const statz = @import("statz");

pub fn main() !void {
    // Linear Regression
    const x = [_]f64{ 1, 2, 3, 4, 5 };
    const y = [_]f64{ 2, 4, 6, 8, 10 };
    const result = try statz.linearRegression(&x, &y);
    std.debug.print("Slope: {d}, Intercept: {d}\n", .{ result.m, result.b });

    // Statistical measures
    const data = [_]f64{ 1, 2, 3, 4, 5 };
    const mean_val = try statz.mean(&data);
    const median_val = try statz.median(&data);
    const mode_val = try statz.mode(&data);

    std.debug.print("Mean: {d}\n", .{mean_val});
    std.debug.print("Median: {d}\n", .{median_val});
    std.debug.print("Mode: {d}\n", .{mode_val});
}
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Tests

To run the tests:

```bash
zig build test
```
