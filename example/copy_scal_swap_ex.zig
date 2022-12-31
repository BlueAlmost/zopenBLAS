const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Vec = zopenBLAS.Vec;
const copy = zopenBLAS.copy;
const scal = zopenBLAS.scal;
const swap = zopenBLAS.swap;

pub fn main() !void {
    const R: type = f32;
    const U: type = Complex(R);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var x = try Vec(R).init(allocator, 4);
    var y = try Vec(R).init(allocator, 4);

    x.val[0] = 1.0;
    x.val[1] = 2.0;
    x.val[2] = 1.0;
    x.val[3] = -3.0;
    x.prt();
    y.prt();

    try copy(R, x, y);
    y.prt();
    try scal(R, 100, y);
    x.prt();
    y.prt();

    try swap(R, x, y);
    x.prt();
    y.prt();

    var u = try Vec(U).init(allocator, 4);
    var v = try Vec(U).init(allocator, 4);
    u.val[0].re = 1.0;
    u.val[1].re = 2.0;
    u.val[2].re = 1.0;
    u.val[3].re = -3.0;
    u.val[0].im = 1.1;
    u.val[1].im = -2.2;
    u.val[2].im = -1.3;
    u.val[3].im = -3.4;
    u.prt();

    try copy(U, u, v);
    v.prt();

    var beta = U.init(100, 0);
    try scal(U, beta, v);
    v.prt();

    try swap(U, u, v);
    u.prt();
    v.prt();
}
