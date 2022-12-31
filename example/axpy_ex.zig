const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Vec = zopenBLAS.Vec;
const axpy = zopenBLAS.axpy;

pub fn main() !void {
    const R: type = f32;
    const U: type = Complex(R);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var x = try Vec(R).init(allocator, 4);
    var y = try Vec(R).init(allocator, 4);
    var alpha: R = 111.111;

    x.val[0] = 1.0;
    x.val[1] = 2.0;
    x.val[2] = 1.0;
    x.val[3] = -3.0;
    x.prt();
    y.val[0] = 1.0;
    y.val[1] = 2.0;
    y.val[2] = 1.0;
    y.val[3] = -3.0;
    y.prt();

    try axpy(R, alpha, x, y);
    y.prt();

    var u = try Vec(U).init(allocator, 4);
    var v = try Vec(U).init(allocator, 4);
    var beta = U.init(111.111, 222.222);
    u.val[0].re = 1.0;
    u.val[1].re = 2.0;
    u.val[2].re = 1.0;
    u.val[3].re = -3.0;
    u.val[0].im = 1.1;
    u.val[1].im = -2.2;
    u.val[2].im = -1.3;
    u.val[3].im = -3.4;
    u.prt();

    v.val[0].re = 1.0;
    v.val[1].re = 2.0;
    v.val[2].re = 1.0;
    v.val[3].re = -3.0;
    v.val[0].im = 2.1;
    v.val[1].im = -2.2;
    v.val[2].im = -2.3;
    v.val[3].im = -2.4;
    v.prt();
    try axpy(U, beta, u, v);
    v.prt();
}
