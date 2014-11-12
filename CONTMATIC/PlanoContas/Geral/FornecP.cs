// Type: Trial.FornecP
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: BBC9D197-4E2C-43D6-999A-8FEEEBDFAA91
// Assembly location: C:\Documents and Settings\Alessandro\Desktop\Trial.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC
{
  public class FornecP
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
    private FornecP.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private FornecP.FieldsClass pvFields;
    private FornecP.FieldsClass[] pvFieldsExtr;
    private FornecP.FieldsClass_priv pvFieldsIntern;
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

    public string fldunnamed_46
    {
      get
      {
        return this.pvFields.fldunnamed_46;
      }
      set
      {
        this.pvFields.fldunnamed_46 = value;
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

    public string fldNumero
    {
      get
      {
        return this.pvFields.fldNumero;
      }
      set
      {
        this.pvFields.fldNumero = value;
      }
    }

    public string fldComplemento
    {
      get
      {
        return this.pvFields.fldComplemento;
      }
      set
      {
        this.pvFields.fldComplemento = value;
      }
    }

    public string fldBairro
    {
      get
      {
        return this.pvFields.fldBairro;
      }
      set
      {
        this.pvFields.fldBairro = value;
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

    public string fldPais
    {
      get
      {
        return this.pvFields.fldPais;
      }
      set
      {
        this.pvFields.fldPais = value;
      }
    }

    public string fldSuframa
    {
      get
      {
        return this.pvFields.fldSuframa;
      }
      set
      {
        this.pvFields.fldSuframa = value;
      }
    }

    public string fldContaContabilF
    {
        get
        {
            return this.pvFields.fldContaContabilF;
        }
        set
        {
            this.pvFields.fldContaContabilF = value;
        }
    }

    public string fldContaContabilC
    {
      get
      {
        return this.pvFields.fldContaContabilC;
      }
      set
      {
        this.pvFields.fldContaContabilC = value;
      }
    }

    public string fldunnamed_70
    {
      get
      {
        return this.pvFields.fldunnamed_70;
      }
      set
      {
        this.pvFields.fldunnamed_70 = value;
      }
    }

    public string fldTelefone
    {
      get
      {
        return this.pvFields.fldTelefone;
      }
      set
      {
        this.pvFields.fldTelefone = value;
      }
    }

    public string fldunnamed_18
    {
      get
      {
        return this.pvFields.fldunnamed_18;
      }
      set
      {
        this.pvFields.fldunnamed_18 = value;
      }
    }

    public string fldEmailTail
    {
      get
      {
        return this.pvFields.fldEmailTail;
      }
      set
      {
        this.pvFields.fldEmailTail = value;
      }
    }

    public string fldunnamed_20
    {
      get
      {
        return this.pvFields.fldunnamed_20;
      }
      set
      {
        this.pvFields.fldunnamed_20 = value;
      }
    }

    public string fldEmail
    {
      get
      {
        return this.pvFields.fldEmail;
      }
      set
      {
        this.pvFields.fldEmail = value;
      }
    }

    public string fldunnamed_22
    {
      get
      {
        return this.pvFields.fldunnamed_22;
      }
      set
      {
        this.pvFields.fldunnamed_22 = value;
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

    public FornecP.KeysStruct Keys
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

    public FornecP.FieldsClass Fields
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

    public FornecP.FieldsClass[] Fields_ext
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

    public FornecP()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[100];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FornecP.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FornecP.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FornecP.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public FornecP(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[100];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FornecP.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FornecP.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FornecP.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public FornecP(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[100];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FornecP.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FornecP.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FornecP.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public FornecP(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[100];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "Y:\\Geral\\FornecP.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new FornecP.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new FornecP.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_0.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_0.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmIdPlano);
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_1.sgmRazaoSocial.Length < 60)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial.PadRight(60)), 0, this.pvPtr, 60);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_1.sgmRazaoSocial), 0, this.pvPtr, 60);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_1.sgmIdPlano);
      }
      else
      {
        if ((int) pKey != 2)
          return;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_2.sgmEstado.Length < 2)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmEstado.PadRight(2)), 0, this.pvPtr, 2);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmEstado), 0, this.pvPtr, 2);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 6L));
        if (this.pvKeys.idxindex_2.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.idxindex_2.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_2.sgmIdPlano);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_0.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_0.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_1.sgmRazaoSocial = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 60) : Marshal.PtrToStringAnsi(this.pvPtr, 60).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_1.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else
      {
        if ((int) pKey != 2)
          return;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_2.sgmEstado = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 2) : Marshal.PtrToStringAnsi(this.pvPtr, 2).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 6L));
        this.pvKeys.idxindex_2.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_2.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      FornecP fornecP = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (FornecP.FieldsClass_priv));
      FornecP.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv(); ;
      FornecP.FieldsClass_priv fieldsClassPriv2 = obj != null ? (FornecP.FieldsClass_priv) obj : fieldsClassPriv1;
      fornecP.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldIdPlano = this.pvFieldsIntern.a_000;
      this.pvFields.fldCNPJ = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
      this.pvFields.fldInscricaoEstadual = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_025) : new string(this.pvFieldsIntern.a_025).Trim();
      this.pvFields.fldInscricaoMunicipal = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_045) : new string(this.pvFieldsIntern.a_045).Trim();
      this.pvFields.fldunnamed_46 = new string(this.pvFieldsIntern.a_066, 0, Math.Min(19, (int) this.pvFieldsIntern.a_065));
      this.pvFields.fldRazaoSocial = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_085) : new string(this.pvFieldsIntern.a_085).Trim();
      this.pvFields.fldEndereco = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_145) : new string(this.pvFieldsIntern.a_145).Trim();
      this.pvFields.fldNumero = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_205) : new string(this.pvFieldsIntern.a_205).Trim();
      this.pvFields.fldComplemento = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_220) : new string(this.pvFieldsIntern.a_220).Trim();
      this.pvFields.fldBairro = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_245) : new string(this.pvFieldsIntern.a_245).Trim();
      this.pvFields.fldCEP = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_285) : new string(this.pvFieldsIntern.a_285).Trim();
      this.pvFields.fldMunicipio = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_294) : new string(this.pvFieldsIntern.a_294).Trim();
      this.pvFields.fldCidade = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_304) : new string(this.pvFieldsIntern.a_304).Trim();
      this.pvFields.fldEstado = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_344) : new string(this.pvFieldsIntern.a_344).Trim();
      this.pvFields.fldPais = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_346) : new string(this.pvFieldsIntern.a_346).Trim();
      this.pvFields.fldSuframa = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_354) : new string(this.pvFieldsIntern.a_354).Trim();
      this.pvFields.fldContaContabilF = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_374) : new string(this.pvFieldsIntern.a_374).Trim();
      this.pvFields.fldContaContabilC = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_399) : new string(this.pvFieldsIntern.a_399).Trim();
      this.pvFields.fldunnamed_70 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_424) : new string(this.pvFieldsIntern.a_424).Trim();
      this.pvFields.fldTelefone = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_468) : new string(this.pvFieldsIntern.a_468).Trim();
      this.pvFields.fldunnamed_18 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_478) : new string(this.pvFieldsIntern.a_478).Trim();
      this.pvFields.fldEmailTail = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_488) : new string(this.pvFieldsIntern.a_488).Trim();
      this.pvFields.fldunnamed_20 = new string(this.pvFieldsIntern.a_509, 0, Math.Min(99, (int) this.pvFieldsIntern.a_508));
      this.pvFields.fldEmail = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_608) : new string(this.pvFieldsIntern.a_608).Trim();
      this.pvFields.fldunnamed_22 = new string(this.pvFieldsIntern.a_649, 0, Math.Min(39, (int) this.pvFieldsIntern.a_648));
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldIdPlano;
      this.pvFieldsIntern.a_004 = this.pvFields.fldCNPJ.PadRight(21).ToCharArray();
      this.pvFieldsIntern.a_025 = this.pvFields.fldInscricaoEstadual.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_045 = this.pvFields.fldInscricaoMunicipal.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_065 = checked ((byte) Math.Min(this.pvFields.fldunnamed_46.Length, 19));
      this.pvFieldsIntern.a_066 = this.pvFields.fldunnamed_46.PadRight(19).ToCharArray();
      this.pvFieldsIntern.a_085 = this.pvFields.fldRazaoSocial.PadRight(60).ToCharArray();
      this.pvFieldsIntern.a_145 = this.pvFields.fldEndereco.PadRight(60).ToCharArray();
      this.pvFieldsIntern.a_205 = this.pvFields.fldNumero.PadRight(15).ToCharArray();
      this.pvFieldsIntern.a_220 = this.pvFields.fldComplemento.PadRight(25).ToCharArray();
      this.pvFieldsIntern.a_245 = this.pvFields.fldBairro.PadRight(40).ToCharArray();
      this.pvFieldsIntern.a_285 = this.pvFields.fldCEP.PadRight(9).ToCharArray();
      this.pvFieldsIntern.a_294 = this.pvFields.fldMunicipio.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_304 = this.pvFields.fldCidade.PadRight(40).ToCharArray();
      this.pvFieldsIntern.a_344 = this.pvFields.fldEstado.PadRight(2).ToCharArray();
      this.pvFieldsIntern.a_346 = this.pvFields.fldPais.PadRight(8).ToCharArray();
      this.pvFieldsIntern.a_354 = this.pvFields.fldSuframa.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_374 = this.pvFields.fldContaContabilF.PadRight(25).ToCharArray();
      this.pvFieldsIntern.a_399 = this.pvFields.fldContaContabilC.PadRight(25).ToCharArray();
      this.pvFieldsIntern.a_424 = this.pvFields.fldunnamed_70.PadRight(44).ToCharArray();
      this.pvFieldsIntern.a_468 = this.pvFields.fldTelefone.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_478 = this.pvFields.fldunnamed_18.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_488 = this.pvFields.fldEmailTail.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_508 = checked ((byte) Math.Min(this.pvFields.fldunnamed_20.Length, 99));
      this.pvFieldsIntern.a_509 = this.pvFields.fldunnamed_20.PadRight(99).ToCharArray();
      this.pvFieldsIntern.a_608 = this.pvFields.fldEmail.PadRight(40).ToCharArray();
      this.pvFieldsIntern.a_648 = checked ((byte) Math.Min(this.pvFields.fldunnamed_22.Length, 39));
      this.pvFieldsIntern.a_649 = this.pvFields.fldunnamed_22.PadRight(39).ToCharArray();
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
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldCNPJ.PadRight(21).ToCharArray();
        this.pvFieldsIntern.a_025 = this.pvFieldsExtr[index].fldInscricaoEstadual.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_045 = this.pvFieldsExtr[index].fldInscricaoMunicipal.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_065 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_46.Length, 19));
        this.pvFieldsIntern.a_066 = this.pvFieldsExtr[index].fldunnamed_46.PadRight(19).ToCharArray();
        this.pvFieldsIntern.a_085 = this.pvFieldsExtr[index].fldRazaoSocial.PadRight(60).ToCharArray();
        this.pvFieldsIntern.a_145 = this.pvFieldsExtr[index].fldEndereco.PadRight(60).ToCharArray();
        this.pvFieldsIntern.a_205 = this.pvFieldsExtr[index].fldNumero.PadRight(15).ToCharArray();
        this.pvFieldsIntern.a_220 = this.pvFieldsExtr[index].fldComplemento.PadRight(25).ToCharArray();
        this.pvFieldsIntern.a_245 = this.pvFieldsExtr[index].fldBairro.PadRight(40).ToCharArray();
        this.pvFieldsIntern.a_285 = this.pvFieldsExtr[index].fldCEP.PadRight(9).ToCharArray();
        this.pvFieldsIntern.a_294 = this.pvFieldsExtr[index].fldMunicipio.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_304 = this.pvFieldsExtr[index].fldCidade.PadRight(40).ToCharArray();
        this.pvFieldsIntern.a_344 = this.pvFieldsExtr[index].fldEstado.PadRight(2).ToCharArray();
        this.pvFieldsIntern.a_346 = this.pvFieldsExtr[index].fldPais.PadRight(8).ToCharArray();
        this.pvFieldsIntern.a_354 = this.pvFieldsExtr[index].fldSuframa.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_374 = this.pvFieldsExtr[index].fldContaContabilF.PadRight(25).ToCharArray();
        this.pvFieldsIntern.a_399 = this.pvFieldsExtr[index].fldContaContabilC.PadRight(25).ToCharArray();
        this.pvFieldsIntern.a_424 = this.pvFieldsExtr[index].fldunnamed_70.PadRight(44).ToCharArray();
        this.pvFieldsIntern.a_468 = this.pvFieldsExtr[index].fldTelefone.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_478 = this.pvFieldsExtr[index].fldunnamed_18.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_488 = this.pvFieldsExtr[index].fldEmailTail.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_508 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_20.Length, 99));
        this.pvFieldsIntern.a_509 = this.pvFieldsExtr[index].fldunnamed_20.PadRight(99).ToCharArray();
        this.pvFieldsIntern.a_608 = this.pvFieldsExtr[index].fldEmail.PadRight(40).ToCharArray();
        this.pvFieldsIntern.a_648 = checked ((byte) Math.Min(this.pvFieldsExtr[index].fldunnamed_22.Length, 39));
        this.pvFieldsIntern.a_649 = this.pvFieldsExtr[index].fldunnamed_22.PadRight(39).ToCharArray();
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 688);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 688));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(FornecP.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(FornecP.OpenModes Mode)
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

    public virtual short btrInsert(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 688;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(FornecP.KeyName Key_nr)
    {
      short num1 = (short) 688;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 688;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(FornecP.KeyName Key_nr)
    {
      short num1 = (short) 688;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(FornecP.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetNext(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetNext(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetNext(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FornecP.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetNext(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetNext(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(FornecP.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(FornecP.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetGreater(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetGreaterThanOrEqual(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(FornecP.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetGreaterThanOrEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLessThan(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(FornecP.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLessThan(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLessThanOrEqual(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(FornecP.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLessThanOrEqual(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetFirst(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(FornecP.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetFirst(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLast(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(FornecP.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
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

    public virtual short btrGetLast(FornecP.KeyName Key_nr, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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
      short num1 = (short) 688;
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

    public virtual short btrGetDirectRecord(FornecP.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(FornecP.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(FornecP.KeyName Key_nr, IntPtr Position, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(FornecP.KeyName Key_nr, IntPtr Position, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
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
      return this.btrStepNext(FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(FornecP.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(FornecP.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(FornecP.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (690 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(FornecP.KeyName Key_nr)
    {
      short num1 = checked ((short) (690 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= FornecP.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(FornecP.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FornecP.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(FornecP.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, FornecP.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(FornecP.KeyName Key_nr, short Percentage, FornecP.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(FornecP.KeyName Key_nr, short Percentage, FornecP.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 688;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(FornecP.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(FornecP.KeyName Key_nr, ref short Percentage)
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
      private FornecP.KeysStruct.struct_01 idxindex_1_priv;
      private FornecP.KeysStruct.struct_02 idxindex_2_priv;
      private FornecP.KeysStruct.struct_00 idxindex_0_priv;

      public FornecP.KeysStruct.struct_01 idxindex_1
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

      public FornecP.KeysStruct.struct_02 idxindex_2
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

      public FornecP.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new FornecP.KeysStruct.struct_01();
        this.idxindex_2_priv = new FornecP.KeysStruct.struct_02();
        this.idxindex_0_priv = new FornecP.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private int sgmIdPlano_priv;
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
          this.sgmCNPJ_priv = string.Empty;
        }
      }

      public class struct_01
      {
        private int sgmIdPlano_priv;
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
          this.sgmRazaoSocial_priv = string.Empty;
        }
      }

      public class struct_02
      {
        private int sgmIdPlano_priv;
        private string sgmEstado_priv;
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

        public string sgmEstado
        {
          get
          {
            return this.sgmEstado_priv;
          }
          set
          {
            this.sgmEstado_priv = value;
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

        public struct_02()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmEstado_priv = string.Empty;
          this.sgmCNPJ_priv = string.Empty;
        }
      }
    }

    public enum KeyName
    {
      NoCurrencyChange = -1,
      index_0 = 0,
      index_1 = 1,
      index_2 = 2,
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

    [StructLayout(LayoutKind.Sequential, Size = 688, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 21)]
      internal char[] a_004;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_025;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_045;
      internal byte a_065;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 19)]
      internal char[] a_066;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
      internal char[] a_085;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
      internal char[] a_145;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 15)]
      internal char[] a_205;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
      internal char[] a_220;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_245;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 9)]
      internal char[] a_285;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_294;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_304;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
      internal char[] a_344;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
      internal char[] a_346;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_354;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
      internal char[] a_374;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 25)]
      internal char[] a_399;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 44)]
      internal char[] a_424;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_468;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_478;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_488;
      internal byte a_508;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 99)]
      internal char[] a_509;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_608;
      internal byte a_648;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 39)]
      internal char[] a_649;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldIdPlano_priv;
      private string fldCNPJ_priv;
      private string fldInscricaoEstadual_priv;
      private string fldInscricaoMunicipal_priv;
      private string fldunnamed_46_priv;
      private string fldRazaoSocial_priv;
      private string fldEndereco_priv;
      private string fldNumero_priv;
      private string fldComplemento_priv;
      private string fldBairro_priv;
      private string fldCEP_priv;
      private string fldMunicipio_priv;
      private string fldCidade_priv;
      private string fldEstado_priv;
      private string fldPais_priv;
      private string fldSuframa_priv;
      private string fldContaContabilF_priv;
      private string fldContaContabilC_priv;
      private string fldunnamed_70_priv;
      private string fldTelefone_priv;
      private string fldunnamed_18_priv;
      private string fldEmailTail_priv;
      private string fldunnamed_20_priv;
      private string fldEmail_priv;
      private string fldunnamed_22_priv;
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

      public string fldunnamed_46
      {
        get
        {
          return this.fldunnamed_46_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_46_priv, value, false) == 0)
            return;
          this.fldunnamed_46_priv = value;
          this.OnPropertyChanged("fldunnamed_46");
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

      public string fldNumero
      {
        get
        {
          return this.fldNumero_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldNumero_priv, value, false) == 0)
            return;
          this.fldNumero_priv = value;
          this.OnPropertyChanged("fldNumero");
        }
      }

      public string fldComplemento
      {
        get
        {
          return this.fldComplemento_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldComplemento_priv, value, false) == 0)
            return;
          this.fldComplemento_priv = value;
          this.OnPropertyChanged("fldComplemento");
        }
      }

      public string fldBairro
      {
        get
        {
          return this.fldBairro_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldBairro_priv, value, false) == 0)
            return;
          this.fldBairro_priv = value;
          this.OnPropertyChanged("fldBairro");
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

      public string fldPais
      {
        get
        {
          return this.fldPais_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldPais_priv, value, false) == 0)
            return;
          this.fldPais_priv = value;
          this.OnPropertyChanged("fldPais");
        }
      }

      public string fldSuframa
      {
        get
        {
          return this.fldSuframa_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldSuframa_priv, value, false) == 0)
            return;
          this.fldSuframa_priv = value;
          this.OnPropertyChanged("fldSuframa");
        }
      }

      public string fldContaContabilF
      {
        get
        {
          return this.fldContaContabilF_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldContaContabilF_priv, value, false) == 0)
            return;
          this.fldContaContabilF_priv = value;
          this.OnPropertyChanged("fldContaContabilF");
        }
      }

      public string fldContaContabilC
      {
          get
          {
              return this.fldContaContabilC_priv;
          }
          set
          {
              if (Operators.CompareString(this.fldContaContabilC_priv, value, false) == 0)
                  return;
              this.fldContaContabilC_priv = value;
              this.OnPropertyChanged("fldContaContabilC");
          }
      }

      public string fldunnamed_70
      {
        get
        {
          return this.fldunnamed_70_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_70_priv, value, false) == 0)
            return;
          this.fldunnamed_70_priv = value;
          this.OnPropertyChanged("fldunnamed_70");
        }
      }

      public string fldTelefone
      {
        get
        {
          return this.fldTelefone_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldTelefone_priv, value, false) == 0)
            return;
          this.fldTelefone_priv = value;
          this.OnPropertyChanged("fldTelefone");
        }
      }

      public string fldunnamed_18
      {
        get
        {
          return this.fldunnamed_18_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_18_priv, value, false) == 0)
            return;
          this.fldunnamed_18_priv = value;
          this.OnPropertyChanged("fldunnamed_18");
        }
      }

      public string fldEmailTail
      {
        get
        {
          return this.fldEmailTail_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEmailTail_priv, value, false) == 0)
            return;
          this.fldEmailTail_priv = value;
          this.OnPropertyChanged("fldEmailTail");
        }
      }

      public string fldunnamed_20
      {
        get
        {
          return this.fldunnamed_20_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_20_priv, value, false) == 0)
            return;
          this.fldunnamed_20_priv = value;
          this.OnPropertyChanged("fldunnamed_20");
        }
      }

      public string fldEmail
      {
        get
        {
          return this.fldEmail_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEmail_priv, value, false) == 0)
            return;
          this.fldEmail_priv = value;
          this.OnPropertyChanged("fldEmail");
        }
      }

      public string fldunnamed_22
      {
        get
        {
          return this.fldunnamed_22_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_22_priv, value, false) == 0)
            return;
          this.fldunnamed_22_priv = value;
          this.OnPropertyChanged("fldunnamed_22");
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
        this.fldCNPJ_priv = string.Empty;
        this.fldInscricaoEstadual_priv = string.Empty;
        this.fldInscricaoMunicipal_priv = string.Empty;
        this.fldunnamed_46_priv = string.Empty;
        this.fldRazaoSocial_priv = string.Empty;
        this.fldEndereco_priv = string.Empty;
        this.fldNumero_priv = string.Empty;
        this.fldComplemento_priv = string.Empty;
        this.fldBairro_priv = string.Empty;
        this.fldCEP_priv = string.Empty;
        this.fldMunicipio_priv = string.Empty;
        this.fldCidade_priv = string.Empty;
        this.fldEstado_priv = string.Empty;
        this.fldPais_priv = string.Empty;
        this.fldSuframa_priv = string.Empty;
        this.fldContaContabilF_priv = string.Empty;
        this.fldContaContabilC_priv = string.Empty;
        this.fldunnamed_70_priv = string.Empty;
        this.fldTelefone_priv = string.Empty;
        this.fldunnamed_18_priv = string.Empty;
        this.fldEmailTail_priv = string.Empty;
        this.fldunnamed_20_priv = string.Empty;
        this.fldEmail_priv = string.Empty;
        this.fldunnamed_22_priv = string.Empty;
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
