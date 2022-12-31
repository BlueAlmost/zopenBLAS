const std = @import("std");
const print = std.debug.print;
const Complex = std.math.Complex;

const zopenBLAS = @import("../../zopenBLAS.zig");

// containers
const Vec = zopenBLAS.Vec;
const Mat = zopenBLAS.Mat;

// BLAS
const cblas = zopenBLAS.cblas;
const blas_int = zopenBLAS.blas_int;
const blas_uint = zopenBLAS.blas_uint;
const Layout = zopenBLAS.BLAS_layout;
const Trans = zopenBLAS.BLAS_trans;
// const Triang    = zopenBLAS.Triang;
// const Diag      = zopenBLAS.Diag;
// const Side      = zopenBLAS.Side;

fn commensurate(comptime T: type, trA: Trans, A: Mat(T), x: Vec(T), y: Vec(T)) !void {

    // set true if either a transpose or hermitian (conjugate) transpose
    var th_A: bool = if ((trA == Trans.t) or (trA == Trans.h)) true else false;

    if (!th_A) {
        if (A.n_col != x.val.len) return error.Noncommensurate_Mat_Vec_Multiply;
        if (A.n_row != y.val.len) return error.Noncommensurate_Mat_Vec_Multiply;
    } else {
        if (A.n_row != x.val.len) return error.Noncommensurate_Mat_Vec_Multiply;
        if (A.n_col != y.val.len) return error.Noncommensurate_Mat_Vec_Multiply;
    }
}

pub fn gemv(comptime T: type, trA: Trans, alpha: T, A: Mat(T), x: Vec(T), beta: T, y: Vec(T)) !void {
    try commensurate(T, trA, A, x, y);

    const layout = @enumToInt(Layout.col_maj);

    var lda: blas_int = @intCast(blas_int, A.n_row);
    var m: blas_int = @intCast(blas_int, A.n_row);
    var n: blas_int = @intCast(blas_int, A.n_col);
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            cblas.cblas_sgemv(layout, @enumToInt(trA), m, n, alpha, A.val.ptr, lda, x.val.ptr, inc_x, beta, y.val.ptr, inc_y);
        },
        f64 => {
            cblas.cblas_dgemv(layout, @enumToInt(trA), m, n, alpha, A.val.ptr, lda, x.val.ptr, inc_x, beta, y.val.ptr, inc_y);
        },
        Complex(f32) => {
            cblas.cblas_cgemv(layout, @enumToInt(trA), m, n, &alpha, A.val.ptr, lda, x.val.ptr, inc_x, &beta, y.val.ptr, inc_y);
        },
        Complex(f64) => {
            cblas.cblas_zgemv(layout, @enumToInt(trA), m, n, &alpha, A.val.ptr, lda, x.val.ptr, inc_x, &beta, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn ger(comptime T: type, alpha: T, x: Vec(T), y: Vec(T), A: Mat(T)) !void {
    if (x.val.len != A.n_row) return error.X_length_incompatable_with_A;
    if (y.val.len != A.n_col) return error.Y_length_incompatable_with_A;

    const layout = @enumToInt(Layout.col_maj);

    var lda: blas_int = @intCast(blas_int, A.n_row);
    var m: blas_int = @intCast(blas_int, A.n_row);
    var n: blas_int = @intCast(blas_int, A.n_col);
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            cblas.cblas_sger(layout, m, n, alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        f64 => {
            cblas.cblas_dger(layout, m, n, alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn gerc(comptime T: type, alpha: T, x: Vec(T), y: Vec(T), A: Mat(T)) !void {
    if (x.val.len != A.n_row) return error.X_length_incompatable_with_A;
    if (y.val.len != A.n_col) return error.Y_length_incompatable_with_A;

    const layout = @enumToInt(Layout.col_maj);

    var lda: blas_int = @intCast(blas_int, A.n_row);
    var m: blas_int = @intCast(blas_int, A.n_row);
    var n: blas_int = @intCast(blas_int, A.n_col);
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        Complex(f32) => {
            cblas.cblas_cgerc(layout, m, n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        Complex(f64) => {
            cblas.cblas_zgerc(layout, m, n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn geru(comptime T: type, alpha: T, x: Vec(T), y: Vec(T), A: Mat(T)) !void {
    if (x.val.len != A.n_row) return error.X_length_incompatable_with_A;
    if (y.val.len != A.n_col) return error.Y_length_incompatable_with_A;

    const layout = @enumToInt(Layout.col_maj);

    var lda: blas_int = @intCast(blas_int, A.n_row);
    var m: blas_int = @intCast(blas_int, A.n_row);
    var n: blas_int = @intCast(blas_int, A.n_col);
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        Complex(f32) => {
            cblas.cblas_cgeru(layout, m, n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        Complex(f64) => {
            cblas.cblas_zgeru(layout, m, n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y, A.val.ptr, lda);
        },
        else => @compileError("unexpected type"),
    }
}
