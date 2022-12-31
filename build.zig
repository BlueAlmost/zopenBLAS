const std = @import("std");
const Pkg = std.build.Pkg;

const pkgs = struct {
    const zopenBLAS = Pkg{
        .name = "zopenBLAS",
        .source = .{ .path = "./zopenBLAS.zig" },
        .dependencies = &[_]Pkg{
            Pkg{
                .name = "zlinalg",
                .source = .{ .path = "../zlinalg/zlinalg.zig" },
                .dependencies = null,
            },
        },
    };
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe_targets = [_]Target{
        .{ .name = "gels_ex", .src = "example/gels_ex.zig", .desc = "gen mat lst sqr solver" },
        .{ .name = "gemm_ex", .src = "example/gemm_ex.zig", .desc = "general matrix multiply" },
        .{ .name = "dot_ex", .src = "example/dot_ex.zig", .desc = "dot example" },
    };

    for (exe_targets) |e_target| {
        e_target.build(b);
    }

    const exe_tests = b.addTest("./main_test.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    exe_tests.addPackage(pkgs.zopenBLAS);

    exe_tests.addLibraryPath("/opt/OpenBLAS/lib");
    exe_tests.linkSystemLibrary("openblas");
    exe_tests.linkLibC();

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

//---------------------------------------------------------------------------

const Target = struct {
    name: []const u8,
    src: []const u8,
    desc: []const u8,

    pub fn build(self: Target, b: *std.build.Builder) void {

        b.exe_dir = b.pathFromRoot("./bin");
        
        // const target = b.standardTargetOptions(.{});
        const mode = b.standardReleaseOptions();

        var exe = b.addExecutable(self.name, self.src);

        exe.setBuildMode(b.standardReleaseOptions());
        // exe.setTarget(target);
        exe.setBuildMode(mode);

        // openBLAS
        exe.addPackage(pkgs.zopenBLAS);
        exe.addLibraryPath("/opt/OpenBLAS/lib");
        exe.linkSystemLibrary("openblas");

        // lapack
        exe.addLibraryPath("/usr/lib/gcc/x86_64-linux-gnu/10");
        exe.linkSystemLibrary("gfortran");
        exe.linkSystemLibrary("pthread");
        exe.linkSystemLibrary("unwind");

        // libc
        exe.linkLibC();

        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
    }
};
