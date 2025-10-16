const std = @import("std");

/// Calculates the sum of consecutive integers from `start` to `end` inclusive.
/// Uses the arithmetic sequence formula: sum = n(a + l)/2 where:
/// - n is the count of numbers
/// - a is the first number (start)
/// - l is the last number (end)
///
/// # Arguments
///
/// * `start` - The first number in the sequence
/// * `end` - The last number in the sequence
///
/// # Returns
///
/// The sum of all integers from start to end (inclusive)
/// Note: Works even if start > end, treating it as if the numbers were swapped
///
pub fn sum_consecutive_numbers(start: i128, end: i128) i128 {
    const count: f128 = if (start > end) @floatFromInt(start - end + 1) else @floatFromInt(end - start + 1);
    const sum: i128 = @intFromFloat((count / 2.0) * @as(f128, @floatFromInt(start + end)));
    return sum;
}

test "sum consecutive numbers" {
    const testing = std.testing;
    try testing.expectEqual(@as(i128, 55), sum_consecutive_numbers(1, 10));
    try testing.expectEqual(@as(i128, 15), sum_consecutive_numbers(1, 5));
    try testing.expectEqual(@as(i128, 0), sum_consecutive_numbers(0, 0));
    try testing.expectEqual(@as(i128, -55), sum_consecutive_numbers(-10, -1));
    try testing.expectEqual(@as(i128, -55), sum_consecutive_numbers(-10, 0));
    try testing.expectEqual(@as(i128, 5_050), sum_consecutive_numbers(1, 100));
    try testing.expectEqual(@as(i128, 500_500), sum_consecutive_numbers(1, 1000));
    try testing.expectEqual(@as(i128, 4_950), sum_consecutive_numbers(1, 99));
    try testing.expectEqual(@as(i128, 40), sum_consecutive_numbers(6, 10));
}

test "edge cases for consecutive numbers" {
    const testing = std.testing;
    // Edge cases
    try testing.expectEqual(@as(i128, 55), sum_consecutive_numbers(10, 1)); // start > end should be 0
    try testing.expectEqual(@as(i128, 5), sum_consecutive_numbers(5, 5)); // single number
    try testing.expectEqual(@as(i128, 0), sum_consecutive_numbers(-5, 5)); // symmetric range around zero
    try testing.expectEqual(@as(i128, -5), sum_consecutive_numbers(-5, -5)); // single negative number
    try testing.expectEqual(@as(i128, 21), sum_consecutive_numbers(10, 11)); // two numbers
}
