const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Vec = zopenBLAS.Vec;
const nrm2 = zopenBLAS.nrm2;
const asum = zopenBLAS.asum;
const iamax = zopenBLAS.iamax;

pub fn main() !void {
    const R: type = f32;
    const U: type = Complex(R);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var x = try Vec(R).init(allocator, 4);

    x.val[0] = 1.0;
    x.val[1] = 2.0;
    x.val[2] = -6.0;
    x.val[3] = -3.0;
    x.prt();

    var r_norm: R = try nrm2(R, x);
    print("r_norm: {d}\n", .{r_norm});

    var r_asum: R = try asum(R, x);
    print("r_asum: {d}\n", .{r_asum});

    var r_iamax: usize = try iamax(R, x);
    print("r_iamax: {d}\n", .{r_iamax});

    var u = try Vec(U).init(allocator, 4);
    u.val[0].re = 1.0;
    u.val[1].re = 2.0;
    u.val[2].re = 1.0;
    u.val[3].re = -3.0;
    u.val[0].im = 1.1;
    u.val[1].im = -2.2;
    u.val[2].im = -1.3;
    u.val[3].im = -3.4;
    u.prt();

    var c_norm: U = try nrm2(U, u);
    print("c_norm: {d}\n", .{c_norm.re});

    var c_asum: U = try asum(U, u);
    print("c_asum: {d}\n", .{c_asum.re});

    var c_iamax: usize = try iamax(U, u);
    print("c_iamax: {d}\n", .{c_iamax});
}
