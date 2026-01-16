const std = @import("std");

pub const BinaryWriter = struct {
    buf: []u8,
    pos: usize,

    pub fn init(buf: []u8) BinaryWriter {
        return BinaryWriter{ .buf = buf, .pos = 0 };
    }

    pub fn remaining(self: *const BinaryWriter) usize {
        return self.buf.len - self.pos;
    }

    pub fn write(self: *BinaryWriter, data: []const u8) error{EndOfStream}!void {
        if (self.pos + data.len > self.buf.len) return error.EndOfStream;

        std.mem.copyForwards(u8, self.buf[self.pos..], data);
        self.pos += data.len;
    }

    pub fn writeU8(self: *BinaryWriter, value: u8) error{EndOfStream}!void {
        try self.write(&[_]u8{value});
    }

    pub fn writeU16LE(self: *BinaryWriter, value: u16) error{EndOfStream}!void {
        try self.write(&[_]u8{ @intCast(value & 0xFF), @intCast((value >> 8) & 0xFF) });
    }

    pub fn writeU16BE(self: *BinaryWriter, value: u16) error{EndOfStream}!void {
        try self.write(&[_]u8{ @intCast((value >> 8) & 0xFF), @intCast(value & 0xFF) });
    }

    pub fn writeU24LE(self: *BinaryWriter, value: u24) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast(value & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast((value >> 16) & 0xFF),
        });
    }

    pub fn writeU24BE(self: *BinaryWriter, value: u24) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast((value >> 16) & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast(value & 0xFF),
        });
    }

    pub fn writeU32LE(self: *BinaryWriter, value: u32) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast(value & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast((value >> 16) & 0xFF),
            @intCast((value >> 24) & 0xFF),
        });
    }

    pub fn writeU32BE(self: *BinaryWriter, value: u32) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast((value >> 24) & 0xFF),
            @intCast((value >> 16) & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast(value & 0xFF),
        });
    }

    pub fn writeU64LE(self: *BinaryWriter, value: u64) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast(value & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast((value >> 16) & 0xFF),
            @intCast((value >> 24) & 0xFF),
            @intCast((value >> 32) & 0xFF),
            @intCast((value >> 40) & 0xFF),
            @intCast((value >> 48) & 0xFF),
            @intCast((value >> 56) & 0xFF),
        });
    }

    pub fn writeU64BE(self: *BinaryWriter, value: u64) error{EndOfStream}!void {
        try self.write(&[_]u8{
            @intCast((value >> 56) & 0xFF),
            @intCast((value >> 48) & 0xFF),
            @intCast((value >> 40) & 0xFF),
            @intCast((value >> 32) & 0xFF),
            @intCast((value >> 24) & 0xFF),
            @intCast((value >> 16) & 0xFF),
            @intCast((value >> 8) & 0xFF),
            @intCast(value & 0xFF),
        });
    }

    pub fn writeULongLE(self: *BinaryWriter, value: u64) error{EndOfStream}!void {
        try self.writeU64LE(value);
    }

    pub fn writeULongBE(self: *BinaryWriter, value: u64) error{EndOfStream}!void {
        try self.writeU64BE(value);
    }

    pub fn writeUShortLE(self: *BinaryWriter, value: u16) error{EndOfStream}!void {
        try self.writeU16LE(value);
    }

    pub fn writeUShortBE(self: *BinaryWriter, value: u16) error{EndOfStream}!void {
        try self.writeU16BE(value);
    }

    pub fn writeI8(self: *BinaryWriter, value: i8) error{EndOfStream}!void {
        try self.writeU8(@bitCast(value));
    }

    pub fn writeI16LE(self: *BinaryWriter, value: i16) error{EndOfStream}!void {
        try self.writeU16LE(@bitCast(value));
    }

    pub fn writeI16BE(self: *BinaryWriter, value: i16) error{EndOfStream}!void {
        try self.writeU16BE(@bitCast(value));
    }

    pub fn writeI24LE(self: *BinaryWriter, value: i24) error{EndOfStream}!void {
        try self.writeU24LE(@bitCast(value));
    }

    pub fn writeI24BE(self: *BinaryWriter, value: i24) error{EndOfStream}!void {
        try self.writeU24BE(@bitCast(value));
    }

    pub fn writeI32LE(self: *BinaryWriter, value: i32) error{EndOfStream}!void {
        try self.writeU32LE(@bitCast(value));
    }

    pub fn writeI32BE(self: *BinaryWriter, value: i32) error{EndOfStream}!void {
        try self.writeU32BE(@bitCast(value));
    }

    pub fn writeI64LE(self: *BinaryWriter, value: i64) error{EndOfStream}!void {
        try self.writeU64LE(@bitCast(value));
    }

    pub fn writeI64BE(self: *BinaryWriter, value: i64) error{EndOfStream}!void {
        try self.writeU64BE(@bitCast(value));
    }

    pub fn writeLongLE(self: *BinaryWriter, value: i64) error{EndOfStream}!void {
        try self.writeI64LE(value);
    }

    pub fn writeLongBE(self: *BinaryWriter, value: i64) error{EndOfStream}!void {
        try self.writeI64BE(value);
    }

    pub fn writeShortLE(self: *BinaryWriter, value: i16) error{EndOfStream}!void {
        try self.writeI16LE(value);
    }

    pub fn writeShortBE(self: *BinaryWriter, value: i16) error{EndOfStream}!void {
        try self.writeI16BE(value);
    }

    pub fn writeBool(self: *BinaryWriter, value: bool) error{EndOfStream}!void {
        try self.writeU8(if (value) 1 else 0);
    }

    pub fn writeVarInt(self: *BinaryWriter, value: u32) error{EndOfStream}!void {
        var buf: [5]u8 = undefined;
        var v = value;
        var len: usize = 0;
        while (true) {
            if ((v & ~@as(u32, 0x7F)) == 0) {
                buf[len] = @truncate(v);
                len += 1;
                break;
            }
            buf[len] = @as(u8, @truncate(v & 0x7F)) | 0x80;
            v >>= 7;
            len += 1;
        }
        try self.write(buf[0..len]);
    }
    pub fn writeVarLong(self: *BinaryWriter, value: u64) error{EndOfStream}!void {
        var buf: [10]u8 = undefined;
        var v = value;
        var len: usize = 0;
        while (true) {
            if ((v & ~@as(u64, 0x7F)) == 0) {
                buf[len] = @truncate(v);
                len += 1;
                break;
            }
            buf[len] = @as(u8, @truncate(v & 0x7F)) | 0x80;
            v >>= 7;
            len += 1;
        }
        try self.write(buf[0..len]);
    }

    pub fn writeZigZag(self: *BinaryWriter, value: i32) error{EndOfStream}!void {
        try self.writeVarInt(@bitCast((value << 1) ^ (value >> 31)));
    }

    pub fn writeZigZag64(self: *BinaryWriter, value: i64) error{EndOfStream}!void {
        try self.writeVarLong(@bitCast((value << 1) ^ (value >> 63)));
    }

    pub fn writeFloat32LE(self: *BinaryWriter, value: f32) error{EndOfStream}!void {
        const bits: u32 = @bitCast(value);
        try self.write(&[_]u8{
            @intCast(bits & 0xFF),
            @intCast((bits >> 8) & 0xFF),
            @intCast((bits >> 16) & 0xFF),
            @intCast((bits >> 24) & 0xFF),
        });
    }

    pub fn writeFloat32BE(self: *BinaryWriter, value: f32) error{EndOfStream}!void {
        const bits: u32 = @bitCast(value);
        try self.write(&[_]u8{
            @intCast((bits >> 24) & 0xFF),
            @intCast((bits >> 16) & 0xFF),
            @intCast((bits >> 8) & 0xFF),
            @intCast(bits & 0xFF),
        });
    }

    pub fn writeFloat64LE(self: *BinaryWriter, value: f64) error{EndOfStream}!void {
        const bits: u64 = @bitCast(value);
        try self.write(&[_]u8{
            @intCast(bits & 0xFF),
            @intCast((bits >> 8) & 0xFF),
            @intCast((bits >> 16) & 0xFF),
            @intCast((bits >> 24) & 0xFF),
            @intCast((bits >> 32) & 0xFF),
            @intCast((bits >> 40) & 0xFF),
            @intCast((bits >> 48) & 0xFF),
            @intCast((bits >> 56) & 0xFF),
        });
    }

    pub fn writeFloat64BE(self: *BinaryWriter, value: f64) error{EndOfStream}!void {
        const bits: u64 = @bitCast(value);
        try self.write(&[_]u8{
            @intCast((bits >> 56) & 0xFF),
            @intCast((bits >> 48) & 0xFF),
            @intCast((bits >> 40) & 0xFF),
            @intCast((bits >> 32) & 0xFF),
            @intCast((bits >> 24) & 0xFF),
            @intCast((bits >> 16) & 0xFF),
            @intCast((bits >> 8) & 0xFF),
            @intCast(bits & 0xFF),
        });
    }

    pub fn writeString16LE(self: *BinaryWriter, str: []const u8) error{EndOfStream}!void {
        try self.writeU16LE(@intCast(str.len));
        try self.write(str);
    }

    pub fn writeString16BE(self: *BinaryWriter, str: []const u8) error{EndOfStream}!void {
        try self.writeU16BE(@intCast(str.len));
        try self.write(str);
    }

    pub fn writeString32LE(self: *BinaryWriter, str: []const u8) error{EndOfStream}!void {
        try self.writeU32LE(@intCast(str.len));
        try self.write(str);
    }

    pub fn writeString32BE(self: *BinaryWriter, str: []const u8) error{EndOfStream}!void {
        try self.writeU32BE(@intCast(str.len));
        try self.write(str);
    }

    pub fn writeVarString(self: *BinaryWriter, str: []const u8) error{EndOfStream}!void {
        try self.writeVarInt(@intCast(str.len));
        try self.write(str);
    }
};
