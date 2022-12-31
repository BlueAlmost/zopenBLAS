const std = @import("std");
const print = std.debug.print;
const zopenBLAS = @import("zopenBLAS");

const Complex = std.math.Complex;

const Vec = zopenBLAS.Vec;
const eps = 1e-6;

test "asum - real \n" {
    const asum = zopenBLAS.asum;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = asum(R, x);

        try std.testing.expectApproxEqAbs(@as(R, 7), q, eps);
    }
}

test "asum - complex \n" {
    const asum = zopenBLAS.asum;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var q = asum(C, x);

        try std.testing.expectApproxEqAbs(@as(R, 14), q, eps);
    }
}

test "axpy - real \n" {
    const axpy = zopenBLAS.axpy;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4, -3 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha: R = 2.0;

        try axpy(R, alpha, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1), x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3), x.val[3], eps);

        try std.testing.expectApproxEqAbs(@as(R, 4), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -2), y.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -9), y.val[3], eps);
    }
}

test "axpy - complex \n" {
    const axpy = zopenBLAS.axpy;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2), C.init(1, -2), C.init(-3, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var alpha = C.init(2.0, 3.0);

        try axpy(C, alpha, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.0), x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.0), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.0), y.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 12.0), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0), y.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 6.0), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.0), y.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.0), y.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -17.0), y.val[3].im, eps);
    }
}

test "copy - real \n" {
    const copy = zopenBLAS.copy;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4, -3 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        try copy(R, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1), x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3), x.val[3], eps);

        try std.testing.expectApproxEqAbs(@as(R, 1), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1), y.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3), y.val[3], eps);
    }
}

test "copy - complex \n" {
    const copy = zopenBLAS.copy;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2), C.init(1, -2), C.init(-3, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        try copy(C, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.0), x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), y.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.0), y.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -3.0), y.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), y.val[3].im, eps);
    }
}

test "dot - real vector dot product \n" {
    const dot = zopenBLAS.dot;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4, -3 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var result: R = try dot(R, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 3.0), result, eps);
    }
}

test "dotu/dotc - complex vector dot products \n" {
    const dotu = zopenBLAS.dotu;
    const dotc = zopenBLAS.dotc;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2), C.init(1, -2), C.init(-3, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var result = try dotu(C, x, y);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), result.re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.0), result.im, eps);

        result = try dotc(C, x, y);
        try std.testing.expectApproxEqAbs(@as(R, 29.0), result.re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), result.im, eps);
    }
}

test "dsdot - real single prec. dot w/ dbl out \n" {
    const dsdot = zopenBLAS.dsdot;
    const R = f32;
    const D = f64;

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var xx = [_]R{ 1, 2, 1, -3 };
    var x = try Vec(R).init(allocator, xx.len);
    x.val = xx[0..];

    var yy = [_]R{ 2, -2, -4, -3 };
    var y = try Vec(R).init(allocator, yy.len);
    y.val = yy[0..];

    var result = try dsdot(R, x, y);

    try std.testing.expectApproxEqAbs(@as(D, 3.0), result, eps);
}

test "iamax - real \n" {
    const iamax = zopenBLAS.iamax;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3, 3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = iamax(R, x);

        try std.testing.expectEqual(@as(usize, 3), q);
    }
}

test "iamax - complex \n" {
    const iamax = zopenBLAS.iamax;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var q = iamax(C, x);

        try std.testing.expectEqual(@as(usize, 3), q);
    }
}

test "iamin - real \n" {
    const iamin = zopenBLAS.iamin;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3, 3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = iamin(R, x);

        try std.testing.expectEqual(@as(usize, 0), q);
    }
}

test "iamin - complex \n" {
    const iamin = zopenBLAS.iamin;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var q = iamin(C, x);

        try std.testing.expectEqual(@as(usize, 0), q);
    }
}

test "imax - real \n" {
    const imax = zopenBLAS.imax;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3, 3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = imax(R, x);

        try std.testing.expectEqual(@as(usize, 4), q);
    }
}

test "imin - real \n" {
    const imin = zopenBLAS.imin;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3, 3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = imin(R, x);

        try std.testing.expectEqual(@as(usize, 3), q);
    }
}

test "nrm2 - real \n" {
    const nrm2 = zopenBLAS.nrm2;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var q = nrm2(R, x);

        try std.testing.expectApproxEqAbs(@as(R, 3.872983346207417), q, eps);
    }
}

test "nrm2 - complex \n" {
    const nrm2 = zopenBLAS.nrm2;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        // var q: R = nrm2(C, R, x);
        var q = nrm2(C, x);

        try std.testing.expectApproxEqAbs(@as(R, 5.477225575051661), q, eps);
    }
}

test "rot - real vector rotation \n" {
    const rot = zopenBLAS.rot;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var c: R = @cos(0.6);
        var s: R = @sin(0.6);

        try rot(R, x, y, c, s);

        try std.testing.expectApproxEqAbs(@as(R, 1.95462056), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.521386283), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.433234278), x.val[2], eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.086028756), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.779956176), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.865984933), y.val[2], eps);
    }
}

test "rot - complex vector rotation \n" {
    const rot = zopenBLAS.rot;
    inline for (.{ f32, f64 }) |R| {
        const C = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 2), C.init(2, 1), C.init(1, 1) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(2, 1), C.init(-2, 3), C.init(-4, 1) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        var c: R = @cos(0.6);
        var s: R = @sin(0.6);

        try rot(C, x, y, c, s);

        try std.testing.expectApproxEqAbs(@as(R, 1.95462056), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.215313702), x.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.521386283), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.519263035), x.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.433234278), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.389978088), x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.086028756), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -0.303949332), y.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.779956176), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.911364371), y.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.865984933), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.260693141), y.val[2].im, eps);
    }
}

