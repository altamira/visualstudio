// Type: lybtrcom.Session
// Assembly: Ly000008, Version=5.0.0.0, Culture=neutral, PublicKeyToken=666697afb0e8e7b5
// MVID: 1D110809-DBFE-4AEC-A1DB-C2824EA241EF
// Assembly location: Z:\Ly000008.dll

using System;
using System.Runtime.InteropServices;

namespace lybtrcom
{
  public class Session
  {
    private static short GL_NULL_short;
    private static IntPtr GL_NULL_ptr;
    private static byte[] GL_NULL_arr;

    static Session()
    {
      Session.GL_NULL_short = (short) 0;
      Session.GL_NULL_ptr = IntPtr.Zero;
      Session.GL_NULL_arr = new byte[128];
    }

    public Session()
    {
    }

    public static short BeginTrans()
    {
      return Session.BeginExclTrans();
    }

    public static short BeginExclTrans()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(19), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short BeginExclTrans(Session.LockModes LockBias)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16((object) (19 + LockBias)), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short BeginExclTrans([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(19), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short BeginExclTrans(Session.LockModes LockBias, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16((object) (19 + LockBias)), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short BeginConcTrans()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(1019), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short BeginConcTrans(Session.LockModes LockBias)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16((object) (1019 + LockBias)), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short BeginConcTrans([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(1019), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short BeginConcTrans(Session.LockModes LockBias, [MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16((object) (1019 + LockBias)), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short AbortTrans()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(21), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short AbortTrans([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(21), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short EndTrans()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(20), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short EndTrans([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(20), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short Reset()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(28), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short Reset([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(28), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public static short StopSession()
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALL(Convert.ToInt16(25), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0));
    }

    public static short StopSession([MarshalAs(UnmanagedType.LPArray, SizeConst = 128)] byte[] ClientId)
    {
      Session.GL_NULL_short = (short) 0;
      IntPtr num = IntPtr.Zero;
      return Func.BTRCALLID(Convert.ToInt16(25), Session.GL_NULL_arr, num, ref Session.GL_NULL_short, num, Convert.ToInt16(0), Convert.ToInt16(0), ClientId);
    }

    public enum LockModes
    {
      Single_Wait_Record_Lock = 100,
      Single_No_Wait_Record_Lock = 200,
      Multiple_Wait_Record_Lock = 300,
      Multiple_No_Wait_Record_Lock = 400,
    }
  }
}
