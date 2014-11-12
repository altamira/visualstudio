// Type: lybtrcom.Func
// Assembly: Ly000008, Version=5.0.0.0, Culture=neutral, PublicKeyToken=666697afb0e8e7b5
// MVID: 1D110809-DBFE-4AEC-A1DB-C2824EA241EF
// Assembly location: Z:\Ly000008.dll

using System;
using System.Runtime.InteropServices;

namespace lybtrcom
{
  public class Func
  {
    public Func()
    {
    }

    [DllImport("wbtrv32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern short BTRCALL(short Opcode, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] Cursor, IntPtr DataBuffer, ref short DataBufferLength, IntPtr KeyBuffer, short KeyLength, short KeyNum);

    [DllImport("wbtrv32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern short BTRCALLID(short Opcode, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] Cursor, IntPtr DataBuffer, ref short DataBufferLength, IntPtr KeyBuffer, short KeyLength, short KeyNum, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId);

    public static short BTRCALL_VarLength(short Opcode, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] Cursor, ref IntPtr DataBuffer, ref short DataBufferLength, IntPtr KeyBuffer, short KeyLength, short KeyNum, int[] offsets)
    {
      int val = 0;
      if ((int) Opcode == 23)
        val = Translate.Cmmn_ReadInt32(DataBuffer, 0);
      short num1 = Func.BTRCALL(Opcode, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, KeyLength, KeyNum);
      if ((int) num1 != 22)
        return num1;
      foreach (int pos in offsets)
      {
        uint num2 = (uint) Translate.Cmmn_ReadInt32(DataBuffer, pos);
        if ((long) DataBufferLength + (long) num2 > (long) short.MaxValue)
          DataBufferLength = short.MaxValue;
        else
          DataBufferLength += (short) num2;
      }
      DataBuffer = Marshal.ReAllocHGlobal(DataBuffer, new IntPtr((int) DataBufferLength));
      short num3;
      if ((int) Opcode == 23)
      {
        Translate.Cmmn_WriteInt32(DataBuffer, val);
        num3 = (short) 0;
      }
      else
      {
        short DataBufferLength1 = (short) 4;
        num3 = Func.BTRCALL((short) 22, Cursor, DataBuffer, ref DataBufferLength1, KeyBuffer, KeyLength, (short) 0);
      }
      if ((int) num3 == 0)
        return Func.BTRCALL((short) 23, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, KeyLength, KeyNum);
      else
        return num3;
    }

    public static short BTRCALLID_VarLength(short Opcode, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] Cursor, ref IntPtr DataBuffer, ref short DataBufferLength, IntPtr KeyBuffer, short KeyLength, short KeyNum, int[] offsets, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      int val = 0;
      if ((int) Opcode == 23)
        val = Translate.Cmmn_ReadInt32(DataBuffer, 0);
      short num1 = Func.BTRCALLID(Opcode, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, KeyLength, KeyNum, ClientId);
      if ((int) num1 != 22)
        return num1;
      foreach (int pos in offsets)
      {
        uint num2 = (uint) Translate.Cmmn_ReadInt32(DataBuffer, pos);
        if ((long) DataBufferLength + (long) num2 > (long) short.MaxValue)
          DataBufferLength = short.MaxValue;
        else
          DataBufferLength += (short) num2;
      }
      DataBuffer = Marshal.ReAllocHGlobal(DataBuffer, new IntPtr((int) DataBufferLength));
      short num3;
      if ((int) Opcode == 23)
      {
        Translate.Cmmn_WriteInt32(DataBuffer, val);
        num3 = (short) 0;
      }
      else
      {
        short DataBufferLength1 = (short) 4;
        num3 = Func.BTRCALLID((short) 22, Cursor, DataBuffer, ref DataBufferLength1, KeyBuffer, KeyLength, (short) 0, ClientId);
      }
      if ((int) num3 == 0)
        return Func.BTRCALLID((short) 23, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, KeyLength, KeyNum, ClientId);
      else
        return num3;
    }
  }
}
