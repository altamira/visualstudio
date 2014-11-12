// Type: Trial.FORNEC
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
using System.Globalization;

namespace CONTMATIC.Geral
{
  public class FORNEC
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
    private FORNEC.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private FORNEC.FieldsClass pvFields;
    private FORNEC.FieldsClass[] pvFieldsExtr;
    private FORNEC.FieldsClass_priv pvFieldsIntern;
    private Globals.StatExtended pvStatExt;
    private Globals.StatInfo pvStatInfo;

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

    public string fldReservado2
    {
      get
      {
        return this.pvFields.fldReservado2;
      }
      set
      {
        this.pvFields.fldReservado2 = value;
      }
    }

    public string fldReservado3
    {
      get
      {
        return this.pvFields.fldReservado3;
      }
      set
      {
        this.pvFields.fldReservado3 = value;
      }
    }

    public string fldInscricaoMunicipal
    {
      get
      {
        return this.pvFields.fldInscricaoMunicipal;
      }
      set
      {
        this.pvFields.fldInscricaoMunicipal = value;
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

    public string fldReservado6
    {
      get
      {
        return this.pvFields.fldReservado6;
      }
      set
      {
        this.pvFields.fldReservado6 = value;
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

    public FORNEC.KeysStruct Keys
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

    public FORNEC.FieldsClass Fields
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

    public FORNEC.FieldsClass[] Fields_ext
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

    public FORNEC()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[48];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FORNEC.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNEC.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNEC.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public FORNEC(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[48];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FORNEC.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNEC.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNEC.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public FORNEC(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[48];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FORNEC.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNEC.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNEC.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public FORNEC(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[48];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FORNEC.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FORNEC.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FORNEC.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 1L));
        if (this.pvKeys.idxindex_0.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_0.sgmClassificacao.Length < 1)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmClassificacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 1L));
        if (this.pvKeys.idxindex_1.sgmRazaoSocial.Length < 48)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial.PadRight(48)), 0, this.pvPtr, 48);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial), 0, this.pvPtr, 48);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_1.sgmClassificacao.Length < 1)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmClassificacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 2)
          return;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 1L));
        this.pvKeys.idxindex_0.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_0.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 1L));
        this.pvKeys.idxindex_1.sgmRazaoSocial = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 48) : Marshal.PtrToStringAnsi(this.pvPtr, 48).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_1.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 2)
          return;
        this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      FORNEC fornec = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (FORNEC.FieldsClass_priv));
      FORNEC.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      FORNEC.FieldsClass_priv fieldsClassPriv2 = obj != null ? (FORNEC.FieldsClass_priv) obj : fieldsClassPriv1;
      fornec.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldId = this.pvFieldsIntern.a_000;
      this.pvFields.fldRazaoSocial = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
      this.pvFields.fldEndereco = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_052) : new string(this.pvFieldsIntern.a_052).Trim();
      this.pvFields.fldCEP = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_100) : new string(this.pvFieldsIntern.a_100).Trim();
      this.pvFields.fldCidade = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_109) : new string(this.pvFieldsIntern.a_109).Trim();
      this.pvFields.fldEstado = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_134) : new string(this.pvFieldsIntern.a_134).Trim();
      this.pvFields.fldClassificacao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_136) : new string(this.pvFieldsIntern.a_136).Trim();
      this.pvFields.fldCNPJ = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_137) : new string(this.pvFieldsIntern.a_137).Trim();
      this.pvFields.fldInscricaoEstadual = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_158) : new string(this.pvFieldsIntern.a_158).Trim();
      this.pvFields.fldMunicipio = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_177) : new string(this.pvFieldsIntern.a_177).Trim();
      this.pvFields.fldReservado2 = new string(this.pvFieldsIntern.a_186, 0, Math.Min(11, (int) this.pvFieldsIntern.a_185));
      this.pvFields.fldReservado3 = new string(this.pvFieldsIntern.a_198, 0, Math.Min(19, (int) this.pvFieldsIntern.a_197));
      this.pvFields.fldInscricaoMunicipal = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_217) : new string(this.pvFieldsIntern.a_217).Trim();
      this.pvFields.fldReservado5 = new string(this.pvFieldsIntern.a_238, 0, Math.Min(19, (int) this.pvFieldsIntern.a_237));
      this.pvFields.fldReservado6 = new string(this.pvFieldsIntern.a_258, 0, Math.Min(19, (int) this.pvFieldsIntern.a_257));
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
        Encoding oem = Encoding.GetEncoding(CultureInfo.CurrentCulture.TextInfo.OEMCodePage);
      this.pvFieldsIntern.a_000 = this.pvFields.fldId;
      if (this.pvFieldsIntern.a_004 == null) this.pvFieldsIntern.a_004 = "".PadLeft(48).ToCharArray();
      oem.GetBytes(this.pvFields.fldRazaoSocial.PadRight(48).Substring(0, 48)).CopyTo(this.pvFieldsIntern.a_004, 0);
      //this.pvFieldsIntern.a_004 = this.pvFields.fldRazaoSocial.PadRight(48).ToCharArray();
      this.pvFieldsIntern.a_052 = this.pvFields.fldEndereco.PadRight(48).ToCharArray();
      this.pvFieldsIntern.a_100 = this.pvFields.fldCEP.PadRight(9).ToCharArray();
      this.pvFieldsIntern.a_109 = this.pvFields.fldCidade.PadRight(25).ToCharArray();
      this.pvFieldsIntern.a_134 = this.pvFields.fldEstado.PadRight(2).ToCharArray();
      this.pvFieldsIntern.a_136 = this.pvFields.fldClassificacao.PadRight(1).ToCharArray();
      this.pvFieldsIntern.a_137 = this.pvFields.fldCNPJ.PadRight(21).ToCharArray();
      this.pvFieldsIntern.a_158 = this.pvFields.fldInscricaoEstadual.PadRight(19).ToCharArray();
      this.pvFieldsIntern.a_177 = this.pvFields.fldMunicipio.PadRight(8).ToCharArray();
      this.pvFieldsIntern.a_185 = checked ((byte) Math.Min(this.pvFields.fldReservado2.Length, 11));
      this.pvFieldsIntern.a_186 = this.pvFields.fldReservado2.PadRight(11).ToCharArray();
      this.pvFieldsIntern.a_197 = checked ((byte) Math.Min(this.pvFields.fldReservado3.Length, 19));
      this.pvFieldsIntern.a_198 = this.pvFields.fldReservado3.PadRight(19).ToCharArray();
      this.pvFieldsIntern.a_217 = this.pvFields.fldInscricaoMunicipal.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_237 = checked ((byte) Math.Min(this.pvFields.fldReservado5.Length, 19));
      this.pvFieldsIntern.a_238 = this.pvFields.fldReservado5.PadRight(19).ToCharArray();
      this.pvFieldsIntern.a_257 = checked ((byte) Math.Min(this.pvFields.fldReservado6.Length, 19));
      this.pvFieldsIntern.a_258 = this.pvFields.fldReservado6.PadRight(19).ToCharArray();
      Marshal.StructureToPtr((object) this.pvFieldsIntern, pPtr2, true);
    }

    private void VartoDB_ext(ref IntPtr pPtr3)
    {
      Translate.Cmmn_WriteInt16(pPtr3, checked ((short) this.pvFieldsExtr.Length));
      short num1 = (short) 2;
      int index = 0;
      while (index < this.pvFieldsExtr.Length)
      {
        this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldId;
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldRazaoSocial.PadRight(48).ToCharArray();
        this.pvFieldsIntern.a_052 = this.pvFieldsExtr[index].fldEndereco.PadRight(48).ToCharArray();
        this.pvFieldsIntern.a_100 = this.pvFieldsExtr[index].fldCEP.PadRight(9).ToCharArray();
        this.pvFieldsIntern.a_109 = this.pvFieldsExtr[index].fldCidade.PadRight(25).ToCharArray();
        this.pvFieldsIntern.a_134 = this.pvFieldsExtr[index].fldEstado.PadRight(2).ToCharArray();
        this.pvFieldsIntern.a_136 = this.pvFieldsExtr[index].fldClassificacao.PadRight(1).ToCharArray();
        this.pvFieldsIntern.a_137 = this.pvFieldsExtr[index].fldCNPJ.PadRight(21).ToCharArray();
        this.pvFieldsIntern.a_158 = this.pvFieldsExtr[index].fldInscricaoEstadual.PadRight(19).ToCharArray();
        this.pvFieldsIntern.a_177 = this.pvFieldsExtr[index].fldMunicipio.PadRight(8).ToCharArray();
        this.pvFieldsIntern.a_185 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldReservado2.Length, 11));
        this.pvFieldsIntern.a_186 = this.pvFieldsExtr[index].fldReservado2.PadRight(11).ToCharArray();
        this.pvFieldsIntern.a_197 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldReservado3.Length, 19));
        this.pvFieldsIntern.a_198 = this.pvFieldsExtr[index].fldReservado3.PadRight(19).ToCharArray();
        this.pvFieldsIntern.a_217 = this.pvFieldsExtr[index].fldInscricaoMunicipal.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_237 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldReservado5.Length, 19));
        this.pvFieldsIntern.a_238 = this.pvFieldsExtr[index].fldReservado5.PadRight(19).ToCharArray();
        this.pvFieldsIntern.a_257 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldReservado6.Length, 19));
        this.pvFieldsIntern.a_258 = this.pvFieldsExtr[index].fldReservado6.PadRight(19).ToCharArray();
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 277);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 277));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(FORNEC.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(FORNEC.OpenModes Mode)
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

    public virtual short btrInsert(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 277;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(FORNEC.KeyName Key_nr)
    {
      short num1 = (short) 277;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 277;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FORNEC.KeyName Key_nr)
    {
      short num1 = (short) 277;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(FORNEC.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FORNEC.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FORNEC.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(FORNEC.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetGreater(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetGreaterThanOrEqual(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(FORNEC.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetGreaterThanOrEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLessThan(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(FORNEC.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLessThan(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLessThanOrEqual(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(FORNEC.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLessThanOrEqual(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetFirst(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(FORNEC.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetFirst(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLast(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(FORNEC.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
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

    public virtual short btrGetLast(FORNEC.KeyName Key_nr, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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
      short num1 = (short) 277;
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

    public virtual short btrGetDirectRecord(FORNEC.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(FORNEC.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(FORNEC.KeyName Key_nr, IntPtr Position, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(FORNEC.KeyName Key_nr, IntPtr Position, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
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
      return this.btrStepNext(FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(FORNEC.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(FORNEC.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(FORNEC.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (279 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(FORNEC.KeyName Key_nr)
    {
      short num1 = checked ((short) (279 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FORNEC.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(FORNEC.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FORNEC.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(FORNEC.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FORNEC.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(FORNEC.KeyName Key_nr, short Percentage, FORNEC.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(FORNEC.KeyName Key_nr, short Percentage, FORNEC.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 277;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(FORNEC.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(FORNEC.KeyName Key_nr, ref short Percentage)
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
      private FORNEC.KeysStruct.struct_01 idxindex_1_priv;
      private FORNEC.KeysStruct.struct_02 idxUK_Id_priv;
      private FORNEC.KeysStruct.struct_00 idxindex_0_priv;

      public FORNEC.KeysStruct.struct_01 idxindex_1
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

      public FORNEC.KeysStruct.struct_02 idxUK_Id
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

      public FORNEC.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new FORNEC.KeysStruct.struct_01();
        this.idxUK_Id_priv = new FORNEC.KeysStruct.struct_02();
        this.idxindex_0_priv = new FORNEC.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private string sgmClassificacao_priv;
        private string sgmCNPJ_priv;

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
          
          this.sgmClassificacao_priv = string.Empty;
          this.sgmCNPJ_priv = string.Empty;
        }
      }

      public class struct_01
      {
        private string sgmClassificacao_priv;
        private string sgmRazaoSocial_priv;

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
          
          this.sgmClassificacao_priv = string.Empty;
          this.sgmRazaoSocial_priv = string.Empty;
        }
      }

      public class struct_02
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

        public struct_02()
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
      UK_Id = 2,
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

    [StructLayout(LayoutKind.Sequential, Size = 277, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 48)]
      internal char[] a_004;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 48)]
      internal char[] a_052;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 9)]
      internal char[] a_100;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
      internal char[] a_109;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
      internal char[] a_134;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
      internal char[] a_136;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 21)]
      internal char[] a_137;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 19)]
      internal char[] a_158;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
      internal char[] a_177;
      internal byte a_185;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 11)]
      internal char[] a_186;
      internal byte a_197;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 19)]
      internal char[] a_198;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_217;
      internal byte a_237;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 19)]
      internal char[] a_238;
      internal byte a_257;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 19)]
      internal char[] a_258;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldId_priv;
      private string fldRazaoSocial_priv;
      private string fldEndereco_priv;
      private string fldCEP_priv;
      private string fldCidade_priv;
      private string fldEstado_priv;
      private string fldClassificacao_priv;
      private string fldCNPJ_priv;
      private string fldInscricaoEstadual_priv;
      private string fldMunicipio_priv;
      private string fldReservado2_priv;
      private string fldReservado3_priv;
      private string fldInscricaoMunicipal_priv;
      private string fldReservado5_priv;
      private string fldReservado6_priv;
      private PropertyChangedEventHandler PropertyChangedEvent;

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

      public string fldReservado2
      {
        get
        {
          return this.fldReservado2_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldReservado2_priv, value, false) == 0)
            return;
          this.fldReservado2_priv = value;
          this.OnPropertyChanged("fldReservado2");
        }
      }

      public string fldReservado3
      {
        get
        {
          return this.fldReservado3_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldReservado3_priv, value, false) == 0)
            return;
          this.fldReservado3_priv = value;
          this.OnPropertyChanged("fldReservado3");
        }
      }

      public string fldInscricaoMunicipal
      {
        get
        {
          return this.fldInscricaoMunicipal_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldInscricaoMunicipal_priv, value, false) == 0)
            return;
          this.fldInscricaoMunicipal_priv = value;
          this.OnPropertyChanged("fldInscricaoMunicipal");
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

      public string fldReservado6
      {
        get
        {
          return this.fldReservado6_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldReservado6_priv, value, false) == 0)
            return;
          this.fldReservado6_priv = value;
          this.OnPropertyChanged("fldReservado6");
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
        
        this.fldId_priv = 0;
        this.fldRazaoSocial_priv = string.Empty;
        this.fldEndereco_priv = string.Empty;
        this.fldCEP_priv = string.Empty;
        this.fldCidade_priv = string.Empty;
        this.fldEstado_priv = string.Empty;
        this.fldClassificacao_priv = string.Empty;
        this.fldCNPJ_priv = string.Empty;
        this.fldInscricaoEstadual_priv = string.Empty;
        this.fldMunicipio_priv = string.Empty;
        this.fldReservado2_priv = string.Empty;
        this.fldReservado3_priv = string.Empty;
        this.fldInscricaoMunicipal_priv = string.Empty;
        this.fldReservado5_priv = string.Empty;
        this.fldReservado6_priv = string.Empty;
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
