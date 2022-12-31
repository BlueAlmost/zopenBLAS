const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Layout = zopenBLAS.BLAS_layout;
const Trans = zopenBLAS.BLAS_trans;

const Mat = zopenBLAS.Mat;

pub fn main() !void {
    const R: type = f64;
    const U: type = Complex(R);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var A = try Mat(R).init(allocator, 3, 2);
    var B = try Mat(R).init(allocator, 2, 3);
    var C = try Mat(R).init(allocator, 3, 3);

    A.val[0] = 1.0;
    A.val[1] = 2.0;
    A.val[2] = 1.0;
    A.val[3] = -3.0;
    A.val[4] = 4.0;
    A.val[5] = -1.0;
    B.val[0] = 1.0;
    B.val[1] = 2.0;
    B.val[2] = 1.0;
    B.val[3] = -3.0;
    B.val[4] = 4.0;
    B.val[5] = -1.0;
    C.fill(0.3);

    A.prt();
    B.prt();
    C.prt();

    var alpha: R = 1.4;
    var beta: R = 13.0;

    try zopenBLAS.gemm(R, Trans.no_t, Trans.no_t, alpha, A, B, beta, C);
    // try zopenBLAS.gemm(R, Trans.no_t, Trans.t,    alpha, A, B, beta, C);
    // try zopenBLAS.gemm(R, Trans.t,    Trans.no_t, alpha, A, B, beta, C);
    // try zopenBLAS.gemm(R, Trans.t,    Trans.t,    alpha, A, B, beta, C);
    C.prt();

    var X = try Mat(U).init(allocator, 3, 2);
    var Y = try Mat(U).init(allocator, 2, 3);
    var Z = try Mat(U).init(allocator, 3, 3);

    X.val[0].re = 1.0;
    X.val[1].re = 2.0;
    X.val[2].re = 1.0;
    X.val[3].re = -3.0;
    X.val[4].re = 4.0;
    X.val[5].re = -1.0;
    X.val[0].im = 1.0;
    X.val[1].im = 2.0;
    X.val[2].im = 1.0;
    X.val[3].im = -3.0;
    X.val[4].im = 4.0;
    X.val[5].im = -1.0;

    Y.val[0].re = 1.0;
    Y.val[1].re = 2.0;
    Y.val[2].re = 1.0;
    Y.val[3].re = -3.0;
    Y.val[4].re = 4.0;
    Y.val[5].re = -1.0;
    Y.val[0].im = 1.0;
    Y.val[1].im = 2.0;
    Y.val[2].im = 1.0;
    Y.val[3].im = -3.0;
    Y.val[4].im = 4.0;
    Y.val[5].im = -1.0;

    Z.fill(U.init(0.2, -0.1));

    X.prt();
    Y.prt();
    Z.prt();

    var gamma = U.init(3.0, 3.2);
    var delta = U.init(4.4, -3.2);

    try zopenBLAS.gemm(U, Trans.no_t, Trans.no_t, gamma, X, Y, delta, Z);
    Z.prt();
}
