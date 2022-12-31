const std = @import("std");
const print = std.debug.print;
const Complex = std.math.Complex;

const zopenBLAS = @import("../../zopenBLAS.zig");

// containers
const Vec = zopenBLAS.Vec;
const ValueType = zopenBLAS.ValueType;
const ElementType = zopenBLAS.ElementType;

// BLAS
const cblas = zopenBLAS.cblas;
const blas_int = zopenBLAS.blas_int;
const blas_uint = zopenBLAS.blas_uint;

pub fn asum(comptime T: type, x: Vec(T)) ValueType(T) {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_sasum(n, x.val.ptr, inc_x);
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_dasum(n, x.val.ptr, inc_x);
        },
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_scasum(n, x.val.ptr, inc_x);
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_dzasum(n, x.val.ptr, inc_x);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn axpy(comptime T: type, alpha: T, x: Vec(T), y: Vec(T)) !void {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_saxpy(n, alpha, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        f64 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_daxpy(n, alpha, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f32) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_caxpy(n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f64) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_zaxpy(n, &alpha, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn copy(comptime T: type, x: Vec(T), y: Vec(T)) !void {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_scopy(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        f64 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_dcopy(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f32) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_ccopy(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f64) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_zcopy(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

//-----------------------------------------

pub fn scal(comptime T: type, alpha: T, x: Vec(T)) void {
    // scale a vector by a same type scalar

    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_sscal(n, alpha, x.val.ptr, inc_x);
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_dscal(n, alpha, x.val.ptr, inc_x);
        },
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_cscal(n, &alpha, x.val.ptr, inc_x);
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_zscal(n, &alpha, x.val.ptr, inc_x);
        },
        else => @compileError("unexpected type"),
    }
}
pub fn scal_cr(comptime T: type, alpha: ValueType(T), x: Vec(T)) void {
    // scale a complex vector by a real scalar

    var inc_x: blas_int = 1;

    switch (T) {
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_csscal(n, alpha, x.val.ptr, inc_x);
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_zdscal(n, alpha, x.val.ptr, inc_x);
        },
        else => @compileError("unexpected type"),
    }
}

//-----------------------------------------

pub fn dot(comptime T: type, x: Vec(T), y: Vec(T)) !T {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            return cblas.cblas_sdot(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            return cblas.cblas_ddot(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn dotc(comptime T: type, x: Vec(T), y: Vec(T)) !T {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    var res: T = undefined;

    switch (T) {
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var tmp = cblas.cblas_cdotc(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
            res.re = tmp.real;
            res.im = tmp.imag;
            return res;
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var tmp = cblas.cblas_zdotc(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
            res.re = tmp.real;
            res.im = tmp.imag;
            return res;
        },
        else => @compileError("unexpected type"),
    }
}

pub fn dotu(comptime T: type, x: Vec(T), y: Vec(T)) !T {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    var res: T = undefined;

    switch (T) {
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var tmp = cblas.cblas_cdotu(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
            res.re = tmp.real;
            res.im = tmp.imag;
            return res;
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var tmp = cblas.cblas_zdotu(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
            res.re = tmp.real;
            res.im = tmp.imag;
            return res;
        },
        else => @compileError("unexpected type"),
    }
}

pub fn dsdot(comptime T: type, x: Vec(T), y: Vec(T)) !f64 {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_dsdot(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn iamax(comptime T: type, x: Vec(T)) usize {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_isamax(n, x.val.ptr, inc_x));
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_idamax(n, x.val.ptr, inc_x));
        },
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_icamax(n, x.val.ptr, inc_x));
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_izamax(n, x.val.ptr, inc_x));
        },
        else => @compileError("unexpected type"),
    }
}

pub fn iamin(comptime T: type, x: Vec(T)) usize {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_isamin(n, x.val.ptr, inc_x));
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_idamin(n, x.val.ptr, inc_x));
        },
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_icamin(n, x.val.ptr, inc_x));
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_izamin(n, x.val.ptr, inc_x));
        },
        else => @compileError("unexpected type"),
    }
}

pub fn imax(comptime T: type, x: Vec(T)) usize {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_ismax(n, x.val.ptr, inc_x));
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_idmax(n, x.val.ptr, inc_x));
        },
        else => @compileError("unexpected type"),
    }
}

pub fn imin(comptime T: type, x: Vec(T)) usize {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_ismin(n, x.val.ptr, inc_x));
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return @intCast(usize, cblas.cblas_idmin(n, x.val.ptr, inc_x));
        },
        else => @compileError("unexpected type"),
    }
}

pub fn nrm2(comptime T: type, x: Vec(T)) ValueType(T) {
    var inc_x: blas_int = 1;

    switch (T) {
        f32 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_snrm2(n, x.val.ptr, inc_x);
        },
        f64 => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_dnrm2(n, x.val.ptr, inc_x);
        },
        Complex(f32) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_scnrm2(n, x.val.ptr, inc_x);
        },
        Complex(f64) => {
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_dznrm2(n, x.val.ptr, inc_x);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn rot(comptime T: type, x: Vec(T), y: Vec(T), c: ValueType(T), s: ValueType(T)) !void {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_srot(n, x.val.ptr, inc_x, y.val.ptr, inc_y, c, s);
        },
        f64 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_drot(n, x.val.ptr, inc_x, y.val.ptr, inc_y, c, s);
        },
        Complex(f32) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_csrot(n, x.val.ptr, inc_x, y.val.ptr, inc_y, c, s);
        },
        Complex(f64) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_zdrot(n, x.val.ptr, inc_x, y.val.ptr, inc_y, c, s);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn rotg(comptime T: type, aa: *T, bb: *T, cc: *ValueType(T), ss: *T) void {
    switch (T) {
        f32 => {
            cblas.cblas_srotg(aa, bb, cc, ss);
        },
        f64 => {
            cblas.cblas_drotg(aa, bb, cc, ss);
        },
        Complex(f32) => {
            cblas.cblas_crotg(aa, bb, cc, ss);
        },
        Complex(f64) => {
            cblas.cblas_zrotg(aa, bb, cc, ss);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn rotm(comptime T: type, x: Vec(T), y: Vec(T), d_param: [*c]ValueType(T)) !void {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_srotm(n, x.val.ptr, inc_x, y.val.ptr, inc_y, d_param);
        },
        f64 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_drotm(n, x.val.ptr, inc_x, y.val.ptr, inc_y, d_param);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn rotmg(comptime T: type, d1: *T, d2: *T, x1: *T, y1: T, d_param: [*c]T) void {
    switch (T) {
        f32 => {
            cblas.cblas_srotmg(d1, d2, x1, y1, d_param);
        },
        f64 => {
            cblas.cblas_drotmg(d1, d2, x1, y1, d_param);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn sdsdot(comptime T: type, alpha: ValueType(T), x: Vec(T), y: Vec(T)) !T {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            return cblas.cblas_sdsdot(n, alpha, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}

pub fn swap(comptime T: type, x: Vec(T), y: Vec(T)) !void {
    var inc_x: blas_int = 1;
    var inc_y: blas_int = 1;

    switch (T) {
        f32 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_sswap(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        f64 => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_dswap(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f32) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_cswap(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        Complex(f64) => {
            if (x.val.len != y.val.len) return error.Unequal_Vec_Lengths;
            var n: blas_int = @intCast(blas_int, x.val.len);
            cblas.cblas_zswap(n, x.val.ptr, inc_x, y.val.ptr, inc_y);
        },
        else => @compileError("unexpected type"),
    }
}
