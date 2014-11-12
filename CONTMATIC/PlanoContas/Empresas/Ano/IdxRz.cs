// Type: Trial.IdxRz
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: CDB94C55-E117-42D1-AF86-FFB4A2D2491F
// Assembly location: C:\Documents and Settings\Alessandro\Desktop\Trial.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC.Empresas
{
  public class IdxRz
  {
    private byte[] pvPB;
    private short pbKBL;
    private IntPtr pvPtr;
    private StringBuilder pvStBld;
    private IntPtr pvPtr2;
    private GCHandle pvGC;
    private byte[] pvaBt;
    private ushort[] pva16;
    private uint[] pva32;
    private ulong[] pva64;
    private float[] pvaSng;
    private double[] pvaDbl;
    private string pvDataPath;
    private string pvDirectory;
    private string pvOwnerName;
    private IdxRz.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private IdxRz.FieldsClass pvFields;
    private IdxRz.FieldsClass[] pvFieldsExtr;
    private IdxRz.FieldsClass_priv pvFieldsIntern;
    private Globals.StatExtended pvStatExt;
    private Globals.StatInfo pvStatInfo;

    public string fldContaContabil
    {
      get
      {
        return this.pvFields.fldContaContabil;
      }
      set
      {
        this.pvFields.fldContaContabil = value;
      }
    }

    public int fldunnamed_1
    {
      get
      {
        return this.pvFields.fldunnamed_1;
      }
      set
      {
        this.pvFields.fldunnamed_1 = value;
      }
    }

    public short fldunnamed_2
    {
      get
      {
        return this.pvFields.fldunnamed_2;
      }
      set
      {
        this.pvFields.fldunnamed_2 = value;
      }
    }

    public short fldunnamed_3
    {
      get
      {
        return this.pvFields.fldunnamed_3;
      }
      set
      {
        this.pvFields.fldunnamed_3 = value;
      }
    }

    public int fldunnamed_4
    {
      get
      {
        return this.pvFields.fldunnamed_4;
      }
      set
      {
        this.pvFields.fldunnamed_4 = value;
      }
    }

    public string DataPath
    {
      get
      {
        return this.pvDataPath;
      }
      set
      {
        this.pvDataPath = value;
      }
    }

    public string Owner
    {
      get
      {
        return this.pvOwnerName;
      }
      set
      {
        this.pvOwnerName = value;
      }
    }

    public string Directory
    {
      get
      {
        return this.pvDirectory;
      }
      set
      {
        this.pvDirectory = value;
      }
    }

    public IdxRz.KeysStruct Keys
    {
      get
      {
        return this.pvKeys;
      }
      set
      {
        this.pvKeys = value;
      }
    }

    public bool TrimStrings
    {
      get
      {
        return this.pvTrimStrings;
      }
      set
      {
        this.pvTrimStrings = value;
      }
    }

    public IdxRz.FieldsClass Fields
    {
      get
      {
        return this.pvFields;
      }
      set
      {
        this.pvFields = value;
      }
    }

    public IdxRz.FieldsClass[] Fields_ext
    {
      get
      {
        return this.pvFieldsExtr;
      }
      set
      {
        this.pvFieldsExtr = value;
      }
    }

    public Globals.StatExtended ExtendedStatInfo
    {
      get
      {
        return this.pvStatExt;
      }
    }

    public Globals.StatInfo StatInformation
    {
      get
      {
        return this.pvStatInfo;
      }
    }

    public IdxRz()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[56];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\IdxRz.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new IdxRz.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new IdxRz.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public IdxRz(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[56];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\IdxRz.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new IdxRz.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new IdxRz.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public IdxRz(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[56];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\IdxRz.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new IdxRz.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new IdxRz.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public IdxRz(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[56];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\IdxRz.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new IdxRz.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new IdxRz.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmunnamed_4);
      else if ((int) pKey == 1)
        Translate.Cmmn_WriteInt16(pPtr, 0, this.pvKeys.idxindex_1.sgmunnamed_2);
      else if ((int) pKey == 2)
      {
        Translate.Cmmn_WriteInt16(pPtr, 56, this.pvKeys.idxindex_2.sgmunnamed_2);
        Translate.Cmmn_WriteInt16(pPtr, 58, this.pvKeys.idxindex_2.sgmunnamed_3);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_2.sgmContaContabil.Length < 56)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmContaContabil.PadRight(56)), 0, this.pvPtr, 56);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmContaContabil), 0, this.pvPtr, 56);
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 3)
          return;
        Translate.Cmmn_WriteInt16(pPtr, 4, this.pvKeys.idxindex_3.sgmunnamed_2);
        Translate.Cmmn_WriteInt16(pPtr, 6, this.pvKeys.idxindex_3.sgmunnamed_3);
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_3.sgmunnamed_1);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
        this.pvKeys.idxindex_0.sgmunnamed_4 = Translate.Cmmn_ReadInt32(pPtr4, 0);
      else if ((int) pKey == 1)
        this.pvKeys.idxindex_1.sgmunnamed_2 = Translate.Cmmn_ReadInt16(pPtr4, 0);
      else if ((int) pKey == 2)
      {
        this.pvKeys.idxindex_2.sgmunnamed_2 = Translate.Cmmn_ReadInt16(pPtr4, 56);
        this.pvKeys.idxindex_2.sgmunnamed_3 = Translate.Cmmn_ReadInt16(pPtr4, 58);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_2.sgmContaContabil = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 56) : Marshal.PtrToStringAnsi(this.pvPtr, 56).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 3)
          return;
        this.pvKeys.idxindex_3.sgmunnamed_2 = Translate.Cmmn_ReadInt16(pPtr4, 4);
        this.pvKeys.idxindex_3.sgmunnamed_3 = Translate.Cmmn_ReadInt16(pPtr4, 6);
        this.pvKeys.idxindex_3.sgmunnamed_1 = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      IdxRz idxRz = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (IdxRz.FieldsClass_priv));
      IdxRz.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      IdxRz.FieldsClass_priv fieldsClassPriv2 = obj != null ? (IdxRz.FieldsClass_priv) obj : fieldsClassPriv1;
      idxRz.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldContaContabil = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_000) : new string(this.pvFieldsIntern.a_000).Trim();
      this.pvFields.fldunnamed_1 = this.pvFieldsIntern.a_056;
      this.pvFields.fldunnamed_2 = this.pvFieldsIntern.a_060;
      this.pvFields.fldunnamed_3 = this.pvFieldsIntern.a_062;
      this.pvFields.fldunnamed_4 = this.pvFieldsIntern.a_064;
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldContaContabil.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_056 = this.pvFields.fldunnamed_1;
      this.pvFieldsIntern.a_060 = this.pvFields.fldunnamed_2;
      this.pvFieldsIntern.a_062 = this.pvFields.fldunnamed_3;
      this.pvFieldsIntern.a_064 = this.pvFields.fldunnamed_4;
      Marshal.StructureToPtr((object) this.pvFieldsIntern, pPtr2, true);
    }

    private void VartoDB_ext(ref IntPtr pPtr3)
    {
      Translate.Cmmn_WriteInt16(pPtr3, checked ((short) this.pvFieldsExtr.Length));
      short num1 = (short) 2;
      int index = 0;
      while (index < this.pvFieldsExtr.Length)
      {
        this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldContaContabil.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_056 = this.pvFieldsExtr[index].fldunnamed_1;
        this.pvFieldsIntern.a_060 = this.pvFieldsExtr[index].fldunnamed_2;
        this.pvFieldsIntern.a_062 = this.pvFieldsExtr[index].fldunnamed_3;
        this.pvFieldsIntern.a_064 = this.pvFieldsExtr[index].fldunnamed_4;
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 68);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 68));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(IdxRz.OpenModes Mode, byte[] ClientId)
    {
      string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
      short num1 = checked ((short) (s.Length + 1));
      IntPtr num2 = Marshal.AllocHGlobal((int) num1);
      short DataBufferLength;
      IntPtr num3;
      if (this.pvOwnerName.Trim().Length == 0)
      {
        DataBufferLength = (short) 0;
        num3 = IntPtr.Zero;
      }
      else
      {
        DataBufferLength = checked ((short) (this.pvOwnerName.Length + 1));
        num3 = Marshal.AllocHGlobal((int) DataBufferLength);
        Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num3, checked ((int) DataBufferLength - 1));
        Translate.Cmmn_WriteByte(num3, checked ((int) DataBufferLength - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked ((int) num1 - 1));
      Translate.Cmmn_WriteByte(num2, checked ((int) num1 - 2), (byte) 0);
      short num4 = Func.BTRCALLID((short) 0, this.pvPB, num3, ref DataBufferLength, num2, (short) byte.MaxValue, checked ((short) Mode), ClientId);
      if ((int) DataBufferLength > 0)
        Marshal.FreeHGlobal(num3);
      Marshal.FreeHGlobal(num2);
      return num4;
    }

    public virtual short btrOpen(IdxRz.OpenModes Mode)
    {
      string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
      short num1 = checked ((short) (s.Length + 1));
      IntPtr num2 = Marshal.AllocHGlobal((int) num1);
      short DataBufferLength;
      IntPtr num3;
      if (this.pvOwnerName.Trim().Length == 0)
      {
        DataBufferLength = (short) 0;
        num3 = IntPtr.Zero;
      }
      else
      {
        DataBufferLength = checked ((short) (this.pvOwnerName.Length + 1));
        num3 = Marshal.AllocHGlobal((int) DataBufferLength);
        Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num3, checked ((int) DataBufferLength - 1));
        Translate.Cmmn_WriteByte(num3, checked ((int) DataBufferLength - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked ((int) num1 - 1));
      Translate.Cmmn_WriteByte(num2, checked ((int) num1 - 2), (byte) 0);
      short num4 = Func.BTRCALL((short) 0, this.pvPB, num3, ref DataBufferLength, num2, (short) byte.MaxValue, checked ((short) Mode));
      if ((int) DataBufferLength > 0)
        Marshal.FreeHGlobal(num3);
      Marshal.FreeHGlobal(num2);
      return num4;
    }

    public virtual short btrClose(byte[] ClientId)
    {
      int num1 = 1;
      byte[] Cursor = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr DataBuffer = num2;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num4 = 0;
      int num5 = 0;
      byte[] ClientId1 = ClientId;
      return Func.BTRCALLID((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
    }

    public virtual short btrClose()
    {
      int num1 = 1;
      byte[] Cursor = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr DataBuffer = num2;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num4 = 0;
      int num5 = 0;
      return Func.BTRCALL((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5);
    }

    public virtual short btrInsert(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrInsert(IdxRz.KeyName Key_nr)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrUpdate(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrUpdate(IdxRz.KeyName Key_nr)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrDelete(byte[] ClientId)
    {
      int num1 = 4;
      byte[] Cursor = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr DataBuffer = num2;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num4 = 0;
      int num5 = 0;
      byte[] ClientId1 = ClientId;
      return Func.BTRCALLID((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
    }

    public virtual short btrDelete()
    {
      int num1 = 4;
      byte[] Cursor = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr DataBuffer = num2;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num4 = 0;
      int num5 = 0;
      return Func.BTRCALL((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5);
    }

    public virtual short btrGetEqual(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(IdxRz.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 5)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 5)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      else
      {
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      else
      {
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      else
      {
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      else
      {
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, DataBufferLength);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(IdxRz.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(IdxRz.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 8)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetGreater(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 8)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetGreaterThanOrEqual(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(IdxRz.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 9)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetGreaterThanOrEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 9)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetLessThan(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(IdxRz.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 10)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetLessThan(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 10)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetLessThanOrEqual(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(IdxRz.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 11)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetLessThanOrEqual(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref num1, checked ((short) Key_nr));
      short num2 = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 11)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref num1, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(num1);
      Marshal.FreeHGlobal(pPtr1);
      return num2;
    }

    public virtual short btrGetFirst(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(IdxRz.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 12)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetFirst(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 12)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLast(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(IdxRz.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 13)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLast(IdxRz.KeyName Key_nr, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 13)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, DataBufferLength);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetStat()
    {
      short DataBufferLength = (short) 68;
      IntPtr num1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr num2 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num3 = Func.BTRCALL((short) 15, this.pvPB, num1, ref DataBufferLength, num2, this.pbKBL, (short) -1);
      if ((int) num3 == 0)
        this.pvStatInfo.RecordLength = Translate.Cmmn_ReadInt16(num1, 0);
      if ((int) num3 == 0)
        this.pvStatInfo.PageSize = Translate.Cmmn_ReadInt16(num1, 2);
      if ((int) num3 == 0)
        this.pvStatInfo.NrOfIndexes = Translate.Cmmn_ReadByte(num1, 4);
      if ((int) num3 == 0)
        this.pvStatInfo.FileVersion = Translate.Cmmn_ReadByte(num1, 5);
      if ((int) num3 == 0)
        this.pvStatInfo.RecordCount = Translate.Cmmn_ReadInt32(num1, 6);
      Marshal.FreeHGlobal(num2);
      Marshal.FreeHGlobal(num1);
      return num3;
    }

    public virtual short btrSetDirectory(byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.Default.GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      //__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = 0;
      int num5 = 0;
      byte[] ClientId1 = ClientId;
      short num6 = Func.BTRCALLID((short) num2, /*(byte[]) local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

    public virtual short btrSetDirectory()
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.Default.GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      //__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = 0;
      int num5 = 0;
      short num6 = Func.BTRCALL((short) num2, /*(byte[]) local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

    public virtual short btrGetDirectory(short Disk_Drive_nr, byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      int num2 = 18;
      // ISSUE: variable of the null type
      //__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = (int) this.pbKBL;
      int num5 = (int) Disk_Drive_nr;
      byte[] ClientId1 = ClientId;
      short num6 = Func.BTRCALLID((short) num2, /*(byte[]) local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
      if ((int) num6 == 0)
        this.pvDirectory = Marshal.PtrToStringAnsi(num1);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

    public virtual short btrGetDirectory(short Disk_Drive_nr)
    {
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      int num2 = 18;
      // ISSUE: variable of the null type
      //__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = (int) this.pbKBL;
      int num5 = (int) Disk_Drive_nr;
      short num6 = Func.BTRCALL((short) num2, /*(byte[]) local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5);
      if ((int) num6 == 0)
        this.pvDirectory = Marshal.PtrToStringAnsi(num1);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

    public virtual short btrGetPosition(ref IntPtr Position, byte[] ClientId)
    {
      int num1 = 22;
      byte[] Cursor = this.pvPB;
      IntPtr DataBuffer = Position;
      short num2 = (short) 4;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num2;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num3 = 0;
      int num4 = 0;
      byte[] ClientId1 = ClientId;
      return Func.BTRCALLID((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num3, (short) num4, ClientId1);
    }

    public virtual short btrGetPosition(ref IntPtr Position)
    {
      int num1 = 22;
      byte[] Cursor = this.pvPB;
      IntPtr DataBuffer = Position;
      short num2 = (short) 4;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num2;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num3 = 0;
      int num4 = 0;
      return Func.BTRCALL((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num3, (short) num4);
    }

    public virtual short btrGetDirectRecord(IdxRz.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(IdxRz.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(IdxRz.KeyName Key_nr, IntPtr Position, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(IdxRz.KeyName Key_nr, IntPtr Position, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(byte[] ClientId)
    {
      return this.btrStepNext(IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(IdxRz.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num = IntPtr.Zero;
      short DataBufferLength = Position == num || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(IdxRz.Unlock UnlockKey, IntPtr Position)
    {
      IntPtr num = IntPtr.Zero;
      short DataBufferLength = Position == num || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALL((short) 27, this.pvPB, Position, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) UnlockKey));
    }

    public virtual short btrClearOwner(byte[] ClientId)
    {
      int num1 = 30;
      byte[] Cursor = this.pvPB;
      IntPtr DataBuffer = IntPtr.Zero;
      short num2 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num2;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num3 = 0;
      int num4 = 0;
      byte[] ClientId1 = ClientId;
      return Func.BTRCALLID((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num3, (short) num4, ClientId1);
    }

    public virtual short btrClearOwner()
    {
      int num1 = 30;
      byte[] Cursor = this.pvPB;
      IntPtr DataBuffer = IntPtr.Zero;
      short num2 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num2;
      IntPtr KeyBuffer = IntPtr.Zero;
      int num3 = 0;
      int num4 = 0;
      return Func.BTRCALL((short) num1, Cursor, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num3, (short) num4);
    }

    public virtual short btrStepFirst(byte[] ClientId)
    {
      return this.btrStepFirst(IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(IdxRz.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = checked ((short) (70 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num;
    }

    public virtual short btrInsertExtended(IdxRz.KeyName Key_nr)
    {
      short DataBufferLength = checked ((short) (70 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= IdxRz.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num;
    }

    public virtual short btrGetByPercentage(IdxRz.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, IdxRz.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(IdxRz.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, IdxRz.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(IdxRz.KeyName Key_nr, short Percentage, IdxRz.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(IdxRz.KeyName Key_nr, short Percentage, IdxRz.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 68;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(IdxRz.KeyName Key_nr, ref short Percentage, byte[] ClientId)
    {
      short DataBufferLength = (short) 4;
      IntPtr num1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref pPtr, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID((short) 45, this.pvPB, num1, ref DataBufferLength, pPtr, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
        Percentage = Translate.Cmmn_ReadInt16(num1, 0);
      Marshal.FreeHGlobal(pPtr);
      Marshal.FreeHGlobal(num1);
      return num2;
    }

    public virtual short btrFindPercentage(IdxRz.KeyName Key_nr, ref short Percentage)
    {
      short DataBufferLength = (short) 4;
      IntPtr num1 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref pPtr, checked ((short) Key_nr));
      short num2 = Func.BTRCALL((short) 45, this.pvPB, num1, ref DataBufferLength, pPtr, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
        Percentage = Translate.Cmmn_ReadInt16(num1, 0);
      Marshal.FreeHGlobal(pPtr);
      Marshal.FreeHGlobal(num1);
      return num2;
    }

    public class KeysStruct
    {
      private IdxRz.KeysStruct.struct_01 idxindex_1_priv;
      private IdxRz.KeysStruct.struct_02 idxindex_2_priv;
      private IdxRz.KeysStruct.struct_03 idxindex_3_priv;
      private IdxRz.KeysStruct.struct_00 idxindex_0_priv;

      public IdxRz.KeysStruct.struct_01 idxindex_1
      {
        get
        {
          return this.idxindex_1_priv;
        }
        set
        {
          this.idxindex_1_priv = value;
        }
      }

      public IdxRz.KeysStruct.struct_02 idxindex_2
      {
        get
        {
          return this.idxindex_2_priv;
        }
        set
        {
          this.idxindex_2_priv = value;
        }
      }

      public IdxRz.KeysStruct.struct_03 idxindex_3
      {
        get
        {
          return this.idxindex_3_priv;
        }
        set
        {
          this.idxindex_3_priv = value;
        }
      }

      public IdxRz.KeysStruct.struct_00 idxindex_0
      {
        get
        {
          return this.idxindex_0_priv;
        }
        set
        {
          this.idxindex_0_priv = value;
        }
      }

      public KeysStruct()
      {
        
        this.idxindex_1_priv = new IdxRz.KeysStruct.struct_01();
        this.idxindex_2_priv = new IdxRz.KeysStruct.struct_02();
        this.idxindex_3_priv = new IdxRz.KeysStruct.struct_03();
        this.idxindex_0_priv = new IdxRz.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private int sgmunnamed_4_priv;

        public int sgmunnamed_4
        {
          get
          {
            return this.sgmunnamed_4_priv;
          }
          set
          {
            this.sgmunnamed_4_priv = value;
          }
        }

        public struct_00()
        {
          
          this.sgmunnamed_4_priv = 0;
        }
      }

      public class struct_01
      {
        private short sgmunnamed_2_priv;

        public short sgmunnamed_2
        {
          get
          {
            return this.sgmunnamed_2_priv;
          }
          set
          {
            this.sgmunnamed_2_priv = value;
          }
        }

        public struct_01()
        {
          
          this.sgmunnamed_2_priv = (short) 0;
        }
      }

      public class struct_02
      {
        private string sgmContaContabil_priv;
        private short sgmunnamed_2_priv;
        private short sgmunnamed_3_priv;

        public string sgmContaContabil
        {
          get
          {
            return this.sgmContaContabil_priv;
          }
          set
          {
            this.sgmContaContabil_priv = value;
          }
        }

        public short sgmunnamed_2
        {
          get
          {
            return this.sgmunnamed_2_priv;
          }
          set
          {
            this.sgmunnamed_2_priv = value;
          }
        }

        public short sgmunnamed_3
        {
          get
          {
            return this.sgmunnamed_3_priv;
          }
          set
          {
            this.sgmunnamed_3_priv = value;
          }
        }

        public struct_02()
        {
          
          this.sgmContaContabil_priv = string.Empty;
          this.sgmunnamed_2_priv = (short) 0;
          this.sgmunnamed_3_priv = (short) 0;
        }
      }

      public class struct_03
      {
        private int sgmunnamed_1_priv;
        private short sgmunnamed_2_priv;
        private short sgmunnamed_3_priv;

        public int sgmunnamed_1
        {
          get
          {
            return this.sgmunnamed_1_priv;
          }
          set
          {
            this.sgmunnamed_1_priv = value;
          }
        }

        public short sgmunnamed_2
        {
          get
          {
            return this.sgmunnamed_2_priv;
          }
          set
          {
            this.sgmunnamed_2_priv = value;
          }
        }

        public short sgmunnamed_3
        {
          get
          {
            return this.sgmunnamed_3_priv;
          }
          set
          {
            this.sgmunnamed_3_priv = value;
          }
        }

        public struct_03()
        {
          
          this.sgmunnamed_1_priv = 0;
          this.sgmunnamed_2_priv = (short) 0;
          this.sgmunnamed_3_priv = (short) 0;
        }
      }
    }

    public enum KeyName
    {
      NoCurrencyChange = -1,
      index_0 = 0,
      index_1 = 1,
      index_2 = 2,
      index_3 = 3,
    }

    public enum OpenModes
    {
      Multi_Engine_File_Sharing = -64,
      Single_Engine_File_Sharing = -32,
      Exclusive = -4,
      Verify = -3,
      Read_Only = -2,
      Accelerated = -1,
      Normal = 0,
    }

    public enum RecordLocks
    {
      NoRecordLock = 0,
      Single_Wait_Record_Lock = 100,
      Single_No_Wait_Record_Lock = 200,
      Multiple_Wait_Record_Lock = 300,
      Multiple_No_Wait_Record_Lock = 400,
    }

    public enum Unlock
    {
      AllMultipleRecordLocks = -2,
      OneRecordFromMultipleRecordLock = -1,
      SingleRecordLock = 0,
    }

    [StructLayout(LayoutKind.Sequential, Size = 68, Pack = 1)]
    internal struct FieldsClass_priv
    {
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_000;
      internal int a_056;
      internal short a_060;
      internal short a_062;
      internal int a_064;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private string fldContaContabil_priv;
      private int fldunnamed_1_priv;
      private short fldunnamed_2_priv;
      private short fldunnamed_3_priv;
      private int fldunnamed_4_priv;
      private PropertyChangedEventHandler PropertyChangedEvent;

      public string fldContaContabil
      {
        get
        {
          return this.fldContaContabil_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldContaContabil_priv, value, false) == 0)
            return;
          this.fldContaContabil_priv = value;
          this.OnPropertyChanged("fldContaContabil");
        }
      }

      public int fldunnamed_1
      {
        get
        {
          return this.fldunnamed_1_priv;
        }
        set
        {
          if (this.fldunnamed_1_priv == value)
            return;
          this.fldunnamed_1_priv = value;
          this.OnPropertyChanged("fldunnamed_1");
        }
      }

      public short fldunnamed_2
      {
        get
        {
          return this.fldunnamed_2_priv;
        }
        set
        {
          if ((int) this.fldunnamed_2_priv == (int) value)
            return;
          this.fldunnamed_2_priv = value;
          this.OnPropertyChanged("fldunnamed_2");
        }
      }

      public short fldunnamed_3
      {
        get
        {
          return this.fldunnamed_3_priv;
        }
        set
        {
          if ((int) this.fldunnamed_3_priv == (int) value)
            return;
          this.fldunnamed_3_priv = value;
          this.OnPropertyChanged("fldunnamed_3");
        }
      }

      public int fldunnamed_4
      {
        get
        {
          return this.fldunnamed_4_priv;
        }
        set
        {
          if (this.fldunnamed_4_priv == value)
            return;
          this.fldunnamed_4_priv = value;
          this.OnPropertyChanged("fldunnamed_4");
        }
      }

      public event PropertyChangedEventHandler PropertyChanged
      {
        [MethodImpl(MethodImplOptions.Synchronized)] add
        {
          this.PropertyChangedEvent = (PropertyChangedEventHandler) Delegate.Combine((Delegate) this.PropertyChangedEvent, (Delegate) value);
        }
        [MethodImpl(MethodImplOptions.Synchronized)] remove
        {
          this.PropertyChangedEvent = (PropertyChangedEventHandler) Delegate.Remove((Delegate) this.PropertyChangedEvent, (Delegate) value);
        }
      }

      public FieldsClass()
      {
        
        this.fldContaContabil_priv = string.Empty;
        this.fldunnamed_1_priv = 0;
        this.fldunnamed_2_priv = (short) 0;
        this.fldunnamed_3_priv = (short) 0;
        this.fldunnamed_4_priv = 0;
      }

      protected internal void OnPropertyChanged(string pPropName)
      {
        PropertyChangedEventHandler changedEventHandler = this.PropertyChangedEvent;
        if (changedEventHandler == null)
          return;
        changedEventHandler((object) this, new PropertyChangedEventArgs(pPropName));
      }
    }
  }
}
