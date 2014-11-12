// Type: lybtrcom.Translate
// Assembly: Ly000008, Version=5.0.0.0, Culture=neutral, PublicKeyToken=666697afb0e8e7b5
// MVID: 1D110809-DBFE-4AEC-A1DB-C2824EA241EF
// Assembly location: Z:\Ly000008.dll

using System;
using System.Runtime.InteropServices;

namespace lybtrcom
{
  public class Translate
  {
    public Translate()
    {
    }

    public static int Cmmn_ChrToInt(char ch)
    {
      return Convert.ToInt32(ch) - 48;
    }

    public static bool Cmmn_IsDigit(char ch)
    {
      return char.IsDigit(ch);
    }

    public static string Cmmn_IntToChr(int i)
    {
      return ((char) (i + 48)).ToString();
    }

    public static int Cmmn_GetASCII(char ch)
    {
      return Convert.ToInt32(ch);
    }

    public static char Cmmn_GetChar(int i)
    {
      return (char) i;
    }

    public static unsafe byte Cmmn_ReadByte(IntPtr source, int pos)
    {
      if (source == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      else
        return *(byte*) ((IntPtr) source.ToPointer() + pos);
    }

    public static unsafe short Cmmn_ReadInt16(IntPtr source, int pos)
    {
      if (source == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      else
        return *(short*) ((IntPtr) source.ToPointer() + pos);
    }

    public static unsafe int Cmmn_ReadInt32(IntPtr source, int pos)
    {
      if (source == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      else
        return *(int*) ((IntPtr) source.ToPointer() + pos);
    }

    public static unsafe long Cmmn_ReadInt64(IntPtr source, int pos)
    {
      if (source == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      else
        return *(long*) ((IntPtr) source.ToPointer() + pos);
    }

    public static unsafe void Cmmn_WriteByte(IntPtr dest, int pos, byte val)
    {
      if (dest == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      *(sbyte*) ((IntPtr) dest.ToPointer() + pos) = (sbyte) val;
    }

    public static unsafe void Cmmn_WriteByte(IntPtr dest, byte val)
    {
      if (dest == IntPtr.Zero)
        throw new ArgumentException();
      *(sbyte*) dest.ToPointer() = (sbyte) val;
    }

    public static unsafe void Cmmn_WriteInt16(IntPtr dest, int pos, short val)
    {
      if (dest == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      *(short*) ((IntPtr) dest.ToPointer() + pos) = val;
    }

    public static unsafe void Cmmn_WriteInt16(IntPtr dest, short val)
    {
      if (dest == IntPtr.Zero)
        throw new ArgumentException();
      *(short*) dest.ToPointer() = val;
    }

    public static unsafe void Cmmn_WriteInt32(IntPtr dest, int pos, int val)
    {
      if (dest == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      *(int*) ((IntPtr) dest.ToPointer() + pos) = val;
    }

    public static unsafe void Cmmn_WriteInt32(IntPtr dest, int val)
    {
      if (dest == IntPtr.Zero)
        throw new ArgumentException();
      *(int*) dest.ToPointer() = val;
    }

    public static unsafe void Cmmn_WriteInt64(IntPtr dest, int pos, long val)
    {
      if (dest == IntPtr.Zero || pos < 0)
        throw new ArgumentException();
      *(long*) ((IntPtr) dest.ToPointer() + pos) = val;
    }

    public static void Cmmn_ShortToBytes(short s, ref byte[] bta, int offset)
    {
      if (offset + 1 > bta.Length - 1)
        throw new IndexOutOfRangeException("Cannot convert short to byte-array.");
      bta[offset] = (byte) ((uint) s % 256U);
      bta[offset + 1] = (byte) ((int) s - (int) bta[offset + 1] >> 8);
    }

    public static string Cmmn_PtrToString(IntPtr source, long pos, int length)
    {
      return Marshal.PtrToStringAnsi(new IntPtr(source.ToInt64() + pos), length).Split(new char[1]
      {
        Translate.Cmmn_GetChar(0)
      })[0];
    }

    public static unsafe float BFLOAT4toSingle(IntPtr ptr, int offset)
    {
      byte* numPtr = (byte*) ((IntPtr) ptr.ToPointer() + offset);
      byte[] numArray1 = new byte[4];
      float[] numArray2 = new float[1];
      byte num1 = (byte) ((uint) numPtr[2] & 128U);
      for (int index = 0; index < 4; ++index)
        numArray1[index] = (byte) 0;
      if ((int) numPtr[3] == 0)
        return numArray2[0];
      numArray1[3] |= num1;
      byte num2 = (byte) ((uint) numPtr[3] - 2U);
      numArray1[3] |= (byte) ((uint) num2 >> 1);
      numArray1[2] |= (byte) ((uint) num2 << 7);
      numArray1[2] |= (byte) ((uint) numPtr[2] & (uint) sbyte.MaxValue);
      numArray1[1] = numPtr[1];
      numArray1[0] = *numPtr;
      Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 4);
      return numArray2[0];
    }

    public static void SingletoBFLOAT4(float psingle, IntPtr ptr, int offset)
    {
      float[] numArray1 = new float[1]
      {
        psingle
      };
      byte[] numArray2 = new byte[4];
      byte[] numArray3 = new byte[4];
      byte num1 = (byte) 0;
      Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 4);
      byte num2 = (byte) ((uint) numArray2[3] & 128U);
      byte num3 = (byte) ((uint) (byte) ((uint) num1 | (uint) (byte) ((uint) numArray2[3] << 1)) | (uint) (byte) ((uint) numArray2[2] >> 7));
      if ((int) num3 == 254)
      {
        for (int index = 0; index < 4; ++index)
          Translate.Cmmn_WriteByte(ptr, index + offset, (byte) 0);
      }
      else
      {
        byte num4 = (byte) ((uint) num3 + 2U);
        for (int index = 0; index < 4; ++index)
          numArray3[index] = (byte) 0;
        numArray3[3] = num4;
        numArray3[2] |= num2;
        numArray3[2] |= (byte) ((uint) numArray2[2] & (uint) sbyte.MaxValue);
        numArray3[1] = numArray2[1];
        numArray3[0] = numArray2[0];
        for (int index = 0; index < 4; ++index)
          Translate.Cmmn_WriteByte(ptr, index + offset, numArray3[index]);
      }
    }

    public static unsafe double BFLOAT8toDouble(IntPtr ptr, int offset)
    {
      byte* numPtr1 = (byte*) ((IntPtr) ptr.ToPointer() + offset);
      byte[] numArray1 = new byte[8];
      double[] numArray2 = new double[1];
      byte num1 = (byte) ((uint) numPtr1[6] & 128U);
      for (int index = 0; index < 8; ++index)
        numArray1[index] = (byte) 0;
      if ((int) numPtr1[7] == 0)
        return numArray2[0];
      numArray1[7] |= num1;
      uint num2 = (uint) ((int) numPtr1[7] - 128 - 1 + 1023);
      numArray1[7] |= (byte) (num2 >> 4);
      numArray1[6] |= (byte) (num2 << 4);
      for (int index = 6; index > 0; --index)
      {
        IntPtr num3 = (IntPtr) (numPtr1 + index);
        int num4 = (int) (byte) ((uint) *(byte*) num3 << 1);
        *(sbyte*) num3 = (sbyte) num4;
        IntPtr num5 = (IntPtr) (numPtr1 + index);
        int num6 = (int) (byte) ((uint) *(byte*) num5 | (uint) (byte) ((uint) numPtr1[index - 1] >> 7));
        *(sbyte*) num5 = (sbyte) num6;
      }
      byte* numPtr2 = numPtr1;
      int num7 = (int) (byte) ((uint) *numPtr2 << 1);
      *numPtr2 = (byte) num7;
      for (int index = 6; index > 0; --index)
      {
        numArray1[index] |= (byte) ((uint) numPtr1[index] >> 4);
        numArray1[index - 1] |= (byte) ((uint) numPtr1[index] << 4);
      }
      numArray1[0] |= (byte) ((uint) *numPtr1 >> 4);
      Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 8);
      return numArray2[0];
    }

    public static void DoubletoBFLOAT8(double pdouble, IntPtr ptr, int offset)
    {
      byte[] numArray1 = new byte[8];
      byte[] numArray2 = new byte[8];
      byte num1 = (byte) 0;
      Buffer.BlockCopy((Array) new double[1]
      {
        pdouble
      }, 0, (Array) numArray1, 0, 8);
      for (int index = 0; index < 8; ++index)
        numArray2[index] = (byte) 0;
      for (int index = 0; index < 8; ++index)
        num1 |= numArray1[index];
      if ((int) num1 == 0)
      {
        for (int index = 0; index < 8; ++index)
          Translate.Cmmn_WriteByte(ptr, index + offset, numArray2[index]);
      }
      else
      {
        byte num2 = (byte) ((uint) numArray1[7] & 128U);
        numArray2[6] |= num2;
        uint num3 = (uint) (((int) numArray1[7] & (int) sbyte.MaxValue) * 16) + ((uint) numArray1[6] >> 4);
        if ((int) num3 - 1023 - 128 > 0)
        {
          for (int index = 0; index < 8; ++index)
            Translate.Cmmn_WriteByte(ptr, index + offset, numArray2[index]);
        }
        else
        {
          numArray2[7] = (byte) ((int) num3 - 1023 + 128 + 1);
          numArray1[6] &= (byte) 15;
          for (int index = 6; index > 0; --index)
          {
            numArray2[index] |= (byte) ((uint) numArray1[index] << 3);
            numArray2[index] |= (byte) ((uint) numArray1[index - 1] >> 5);
          }
          numArray2[0] |= (byte) ((uint) numArray1[0] << 3);
          for (int index = 0; index < 8; ++index)
            Translate.Cmmn_WriteByte(ptr, index + offset, numArray2[index]);
        }
      }
    }

    public static unsafe float BFLOAT4toSingle(byte[] bt)
    {
      fixed (byte* numPtr = bt)
      {
        byte[] numArray1 = new byte[4];
        float[] numArray2 = new float[1];
        byte num1 = (byte) ((uint) numPtr[2] & 128U);
        for (int index = 0; index < 4; ++index)
          numArray1[index] = (byte) 0;
        if ((int) numPtr[3] == 0)
          return numArray2[0];
        numArray1[3] |= num1;
        byte num2 = (byte) ((uint) numPtr[3] - 2U);
        numArray1[3] |= (byte) ((uint) num2 >> 1);
        numArray1[2] |= (byte) ((uint) num2 << 7);
        numArray1[2] |= (byte) ((uint) numPtr[2] & (uint) sbyte.MaxValue);
        numArray1[1] = numPtr[1];
        numArray1[0] = numPtr[0];
        Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 4);
        return numArray2[0];
      }
    }

    public static byte[] SingletoBFLOAT4(float psingle)
    {
      float[] numArray1 = new float[1]
      {
        psingle
      };
      byte[] numArray2 = new byte[4];
      byte[] numArray3 = new byte[4];
      byte num1 = (byte) 0;
      Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 4);
      for (int index = 0; index < 4; ++index)
        numArray3[index] = (byte) 0;
      byte num2 = (byte) ((uint) numArray2[3] & 128U);
      byte num3 = (byte) ((uint) (byte) ((uint) num1 | (uint) (byte) ((uint) numArray2[3] << 1)) | (uint) (byte) ((uint) numArray2[2] >> 7));
      if ((int) num3 == 254)
        return numArray3;
      byte num4 = (byte) ((uint) num3 + 2U);
      numArray3[3] = num4;
      numArray3[2] |= num2;
      numArray3[2] |= (byte) ((uint) numArray2[2] & (uint) sbyte.MaxValue);
      numArray3[1] = numArray2[1];
      numArray3[0] = numArray2[0];
      return numArray3;
    }

    public static unsafe double BFLOAT8toDouble(byte[] bt)
    {
      fixed (byte* numPtr = bt)
      {
        byte[] numArray1 = new byte[8];
        double[] numArray2 = new double[1];
        byte num1 = (byte) ((uint) numPtr[6] & 128U);
        for (int index = 0; index < 8; ++index)
          numArray1[index] = (byte) 0;
        if ((int) numPtr[7] == 0)
          return numArray2[0];
        numArray1[7] |= num1;
        uint num2 = (uint) ((int) numPtr[7] - 128 - 1 + 1023);
        numArray1[7] |= (byte) (num2 >> 4);
        numArray1[6] |= (byte) (num2 << 4);
        for (int index = 6; index > 0; --index)
        {
          IntPtr num3 = (IntPtr) (numPtr + index);
          int num4 = (int) (byte) ((uint) *(byte*) num3 << 1);
          *(sbyte*) num3 = (sbyte) num4;
          IntPtr num5 = (IntPtr) (numPtr + index);
          int num6 = (int) (byte) ((uint) *(byte*) num5 | (uint) (byte) ((uint) numPtr[index - 1] >> 7));
          *(sbyte*) num5 = (sbyte) num6;
        }
        IntPtr num7 = (IntPtr) numPtr;
        int num8 = (int) (byte) ((uint) *(byte*) num7 << 1);
        *(sbyte*) num7 = (sbyte) num8;
        for (int index = 6; index > 0; --index)
        {
          numArray1[index] |= (byte) ((uint) numPtr[index] >> 4);
          numArray1[index - 1] |= (byte) ((uint) numPtr[index] << 4);
        }
        numArray1[0] |= (byte) ((uint) numPtr[0] >> 4);
        Buffer.BlockCopy((Array) numArray1, 0, (Array) numArray2, 0, 8);
        return numArray2[0];
      }
    }

    public static byte[] DoubletoBFLOAT8(double pdouble)
    {
      byte[] numArray1 = new byte[8];
      byte[] numArray2 = new byte[8];
      byte num1 = (byte) 0;
      Buffer.BlockCopy((Array) new double[1]
      {
        pdouble
      }, 0, (Array) numArray1, 0, 8);
      for (int index = 0; index < 8; ++index)
        numArray2[index] = (byte) 0;
      for (int index = 0; index < 8; ++index)
        num1 |= numArray1[index];
      if ((int) num1 == 0)
        return numArray2;
      byte num2 = (byte) ((uint) numArray1[7] & 128U);
      numArray2[6] |= num2;
      uint num3 = (uint) (((int) numArray1[7] & (int) sbyte.MaxValue) * 16) + ((uint) numArray1[6] >> 4);
      if ((int) num3 - 1023 - 128 > 0)
        return numArray2;
      numArray2[7] = (byte) ((int) num3 - 1023 + 128 + 1);
      numArray1[6] &= (byte) 15;
      for (int index = 6; index > 0; --index)
      {
        numArray2[index] |= (byte) ((uint) numArray1[index] << 3);
        numArray2[index] |= (byte) ((uint) numArray1[index - 1] >> 5);
      }
      numArray2[0] |= (byte) ((uint) numArray1[0] << 3);
      return numArray2;
    }
  }
}
