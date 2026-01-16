const std = @import("std");

pub const BinaryReader = struct {
    buf: []const u8,
    pos: usize = 0,

    pub fn init(buf: []const u8) BinaryReader {
        return BinaryReader{ .buf = buf, .pos = 0 };
    }

    pub fn skip(self: *BinaryReader, n: usize) error{EndOfStream}!void {
        if (self.pos + n > self.buf.len) return error.EndOfStream;
        self.pos += n;
    }

    pub fn remaining(self: *const BinaryReader) usize {
        return self.buf.len - self.pos;
    }

    pub fn read(self: *BinaryReader, n: usize) error{EndOfStream}![]const u8 {
        if (self.pos + n > self.buf.len) return error.EndOfStream;
        const out = self.buf[self.pos .. self.pos + n];
        self.pos += n;
        return out;
    }

    pub fn readU8(self: *BinaryReader) error{EndOfStream}!u8 {
        const b = try self.read(1);
        return b[0];
    }

    pub fn readU16LE(self: *BinaryReader) error{EndOfStream}!u16 {
        const b = try self.read(2);
        return @as(u16, b[0]) | (@as(u16, b[1]) << 8);
    }

    pub fn readU16BE(self: *BinaryReader) error{EndOfStream}!u16 {
        const b = try self.read(2);
        return (@as(u16, b[0]) << 8) | @as(u16, b[1]);
    }

    pub fn readU24LE(self: *BinaryReader) error{EndOfStream}!u24 {
        const b = try self.read(3);
        return @as(u24, b[0]) | (@as(u24, b[1]) << 8) | (@as(u24, b[2]) << 16);
    }

    pub fn readU24BE(self: *BinaryReader) error{EndOfStream}!u24 {
        const b = try self.read(3);
        return (@as(u24, b[0]) << 16) | (@as(u24, b[1]) << 8) | @as(u24, b[2]);
    }

    pub fn readU32LE(self: *BinaryReader) error{EndOfStream}!u32 {
        const b = try self.read(4);
        return @as(u32, b[0]) | (@as(u32, b[1]) << 8) | (@as(u32, b[2]) << 16) | (@as(u32, b[3]) << 24);
    }

    pub fn readU32BE(self: *BinaryReader) error{EndOfStream}!u32 {
        const b = try self.read(4);
        return (@as(u32, b[0]) << 24) | (@as(u32, b[1]) << 16) | (@as(u32, b[2]) << 8) | @as(u32, b[3]);
    }

    pub fn readU64LE(self: *BinaryReader) error{EndOfStream}!u64 {
        const b = try self.read(8);
        return @as(u64, b[0]) | (@as(u64, b[1]) << 8) | (@as(u64, b[2]) << 16) | (@as(u64, b[3]) << 24) |
            (@as(u64, b[4]) << 32) | (@as(u64, b[5]) << 40) | (@as(u64, b[6]) << 48) | (@as(u64, b[7]) << 56);
    }

    pub fn readU64BE(self: *BinaryReader) error{EndOfStream}!u64 {
        const b = try self.read(8);
        return (@as(u64, b[0]) << 56) | (@as(u64, b[1]) << 48) | (@as(u64, b[2]) << 40) | (@as(u64, b[3]) << 32) |
            (@as(u64, b[4]) << 24) | (@as(u64, b[5]) << 16) | (@as(u64, b[6]) << 8) | @as(u64, b[7]);
    }

    pub fn readULongLE(self: *BinaryReader) error{EndOfStream}!u64 {
        return try self.readU64LE();
    }

    pub fn readULongBE(self: *BinaryReader) error{EndOfStream}!u64 {
        return try self.readU64BE();
    }

    pub fn readUShortLE(self: *BinaryReader) error{EndOfStream}!u16 {
        return try self.readU16LE();
    }

    pub fn readUShortBE(self: *BinaryReader) error{EndOfStream}!u16 {
        return try self.readU16BE();
    }

    pub fn readI8(self: *BinaryReader) error{EndOfStream}!i8 {
        return @bitCast(try self.readU8());
    }

    pub fn readI16LE(self: *BinaryReader) error{EndOfStream}!i16 {
        return @bitCast(try self.readU16LE());
    }

    pub fn readI16BE(self: *BinaryReader) error{EndOfStream}!i16 {
        return @bitCast(try self.readU16BE());
    }

    pub fn readI24LE(self: *BinaryReader) error{EndOfStream}!i32 {
        const value = try self.read(3);

        var result: i32 = 0;

        result = @as(i32, @intCast(value[0])) |
            (@as(i32, @intCast(value[1])) << 8) |
            (@as(i32, @intCast(value[2])) << 16);

        if ((value[2] & 0x80) != 0) {
            result |= @as(i32, -16777216);
        }
        return result;
    }

    pub fn readI24BE(self: *BinaryReader) error{EndOfStream}!i32 {
        const value = try self.read(3);

        var result: i32 = 0;

        result = (@as(i32, @intCast(value[0])) << 16) |
            (@as(i32, @intCast(value[1])) << 8) |
            @as(i32, @intCast(value[2]));

        if ((value[0] & 0x80) != 0) {
            result |= @as(i32, -16777216);
        }
        return result;
    }

    pub fn readI32LE(self: *BinaryReader) error{EndOfStream}!i32 {
        return @bitCast(try self.readU32LE());
    }

    pub fn readI32BE(self: *BinaryReader) error{EndOfStream}!i32 {
        return @bitCast(try self.readU32BE());
    }

    pub fn readI64LE(self: *BinaryReader) error{EndOfStream}!i64 {
        return @bitCast(try self.readU64LE());
    }

    pub fn readI64BE(self: *BinaryReader) error{EndOfStream}!i64 {
        return @bitCast(try self.readU64BE());
    }

    pub fn readLongLE(self: *BinaryReader) error{EndOfStream}!i64 {
        return try self.readI64LE();
    }

    pub fn readLongBE(self: *BinaryReader) error{EndOfStream}!i64 {
        return try self.readI64BE();
    }

    pub fn readShortLE(self: *BinaryReader) error{EndOfStream}!i16 {
        return try self.readI16LE();
    }

    pub fn readShortBE(self: *BinaryReader) error{EndOfStream}!i16 {
        return try self.readI16BE();
    }

    pub fn readBool(self: *BinaryReader) error{EndOfStream}!bool {
        return try self.readU8() == 1;
    }

    pub fn readVarInt(self: *BinaryReader) error{ EndOfStream, Overflow }!usize {
        var value: u32 = 0;
        var shift: u5 = 0;
        while (shift < 35) {
            const byte = try self.readU8();
            value |= @as(u32, byte & 0x7F) << shift;
            if (byte & 0x80 == 0) return value;
            shift += 7;
        }
        return error.Overflow;
    }

    pub fn readVarLong(self: *BinaryReader) error{ EndOfStream, Overflow }!u64 {
        var value: u64 = 0;
        var shift: u6 = 0;
        var i: u4 = 0;
        while (i < 10) : (i += 1) {
            const byte = try self.readU8();
            value |= @as(u64, byte & 0x7F) << shift;
            if (byte & 0x80 == 0) return value;
            shift +%= 7;
        }
        return error.Overflow;
    }

    pub fn readZigZag(self: *BinaryReader) error{ EndOfStream, Overflow }!i32 {
        const value: usize = try self.readVarInt();
        const signedValue: i32 = @intCast(value);
        return (signedValue >> 1) ^ (-(signedValue & 1));
    }

    pub fn readZigZag64(self: *BinaryReader) error{ EndOfStream, Overflow }!i64 {
        const value: u64 = try self.readVarLong();
        const signedValue: i64 = @intCast(value);
        return (signedValue >> 1) ^ (-(signedValue & 1));
    }

    pub fn readFloat32LE(self: *BinaryReader) error{EndOfStream}!f32 {
        const bytes = try self.read(4);
        const bits: u32 = @as(u32, bytes[0]) | (@as(u32, bytes[1]) << 8) | (@as(u32, bytes[2]) << 16) | (@as(u32, bytes[3]) << 24);
        return @bitCast(bits);
    }

    pub fn readFloat32BE(self: *BinaryReader) error{EndOfStream}!f32 {
        const bytes = try self.read(4);
        const bits: u32 = (@as(u32, bytes[0]) << 24) | (@as(u32, bytes[1]) << 16) | (@as(u32, bytes[2]) << 8) | @as(u32, bytes[3]);
        return @bitCast(bits);
    }

    pub fn readFloat64LE(self: *BinaryReader) error{EndOfStream}!f64 {
        const bytes = try self.read(8);
        const bits: u64 = @as(u64, bytes[0]) | (@as(u64, bytes[1]) << 8) | (@as(u64, bytes[2]) << 16) | (@as(u64, bytes[3]) << 24) |
            (@as(u64, bytes[4]) << 32) | (@as(u64, bytes[5]) << 40) | (@as(u64, bytes[6]) << 48) | (@as(u64, bytes[7]) << 56);
        return @bitCast(bits);
    }

    pub fn readFloat64BE(self: *BinaryReader) error{EndOfStream}!f64 {
        const bytes = try self.read(8);
        const bits: u64 = (@as(u64, bytes[0]) << 56) | (@as(u64, bytes[1]) << 48) | (@as(u64, bytes[2]) << 40) | (@as(u64, bytes[3]) << 32) |
            (@as(u64, bytes[4]) << 24) | (@as(u64, bytes[5]) << 16) | (@as(u64, bytes[6]) << 8) | @as(u64, bytes[7]);
        return @bitCast(bits);
    }

    pub fn readString16LE(self: *BinaryReader) error{EndOfStream}![]const u8 {
        const length = try self.readU16LE();
        return try self.read(@as(usize, length));
    }

    pub fn readString16BE(self: *BinaryReader) error{EndOfStream}![]const u8 {
        const length = try self.readU16BE();
        return try self.read(@as(usize, length));
    }

    pub fn readString32LE(self: *BinaryReader) error{EndOfStream}![]const u8 {
        const length = try self.readU32LE();
        return try self.read(@as(usize, length));
    }

    pub fn readString32BE(self: *BinaryReader) error{EndOfStream}![]const u8 {
        const length = try self.readU32BE();
        return try self.read(@as(usize, length));
    }

    pub fn readVarString(self: *BinaryReader) error{ EndOfStream, Overflow }![]const u8 {
        const length = try self.readVarInt();
        return try self.read(length);
    }
};