test "rotg - real generate plane rotation \n" {
    const rotg = zopenBLAS.rotg;
    inline for (.{ f32, f64 }) |R| {
        var a: R = 1.0; // in: a, out: r
        var b: R = 2.0; // in: b, out: z
        var c: R = undefined; //        out: c
        var s: R = undefined; //        out: s

        rotg(R, &a, &b, &c, &s);

        try std.testing.expectApproxEqAbs(@as(R, 2.23606797749979), a, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.23606797749979), b, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.447213595499957), c, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.894427190999915), s, eps);
    }
}

test "rotg - complex generate plane rotation \n" {
    const rotg = zopenBLAS.rotg;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var za = C.init(1.1, -2.1); // in: a, out: r
        var zb = C.init(3.2, 1.3); // in: b, out: z
        var zc: R = undefined; //        out: c
        var zs = C.init(undefined, undefined); //        out: s

        rotg(C, &za, &zb, &zc, &zs);

        try std.testing.expectApproxEqAbs(@as(R, 1.9438515166702446), za.re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.71098925909774), za.im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.2), zb.re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.3), zb.im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.565886844013819), zc, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.07954637131155111), zs.re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -0.8206366154292927), zs.im, eps);
    }
}

test "rotm - Givens rotation \n" {
    const rotm = zopenBLAS.rotm;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4, -3 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        var d_param = [_]R{ -1, 1.1, 2.1, -0.3, 3.2 };
        try rotm(R, x, y, &d_param);

        try std.testing.expectApproxEqAbs(@as(R, 0.5), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.8), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.3), x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.4), x.val[3], eps);

        try std.testing.expectApproxEqAbs(@as(R, 8.5), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.2), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -10.7), y.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -15.9), y.val[3], eps);
    }
}

test "rotmg - construction of modified Given rot matrix test \n" {
    const rotmg = zopenBLAS.rotmg;
    inline for (.{ f32, f64 }) |R| {
        var d1: R = 1.0; // in: a, out: r
        var d2: R = 1.2; // in: a, out: r
        var x1: R = -3.4; // in: a, out: r
        var y1: R = 4.5; // in: a, out: r
        var d_param = [_]R{ undefined, undefined, undefined, undefined, undefined };

        rotmg(R, &d1, &d2, &x1, y1, &d_param);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), d_param[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -0.629629629629), d_param[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0), d_param[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0), d_param[3], eps);
        try std.testing.expectApproxEqAbs(@as(R, -0.755555555555), d_param[4], eps);
    }
}

test "scal - real vector scaling by element type\n" {
    const scal = zopenBLAS.scal;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var alpha: R = 2.0;

        scal(R, alpha, x);

        try std.testing.expectApproxEqAbs(@as(R, 2), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 4), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -6), x.val[3], eps);
    }
}

test "scal - complex vector scaling by element type\n" {
    const scal = zopenBLAS.scal;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var alpha = C.init(2.0, -1.0);

        scal(C, alpha, x);

        try std.testing.expectApproxEqAbs(@as(R, 3.0), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -6.0), x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -9.0), x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].im, eps);
    }
}

test "scal_cr - complex vector scaling by real value type\n" {
    const scal_cr = zopenBLAS.scal_cr;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var alpha: R = 2.0;

        scal_cr(C, alpha, x);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 4.0), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.0), x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -6.0), x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -6.0), x.val[3].im, eps);
    }
}

test "sdsdot - real single prec. dot with dbl accum \n" {
    const sdsdot = zopenBLAS.sdsdot;
    const R = f32;

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var xx = [_]R{ 1, 2, 1, -3 };
    var x = try Vec(R).init(allocator, xx.len);
    x.val = xx[0..];

    var yy = [_]R{ 2, -2, -4, -3 };
    var y = try Vec(R).init(allocator, yy.len);
    y.val = yy[0..];

    var alpha: R = 2.0;

    var result = try sdsdot(R, alpha, x, y);

    try std.testing.expectApproxEqAbs(@as(R, 5.0), result, eps);
}

test "swap - real \n" {
    const swap = zopenBLAS.swap;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]R{ 1, 2, 1, -3 };
        var x = try Vec(R).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]R{ 2, -2, -4, -3 };
        var y = try Vec(R).init(allocator, yy.len);
        y.val = yy[0..];

        try swap(R, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 2), x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -2), x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -4), x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3), x.val[3], eps);

        try std.testing.expectApproxEqAbs(@as(R, 1), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1), y.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3), y.val[3], eps);
    }
}

test "swap - complex \n" {
    const swap = zopenBLAS.swap;
    inline for (.{ f32, f64 }) |R| {
        const C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var xx = [_]C{ C.init(1, 1), C.init(2, -2), C.init(1, -1), C.init(-3, -3) };
        var x = try Vec(C).init(allocator, xx.len);
        x.val = xx[0..];

        var yy = [_]C{ C.init(1, 2), C.init(2, -2), C.init(1, -2), C.init(-3, -2) };
        var y = try Vec(C).init(allocator, yy.len);
        y.val = yy[0..];

        try swap(C, x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.0), x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[2].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), x.val[3].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.0), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.0), y.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.0), y.val[2].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), y.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.0), y.val[3].im, eps);
    }
}
