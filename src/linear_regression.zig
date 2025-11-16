const std = @import("std");

pub const LinearError = error{
    InvalidInput,
    SingularMatrix,
};

/// Computes the slope and intercept for simple linear regression (y = mx + b)
/// given slices of x and y values.
/// Returns a tuple (m, b) where:
///   m = slope
///   b = intercept
pub const LinearRegressionResult = struct {
    m: f64,
    b: f64,
};

/// Calculates the simple linear regression for a set of data points.
/// This function takes two slices of f64, representing the x and y coordinates,
/// and computes the slope (m) and y-intercept (b) of the line of best fit.
/// The equation of the line is y = mx + b.
///
/// # Arguments
///
/// * `x` - A slice of f64 values representing the independent variable.
/// * `y` - A slice of f64 values representing the dependent variable.
///
/// # Returns
///
/// A `LinearRegressionResult` struct containing the slope `m` and intercept `b`.
///
/// # Errors
///
/// * `LinearError.InvalidInput` - If the input slices `x` and `y` have different lengths or are empty.
/// * `LinearError.SingularMatrix` - If all x values are the same, which would result in a division by zero.
pub fn linearRegression(x: []const f64, y: []const f64) LinearError!LinearRegressionResult {
    if (x.len != y.len or x.len == 0) {
        return LinearError.InvalidInput;
    }

    const n = @as(f64, @floatFromInt(x.len));
    var sum_x: f64 = 0;
    var sum_y: f64 = 0;
    var sum_xy: f64 = 0;
    var sum_x2: f64 = 0;

    for (x, 0..) |xi, i| {
        const yi = y[i];
        sum_x += xi;
        sum_y += yi;
        sum_xy += xi * yi;
        sum_x2 += xi * xi;
    }

    const denominator = n * sum_x2 - sum_x * sum_x;
    if (denominator == 0) {
        return LinearError.SingularMatrix;
    }

    const m = (n * sum_xy - sum_x * sum_y) / denominator;
    const b = (sum_y - m * sum_x) / n;

    return LinearRegressionResult{ .m = m, .b = b };
}

test "linear regression computes correct slope and intercept" {
    const x = [_]f64{ 1, 2, 3, 4, 5 };
    const y = [_]f64{ 2, 4, 6, 8, 10 };
    const result = try linearRegression(&x, &y);
    try std.testing.expectApproxEqAbs(result.m, 2.0, 1e-9);
    try std.testing.expectApproxEqAbs(result.b, 0.0, 1e-9);
}

test "linear regression computes correct slope and intercept for 20 points, some negative y" {
    // y = 3x + 4, with some negative y values for negative x
    const x = [_]f64{ -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
    const y = [_]f64{ -20, -17, -14, -11, -8, -5, -2, 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37 };
    const result = try linearRegression(&x, &y);
    try std.testing.expectApproxEqAbs(result.m, 3.0, 1e-9);
    try std.testing.expectApproxEqAbs(result.b, 4.0, 1e-9);
}

test "linear regression returns error on invalid input" {
    const x = [_]f64{ 1, 2, 3 };
    const y = [_]f64{ 4, 5 }; // Different length
    try std.testing.expectError(error.InvalidInput, linearRegression(&x, &y));
}

test "linear regression returns error on singular matrix" {
    // All x values are the same, so denominator will be zero
    const x = [_]f64{ 1, 1, 1 };
    const y = [_]f64{ 2, 3, 4 };
    try std.testing.expectError(error.SingularMatrix, linearRegression(&x, &y));
}

test "linear regression returns 0 for both when graph is on the x-axis" {
    const x = [_]f64{ 1, 2, 3, 4 };
    const y = [_]f64{ 0, 0, 0, 0 };
    const result = try linearRegression(&x, &y);
    try std.testing.expectApproxEqAbs(result.m, 0.0, 1e-9);
    try std.testing.expectApproxEqAbs(result.b, 0.0, 1e-9);
}

test "linear regression returns 0 slope and 1 intercept when graph y is always 1" {
    const x = [_]f64{ 1, 2, 3, 4 };
    const y = [_]f64{ 1, 1, 1, 1 };
    const result = try linearRegression(&x, &y);
    try std.testing.expectApproxEqAbs(result.m, 0.0, 1e-9);
    try std.testing.expectApproxEqAbs(result.b, 1.0, 1e-9);
}

test "linear regression returns a slope of 1 and 01 intercept when graph y is always equal to x" {
    const x = [_]f64{ 10, 20, 30, 40 };
    const y = [_]f64{ 10, 20, 30, 40 };
    const result = try linearRegression(&x, &y);
    try std.testing.expectApproxEqAbs(result.m, 1.0, 1e-9);
    try std.testing.expectApproxEqAbs(result.b, 0.0, 1e-9);
}
