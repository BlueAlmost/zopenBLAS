const std = @import("std");
const print = std.debug.print;
const zopenBLAS = @import("zopenBLAS");

const Complex = std.math.Complex;

const Mat = zopenBLAS.Mat;
const BLAS_trans = zopenBLAS.BLAS_trans;

const Vec = zopenBLAS.Vec;
const eps = 1e-6;

test "gemv - real, no transpose  \n" {
    const gemv = zopenBLAS.gemv;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]R{ 1, 2, 2, 2, -3, 1 };
        var A = try Mat(R).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]R{ 1, 2 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, 4, 1 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha: R = 3;
        var beta: R = -1;

        try gemv(R, BLAS_trans.no_t, alpha, A, x, beta, y);

        try std.testing.expectApproxEqAbs(@as(R, 13), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -16), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 11), y.val[2], eps);
    }
}

test "gemv - real, transpose  \n" {
    const gemv = zopenBLAS.gemv;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]R{ 1, 2, 2, 2, -3, 1 };
        var A = try Mat(R).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]R{ 2, 4, 1 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 1, 2 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha: R = 3;
        var beta: R = -1;

        try gemv(R, BLAS_trans.t, alpha, A, x, beta, y);

        try std.testing.expectApproxEqAbs(@as(R, 35), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -23), y.val[1], eps);
    }
}

test "gemv - complex, no transpose  \n" {
    const gemv = zopenBLAS.gemv;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]C{ C.init(1, 1), C.init(2, 0), C.init(2, 0), C.init(2, -3), C.init(-3, 0), C.init(1, 0) };
        var A = try Mat(C).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]C{ C.init(1, 0), C.init(2, -4) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(2, 1), C.init(4, 0), C.init(1, 0) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(3, -2);
        var beta = C.init(-1, 2);

        try gemv(C, BLAS_trans.no_t, alpha, A, x, beta, y);

        try std.testing.expectApproxEqAbs(@as(R, -51), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -22), y.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 8), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 52), y.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 3), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -18), y.val[2].im, eps);
    }
}

test "gemv - complex, transpose  \n" {
    const gemv = zopenBLAS.gemv;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]C{ C.init(1, 1), C.init(2, 0), C.init(2, 0), C.init(2, -3), C.init(-3, 0), C.init(1, 0) };
        var A = try Mat(C).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]C{ C.init(2, 1), C.init(4, 0), C.init(1, 0) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 0), C.init(2, -4) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(3, -2);
        var beta = C.init(-1, 2);

        try gemv(C, BLAS_trans.t, alpha, A, x, beta, y);

        try std.testing.expectApproxEqAbs(@as(R, 38), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -11), y.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -14), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4), y.val[1].im, eps);
    }
}

test "gemv - complex, hermitian  \n" {
    const gemv = zopenBLAS.gemv;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]C{ C.init(1, 1), C.init(2, 0), C.init(2, 0), C.init(2, -3), C.init(-3, 0), C.init(1, 0) };
        var A = try Mat(C).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]C{ C.init(2, 1), C.init(4, 0), C.init(1, 0) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 0), C.init(2, -4) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(3, -2);
        var beta = C.init(-1, 2);

        try gemv(C, BLAS_trans.h, alpha, A, x, beta, y);

        try std.testing.expectApproxEqAbs(@as(R, 36), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -27), y.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -8), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 52), y.val[1].im, eps);
    }
}

//-------------------------------
test "ger - real, transpose  \n" {
    const ger = zopenBLAS.ger;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]R{ 1, 2, 2, 2, -3, 1 };
        var A = try Mat(R).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]R{ 2, 4, 1 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 1, 2 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha: R = 3;

        try ger(R, alpha, x, y, A);

        try std.testing.expectApproxEqAbs(@as(R, 7), A.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 14), A.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5), A.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 14), A.val[3], eps);
        try std.testing.expectApproxEqAbs(@as(R, 21), A.val[4], eps);
        try std.testing.expectApproxEqAbs(@as(R, 7), A.val[5], eps);
    }
}

test "gerc - complex, hermitian  \n" {
    const gerc = zopenBLAS.gerc;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]C{ C.init(1, 1), C.init(2, -1), C.init(2, 0), C.init(2, -2), C.init(-3, 1), C.init(1, 1) };
        var A = try Mat(C).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]C{ C.init(2, 0), C.init(4, -1), C.init(1, 1) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(3, 2);

        try gerc(C, alpha, x, y, A);

        try std.testing.expectApproxEqAbs(@as(R, 15), A.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -7), A.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 26), A.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -24), A.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 13), A.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 3), A.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 6), A.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 18), A.val[3].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 15), A.val[4].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 39), A.val[4].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -7), A.val[5].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 13), A.val[5].im, eps);
    }
}

test "geru - complex, transpose  \n" {
    const geru = zopenBLAS.geru;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var AA = [_]C{ C.init(1, 1), C.init(2, -1), C.init(2, 0), C.init(2, -2), C.init(-3, 1), C.init(1, 1) };
        var A = try Mat(C).init(allocator, 3, 2);
        A.val = AA[0..];

        var xx = [_]C{ C.init(2, 0), C.init(4, -1), C.init(1, 1) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(3, 2);

        try geru(C, alpha, x, y, A);

        try std.testing.expectApproxEqAbs(@as(R, -1), A.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 17), A.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 6), A.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 32), A.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -7), A.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 7), A.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 22), A.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -6), A.val[3].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 35), A.val[4].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -17), A.val[4].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 13), A.val[5].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 9), A.val[5].im, eps);
    }
}
