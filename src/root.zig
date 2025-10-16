//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.

test "mean" {
    _ = @import("mean.zig");
}

test "median" {
    _ = @import("median.zig");
}

test "mode" {
    _ = @import("mode.zig");
}

test "std_dev" {
    _ = @import("std_dev.zig");
}

test "sum_consecutive_numbers" {
    _ = @import("sum_consec.zig");
}
