// Type: Trial.DemoResu
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: D407B2B4-8CD3-41A0-BBB1-C93C99EF8732
// Assembly location: C:\Documents and Settings\Alessandro\Desktop\Trial.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC.Geral
{
  public class DemoResu
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
    private DemoResu.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private DemoResu.FieldsClass pvFields;
    private DemoResu.FieldsClass[] pvFieldsExtr;
    private DemoResu.FieldsClass_priv pvFieldsIntern;
    private Globals.StatExtended pvStatExt;
    private Globals.StatInfo pvStatInfo;

    public string fldModelo1
    {
      get
      {
        return this.pvFields.fldModelo1;
      }
      set
      {
        this.pvFields.fldModelo1 = value;
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

    public string fldunnamed_2
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

    public string fldConta
    {
      get
      {
        return this.pvFields.fldConta;
      }
      set
      {
        this.pvFields.fldConta = value;
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

    public int fldIdPlano
    {
      get
      {
        return this.pvFields.fldIdPlano;
      }
      set
      {
        this.pvFields.fldIdPlano = value;
      }
    }

    public int Id
    {
      get
      {
        return this.pvFields.Id;
      }
      set
      {
        this.pvFields.Id = value;
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

    public DemoResu.KeysStruct Keys
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

    public DemoResu.FieldsClass Fields
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

    public DemoResu.FieldsClass[] Fields_ext
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

    public DemoResu()
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
      this.pvDataPath = "C:\\Phoenix\\Geral\\DEMORESU.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new DemoResu.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new DemoResu.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public DemoResu(bool Trim_Strings)
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
      this.pvDataPath = "C:\\Phoenix\\Geral\\DEMORESU.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new DemoResu.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new DemoResu.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public DemoResu(string DataPath)
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
      this.pvDataPath = "C:\\Phoenix\\Geral\\DEMORESU.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new DemoResu.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new DemoResu.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public DemoResu(string DataPath, bool Trim_Strings)
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
      this.pvDataPath = "C:\\Phoenix\\Geral\\DEMORESU.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new DemoResu.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new DemoResu.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_0.sgmModelo1.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmModelo1.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmModelo1), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 5, this.pvKeys.idxindex_0.sgmunnamed_1);
        Translate.Cmmn_WriteInt32(pPtr, 9, this.pvKeys.idxindex_0.sgmunnamed_4);
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmIdPlano);
      }
      else if ((int) pKey == 1)
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_1.sgmunnamed_1);
      else if ((int) pKey == 2)
      {
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_unnamed_6.sgmunnamed_6);
      }
      else
      {
        if ((int) pKey != 3)
          return;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_3.sgmConta.Length < 56)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_3.sgmConta.PadRight(56)), 0, this.pvPtr, 56);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_3.sgmConta), 0, this.pvPtr, 56);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_3.sgmIdPlano);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_0.sgmModelo1 = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_0.sgmunnamed_1 = Translate.Cmmn_ReadInt32(pPtr4, 5);
        this.pvKeys.idxindex_0.sgmunnamed_4 = Translate.Cmmn_ReadInt32(pPtr4, 9);
        this.pvKeys.idxindex_0.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else if ((int) pKey == 1)
        this.pvKeys.idxindex_1.sgmunnamed_1 = Translate.Cmmn_ReadInt32(pPtr4, 0);
      else if ((int) pKey == 2)
      {
        this.pvKeys.idxUK_unnamed_6.sgmunnamed_6 = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else
      {
        if ((int) pKey != 3)
          return;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_3.sgmConta = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 56) : Marshal.PtrToStringAnsi(this.pvPtr, 56).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_3.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      DemoResu demoResu = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (DemoResu.FieldsClass_priv));
      DemoResu.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      DemoResu.FieldsClass_priv fieldsClassPriv2 = obj != null ? (DemoResu.FieldsClass_priv) obj : fieldsClassPriv1;
      demoResu.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldModelo1 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_000) : new string(this.pvFieldsIntern.a_000).Trim();
      this.pvFields.fldunnamed_1 = this.pvFieldsIntern.a_001;
      this.pvFields.fldunnamed_2 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_005) : new string(this.pvFieldsIntern.a_005).Trim();
      this.pvFields.fldConta = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_055) : new string(this.pvFieldsIntern.a_055).Trim();
      this.pvFields.fldunnamed_4 = this.pvFieldsIntern.a_111;
      this.pvFields.fldIdPlano = this.pvFieldsIntern.a_115;
      this.pvFields.Id = this.pvFieldsIntern.a_119;
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldModelo1.PadRight(1).ToCharArray();
      this.pvFieldsIntern.a_001 = this.pvFields.fldunnamed_1;
      this.pvFieldsIntern.a_005 = this.pvFields.fldunnamed_2.PadRight(50).ToCharArray();
      this.pvFieldsIntern.a_055 = this.pvFields.fldConta.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_111 = this.pvFields.fldunnamed_4;
      this.pvFieldsIntern.a_115 = this.pvFields.fldIdPlano;
      this.pvFieldsIntern.a_119 = this.pvFields.Id;
      Marshal.StructureToPtr((object) this.pvFieldsIntern, pPtr2, true);
    }

    private void VartoDB_ext(ref IntPtr pPtr3)
    {
      Translate.Cmmn_WriteInt16(pPtr3, checked ((short) this.pvFieldsExtr.Length));
      short num1 = (short) 2;
      int index = 0;
      while (index < this.pvFieldsExtr.Length)
      {
        this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldModelo1.PadRight(1).ToCharArray();
        this.pvFieldsIntern.a_001 = this.pvFieldsExtr[index].fldunnamed_1;
        this.pvFieldsIntern.a_005 = this.pvFieldsExtr[index].fldunnamed_2.PadRight(50).ToCharArray();
        this.pvFieldsIntern.a_055 = this.pvFieldsExtr[index].fldConta.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_111 = this.pvFieldsExtr[index].fldunnamed_4;
        this.pvFieldsIntern.a_115 = this.pvFieldsExtr[index].fldIdPlano;
        this.pvFieldsIntern.a_119 = this.pvFieldsExtr[index].Id;
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 123);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 123));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(DemoResu.OpenModes Mode, byte[] ClientId)
    {
      string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
      short num1 = checked ((short) (s.Length + 1));
      IntPtr num2 = Marshal.AllocHGlobal((int) num1);
      short num3;
      IntPtr num4;
      if (this.pvOwnerName.Trim().Length == 0)
      {
        num3 = (short) 0;
        num4 = IntPtr.Zero;
      }
      else
      {
        num3 = checked ((short) (this.pvOwnerName.Length + 1));
        num4 = Marshal.AllocHGlobal((int) num3);
        Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num4, checked ((int) num3 - 1));
        Translate.Cmmn_WriteByte(num4, checked ((int) num3 - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked ((int) num1 - 1));
      Translate.Cmmn_WriteByte(num2, checked ((int) num1 - 2), (byte) 0);
      short num5 = Func.BTRCALLID((short) 0, this.pvPB, num4, ref num3, num2, (short) byte.MaxValue, checked ((short) Mode), ClientId);
      if ((int) num3 > 0)
        Marshal.FreeHGlobal(num4);
      Marshal.FreeHGlobal(num2);
      return num5;
    }

    public virtual short btrOpen(DemoResu.OpenModes Mode)
    {
      string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
      short num1 = checked ((short) (s.Length + 1));
      IntPtr num2 = Marshal.AllocHGlobal((int) num1);
      short num3;
      IntPtr num4;
      if (this.pvOwnerName.Trim().Length == 0)
      {
        num3 = (short) 0;
        num4 = IntPtr.Zero;
      }
      else
      {
        num3 = checked ((short) (this.pvOwnerName.Length + 1));
        num4 = Marshal.AllocHGlobal((int) num3);
        Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num4, checked ((int) num3 - 1));
        Translate.Cmmn_WriteByte(num4, checked ((int) num3 - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked ((int) num1 - 1));
      Translate.Cmmn_WriteByte(num2, checked ((int) num1 - 2), (byte) 0);
      short num5 = Func.BTRCALL((short) 0, this.pvPB, num4, ref num3, num2, (short) byte.MaxValue, checked ((short) Mode));
      if ((int) num3 > 0)
        Marshal.FreeHGlobal(num4);
      Marshal.FreeHGlobal(num2);
      return num5;
    }

    public virtual short btrClose(byte[] ClientId)
    {
      int num1 = 1;
      byte[] numArray1 = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr num3 = num2;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num4;
      IntPtr num5 = IntPtr.Zero;
      int num6 = 0;
      int num7 = 0;
      byte[] numArray2 = ClientId;
      return Func.BTRCALLID((short) num1, numArray1, num3, ref local, num5, (short) num6, (short) num7, numArray2);
    }

    public virtual short btrClose()
    {
      int num1 = 1;
      byte[] numArray = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr num3 = num2;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num4;
      IntPtr num5 = IntPtr.Zero;
      int num6 = 0;
      int num7 = 0;
      return Func.BTRCALL((short) num1, numArray, num3, ref local, num5, (short) num6, (short) num7);
    }

    public virtual short btrInsert(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 123;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(DemoResu.KeyName Key_nr)
    {
      short num1 = (short) 123;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 123;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(DemoResu.KeyName Key_nr)
    {
      short num1 = (short) 123;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrDelete(byte[] ClientId)
    {
      int num1 = 4;
      byte[] numArray1 = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr num3 = num2;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num4;
      IntPtr num5 = IntPtr.Zero;
      int num6 = 0;
      int num7 = 0;
      byte[] numArray2 = ClientId;
      return Func.BTRCALLID((short) num1, numArray1, num3, ref local, num5, (short) num6, (short) num7, numArray2);
    }

    public virtual short btrDelete()
    {
      int num1 = 4;
      byte[] numArray = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      IntPtr num3 = num2;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num4;
      IntPtr num5 = IntPtr.Zero;
      int num6 = 0;
      int num7 = 0;
      return Func.BTRCALL((short) num1, numArray, num3, ref local, num5, (short) num6, (short) num7);
    }

    public virtual short btrGetEqual(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(DemoResu.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 5)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 5)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      else
      {
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      else
      {
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      else
      {
        num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr), ClientId);
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num;
      if (KeyBuffer.Equals((object) IntPtr.Zero))
      {
        KeyBuffer = Marshal.AllocHGlobal((int) this.pbKBL);
        this.VartoKB(ref KeyBuffer, checked ((short) Key_nr));
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      else
      {
        num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked ((short) Key_nr));
        if ((int) num == 0)
          this.DBtoStruct(ref pPtr1, pDBL);
      }
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(DemoResu.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(DemoResu.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 8)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetGreater(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 8)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetGreaterThanOrEqual(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(DemoResu.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 9)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetGreaterThanOrEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 9)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLessThan(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(DemoResu.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 10)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLessThan(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 10)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLessThanOrEqual(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(DemoResu.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 11)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLessThanOrEqual(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr hglobal = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref hglobal, checked ((short) Key_nr));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 11)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref hglobal, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(hglobal);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetFirst(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(DemoResu.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 12)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetFirst(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 12)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLast(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(DemoResu.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 13)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetLast(DemoResu.KeyName Key_nr, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 13)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if ((int) num == 0)
      {
        this.DBtoStruct(ref pPtr1, pDBL);
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      }
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetStat()
    {
      short num1 = (short) 123;
      IntPtr hglobal1 = Marshal.AllocHGlobal((int) num1);
      IntPtr hglobal2 = Marshal.AllocHGlobal((int) this.pbKBL);
      short num2 = Func.BTRCALL((short) 15, this.pvPB, hglobal1, ref num1, hglobal2, this.pbKBL, (short) -1);
      if ((int) num2 == 0)
        this.pvStatInfo.RecordLength = Translate.Cmmn_ReadInt16(hglobal1, 0);
      if ((int) num2 == 0)
        this.pvStatInfo.PageSize = Translate.Cmmn_ReadInt16(hglobal1, 2);
      if ((int) num2 == 0)
        this.pvStatInfo.NrOfIndexes = Translate.Cmmn_ReadByte(hglobal1, 4);
      if ((int) num2 == 0)
        this.pvStatInfo.FileVersion = Translate.Cmmn_ReadByte(hglobal1, 5);
      if ((int) num2 == 0)
        this.pvStatInfo.RecordCount = Translate.Cmmn_ReadInt32(hglobal1, 6);
      Marshal.FreeHGlobal(hglobal2);
      Marshal.FreeHGlobal(hglobal1);
      return num2;
    }

    public virtual short btrSetDirectory(byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.Default.GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      //__Null local1 = null;
      IntPtr num3 = IntPtr.Zero;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local2 = @num4;
      IntPtr num5 = num1;
      int num6 = 0;
      int num7 = 0;
      byte[] numArray = ClientId;
      short num8 = Func.BTRCALLID((short) num2, /*(byte[]) local1*/null, num3, ref local2, num5, (short) num6, (short) num7, numArray);
      Marshal.FreeHGlobal(num1);
      return num8;
    }

    public virtual short btrSetDirectory()
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.Default.GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      //__Null local1 = null;
      IntPtr num3 = IntPtr.Zero;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local2 = @num4;
      IntPtr num5 = num1;
      int num6 = 0;
      int num7 = 0;
      short num8 = Func.BTRCALL((short) num2, /*(byte[]) local1*/null, num3, ref local2, num5, (short) num6, (short) num7);
      Marshal.FreeHGlobal(num1);
      return num8;
    }

    public virtual short btrGetDirectory(short Disk_Drive_nr, byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      int num2 = 18;
      // ISSUE: variable of the null type
      //__Null local1 = null;
      IntPtr num3 = IntPtr.Zero;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local2 = @num4;
      IntPtr num5 = num1;
      int num6 = (int) this.pbKBL;
      int num7 = (int) Disk_Drive_nr;
      byte[] numArray = ClientId;
      short num8 = Func.BTRCALLID((short) num2, /*(byte[]) local1*/null, num3, ref local2, num5, (short) num6, (short) num7, numArray);
      if ((int) num8 == 0)
        this.pvDirectory = Marshal.PtrToStringAnsi(num1);
      Marshal.FreeHGlobal(num1);
      return num8;
    }

    public virtual short btrGetDirectory(short Disk_Drive_nr)
    {
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      int num2 = 18;
      // ISSUE: variable of the null type
      //__Null local1 = null;
      IntPtr num3 = IntPtr.Zero;
      short num4 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local2 = @num4;
      IntPtr num5 = num1;
      int num6 = (int) this.pbKBL;
      int num7 = (int) Disk_Drive_nr;
      short num8 = Func.BTRCALL((short) num2, /*(byte[]) local1*/null, num3, ref local2, num5, (short) num6, (short) num7);
      if ((int) num8 == 0)
        this.pvDirectory = Marshal.PtrToStringAnsi(num1);
      Marshal.FreeHGlobal(num1);
      return num8;
    }

    public virtual short btrGetPosition(ref IntPtr Position, byte[] ClientId)
    {
      int num1 = 22;
      byte[] numArray1 = this.pvPB;
      IntPtr num2 = Position;
      short num3 = (short) 4;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num3;
      IntPtr num4 = IntPtr.Zero;
      int num5 = 0;
      int num6 = 0;
      byte[] numArray2 = ClientId;
      return Func.BTRCALLID((short) num1, numArray1, num2, ref local, num4, (short) num5, (short) num6, numArray2);
    }

    public virtual short btrGetPosition(ref IntPtr Position)
    {
      int num1 = 22;
      byte[] numArray = this.pvPB;
      IntPtr num2 = Position;
      short num3 = (short) 4;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num3;
      IntPtr num4 = IntPtr.Zero;
      int num5 = 0;
      int num6 = 0;
      return Func.BTRCALL((short) num1, numArray, num2, ref local, num4, (short) num5, (short) num6);
    }

    public virtual short btrGetDirectRecord(DemoResu.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(DemoResu.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(DemoResu.KeyName Key_nr, IntPtr Position, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(DemoResu.KeyName Key_nr, IntPtr Position, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(byte[] ClientId)
    {
      return this.btrStepNext(DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(DemoResu.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(DemoResu.Unlock UnlockKey, IntPtr Position)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALL((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey));
    }

    public virtual short btrClearOwner(byte[] ClientId)
    {
      int num1 = 30;
      byte[] numArray1 = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num3;
      IntPtr num4 = IntPtr.Zero;
      int num5 = 0;
      int num6 = 0;
      byte[] numArray2 = ClientId;
      return Func.BTRCALLID((short) num1, numArray1, num2, ref local, num4, (short) num5, (short) num6, numArray2);
    }

    public virtual short btrClearOwner()
    {
      int num1 = 30;
      byte[] numArray = this.pvPB;
      IntPtr num2 = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short local = @num3;
      IntPtr num4 = IntPtr.Zero;
      int num5 = 0;
      int num6 = 0;
      return Func.BTRCALL((short) num1, numArray, num2, ref local, num4, (short) num5, (short) num6);
    }

    public virtual short btrStepFirst(byte[] ClientId)
    {
      return this.btrStepFirst(DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(DemoResu.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (125 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(DemoResu.KeyName Key_nr)
    {
      short num1 = checked ((short) (125 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= DemoResu.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(DemoResu.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, DemoResu.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(DemoResu.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, DemoResu.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(DemoResu.KeyName Key_nr, short Percentage, DemoResu.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(DemoResu.KeyName Key_nr, short Percentage, DemoResu.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 123;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(DemoResu.KeyName Key_nr, ref short Percentage, byte[] ClientId)
    {
      short num1 = (short) 4;
      IntPtr hglobal = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref pPtr, checked ((short) Key_nr));
      short num2 = Func.BTRCALLID((short) 45, this.pvPB, hglobal, ref num1, pPtr, this.pbKBL, checked ((short) Key_nr), ClientId);
      if ((int) num2 == 0)
        Percentage = Translate.Cmmn_ReadInt16(hglobal, 0);
      Marshal.FreeHGlobal(pPtr);
      Marshal.FreeHGlobal(hglobal);
      return num2;
    }

    public virtual short btrFindPercentage(DemoResu.KeyName Key_nr, ref short Percentage)
    {
      short num1 = (short) 4;
      IntPtr hglobal = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoKB(ref pPtr, checked ((short) Key_nr));
      short num2 = Func.BTRCALL((short) 45, this.pvPB, hglobal, ref num1, pPtr, this.pbKBL, checked ((short) Key_nr));
      if ((int) num2 == 0)
        Percentage = Translate.Cmmn_ReadInt16(hglobal, 0);
      Marshal.FreeHGlobal(pPtr);
      Marshal.FreeHGlobal(hglobal);
      return num2;
    }

    public class KeysStruct
    {
      private DemoResu.KeysStruct.struct_01 idxindex_1_priv;
      private DemoResu.KeysStruct.struct_02 idxUK_unnamed_6_priv;
      private DemoResu.KeysStruct.struct_03 idxindex_3_priv;
      private DemoResu.KeysStruct.struct_00 idxindex_0_priv;

      public DemoResu.KeysStruct.struct_01 idxindex_1
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

      public DemoResu.KeysStruct.struct_02 idxUK_unnamed_6
      {
        get
        {
          return this.idxUK_unnamed_6_priv;
        }
        set
        {
          this.idxUK_unnamed_6_priv = value;
        }
      }

      public DemoResu.KeysStruct.struct_03 idxindex_3
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

      public DemoResu.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new DemoResu.KeysStruct.struct_01();
        this.idxUK_unnamed_6_priv = new DemoResu.KeysStruct.struct_02();
        this.idxindex_3_priv = new DemoResu.KeysStruct.struct_03();
        this.idxindex_0_priv = new DemoResu.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private int sgmIdPlano_priv;
        private string sgmModelo1_priv;
        private int sgmunnamed_1_priv;
        private int sgmunnamed_4_priv;

        public int sgmIdPlano
        {
          get
          {
            return this.sgmIdPlano_priv;
          }
          set
          {
            this.sgmIdPlano_priv = value;
          }
        }

        public string sgmModelo1
        {
          get
          {
            return this.sgmModelo1_priv;
          }
          set
          {
            this.sgmModelo1_priv = value;
          }
        }

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
          
          this.sgmIdPlano_priv = 0;
          this.sgmModelo1_priv = string.Empty;
          this.sgmunnamed_1_priv = 0;
          this.sgmunnamed_4_priv = 0;
        }
      }

      public class struct_01
      {
        private int sgmunnamed_1_priv;

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

        public struct_01()
        {
          
          this.sgmunnamed_1_priv = 0;
        }
      }

      public class struct_02
      {
        private int sgmunnamed_6_priv;

        public int sgmunnamed_6
        {
          get
          {
            return this.sgmunnamed_6_priv;
          }
          set
          {
            this.sgmunnamed_6_priv = value;
          }
        }

        public struct_02()
        {
          
          this.sgmunnamed_6_priv = 0;
        }
      }

      public class struct_03
      {
        private int sgmIdPlano_priv;
        private string sgmConta_priv;

        public int sgmIdPlano
        {
          get
          {
            return this.sgmIdPlano_priv;
          }
          set
          {
            this.sgmIdPlano_priv = value;
          }
        }

        public string sgmConta
        {
          get
          {
            return this.sgmConta_priv;
          }
          set
          {
            this.sgmConta_priv = value;
          }
        }

        public struct_03()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmConta_priv = string.Empty;
        }
      }
    }

    public enum KeyName
    {
      NoCurrencyChange = -1,
      index_0 = 0,
      index_1 = 1,
      UK_unnamed_6 = 2,
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

    [StructLayout(LayoutKind.Sequential, Size = 123, Pack = 1)]
    internal struct FieldsClass_priv
    {
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
      internal char[] a_000;
      internal int a_001;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 50)]
      internal char[] a_005;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_055;
      internal int a_111;
      internal int a_115;
      internal int a_119;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private string fldModelo1_priv;
      private int fldunnamed_1_priv;
      private string fldunnamed_2_priv;
      private string fldConta_priv;
      private int fldunnamed_4_priv;
      private int fldIdPlano_priv;
      private int Id_priv;
      private PropertyChangedEventHandler PropertyChangedEvent;

      public string fldModelo1
      {
        get
        {
          return this.fldModelo1_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldModelo1_priv, value, false) == 0)
            return;
          this.fldModelo1_priv = value;
          this.OnPropertyChanged("fldModelo1");
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

      public string fldunnamed_2
      {
        get
        {
          return this.fldunnamed_2_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_2_priv, value, false) == 0)
            return;
          this.fldunnamed_2_priv = value;
          this.OnPropertyChanged("fldunnamed_2");
        }
      }

      public string fldConta
      {
        get
        {
          return this.fldConta_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldConta_priv, value, false) == 0)
            return;
          this.fldConta_priv = value;
          this.OnPropertyChanged("fldConta");
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

      public int fldIdPlano
      {
        get
        {
          return this.fldIdPlano_priv;
        }
        set
        {
          if (this.fldIdPlano_priv == value)
            return;
          this.fldIdPlano_priv = value;
          this.OnPropertyChanged("fldIdPlano");
        }
      }

      public int Id
      {
        get
        {
          return this.Id_priv;
        }
        set
        {
          if (this.Id_priv == value)
            return;
          this.Id_priv = value;
          this.OnPropertyChanged("Id");
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
        
        this.fldModelo1_priv = string.Empty;
        this.fldunnamed_1_priv = 0;
        this.fldunnamed_2_priv = string.Empty;
        this.fldConta_priv = string.Empty;
        this.fldunnamed_4_priv = 0;
        this.fldIdPlano_priv = 0;
        this.Id_priv = 0;
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
