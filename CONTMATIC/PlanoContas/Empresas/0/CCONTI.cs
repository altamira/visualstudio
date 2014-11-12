// Type: Trial.CCONTI
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 40F07715-A9C6-4D89-9D95-435F1C1B78ED
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
  public class CCONTI
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
    private CCONTI.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private CCONTI.FieldsClass pvFields;
    private CCONTI.FieldsClass[] pvFieldsExtr;
    private CCONTI.FieldsClass_priv pvFieldsIntern;
    private Globals.StatExtended pvStatExt;
    private Globals.StatInfo pvStatInfo;

    public string fldCFOP
    {
      get
      {
        return this.pvFields.fldCFOP;
      }
      set
      {
        this.pvFields.fldCFOP = value;
      }
    }

    public int fldContaContabilFiscal
    {
      get
      {
        return this.pvFields.fldContaContabilFiscal;
      }
      set
      {
        this.pvFields.fldContaContabilFiscal = value;
      }
    }

    public string fldPartida
    {
      get
      {
        return this.pvFields.fldPartida;
      }
      set
      {
        this.pvFields.fldPartida = value;
      }
    }

    public string fldContraPartida
    {
      get
      {
        return this.pvFields.fldContraPartida;
      }
      set
      {
        this.pvFields.fldContraPartida = value;
      }
    }

    public int fldCodigoHistorico
    {
      get
      {
        return this.pvFields.fldCodigoHistorico;
      }
      set
      {
        this.pvFields.fldCodigoHistorico = value;
      }
    }

    public string fldComplementoHistorico
    {
      get
      {
        return this.pvFields.fldComplementoHistorico;
      }
      set
      {
        this.pvFields.fldComplementoHistorico = value;
      }
    }

    public string fldExtenso
    {
      get
      {
        return this.pvFields.fldExtenso;
      }
      set
      {
        this.pvFields.fldExtenso = value;
      }
    }

    public string fldunnamed_4
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

    public string fldTipo
    {
      get
      {
        return this.pvFields.fldTipo;
      }
      set
      {
        this.pvFields.fldTipo = value;
      }
    }

    public string fldunnamed_6
    {
      get
      {
        return this.pvFields.fldunnamed_6;
      }
      set
      {
        this.pvFields.fldunnamed_6 = value;
      }
    }

    public string fldunnamed_11
    {
      get
      {
        return this.pvFields.fldunnamed_11;
      }
      set
      {
        this.pvFields.fldunnamed_11 = value;
      }
    }

    public string fldunnamed_12
    {
      get
      {
        return this.pvFields.fldunnamed_12;
      }
      set
      {
        this.pvFields.fldunnamed_12 = value;
      }
    }

    public string fldunnamed_13
    {
      get
      {
        return this.pvFields.fldunnamed_13;
      }
      set
      {
        this.pvFields.fldunnamed_13 = value;
      }
    }

    public string fldunnamed_14
    {
      get
      {
        return this.pvFields.fldunnamed_14;
      }
      set
      {
        this.pvFields.fldunnamed_14 = value;
      }
    }

    public int fldId
    {
      get
      {
        return this.pvFields.fldId;
      }
      set
      {
        this.pvFields.fldId = value;
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

    public CCONTI.KeysStruct Keys
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

    public CCONTI.FieldsClass Fields
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

    public CCONTI.FieldsClass[] Fields_ext
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

    public CCONTI()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[155];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Empresas\\ALTAMIRA\\0\\CCONTI.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new CCONTI.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new CCONTI.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public CCONTI(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[155];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Empresas\\ALTAMIRA\\0\\CCONTI.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new CCONTI.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new CCONTI.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public CCONTI(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[155];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Empresas\\ALTAMIRA\\0\\CCONTI.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new CCONTI.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new CCONTI.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public CCONTI(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[155];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Empresas\\ALTAMIRA\\0\\CCONTI.BTR";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new CCONTI.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new CCONTI.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 3L));
        if (this.pvKeys.idxindex_0.sgmCFOP.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCFOP.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCFOP), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 6, this.pvKeys.idxindex_0.sgmContaContabilFiscal);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_0.sgmTipo.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmTipo.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmTipo), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        Translate.Cmmn_WriteInt32(pPtr, 3, this.pvKeys.idxindex_1.sgmContaContabilFiscal);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 7L));
        if (this.pvKeys.idxindex_1.sgmTipo.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmTipo.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmTipo), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_1.sgmCFOP.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmCFOP.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmCFOP), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 2)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 3L));
        if (this.pvKeys.idxindex_2.sgmCFOP.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmCFOP.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmCFOP), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 6L));
        if (this.pvKeys.idxindex_2.sgmExtenso.Length < 70)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmExtenso.PadRight(70)), 0, this.pvPtr, 70);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmExtenso), 0, this.pvPtr, 70);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_2.sgmTipo.Length < 3)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmTipo.PadRight(3)), 0, this.pvPtr, 3);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmTipo), 0, this.pvPtr, 3);
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 3)
          return;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 3L));
        this.pvKeys.idxindex_0.sgmCFOP = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_0.sgmContaContabilFiscal = Translate.Cmmn_ReadInt32(pPtr4, 6);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_0.sgmTipo = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        this.pvKeys.idxindex_1.sgmContaContabilFiscal = Translate.Cmmn_ReadInt32(pPtr4, 3);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 7L));
        this.pvKeys.idxindex_1.sgmTipo = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_1.sgmCFOP = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 2)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 3L));
        this.pvKeys.idxindex_2.sgmCFOP = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 6L));
        this.pvKeys.idxindex_2.sgmExtenso = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 70) : Marshal.PtrToStringAnsi(this.pvPtr, 70).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_2.sgmTipo = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 3) : Marshal.PtrToStringAnsi(this.pvPtr, 3).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 3)
          return;
        this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      CCONTI cconti = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (CCONTI.FieldsClass_priv));
      CCONTI.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      CCONTI.FieldsClass_priv fieldsClassPriv2 = obj != null ? (CCONTI.FieldsClass_priv) obj : fieldsClassPriv1;
      cconti.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldCFOP = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_000) : new string(this.pvFieldsIntern.a_000).Trim();
      this.pvFields.fldContaContabilFiscal = this.pvFieldsIntern.a_003;
      this.pvFields.fldPartida = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_007) : new string(this.pvFieldsIntern.a_007).Trim();
      this.pvFields.fldContraPartida = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_063) : new string(this.pvFieldsIntern.a_063).Trim();
      this.pvFields.fldCodigoHistorico = this.pvFieldsIntern.a_119;
      this.pvFields.fldComplementoHistorico = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_123) : new string(this.pvFieldsIntern.a_123).Trim();
      this.pvFields.fldExtenso = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_278) : new string(this.pvFieldsIntern.a_278).Trim();
      this.pvFields.fldunnamed_4 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_348) : new string(this.pvFieldsIntern.a_348).Trim();
      this.pvFields.fldTipo = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_359) : new string(this.pvFieldsIntern.a_359).Trim();
      this.pvFields.fldunnamed_6 = new string(this.pvFieldsIntern.a_363, 0, Math.Min(99, (int) this.pvFieldsIntern.a_362));
      this.pvFields.fldunnamed_11 = new string(this.pvFieldsIntern.a_463, 0, Math.Min(99, (int) this.pvFieldsIntern.a_462));
      this.pvFields.fldunnamed_12 = new string(this.pvFieldsIntern.a_563, 0, Math.Min(99, (int) this.pvFieldsIntern.a_562));
      this.pvFields.fldunnamed_13 = new string(this.pvFieldsIntern.a_663, 0, Math.Min(99, (int) this.pvFieldsIntern.a_662));
      this.pvFields.fldunnamed_14 = new string(this.pvFieldsIntern.a_763, 0, Math.Min(71, (int) this.pvFieldsIntern.a_762));
      this.pvFields.fldId = this.pvFieldsIntern.a_834;
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldCFOP.PadRight(3).ToCharArray();
      this.pvFieldsIntern.a_003 = this.pvFields.fldContaContabilFiscal;
      this.pvFieldsIntern.a_007 = this.pvFields.fldPartida.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_063 = this.pvFields.fldContraPartida.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_119 = this.pvFields.fldCodigoHistorico;
      this.pvFieldsIntern.a_123 = this.pvFields.fldComplementoHistorico.PadRight(155).ToCharArray();
      this.pvFieldsIntern.a_278 = this.pvFields.fldExtenso.PadRight(70).ToCharArray();
      this.pvFieldsIntern.a_348 = this.pvFields.fldunnamed_4.PadRight(11).ToCharArray();
      this.pvFieldsIntern.a_359 = this.pvFields.fldTipo.PadRight(3).ToCharArray();
      this.pvFieldsIntern.a_362 = checked ((byte) Math.Min(this.pvFields.fldunnamed_6.Length, 99));
      this.pvFieldsIntern.a_363 = this.pvFields.fldunnamed_6.PadRight(99).ToCharArray();
      this.pvFieldsIntern.a_462 = checked ((byte) Math.Min(this.pvFields.fldunnamed_11.Length, 99));
      this.pvFieldsIntern.a_463 = this.pvFields.fldunnamed_11.PadRight(99).ToCharArray();
      this.pvFieldsIntern.a_562 = checked ((byte) Math.Min(this.pvFields.fldunnamed_12.Length, 99));
      this.pvFieldsIntern.a_563 = this.pvFields.fldunnamed_12.PadRight(99).ToCharArray();
      this.pvFieldsIntern.a_662 = checked ((byte) Math.Min(this.pvFields.fldunnamed_13.Length, 99));
      this.pvFieldsIntern.a_663 = this.pvFields.fldunnamed_13.PadRight(99).ToCharArray();
      this.pvFieldsIntern.a_762 = checked ((byte) Math.Min(this.pvFields.fldunnamed_14.Length, 71));
      this.pvFieldsIntern.a_763 = this.pvFields.fldunnamed_14.PadRight(71).ToCharArray();
      this.pvFieldsIntern.a_834 = this.pvFields.fldId;
      Marshal.StructureToPtr((object) this.pvFieldsIntern, pPtr2, true);
    }

    private void VartoDB_ext(ref IntPtr pPtr3)
    {
      Translate.Cmmn_WriteInt16(pPtr3, checked ((short) this.pvFieldsExtr.Length));
      short num1 = (short) 2;
      int index = 0;
      while (index < this.pvFieldsExtr.Length)
      {
        this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldCFOP.PadRight(3).ToCharArray();
        this.pvFieldsIntern.a_003 = this.pvFieldsExtr[index].fldContaContabilFiscal;
        this.pvFieldsIntern.a_007 = this.pvFieldsExtr[index].fldPartida.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_063 = this.pvFieldsExtr[index].fldContraPartida.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_119 = this.pvFieldsExtr[index].fldCodigoHistorico;
        this.pvFieldsIntern.a_123 = this.pvFieldsExtr[index].fldComplementoHistorico.PadRight(155).ToCharArray();
        this.pvFieldsIntern.a_278 = this.pvFieldsExtr[index].fldExtenso.PadRight(70).ToCharArray();
        this.pvFieldsIntern.a_348 = this.pvFieldsExtr[index].fldunnamed_4.PadRight(11).ToCharArray();
        this.pvFieldsIntern.a_359 = this.pvFieldsExtr[index].fldTipo.PadRight(3).ToCharArray();
        this.pvFieldsIntern.a_362 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_6.Length, 99));
        this.pvFieldsIntern.a_363 = this.pvFieldsExtr[index].fldunnamed_6.PadRight(99).ToCharArray();
        this.pvFieldsIntern.a_462 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_11.Length, 99));
        this.pvFieldsIntern.a_463 = this.pvFieldsExtr[index].fldunnamed_11.PadRight(99).ToCharArray();
        this.pvFieldsIntern.a_562 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_12.Length, 99));
        this.pvFieldsIntern.a_563 = this.pvFieldsExtr[index].fldunnamed_12.PadRight(99).ToCharArray();
        this.pvFieldsIntern.a_662 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_13.Length, 99));
        this.pvFieldsIntern.a_663 = this.pvFieldsExtr[index].fldunnamed_13.PadRight(99).ToCharArray();
        this.pvFieldsIntern.a_762 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_14.Length, 71));
        this.pvFieldsIntern.a_763 = this.pvFieldsExtr[index].fldunnamed_14.PadRight(71).ToCharArray();
        this.pvFieldsIntern.a_834 = this.pvFieldsExtr[index].fldId;
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 838);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 838));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(CCONTI.OpenModes Mode, byte[] ClientId)
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
        Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvOwnerName), 0, num4, checked ((int) num3 - 1));
        Translate.Cmmn_WriteByte(num4, checked ((int) num3 - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(s), 0, num2, checked ((int) num1 - 1));
      Translate.Cmmn_WriteByte(num2, checked ((int) num1 - 2), (byte) 0);
      short num5 = Func.BTRCALLID((short) 0, this.pvPB, num4, ref num3, num2, (short) byte.MaxValue, checked ((short) Mode), ClientId);
      if ((int) num3 > 0)
        Marshal.FreeHGlobal(num4);
      Marshal.FreeHGlobal(num2);
      return num5;
    }

    public virtual short btrOpen(CCONTI.OpenModes Mode)
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
        Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvOwnerName), 0, num4, checked ((int) num3 - 1));
        Translate.Cmmn_WriteByte(num4, checked ((int) num3 - 1), (byte) 0);
      }
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(s), 0, num2, checked ((int) num1 - 1));
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

    public virtual short btrInsert(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 838;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(CCONTI.KeyName Key_nr)
    {
      short num1 = (short) 838;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 838;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(CCONTI.KeyName Key_nr)
    {
      short num1 = (short) 838;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(CCONTI.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(CCONTI.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(CCONTI.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(CCONTI.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetGreater(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetGreaterThanOrEqual(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(CCONTI.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetGreaterThanOrEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLessThan(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(CCONTI.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLessThan(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLessThanOrEqual(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(CCONTI.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLessThanOrEqual(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetFirst(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(CCONTI.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetFirst(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLast(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(CCONTI.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
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

    public virtual short btrGetLast(CCONTI.KeyName Key_nr, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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
      short num1 = (short) 838;
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
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
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
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
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

    public virtual short btrGetDirectRecord(CCONTI.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(CCONTI.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(CCONTI.KeyName Key_nr, IntPtr Position, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(CCONTI.KeyName Key_nr, IntPtr Position, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
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
      return this.btrStepNext(CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(CCONTI.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(CCONTI.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(CCONTI.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (840 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(CCONTI.KeyName Key_nr)
    {
      short num1 = checked ((short) (840 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= CCONTI.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(CCONTI.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, CCONTI.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(CCONTI.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, CCONTI.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(CCONTI.KeyName Key_nr, short Percentage, CCONTI.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(CCONTI.KeyName Key_nr, short Percentage, CCONTI.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 838;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(CCONTI.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(CCONTI.KeyName Key_nr, ref short Percentage)
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
      private CCONTI.KeysStruct.struct_01 idxindex_1_priv;
      private CCONTI.KeysStruct.struct_02 idxindex_2_priv;
      private CCONTI.KeysStruct.struct_03 idxUK_Id_priv;
      private CCONTI.KeysStruct.struct_00 idxindex_0_priv;

      public CCONTI.KeysStruct.struct_01 idxindex_1
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

      public CCONTI.KeysStruct.struct_02 idxindex_2
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

      public CCONTI.KeysStruct.struct_03 idxUK_Id
      {
        get
        {
          return this.idxUK_Id_priv;
        }
        set
        {
          this.idxUK_Id_priv = value;
        }
      }

      public CCONTI.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new CCONTI.KeysStruct.struct_01();
        this.idxindex_2_priv = new CCONTI.KeysStruct.struct_02();
        this.idxUK_Id_priv = new CCONTI.KeysStruct.struct_03();
        this.idxindex_0_priv = new CCONTI.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private string sgmTipo_priv;
        private string sgmCFOP_priv;
        private int sgmContaContabilFiscal_priv;

        public string sgmTipo
        {
          get
          {
            return this.sgmTipo_priv;
          }
          set
          {
            this.sgmTipo_priv = value;
          }
        }

        public string sgmCFOP
        {
          get
          {
            return this.sgmCFOP_priv;
          }
          set
          {
            this.sgmCFOP_priv = value;
          }
        }

        public int sgmContaContabilFiscal
        {
          get
          {
            return this.sgmContaContabilFiscal_priv;
          }
          set
          {
            this.sgmContaContabilFiscal_priv = value;
          }
        }

        public struct_00()
        {
          
          this.sgmTipo_priv = string.Empty;
          this.sgmCFOP_priv = string.Empty;
          this.sgmContaContabilFiscal_priv = 0;
        }
      }

      public class struct_01
      {
        private string sgmCFOP_priv;
        private int sgmContaContabilFiscal_priv;
        private string sgmTipo_priv;

        public string sgmCFOP
        {
          get
          {
            return this.sgmCFOP_priv;
          }
          set
          {
            this.sgmCFOP_priv = value;
          }
        }

        public int sgmContaContabilFiscal
        {
          get
          {
            return this.sgmContaContabilFiscal_priv;
          }
          set
          {
            this.sgmContaContabilFiscal_priv = value;
          }
        }

        public string sgmTipo
        {
          get
          {
            return this.sgmTipo_priv;
          }
          set
          {
            this.sgmTipo_priv = value;
          }
        }

        public struct_01()
        {
          
          this.sgmCFOP_priv = string.Empty;
          this.sgmContaContabilFiscal_priv = 0;
          this.sgmTipo_priv = string.Empty;
        }
      }

      public class struct_02
      {
        private string sgmTipo_priv;
        private string sgmCFOP_priv;
        private string sgmExtenso_priv;

        public string sgmTipo
        {
          get
          {
            return this.sgmTipo_priv;
          }
          set
          {
            this.sgmTipo_priv = value;
          }
        }

        public string sgmCFOP
        {
          get
          {
            return this.sgmCFOP_priv;
          }
          set
          {
            this.sgmCFOP_priv = value;
          }
        }

        public string sgmExtenso
        {
          get
          {
            return this.sgmExtenso_priv;
          }
          set
          {
            this.sgmExtenso_priv = value;
          }
        }

        public struct_02()
        {
          
          this.sgmTipo_priv = string.Empty;
          this.sgmCFOP_priv = string.Empty;
          this.sgmExtenso_priv = string.Empty;
        }
      }

      public class struct_03
      {
        private int sgmId_priv;

        public int sgmId
        {
          get
          {
            return this.sgmId_priv;
          }
          set
          {
            this.sgmId_priv = value;
          }
        }

        public struct_03()
        {
          
          this.sgmId_priv = 0;
        }
      }
    }

    public enum KeyName
    {
      NoCurrencyChange = -1,
      index_0 = 0,
      index_1 = 1,
      index_2 = 2,
      UK_Id = 3,
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

    [StructLayout(LayoutKind.Sequential, Size = 838, Pack = 1)]
    internal struct FieldsClass_priv
    {
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
      internal char[] a_000;
      internal int a_003;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_007;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_063;
      internal int a_119;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 155)]
      internal char[] a_123;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 70)]
      internal char[] a_278;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 11)]
      internal char[] a_348;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
      internal char[] a_359;
      internal byte a_362;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
      internal char[] a_363;
      internal byte a_462;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
      internal char[] a_463;
      internal byte a_562;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
      internal char[] a_563;
      internal byte a_662;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
      internal char[] a_663;
      internal byte a_762;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 71)]
      internal char[] a_763;
      internal int a_834;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private string fldCFOP_priv;
      private int fldContaContabilFiscal_priv;
      private string fldPartida_priv;
      private string fldContraPartida_priv;
      private int fldCodigoHistorico_priv;
      private string fldComplementoHistorico_priv;
      private string fldExtenso_priv;
      private string fldunnamed_4_priv;
      private string fldTipo_priv;
      private string fldunnamed_6_priv;
      private string fldunnamed_11_priv;
      private string fldunnamed_12_priv;
      private string fldunnamed_13_priv;
      private string fldunnamed_14_priv;
      private int fldId_priv;
      private PropertyChangedEventHandler PropertyChangedEvent;

      public string fldCFOP
      {
        get
        {
          return this.fldCFOP_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCFOP_priv, value, false) == 0)
            return;
          this.fldCFOP_priv = value;
          this.OnPropertyChanged("fldCFOP");
        }
      }

      public int fldContaContabilFiscal
      {
        get
        {
          return this.fldContaContabilFiscal_priv;
        }
        set
        {
          if (this.fldContaContabilFiscal_priv == value)
            return;
          this.fldContaContabilFiscal_priv = value;
          this.OnPropertyChanged("fldContaContabilFiscal");
        }
      }

      public string fldPartida
      {
        get
        {
          return this.fldPartida_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldPartida_priv, value, false) == 0)
            return;
          this.fldPartida_priv = value;
          this.OnPropertyChanged("fldPartida");
        }
      }

      public string fldContraPartida
      {
        get
        {
          return this.fldContraPartida_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldContraPartida_priv, value, false) == 0)
            return;
          this.fldContraPartida_priv = value;
          this.OnPropertyChanged("fldContraPartida");
        }
      }

      public int fldCodigoHistorico
      {
        get
        {
          return this.fldCodigoHistorico_priv;
        }
        set
        {
          if (this.fldCodigoHistorico_priv == value)
            return;
          this.fldCodigoHistorico_priv = value;
          this.OnPropertyChanged("fldCodigoHistorico");
        }
      }

      public string fldComplementoHistorico
      {
        get
        {
          return this.fldComplementoHistorico_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldComplementoHistorico_priv, value, false) == 0)
            return;
          this.fldComplementoHistorico_priv = value;
          this.OnPropertyChanged("fldComplementoHistorico");
        }
      }

      public string fldExtenso
      {
        get
        {
          return this.fldExtenso_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldExtenso_priv, value, false) == 0)
            return;
          this.fldExtenso_priv = value;
          this.OnPropertyChanged("fldExtenso");
        }
      }

      public string fldunnamed_4
      {
        get
        {
          return this.fldunnamed_4_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_4_priv, value, false) == 0)
            return;
          this.fldunnamed_4_priv = value;
          this.OnPropertyChanged("fldunnamed_4");
        }
      }

      public string fldTipo
      {
        get
        {
          return this.fldTipo_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldTipo_priv, value, false) == 0)
            return;
          this.fldTipo_priv = value;
          this.OnPropertyChanged("fldTipo");
        }
      }

      public string fldunnamed_6
      {
        get
        {
          return this.fldunnamed_6_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_6_priv, value, false) == 0)
            return;
          this.fldunnamed_6_priv = value;
          this.OnPropertyChanged("fldunnamed_6");
        }
      }

      public string fldunnamed_11
      {
        get
        {
          return this.fldunnamed_11_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_11_priv, value, false) == 0)
            return;
          this.fldunnamed_11_priv = value;
          this.OnPropertyChanged("fldunnamed_11");
        }
      }

      public string fldunnamed_12
      {
        get
        {
          return this.fldunnamed_12_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_12_priv, value, false) == 0)
            return;
          this.fldunnamed_12_priv = value;
          this.OnPropertyChanged("fldunnamed_12");
        }
      }

      public string fldunnamed_13
      {
        get
        {
          return this.fldunnamed_13_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_13_priv, value, false) == 0)
            return;
          this.fldunnamed_13_priv = value;
          this.OnPropertyChanged("fldunnamed_13");
        }
      }

      public string fldunnamed_14
      {
        get
        {
          return this.fldunnamed_14_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_14_priv, value, false) == 0)
            return;
          this.fldunnamed_14_priv = value;
          this.OnPropertyChanged("fldunnamed_14");
        }
      }

      public int fldId
      {
        get
        {
          return this.fldId_priv;
        }
        set
        {
          if (this.fldId_priv == value)
            return;
          this.fldId_priv = value;
          this.OnPropertyChanged("fldId");
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
        
        this.fldCFOP_priv = string.Empty;
        this.fldContaContabilFiscal_priv = 0;
        this.fldPartida_priv = string.Empty;
        this.fldContraPartida_priv = string.Empty;
        this.fldCodigoHistorico_priv = 0;
        this.fldComplementoHistorico_priv = string.Empty;
        this.fldExtenso_priv = string.Empty;
        this.fldunnamed_4_priv = string.Empty;
        this.fldTipo_priv = string.Empty;
        this.fldunnamed_6_priv = string.Empty;
        this.fldunnamed_11_priv = string.Empty;
        this.fldunnamed_12_priv = string.Empty;
        this.fldunnamed_13_priv = string.Empty;
        this.fldunnamed_14_priv = string.Empty;
        this.fldId_priv = 0;
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
