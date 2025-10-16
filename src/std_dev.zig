const std = @import("std");
const mean = @import("mean.zig").mean;

pub fn std_dev(arr: []const f64) !f64 {
    const n = arr.len;
    if (n == 0) return error.EmptyArray;

    const m = try mean(arr);
    var sum = @as(f64, 0);
    for (arr) |x| {
        const diff = x - m;
        sum += diff * diff;
    }
    const num: f64 = @floatFromInt(n);
    const variance: f64 = sum / num;
    return @sqrt(variance);
}

test "std dev should calculate proper value" {
    const arr = [_]f64{ 2, 4, 4, 4, 5, 5, 7, 9 };
    const expected = 2.0;
    const actual = try std_dev(&arr);
    try std.testing.expectEqual(expected, actual);
}

test "std dev should error on empty array" {
    const arr = [_]f64{};
    const expected = error.EmptyArray;
    const actual = std_dev(&arr);
    try std.testing.expectError(expected, actual);
}
