const std = @import("std");

const ModeError = error{ EmptyArray, NoMode, OutOfMemory };

/// Calculates the mode of a slice of f64 values.
/// The mode is the value that appears most frequently in a data set.
/// This function uses a hash map to count occurrences of each number.
///
/// # Arguments
///
/// * `arr` - A slice of f64 values.
///
/// # Returns
///
/// The most frequent value (mode) in the slice as an f64.
///
/// # Errors
///
/// * `ModeError.EmptyArray` - If the input slice is empty.
/// * `ModeError.NoMode` - If the slice has fewer than 3 elements.
/// * `ModeError.OutOfMemory` - If memory allocation for the frequency map fails.
pub fn mode(arr: []const f64) ModeError!f64 {
    if (arr.len == 0) return error.EmptyArray;
    if (arr.len < 3) return error.NoMode;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var counters = std.AutoHashMap(*const f64, u64).init(gpa.allocator());
    defer counters.deinit();

    for (arr) |item| {
        const entry = try counters.getOrPut(&item);
        if (!entry.found_existing) {
            entry.value_ptr.* = 1;
        } else {
            entry.value_ptr.* += 1;
        }
    }

    var max_count: u64 = 0;
    var mode_value: f64 = 0;
    var entries = counters.iterator();
    while (entries.next()) |entry| {
        const count = entry.value_ptr.*;
        if (count > max_count) {
            max_count = count;
            mode_value = entry.key_ptr.*.*;
        }
    }

    return mode_value;
}

test "mode should return the most frequent value" {
    const arr = [_]f64{ 1.0, 2.0, 2.0, 3.0, 3.0, 3.0 };
    const result = try mode(&arr);
    try std.testing.expectEqual(result, 3.0);

    const arr2 = [_]f64{ -1.0, 2.0, 2.0, 3.0, -1.0, 3.0, 4.0, 4.0, -1.0 };
    const result2 = try mode(&arr2);
    try std.testing.expectEqual(result2, -1.0);

    const arr3 = [_]f64{ std.math.floatMax(f64), 1.0, 2.0, 2.0, 3.0, 3.0, 3.5, std.math.floatMax(f64), 4.0, std.math.floatMax(f64) };
    const result3 = try mode(&arr3);
    try std.testing.expectEqual(result3, std.math.floatMax(f64));
}

test "mode should handle empty array" {
    const arr = [_]f64{};
    const result = mode(&arr);
    try std.testing.expectError(ModeError.EmptyArray, result);
}

test "mode should error when no mode is possible" {
    const arr = [_]f64{ 1.0, 2.0 };
    const result = mode(&arr);
    try std.testing.expectError(ModeError.NoMode, result);
}
