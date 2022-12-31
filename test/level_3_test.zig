const std = @import("std");
const print = std.debug.print;
const zopenBLAS = @import("zopenBLAS");

const Complex = std.math.Complex;

const Mat = zopenBLAS.Mat;
const BLAS_trans = zopenBLAS.BLAS_trans;

const Vec = zopenBLAS.Vec;
const eps = 1e-6;

test "gemm - TEST IS NOT YET IMPLEMENTED  \n" {
    print("\t\t ### still need to write this level 3 test ### \n", .{});
    print("\t\t ### still need to write this level 3 test ### \n", .{});
    print("\t\t ### still need to write this level 3 test ### \n", .{});

    // const gemm   = zopenBLAS.gemm;
    // inline for (.{f32, f64}) |R| {
    //     var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    //     defer arena.deinit();
    //     const allocator = arena.allocator();
    //     var AA = [_]R { 1,  2, 2, 2, -3, 1};
    //     var A = try Mat(R).init(allocator, 3, 2);
    //     A.val = AA[0..];
    //     var xx = [_]R { 1,  2 };
    //     var x = try Vec(R).init(allocator, xx.len);
    //     x.val = xx[0..];
    //     var yy = [_]R { 2,  4, 1 };
    //     var y = try Vec(R).init(allocator, yy.len);
    //     y.val = yy[0..];
    //     var alpha: R = 3;
    //     var beta: R = -1;
    //     try gemv(R, BLAS_trans.no_t, alpha, A, x, beta, y);
    //     try std.testing.expectApproxEqAbs(y.val[0],  13, eps);
    //     try std.testing.expectApproxEqAbs(y.val[1], -16, eps);
    //     try std.testing.expectApproxEqAbs(y.val[2],  11, eps);
    // }
}
