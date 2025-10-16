const std = @import("std");
const math = std.math;
const testing = std.testing;

/// Calculates the arithmetic mean (average) of a slice of f64 values.
///
/// # Arguments
///
/// * `arr` - A slice of f64 values.
///
/// # Returns
///
/// The mean of the values in the slice as an f64.
///
/// # Errors
///
/// * `error.EmptyArray` - If the input slice is empty.
pub fn mean(arr: []const f64) !f64 {
    if (arr.len == 0) return error.EmptyArray;
    var sum: f64 = 0;
    for (arr) |item| {
        // sum = math.add(f64, sum, item) catch return error.Overflow;
        sum += item;
    }
    const len: f64 = @floatFromInt(arr.len);
    return sum / len;
}

test "mean function should return correct result" {
    var result = mean(&[_]f64{ 3.0, 6.0, 9.0 }) catch -1;
    try testing.expect(result == 6);

    result = mean(&[_]f64{ 13.0, 13.0, 13.0, 13.0 }) catch -1;
    try testing.expect(result == 13.0);

    result = mean(&[_]f64{ 9.0, 50.0, 12.0, 4.0 }) catch -1;
    try testing.expect(result != 6.0);

    result = mean(&[_]f64{ 9.0, 50.0, 12.0, 4.0 }) catch -1;
    try testing.expect(result == 18.75);

    result = mean(&[_]f64{ 13.0, 13.0, 13.0, -13.0, 13.0 }) catch -1;
    try testing.expect(result == 7.8);

    const arr = [5]f64{ -13.0, -13.0, -13.0, -13.0, -13.0 };
    const slice = arr[0..];
    result = mean(slice) catch -1;
    try testing.expect(result == -13);
}

test "mean function should return exact result according to IEEE 754" {
    const result = mean(&[_]f64{ 9.6, 50.7, 12.8, 4.2 }) catch -1;
    try testing.expect(result == 19.3250000000000031);
}

test "mean function should work with a dynamic array list" {
    const alloc = testing.allocator;
    var al = std.ArrayList(f64).empty;

    defer al.deinit(alloc);
    try al.appendSlice(
        alloc,
        &[_]f64{ 69.0, 0.0, 4.20, 711.0, 3000.06 },
    );
    const slice = al.items[0..];
    const result = mean(slice) catch -1;
    try testing.expect(result == 756.8520000000001);
}

test "mean function should error when array is empty" {
    try testing.expectError(error.EmptyArray, mean(&[_]f64{}));
}
