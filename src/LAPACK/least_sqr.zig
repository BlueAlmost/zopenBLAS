const std = @import("std");
const print = std.debug.print;
const Complex = std.math.Complex;

const zopenBLAS = @import("../../zopenBLAS.zig");

// containers
const Vec = zopenBLAS.Vec;
const Mat = zopenBLAS.Mat;

// LAPACK
const lp = zopenBLAS.lapack;
const lp_int = zopenBLAS.lp_int;
const lp_cmpx_float = zopenBLAS.lp_cmpx_float;
const lp_cmpx_double = zopenBLAS.lp_cmpx_double;

const LP_trans = zopenBLAS.LP_trans;
const LP_layout = zopenBLAS.LP_layout;

pub fn gels(comptime T: type, tr: LP_trans, A: Mat(T), B: Mat(T), W: Mat(T), info: *lp_int) !void {
    var m: lp_int = @intCast(lp_int, A.n_row);
    var n: lp_int = @intCast(lp_int, A.n_col);
    var nrhs: lp_int = @intCast(lp_int, B.n_col);

    var lda: lp_int = m;
    var ldb: lp_int = if (m > n) m else n;

    // CHECK THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
    var lwork: lp_int = if (m * n > nrhs) m * n + nrhs else n * n;

    // ACTUALLY, CHECK THIS ENTIRE FUNCTION!!!!!!!!!!!!

    var trans = @enumToInt(tr);
    var layout = @enumToInt(LP_layout.col_maj);

    switch (T) {
        f32 => {
            lp.sgels(trans, m, n, nrhs, A.val.ptr, lda, B.val.ptr, ldb, W.val.ptr, lwork, info);
        },

        f64 => {
            _ = lp.LAPACKE_dgels_work(layout, trans, m, n, nrhs, A.val.ptr, lda, B.val.ptr, ldb, W.val.ptr, lwork);
            // junk_info = lp.LAPACKE_dgels_work(layout, trans, m, n, nrhs,
            //     A.val.ptr, lda, B.val.ptr, ldb, W.val.ptr, lwork);
        },

        Complex(f32) => {
            print("Complex(f32) is not yet implemented\n", .{});
        },
        Complex(f64) => {
            print("Complex(f64) is not yet implemented\n", .{});
        },
        else => @compileError("unexpected input type"),
    }
}
