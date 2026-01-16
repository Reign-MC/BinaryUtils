const std = @import("std");

pub const BinaryReader = @import("reader.zig").BinaryReader;
pub const BinaryWriter = @import("writer.zig").BinaryWriter;

test "BinaryWriter/Reader full roundtrip with logging" {
    var buffer: [4096]u8 = undefined;
    var writer = BinaryWriter.init(buffer[0..]);
    const log = std.debug.print;

    try writer.writeU8(0xAB);
    try writer.writeU16LE(0xABCD);
    try writer.writeU16BE(0xABCD);
    try writer.writeU24LE(0x123456);
    try writer.writeU24BE(0x123456);
    try writer.writeU32LE(0x12345678);
    try writer.writeU32BE(0x12345678);
    try writer.writeU64LE(0x1122334455667788);
    try writer.writeU64BE(0x1122334455667788);

    try writer.writeULongLE(0x1122334455667788);
    try writer.writeULongBE(0x1122334455667788);
    try writer.writeUShortLE(0xABCD);
    try writer.writeUShortBE(0xABCD);

    try writer.writeI8(-42);
    try writer.writeI16LE(-12345);
    try writer.writeI16BE(-12345);
    try writer.writeI24LE(-0x123456);
    try writer.writeI24BE(-0x123456);
    try writer.writeI32LE(-123456789);
    try writer.writeI32BE(-123456789);
    try writer.writeI64LE(-0x1122334455667788);
    try writer.writeI64BE(-0x1122334455667788);

    try writer.writeLongLE(-0x1122334455667788);
    try writer.writeLongBE(-0x1122334455667788);
    try writer.writeShortLE(-12345);
    try writer.writeShortBE(-12345);

    try writer.writeBool(true);
    try writer.writeBool(false);

    try writer.writeVarInt(300);
    try writer.writeVarLong(1234567890123456789);
    try writer.writeZigZag(-12345);
    try writer.writeZigZag64(-1234567890123456789);

    try writer.writeFloat32LE(-1234.5678);
    try writer.writeFloat32BE(-1234.5678);
    try writer.writeFloat64LE(-129481.5678);
    try writer.writeFloat64BE(-129481.5678);

    const string16 = "Hello16";
    const string32 = "Hello32LongerString";
    try writer.writeString16LE(string16);
    try writer.writeString16BE(string16);
    try writer.writeString32LE(string32);
    try writer.writeString32BE(string32);
    try writer.writeVarString(string32);

    var reader = BinaryReader.init(buffer[0..writer.pos]);
    log("Reader initialized with {} bytes\n", .{writer.pos});

    try std.testing.expectEqual(@as(u8, 0xAB), try reader.readU8());
    log("Read U8: 0x{X}\n", .{0xAB});

    try std.testing.expectEqual(@as(u16, 0xABCD), try reader.readU16LE());
    log("Read U16LE: 0x{X}\n", .{0xABCD});
    try std.testing.expectEqual(@as(u16, 0xABCD), try reader.readU16BE());
    log("Read U16BE: 0x{X}\n", .{0xABCD});

    try std.testing.expectEqual(@as(u24, 0x123456), try reader.readU24LE());
    log("Read U24LE: 0x{X}\n", .{0x123456});
    try std.testing.expectEqual(@as(u24, 0x123456), try reader.readU24BE());
    log("Read U24BE: 0x{X}\n", .{0x123456});

    try std.testing.expectEqual(@as(u32, 0x12345678), try reader.readU32LE());
    log("Read U32LE: 0x{X}\n", .{0x12345678});
    try std.testing.expectEqual(@as(u32, 0x12345678), try reader.readU32BE());
    log("Read U32BE: 0x{X}\n", .{0x12345678});

    try std.testing.expectEqual(@as(u64, 0x1122334455667788), try reader.readU64LE());
    log("Read U64LE: 0x{X}\n", .{0x1122334455667788});
    try std.testing.expectEqual(@as(u64, 0x1122334455667788), try reader.readU64BE());
    log("Read U64BE: 0x{X}\n", .{0x1122334455667788});

    try std.testing.expectEqual(@as(u64, 0x1122334455667788), try reader.readULongLE());
    log("Read ULongLE: 0x{X}\n", .{0x1122334455667788});
    try std.testing.expectEqual(@as(u64, 0x1122334455667788), try reader.readULongBE());
    log("Read ULongBE: 0x{X}\n", .{0x1122334455667788});

    try std.testing.expectEqual(@as(u16, 0xABCD), try reader.readUShortLE());
    log("Read UShortLE: 0x{X}\n", .{0xABCD});
    try std.testing.expectEqual(@as(u16, 0xABCD), try reader.readUShortBE());
    log("Read UShortBE: 0x{X}\n", .{0xABCD});

    try std.testing.expectEqual(@as(i8, -42), try reader.readI8());
    log("Read I8: {d}\n", .{-42});
    try std.testing.expectEqual(@as(i16, -12345), try reader.readI16LE());
    log("Read I16LE: {d}\n", .{-12345});
    try std.testing.expectEqual(@as(i16, -12345), try reader.readI16BE());
    log("Read I16BE: {d}\n", .{-12345});
    try std.testing.expectEqual(@as(i24, -0x123456), try reader.readI24LE());
    log("Read I24LE: {d}\n", .{-0x123456});
    try std.testing.expectEqual(@as(i24, -0x123456), try reader.readI24BE());
    log("Read I24BE: {d}\n", .{-0x123456});
    try std.testing.expectEqual(@as(i32, -123456789), try reader.readI32LE());
    log("Read I32LE: {d}\n", .{-123456789});
    try std.testing.expectEqual(@as(i32, -123456789), try reader.readI32BE());
    log("Read I32BE: {d}\n", .{-123456789});
    try std.testing.expectEqual(@as(i64, -0x1122334455667788), try reader.readI64LE());
    log("Read I64LE: {d}\n", .{-0x1122334455667788});
    try std.testing.expectEqual(@as(i64, -0x1122334455667788), try reader.readI64BE());
    log("Read I64BE: {d}\n", .{-0x1122334455667788});

    try std.testing.expectEqual(@as(i64, -0x1122334455667788), try reader.readLongLE());
    log("Read LongLE: {d}\n", .{-0x1122334455667788});
    try std.testing.expectEqual(@as(i64, -0x1122334455667788), try reader.readLongBE());
    log("Read LongBE: {d}\n", .{-0x1122334455667788});

    try std.testing.expectEqual(@as(i16, -12345), try reader.readShortLE());
    log("Read ShortLE: {d}\n", .{-12345});
    try std.testing.expectEqual(@as(i16, -12345), try reader.readShortBE());
    log("Read ShortBE: {d}\n", .{-12345});

    try std.testing.expectEqual(true, try reader.readBool());
    log("Read Bool: true\n", .{});
    try std.testing.expectEqual(false, try reader.readBool());
    log("Read Bool: false\n", .{});

    try std.testing.expectEqual(300, try reader.readVarInt());
    log("Read VarInt: 300\n", .{});
    try std.testing.expectEqual(1234567890123456789, try reader.readVarLong());
    log("Read VarLong: 1234567890123456789\n", .{});
    try std.testing.expectEqual(-12345, try reader.readZigZag());
    log("Read ZigZag: -12345\n", .{});
    try std.testing.expectEqual(-1234567890123456789, try reader.readZigZag64());
    log("Read ZigZag64: -1234567890123456789\n", .{});

    try std.testing.expectEqual(-1234.5678, try reader.readFloat32LE());
    log("Read Float32LE: -1234.5678\n", .{});
    try std.testing.expectEqual(-1234.5678, try reader.readFloat32BE());
    log("Read Float32BE: -1234.5678\n", .{});
    try std.testing.expectEqual(-129481.5678, try reader.readFloat64LE());
    log("Read Float64LE: -129481.5678\n", .{});
    try std.testing.expectEqual(-129481.5678, try reader.readFloat64BE());
    log("Read Float64BE: -129481.5678\n", .{});

    try std.testing.expect(std.mem.eql(u8, string16, try reader.readString16LE()));
    log("Read String16LE: {s}\n", .{string16});
    try std.testing.expect(std.mem.eql(u8, string16, try reader.readString16BE()));
    log("Read String16BE: {s}\n", .{string16});
    try std.testing.expect(std.mem.eql(u8, string32, try reader.readString32LE()));
    log("Read String32LE: {s}\n", .{string32});
    try std.testing.expect(std.mem.eql(u8, string32, try reader.readString32BE()));
    log("Read String32BE: {s}\n", .{string32});
    try std.testing.expect(std.mem.eql(u8, string32, try reader.readVarString()));
    log("Read VarString: {s}\n", .{string32});
}
