const std = @import("std");
const print = std.debug.print;
const Complex = std.math.Complex;

const zopenBLAS = @import("../zopenBLAS.zig");

// containers
const Vec = zopenBLAS.Vec;
const Mat = zopenBLAS.Mat;

//-------------------------------

pub fn ValueType(comptime T: type) type {
    switch (T) {
        f32, Complex(f32) => {
            return f32;
        },
        []f32, []Complex(f32) => {
            return f32;
        },
        Vec(f32), Mat(f32), Vec(Complex(f32)), Mat(Complex(f32)) => {
            return f32;
        },

        f64, Complex(f64) => {
            return f64;
        },
        []f64, []Complex(f64) => {
            return f64;
        },
        Vec(f64), Mat(f64), Vec(Complex(f64)), Mat(Complex(f64)) => {
            return f64;
        },
        else => {
            @compileError("type not implemented");
        },
    }
}

pub fn ElementType(comptime T: type) type {
    switch (T) {
        f32, []f32, Vec(f32), Mat(f32) => {
            return f32;
        },
        f64, []f64, Vec(f64), Mat(f64) => {
            return f64;
        },
        []Complex(f32), Vec(Complex(f32)), Mat(Complex(f32)) => {
            return Complex(f32);
        },
        []Complex(f64), Vec(Complex(f64)), Mat(Complex(f64)) => {
            return Complex(f64);
        },
        else => {
            @compileError("type not implemented");
        },
    }
}

pub fn isComplex(comptime T: type) bool {
    switch (T) {
        f32, f64, Vec(f32), Vec(f64), Mat(f32), Mat(f64) => {
            return false;
        },

        Complex(f32),
        Complex(f64),
        Vec(Complex(f32)),
        Vec(Complex(f64)),
        Mat(Complex(f32)),
        Mat(Complex(f64)),
        => {
            return true;
        },

        else => {
            @compileError("type not implemented");
        },
    }
}
