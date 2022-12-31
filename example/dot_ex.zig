const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Vec = zopenBLAS.Vec;
const dot = zopenBLAS.dot;
const dotu = zopenBLAS.dotu;
const dotc = zopenBLAS.dotc;

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
    y.val[0] = 1.0;
    y.val[1] = 2.0;
    y.val[2] = 1.0;
    y.val[3] = -3.0;
    y.prt();

    var rdot: R = try dot(R, x, y);
    print("rdot: {any}\n", .{rdot});

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

    v.val[0].re = 1.0;
    v.val[1].re = 2.0;
    v.val[2].re = 1.0;
    v.val[3].re = -3.0;
    v.val[0].im = 2.1;
    v.val[1].im = -2.2;
    v.val[2].im = -2.3;
    v.val[3].im = -2.4;
    v.prt();

    var uv_dotc: U = try dotc(U, u, v);
    print("\nuv_dotc: ({e:7.2}, {e:7.2})\n", .{ uv_dotc.re, uv_dotc.im });
    var uv_dotu: U = try dotu(U, u, v);
    print("\nuv_dotu: ({e:7.2}, {e:7.2})\n", .{ uv_dotu.re, uv_dotu.im });
}
