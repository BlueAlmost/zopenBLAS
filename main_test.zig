test "begin test list\n" {
    _ = @import("./test/level_1_test.zig");
    _ = @import("./test/level_2_test.zig");
    _ = @import("./test/level_3_test.zig");
}
