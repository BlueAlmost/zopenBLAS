const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Vec = zopenBLAS.Vec;
const rotg = zopenBLAS.rotg;

pub fn main() !void {
    const R: type = f32;
    const U: type = Complex(R);

    var a: R = 4.4;
    var b: R = -1.3;
    var c: R = undefined;
    var s: R = undefined;

    print("a: {d}, b: {d}, c: {d}, s: {d}\n", .{ a, b, c, s });
    try rotg(R, &a, &b, &c, &s);
    print("a: {d}, b: {d}, c: {d}, s: {d}\n", .{ a, b, c, s });

    var ca = U.init(4.4, 1.0);
    var cb = U.init(0.4, -1.3);
    var cc: R = undefined;
    var cs: U = undefined;

    print("\nca: {any}\ncb: {any}\ncc: {any}\ncs: {any}\n", .{ ca, cb, cc, cs });
    try rotg(U, &ca, &cb, &cc, &cs);
    print("\nca: {any}\ncb: {any}\ncc: {any}\ncs: {any}\n", .{ ca, cb, cc, cs });
}
