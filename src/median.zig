const std = @import("std");
const testing = std.testing;

/// Calculates the median of a slice of f64 values.
/// Note: This function sorts the input slice in place.
///
/// # Arguments
///
/// * `slice` - A mutable slice of f64 values. The contents will be sorted.
///
/// # Returns
///
/// The median value of the slice as an f64.
///
/// # Errors
///
/// * `error.EmptyArray` - If the input slice is empty.
pub fn median(slice: []f64) !f64 {
    if (slice.len == 0) return error.EmptyArray;

    const len = slice.len;

    std.mem.sort(f64, slice, {}, std.sort.asc(f64));
    if (len % 2 == 0) {
        return (slice[len / 2 - 1] + slice[len / 2]) / 2.0;
    } else {
        return slice[len / 2];
    }
}

test "median should calculate currectly on a sorted array" {
    var arr = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0 };

    const slice = arr[0..arr.len];
    try testing.expectEqual(try median(slice), 3.0);

    const slice1 = arr[0..3];
    try testing.expectEqual(try median(slice1), 2.0);

    const slice2 = arr[0..4];
    try testing.expectEqual(try median(slice2), 2.5);
}

test "median should calculate currectly on a unsorted array" {
    var arr = [_]f64{ 3.0, 2.0, 1.0, 5.0, 4.0 };

    try testing.expectEqual(try median(arr[0..]), 3.0);
    arr = [_]f64{ 3.0, 5.0, 1.0, 2.0, 4.0 };

    const slice1 = arr[0..3];
    try testing.expectEqual(try median(slice1), 3.0);

    const slice2 = arr[1..4];
    try testing.expectEqual(try median(slice2), 3.0);

    var arr1 = [_]f64{ 3.2, 5.0, 1.0, 2.0, 4.0, 8 };
    const slice3 = arr1[0..];
    try testing.expectEqual(try median(slice3), 3.6);
}
