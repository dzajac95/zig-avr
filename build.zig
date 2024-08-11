const std = @import("std");

const DEFAULT_PORT = "/dev/ttyACM0";

pub fn build(b: *std.Build) !void {
    const query = try std.Target.Query.parse(.{
        .arch_os_abi = "avr-freestanding-none",
        .cpu_features = "atmega328p",
    });
    const target = b.resolveTargetQuery(query);

    const exe = b.addExecutable(.{
        .name = "zig-avr.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseSmall,
    });
    exe.bundle_compiler_rt = false;
    exe.linker_script = b.path("src/avr5.ld");

    b.installArtifact(exe);

    var tmp = std.ArrayList(u8).init(b.allocator);
    try std.fmt.format(tmp.writer(), "Serial port the Arduino is connected to (defaults to {s})", .{DEFAULT_PORT});
    const port_help = try tmp.toOwnedSlice();
    const port = b.option(
        []const u8,
        "port",
        port_help
    ) orelse DEFAULT_PORT;


    try tmp.appendSlice("-Uflash:w:");
    try tmp.appendSlice(b.getInstallPath(.bin, exe.out_filename));
    try tmp.appendSlice(":e");
    const cmd_string = try tmp.toOwnedSlice();
    const flash_cmd = b.addSystemCommand(&.{
        "avrdude",
        "-c",
        "arduino",
        "-p",
        "m328p",
        "-D",
        "-P",
        port,
        cmd_string
    });
    flash_cmd.step.dependOn(b.getInstallStep());

    const flash_step = b.step("flash", "Flash the built binary using avrdude");
    flash_step.dependOn(&flash_cmd.step);
}
