const std = @import("std");
const print = std.debug.print;
const Complex = std.math.Complex;

const zopenBLAS = @import("../../zopenBLAS.zig");

// containers
const Mat = zopenBLAS.Mat;

// BLAS
const cblas = zopenBLAS.cblas;
const Layout = zopenBLAS.BLAS_layout;
const Trans = zopenBLAS.BLAS_trans;
const blas_int = zopenBLAS.blas_int;
const blas_uint = zopenBLAS.blas_uint;

fn commensurate(comptime T: type, trA: Trans, trB: Trans, A: Mat(T), B: Mat(T), C: Mat(T)) !void {

    // set true if either a transpose or hermitian (conjugate) transpose
    var th_A: bool = if ((trA == Trans.t) or (trA == Trans.h)) true else false;
    var th_B: bool = if ((trB == Trans.t) or (trB == Trans.h)) true else false;

    if (!th_A and !th_B) {
        if (C.n_row != A.n_row) return error.Noncommensurate_Mat_Multiply;
        if (C.n_col != B.n_col) return error.Noncommensurate_Mat_Multiply;
        if (A.n_col != B.n_row) return error.Noncommensurate_Mat_Multiply;
    } else if (!th_A and th_B) {
        if (C.n_row != A.n_row) return error.Noncommensurate_Mat_Multiply;
        if (C.n_col != B.n_row) return error.Noncommensurate_Mat_Multiply;
        if (A.n_col != B.n_col) return error.Noncommensurate_Mat_Multiply;
    } else if (th_A and !th_B) {
        if (C.n_row != A.n_col) return error.Noncommensurate_Mat_Multiply;
        if (C.n_col != B.n_col) return error.Noncommensurate_Mat_Multiply;
        if (A.n_row != B.n_row) return error.Noncommensurate_Mat_Multiply;
    } else if (th_A and th_B) {
        if (C.n_row != A.n_col) return error.Noncommensurate_Mat_Multiply;
        if (C.n_col != B.n_row) return error.Noncommensurate_Mat_Multiply;
        if (A.n_row != B.n_col) return error.Noncommensurate_Mat_Multiply;
    }
}

pub fn gemm(comptime T: type, trA: Trans, trB: Trans, alpha: T, A: Mat(T), B: Mat(T), beta: T, C: Mat(T)) !void {
    try commensurate(T, trA, trB, A, B, C);

    const layout = @enumToInt(Layout.col_maj);

    var lda: blas_int = @intCast(blas_int, A.n_row);
    var ldb: blas_int = @intCast(blas_int, B.n_row);
    var ldc: blas_int = @intCast(blas_int, C.n_row);

    var m: blas_int = @intCast(blas_int, C.n_row);
    var n: blas_int = @intCast(blas_int, C.n_col);
    var k: blas_int = @intCast(blas_int, A.n_col);

    switch (T) {
        f32 => {
            cblas.cblas_sgemm(layout, @enumToInt(trA), @enumToInt(trB), m, n, k, alpha, A.val.ptr, lda, B.val.ptr, ldb, beta, C.val.ptr, ldc);
        },
        f64 => {
            cblas.cblas_dgemm(layout, @enumToInt(trA), @enumToInt(trB), m, n, k, alpha, A.val.ptr, lda, B.val.ptr, ldb, beta, C.val.ptr, ldc);
        },

        Complex(f32) => {
            cblas.cblas_cgemm(layout, @enumToInt(trA), @enumToInt(trB), m, n, k, &alpha, A.val.ptr, lda, B.val.ptr, ldb, &beta, C.val.ptr, ldc);
        },
        Complex(f64) => {
            cblas.cblas_zgemm(layout, @enumToInt(trA), @enumToInt(trB), m, n, k, &alpha, A.val.ptr, lda, B.val.ptr, ldb, &beta, C.val.ptr, ldc);
        },
        else => @compileError("unexpected type"),
    }
}
