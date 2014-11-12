// Type: lybtrcom.Globals
// Assembly: Ly000008, Version=5.0.0.0, Culture=neutral, PublicKeyToken=666697afb0e8e7b5
// MVID: 1D110809-DBFE-4AEC-A1DB-C2824EA241EF
// Assembly location: Z:\Ly000008.dll

using System;

namespace lybtrcom
{
  public class Globals
  {
    public static DateTime GL_1900;

    static Globals()
    {
      Globals.GL_1900 = new DateTime(1900, 1, 1);
    }

    public Globals()
    {

    }

    public struct StatExtended
    {
      public short AmountInserted;
    }

    public struct StatInfo
    {
      public short RecordLength;
      public short PageSize;
      public byte NrOfIndexes;
      public byte FileVersion;
      public int RecordCount;
    }

    public enum OpCodes : short
    {
      OPEN = (short) 0,
      CLOSE = (short) 1,
      INSERT = (short) 2,
      UPDATE = (short) 3,
      DELETE = (short) 4,
      GETEQUAL = (short) 5,
      GETNEXT = (short) 6,
      GETPREVIOUS = (short) 7,
      GETGREATER = (short) 8,
      GETGREATEROREQUAL = (short) 9,
      GETLESS = (short) 10,
      GETLESSOREQUAL = (short) 11,
      GETFIRST = (short) 12,
      GETLAST = (short) 13,
      CREATE = (short) 14,
      STAT = (short) 15,
      STATINFO = (short) 15,
      SETDIRECTORY = (short) 17,
      GETDIRECTORY = (short) 18,
      BEGINTRANS = (short) 19,
      ENDTRANS = (short) 20,
      ABORTTRANS = (short) 21,
      GETPOSITION = (short) 22,
      GETDIRCHUNK = (short) 23,
      GETDIRECT = (short) 23,
      STEPNEXT = (short) 24,
      _STOP = (short) 25,
      VERSION = (short) 26,
      UNLOCK = (short) 27,
      RESET = (short) 28,
      SETOWNER = (short) 29,
      CLEAROWNER = (short) 30,
      CREATEINDEX = (short) 31,
      DROPINDEX = (short) 32,
      STEPFIRST = (short) 33,
      STEPLAST = (short) 34,
      STEPPREVIOUS = (short) 35,
      GETNEXTEXTENDED = (short) 36,
      GETPREVIOUSEXTENDED = (short) 37,
      STEPNEXTEXTENDED = (short) 38,
      STEPREVIOUSEXTENDED = (short) 39,
      INSERTEXTENDED = (short) 40,
      CONTINIOUSOPERATION = (short) 42,
      GETBYPERC = (short) 44,
      FINDPERC = (short) 45,
      STATEXTENDED = (short) 65,
    }
  }
}
