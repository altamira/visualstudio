// Type: Trial.FORNECCT
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: B4680EED-0CF3-4452-96EE-158A33625440
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
  public class FORNECCT
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
    private FORNECCT.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private FORNECCT.FieldsClass pvFields;
    private FORNECCT.FieldsClass[] pvFieldsExtr;
    private FORNECCT.FieldsClass_priv pvFieldsIntern;
    private Globals.StatExtended pvStatExt;
    private Globals.StatInfo pvStatInfo;

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

    public string fldClassificacao
    {
      get
      {
        return this.pvFields.fldClassificacao;
      }
      set
      {
        this.pvFields.fldClassificacao = value;
      }
    }

    public string fldCNPJ
    {
      get
      {
        return this.pvFields.fldCNPJ;
      }
      set
      {
        this.pvFields.fldCNPJ = value;
      }
    }

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

    public string fldRazaoSocial
    {
      get
      {
        return this.pvFields.fldRazaoSocial;
      }
      set
      {
        this.pvFields.fldRazaoSocial = value;
      }
    }

    public string fldInscricaoEstadual
    {
      get
      {
        return this.pvFields.fldInscricaoEstadual;
      }
      set
      {
        this.pvFields.fldInscricaoEstadual = value;
      }
    }

    public string fldEstado
    {
      get
      {
        return this.pvFields.fldEstado;
      }
      set
      {
        this.pvFields.fldEstado = value;
      }
    }

    public string fldEndereco
    {
      get
      {
        return this.pvFields.fldEndereco;
      }
      set
      {
        this.pvFields.fldEndereco = value;
      }
    }

    public string fldCEP
    {
      get
      {
        return this.pvFields.fldCEP;
      }
      set
      {
        this.pvFields.fldCEP = value;
      }
    }

    public string fldCidade
    {
      get
      {
        return this.pvFields.fldCidade;
      }
      set
      {
        this.pvFields.fldCidade = value;
      }
    }

    public string fldMunicipio
    {
      get
      {
        return this.pvFields.fldMunicipio;
      }
      set
      {
        this.pvFields.fldMunicipio = value;
      }
    }

    public string fldReservado5
    {
      get
      {
        return this.pvFields.fldReservado5;
      }
      set
      {
        this.pvFields.fldReservado5 = value;
      }
    }

    public string fldIncricaoMunicipal
    {
      get
      {
        return this.pvFields.fldIncricaoMunicipal;
      }
      set
      {
        this.pvFields.fldIncricaoMunicipal = value;
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

    public FORNECCT.KeysStruct Keys
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

    public FORNECCT.FieldsClass Fields
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

    public FORNECCT.FieldsClass[] Fields_ext
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

    public FORNECCT()
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
      this.pvDataPath = "Y:\\Geral\\fornecCt.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNECCT.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNECCT.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public FORNECCT(bool Trim_Strings)
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
      this.pvDataPath = "Y:\\Geral\\fornecCt.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNECCT.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNECCT.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public FORNECCT(string DataPath)
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
      this.pvDataPath = "Y:\\Geral\\fornecCt.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNECCT.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNECCT.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public FORNECCT(string DataPath, bool Trim_Strings)
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
      this.pvDataPath = "Y:\\Geral\\fornecCt.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNECCT.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNECCT.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_0.sgmClassificacao.Length < 1)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmClassificacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 5L));
        if (this.pvKeys.idxindex_0.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmIdPlano);
      }
      else
      {
        if ((int) pKey != 1)
          return;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_1.sgmClassificacao.Length < 1)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmClassificacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 5L));
        if (this.pvKeys.idxindex_1.sgmRazaoSocial.Length < 48)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial.PadRight(48)), 0, this.pvPtr, 48);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial), 0, this.pvPtr, 48);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_1.sgmIdPlano);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_0.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 5L));
        this.pvKeys.idxindex_0.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_0.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else
      {
        if ((int) pKey != 1)
          return;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_1.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 5L));
        this.pvKeys.idxindex_1.sgmRazaoSocial = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 48) : Marshal.PtrToStringAnsi(this.pvPtr, 48).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_1.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      FORNECCT fornecct = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (FORNECCT.FieldsClass_priv));
      FORNECCT.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      FORNECCT.FieldsClass_priv fieldsClassPriv2 = obj != null ? (FORNECCT.FieldsClass_priv) obj : fieldsClassPriv1;
      fornecct.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldIdPlano = this.pvFieldsIntern.a_000;
      this.pvFields.fldClassificacao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
      this.pvFields.fldCNPJ = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_005) : new string(this.pvFieldsIntern.a_005).Trim();
      this.pvFields.fldContaContabil = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_026) : new string(this.pvFieldsIntern.a_026).Trim();
      this.pvFields.fldRazaoSocial = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_082) : new string(this.pvFieldsIntern.a_082).Trim();
      this.pvFields.fldInscricaoEstadual = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_130) : new string(this.pvFieldsIntern.a_130).Trim();
      this.pvFields.fldEstado = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_148) : new string(this.pvFieldsIntern.a_148).Trim();
      this.pvFields.fldEndereco = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_150) : new string(this.pvFieldsIntern.a_150).Trim();
      this.pvFields.fldCEP = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_185) : new string(this.pvFieldsIntern.a_185).Trim();
      this.pvFields.fldCidade = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_195) : new string(this.pvFieldsIntern.a_195).Trim();
      this.pvFields.fldMunicipio = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_220) : new string(this.pvFieldsIntern.a_220).Trim();
      this.pvFields.fldReservado5 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_230) : new string(this.pvFieldsIntern.a_230).Trim();
      this.pvFields.fldIncricaoMunicipal = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_262) : new string(this.pvFieldsIntern.a_262).Trim();
      if (this.pvTrimStrings)
        this.pvFields.fldunnamed_14 = new string(this.pvFieldsIntern.a_282).Trim();
      else
        this.pvFields.fldunnamed_14 = new string(this.pvFieldsIntern.a_282);
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldIdPlano;
      this.pvFieldsIntern.a_004 = this.pvFields.fldClassificacao.PadRight(1).ToCharArray();
      this.pvFieldsIntern.a_005 = this.pvFields.fldCNPJ.PadRight(21).ToCharArray();
      this.pvFieldsIntern.a_026 = this.pvFields.fldContaContabil.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_082 = this.pvFields.fldRazaoSocial.PadRight(48).ToCharArray();
      this.pvFieldsIntern.a_130 = this.pvFields.fldInscricaoEstadual.PadRight(18).ToCharArray();
      this.pvFieldsIntern.a_148 = this.pvFields.fldEstado.PadRight(2).ToCharArray();
      this.pvFieldsIntern.a_150 = this.pvFields.fldEndereco.PadRight(35).ToCharArray();
      this.pvFieldsIntern.a_185 = this.pvFields.fldCEP.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_195 = this.pvFields.fldCidade.PadRight(25).ToCharArray();
      this.pvFieldsIntern.a_220 = this.pvFields.fldMunicipio.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_230 = this.pvFields.fldReservado5.PadRight(32).ToCharArray();
      this.pvFieldsIntern.a_262 = this.pvFields.fldIncricaoMunicipal.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_282 = this.pvFields.fldunnamed_14.PadRight(40).ToCharArray();
      Marshal.StructureToPtr((object) this.pvFieldsIntern, pPtr2, true);
    }

    private void VartoDB_ext(ref IntPtr pPtr3)
    {
      Translate.Cmmn_WriteInt16(pPtr3, checked ((short) this.pvFieldsExtr.Length));
      short num1 = (short) 2;
      int index = 0;
      while (index < this.pvFieldsExtr.Length)
      {
        this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldIdPlano;
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldClassificacao.PadRight(1).ToCharArray();
        this.pvFieldsIntern.a_005 = this.pvFieldsExtr[index].fldCNPJ.PadRight(21).ToCharArray();
        this.pvFieldsIntern.a_026 = this.pvFieldsExtr[index].fldContaContabil.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_082 = this.pvFieldsExtr[index].fldRazaoSocial.PadRight(48).ToCharArray();
        this.pvFieldsIntern.a_130 = this.pvFieldsExtr[index].fldInscricaoEstadual.PadRight(18).ToCharArray();
        this.pvFieldsIntern.a_148 = this.pvFieldsExtr[index].fldEstado.PadRight(2).ToCharArray();
        this.pvFieldsIntern.a_150 = this.pvFieldsExtr[index].fldEndereco.PadRight(35).ToCharArray();
        this.pvFieldsIntern.a_185 = this.pvFieldsExtr[index].fldCEP.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_195 = this.pvFieldsExtr[index].fldCidade.PadRight(25).ToCharArray();
        this.pvFieldsIntern.a_220 = this.pvFieldsExtr[index].fldMunicipio.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_230 = this.pvFieldsExtr[index].fldReservado5.PadRight(32).ToCharArray();
        this.pvFieldsIntern.a_262 = this.pvFieldsExtr[index].fldIncricaoMunicipal.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_282 = this.pvFieldsExtr[index].fldunnamed_14.PadRight(40).ToCharArray();
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 322);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 322));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(FORNECCT.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(FORNECCT.OpenModes Mode)
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

    public virtual short btrInsert(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 322;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(FORNECCT.KeyName Key_nr)
    {
      short num1 = (short) 322;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 322;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FORNECCT.KeyName Key_nr)
    {
      short num1 = (short) 322;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FORNECCT.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetGreater(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetGreaterThanOrEqual(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetGreaterThanOrEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLessThan(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLessThan(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLessThanOrEqual(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLessThanOrEqual(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetFirst(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetFirst(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLast(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(FORNECCT.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
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

    public virtual short btrGetLast(FORNECCT.KeyName Key_nr, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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
      short num1 = (short) 322;
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

    public virtual short btrGetDirectRecord(FORNECCT.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(FORNECCT.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(FORNECCT.KeyName Key_nr, IntPtr Position, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(FORNECCT.KeyName Key_nr, IntPtr Position, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
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
      return this.btrStepNext(FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(FORNECCT.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(FORNECCT.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(FORNECCT.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (324 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(FORNECCT.KeyName Key_nr)
    {
      short num1 = checked ((short) (324 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNECCT.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(FORNECCT.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FORNECCT.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(FORNECCT.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FORNECCT.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(FORNECCT.KeyName Key_nr, short Percentage, FORNECCT.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(FORNECCT.KeyName Key_nr, short Percentage, FORNECCT.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 322;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(FORNECCT.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(FORNECCT.KeyName Key_nr, ref short Percentage)
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
      private FORNECCT.KeysStruct.struct_01 idxindex_1_priv;
      private FORNECCT.KeysStruct.struct_00 idxindex_0_priv;

      public FORNECCT.KeysStruct.struct_01 idxindex_1
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

      public FORNECCT.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new FORNECCT.KeysStruct.struct_01();
        this.idxindex_0_priv = new FORNECCT.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private int sgmIdPlano_priv;
        private string sgmClassificacao_priv;
        private string sgmCNPJ_priv;

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

        public string sgmClassificacao
        {
          get
          {
            return this.sgmClassificacao_priv;
          }
          set
          {
            this.sgmClassificacao_priv = value;
          }
        }

        public string sgmCNPJ
        {
          get
          {
            return this.sgmCNPJ_priv;
          }
          set
          {
            this.sgmCNPJ_priv = value;
          }
        }

        public struct_00()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmClassificacao_priv = string.Empty;
          this.sgmCNPJ_priv = string.Empty;
        }
      }

      public class struct_01
      {
        private int sgmIdPlano_priv;
        private string sgmClassificacao_priv;
        private string sgmRazaoSocial_priv;

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

        public string sgmClassificacao
        {
          get
          {
            return this.sgmClassificacao_priv;
          }
          set
          {
            this.sgmClassificacao_priv = value;
          }
        }

        public string sgmRazaoSocial
        {
          get
          {
            return this.sgmRazaoSocial_priv;
          }
          set
          {
            this.sgmRazaoSocial_priv = value;
          }
        }

        public struct_01()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmClassificacao_priv = string.Empty;
          this.sgmRazaoSocial_priv = string.Empty;
        }
      }
    }

    public enum KeyName
    {
      NoCurrencyChange = -1,
      index_0 = 0,
      index_1 = 1,
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

    [StructLayout(LayoutKind.Sequential, Size = 322, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
      internal char[] a_004;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 21)]
      internal char[] a_005;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_026;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 48)]
      internal char[] a_082;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 18)]
      internal char[] a_130;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
      internal char[] a_148;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 35)]
      internal char[] a_150;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_185;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
      internal char[] a_195;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_220;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
      internal char[] a_230;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_262;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_282;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldIdPlano_priv;
      private string fldClassificacao_priv;
      private string fldCNPJ_priv;
      private string fldContaContabil_priv;
      private string fldRazaoSocial_priv;
      private string fldInscricaoEstadual_priv;
      private string fldEstado_priv;
      private string fldEndereco_priv;
      private string fldCEP_priv;
      private string fldCidade_priv;
      private string fldMunicipio_priv;
      private string fldReservado5_priv;
      private string fldIncricaoMunicipal_priv;
      private string fldunnamed_14_priv;
      private PropertyChangedEventHandler PropertyChangedEvent;

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

      public string fldClassificacao
      {
        get
        {
          return this.fldClassificacao_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldClassificacao_priv, value, false) == 0)
            return;
          this.fldClassificacao_priv = value;
          this.OnPropertyChanged("fldClassificacao");
        }
      }

      public string fldCNPJ
      {
        get
        {
          return this.fldCNPJ_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCNPJ_priv, value, false) == 0)
            return;
          this.fldCNPJ_priv = value;
          this.OnPropertyChanged("fldCNPJ");
        }
      }

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

      public string fldRazaoSocial
      {
        get
        {
          return this.fldRazaoSocial_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldRazaoSocial_priv, value, false) == 0)
            return;
          this.fldRazaoSocial_priv = value;
          this.OnPropertyChanged("fldRazaoSocial");
        }
      }

      public string fldInscricaoEstadual
      {
        get
        {
          return this.fldInscricaoEstadual_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldInscricaoEstadual_priv, value, false) == 0)
            return;
          this.fldInscricaoEstadual_priv = value;
          this.OnPropertyChanged("fldInscricaoEstadual");
        }
      }

      public string fldEstado
      {
        get
        {
          return this.fldEstado_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEstado_priv, value, false) == 0)
            return;
          this.fldEstado_priv = value;
          this.OnPropertyChanged("fldEstado");
        }
      }

      public string fldEndereco
      {
        get
        {
          return this.fldEndereco_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEndereco_priv, value, false) == 0)
            return;
          this.fldEndereco_priv = value;
          this.OnPropertyChanged("fldEndereco");
        }
      }

      public string fldCEP
      {
        get
        {
          return this.fldCEP_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCEP_priv, value, false) == 0)
            return;
          this.fldCEP_priv = value;
          this.OnPropertyChanged("fldCEP");
        }
      }

      public string fldCidade
      {
        get
        {
          return this.fldCidade_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCidade_priv, value, false) == 0)
            return;
          this.fldCidade_priv = value;
          this.OnPropertyChanged("fldCidade");
        }
      }

      public string fldMunicipio
      {
        get
        {
          return this.fldMunicipio_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldMunicipio_priv, value, false) == 0)
            return;
          this.fldMunicipio_priv = value;
          this.OnPropertyChanged("fldMunicipio");
        }
      }

      public string fldReservado5
      {
        get
        {
          return this.fldReservado5_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldReservado5_priv, value, false) == 0)
            return;
          this.fldReservado5_priv = value;
          this.OnPropertyChanged("fldReservado5");
        }
      }

      public string fldIncricaoMunicipal
      {
        get
        {
          return this.fldIncricaoMunicipal_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldIncricaoMunicipal_priv, value, false) == 0)
            return;
          this.fldIncricaoMunicipal_priv = value;
          this.OnPropertyChanged("fldIncricaoMunicipal");
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
        
        this.fldIdPlano_priv = 0;
        this.fldClassificacao_priv = string.Empty;
        this.fldCNPJ_priv = string.Empty;
        this.fldContaContabil_priv = string.Empty;
        this.fldRazaoSocial_priv = string.Empty;
        this.fldInscricaoEstadual_priv = string.Empty;
        this.fldEstado_priv = string.Empty;
        this.fldEndereco_priv = string.Empty;
        this.fldCEP_priv = string.Empty;
        this.fldCidade_priv = string.Empty;
        this.fldMunicipio_priv = string.Empty;
        this.fldReservado5_priv = string.Empty;
        this.fldIncricaoMunicipal_priv = string.Empty;
        this.fldunnamed_14_priv = string.Empty;
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
