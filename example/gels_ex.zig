const std = @import("std");
const Complex = std.math.Complex;
const zopenBLAS = @import("zopenBLAS");
const print = std.debug.print;

const Mat = zopenBLAS.Mat;

const lp_int = zopenBLAS.lp_int;
const Layout = zopenBLAS.LP_layout;
const Trans = zopenBLAS.LP_trans;

pub fn main() !void {
    const R: type = f64;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var A = try Mat(R).init(allocator, 3, 2);
    var B = try Mat(R).init(allocator, 2, 3);
    var W = try Mat(R).init(allocator, 3, 3);

    A.val[0] = 1.0;
    A.val[1] = 2.0;
    A.val[2] = 1.0;
    A.val[3] = -3.0;
    A.val[4] = 4.0;
    A.val[5] = -1.0;
    B.val[0] = 1.0;
    B.val[1] = 2.0;
    B.val[2] = 1.0;
    B.val[3] = -3.0;
    B.val[4] = 4.0;
    B.val[5] = -1.0;
    W.zeros();

    A.prt();
    B.prt();
    W.prt();

    var info: lp_int = 0;

    print("------------- before: A, B, W\n", .{});
    A.prt();
    B.prt();
    W.prt();

    try zopenBLAS.gels(R, Trans.no_t, A, B, W, &info);

    print("------------- after: A, B, W\n", .{});
    A.prt();
    B.prt();
    W.prt();
}
