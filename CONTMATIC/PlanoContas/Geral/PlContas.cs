﻿// Type: Trial.PlContas
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 8CC272E9-BB1F-459C-85D5-8D46724B7E17
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
  public class PlContas
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
    private PlContas.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private PlContas.FieldsClass pvFields;
    private PlContas.FieldsClass[] pvFieldsExtr;
    private PlContas.FieldsClass_priv pvFieldsIntern;
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

    public string fldDescricao
    {
      get
      {
        return this.pvFields.fldDescricao;
      }
      set
      {
        this.pvFields.fldDescricao = value;
      }
    }

    public int fldReduzida
    {
      get
      {
        return this.pvFields.fldReduzida;
      }
      set
      {
        this.pvFields.fldReduzida = value;
      }
    }

    public byte fldNivel
    {
      get
      {
        return this.pvFields.fldNivel;
      }
      set
      {
        this.pvFields.fldNivel = value;
      }
    }

    public short fldunnamed_10
    {
      get
      {
        return this.pvFields.fldunnamed_10;
      }
      set
      {
        this.pvFields.fldunnamed_10 = value;
      }
    }

    public string fldCodigoCC1
    {
      get
      {
        return this.pvFields.fldCodigoCC1;
      }
      set
      {
        this.pvFields.fldCodigoCC1 = value;
      }
    }

    public double fldPercentualCC1
    {
      get
      {
        return this.pvFields.fldPercentualCC1;
      }
      set
      {
        this.pvFields.fldPercentualCC1 = value;
      }
    }

    public string fldCodigoCC2
    {
      get
      {
        return this.pvFields.fldCodigoCC2;
      }
      set
      {
        this.pvFields.fldCodigoCC2 = value;
      }
    }

    public double fldPercentualCC2
    {
      get
      {
        return this.pvFields.fldPercentualCC2;
      }
      set
      {
        this.pvFields.fldPercentualCC2 = value;
      }
    }

    public string fldCodigoCC3
    {
      get
      {
        return this.pvFields.fldCodigoCC3;
      }
      set
      {
        this.pvFields.fldCodigoCC3 = value;
      }
    }

    public double fldPercentualCC3
    {
      get
      {
        return this.pvFields.fldPercentualCC3;
      }
      set
      {
        this.pvFields.fldPercentualCC3 = value;
      }
    }

    public string fldCodigoCC4
    {
      get
      {
        return this.pvFields.fldCodigoCC4;
      }
      set
      {
        this.pvFields.fldCodigoCC4 = value;
      }
    }

    public double fldPercentualCC4
    {
      get
      {
        return this.pvFields.fldPercentualCC4;
      }
      set
      {
        this.pvFields.fldPercentualCC4 = value;
      }
    }

    public string fldCodigoCC5
    {
      get
      {
        return this.pvFields.fldCodigoCC5;
      }
      set
      {
        this.pvFields.fldCodigoCC5 = value;
      }
    }

    public double fldPercentualCC5
    {
      get
      {
        return this.pvFields.fldPercentualCC5;
      }
      set
      {
        this.pvFields.fldPercentualCC5 = value;
      }
    }

    public string fldCodigoCC6
    {
      get
      {
        return this.pvFields.fldCodigoCC6;
      }
      set
      {
        this.pvFields.fldCodigoCC6 = value;
      }
    }

    public double fldPercentualCC6
    {
      get
      {
        return this.pvFields.fldPercentualCC6;
      }
      set
      {
        this.pvFields.fldPercentualCC6 = value;
      }
    }

    public string fldCodigoCC7
    {
      get
      {
        return this.pvFields.fldCodigoCC7;
      }
      set
      {
        this.pvFields.fldCodigoCC7 = value;
      }
    }

    public double fldPercentualCC7
    {
      get
      {
        return this.pvFields.fldPercentualCC7;
      }
      set
      {
        this.pvFields.fldPercentualCC7 = value;
      }
    }

    public string fldCodigoCC8
    {
      get
      {
        return this.pvFields.fldCodigoCC8;
      }
      set
      {
        this.pvFields.fldCodigoCC8 = value;
      }
    }

    public double fldPercentualCC8
    {
      get
      {
        return this.pvFields.fldPercentualCC8;
      }
      set
      {
        this.pvFields.fldPercentualCC8 = value;
      }
    }

    public string fldCodigoCC9
    {
      get
      {
        return this.pvFields.fldCodigoCC9;
      }
      set
      {
        this.pvFields.fldCodigoCC9 = value;
      }
    }

    public double fldPercentualCC9
    {
      get
      {
        return this.pvFields.fldPercentualCC9;
      }
      set
      {
        this.pvFields.fldPercentualCC9 = value;
      }
    }

    public string fldCodigoCC10
    {
      get
      {
        return this.pvFields.fldCodigoCC10;
      }
      set
      {
        this.pvFields.fldCodigoCC10 = value;
      }
    }

    public double fldPercentualCC10
    {
      get
      {
        return this.pvFields.fldPercentualCC10;
      }
      set
      {
        this.pvFields.fldPercentualCC10 = value;
      }
    }

    public string fldCodigoCC11
    {
      get
      {
        return this.pvFields.fldCodigoCC11;
      }
      set
      {
        this.pvFields.fldCodigoCC11 = value;
      }
    }

    public double fldPercentualCC11
    {
      get
      {
        return this.pvFields.fldPercentualCC11;
      }
      set
      {
        this.pvFields.fldPercentualCC11 = value;
      }
    }

    public string fldCodigoCC12
    {
      get
      {
        return this.pvFields.fldCodigoCC12;
      }
      set
      {
        this.pvFields.fldCodigoCC12 = value;
      }
    }

    public double fldPercentualCC12
    {
      get
      {
        return this.pvFields.fldPercentualCC12;
      }
      set
      {
        this.pvFields.fldPercentualCC12 = value;
      }
    }

    public string fldCodigoCC13
    {
      get
      {
        return this.pvFields.fldCodigoCC13;
      }
      set
      {
        this.pvFields.fldCodigoCC13 = value;
      }
    }

    public double fldPercentualCC13
    {
      get
      {
        return this.pvFields.fldPercentualCC13;
      }
      set
      {
        this.pvFields.fldPercentualCC13 = value;
      }
    }

    public string fldCodigoCC14
    {
      get
      {
        return this.pvFields.fldCodigoCC14;
      }
      set
      {
        this.pvFields.fldCodigoCC14 = value;
      }
    }

    public double fldPercentualCC14
    {
      get
      {
        return this.pvFields.fldPercentualCC14;
      }
      set
      {
        this.pvFields.fldPercentualCC14 = value;
      }
    }

    public string fldCodigoCC15
    {
      get
      {
        return this.pvFields.fldCodigoCC15;
      }
      set
      {
        this.pvFields.fldCodigoCC15 = value;
      }
    }

    public double fldPercentualCC15
    {
      get
      {
        return this.pvFields.fldPercentualCC15;
      }
      set
      {
        this.pvFields.fldPercentualCC15 = value;
      }
    }

    public string fldCodigoCC16
    {
      get
      {
        return this.pvFields.fldCodigoCC16;
      }
      set
      {
        this.pvFields.fldCodigoCC16 = value;
      }
    }

    public double fldPercentualCC16
    {
      get
      {
        return this.pvFields.fldPercentualCC16;
      }
      set
      {
        this.pvFields.fldPercentualCC16 = value;
      }
    }

    public string fldCodigoCC17
    {
      get
      {
        return this.pvFields.fldCodigoCC17;
      }
      set
      {
        this.pvFields.fldCodigoCC17 = value;
      }
    }

    public double fldPercentualCC17
    {
      get
      {
        return this.pvFields.fldPercentualCC17;
      }
      set
      {
        this.pvFields.fldPercentualCC17 = value;
      }
    }

    public string fldCodigoCC18
    {
      get
      {
        return this.pvFields.fldCodigoCC18;
      }
      set
      {
        this.pvFields.fldCodigoCC18 = value;
      }
    }

    public double fldPercentualCC18
    {
      get
      {
        return this.pvFields.fldPercentualCC18;
      }
      set
      {
        this.pvFields.fldPercentualCC18 = value;
      }
    }

    public string fldCodigoCC19
    {
      get
      {
        return this.pvFields.fldCodigoCC19;
      }
      set
      {
        this.pvFields.fldCodigoCC19 = value;
      }
    }

    public double fldPercentualCC19
    {
      get
      {
        return this.pvFields.fldPercentualCC19;
      }
      set
      {
        this.pvFields.fldPercentualCC19 = value;
      }
    }

    public string fldCodigoCC20
    {
      get
      {
        return this.pvFields.fldCodigoCC20;
      }
      set
      {
        this.pvFields.fldCodigoCC20 = value;
      }
    }

    public double fldPercentualCC20
    {
      get
      {
        return this.pvFields.fldPercentualCC20;
      }
      set
      {
        this.pvFields.fldPercentualCC20 = value;
      }
    }

    public string fldCodigoCC21
    {
      get
      {
        return this.pvFields.fldCodigoCC21;
      }
      set
      {
        this.pvFields.fldCodigoCC21 = value;
      }
    }

    public double fldPercentualCC21
    {
      get
      {
        return this.pvFields.fldPercentualCC21;
      }
      set
      {
        this.pvFields.fldPercentualCC21 = value;
      }
    }

    public string fldCodigoCC22
    {
      get
      {
        return this.pvFields.fldCodigoCC22;
      }
      set
      {
        this.pvFields.fldCodigoCC22 = value;
      }
    }

    public double fldPercentualCC22
    {
      get
      {
        return this.pvFields.fldPercentualCC22;
      }
      set
      {
        this.pvFields.fldPercentualCC22 = value;
      }
    }

    public string fldCodigoCC23
    {
      get
      {
        return this.pvFields.fldCodigoCC23;
      }
      set
      {
        this.pvFields.fldCodigoCC23 = value;
      }
    }

    public double fldPercentualCC23
    {
      get
      {
        return this.pvFields.fldPercentualCC23;
      }
      set
      {
        this.pvFields.fldPercentualCC23 = value;
      }
    }

    public string fldCodigoCC24
    {
      get
      {
        return this.pvFields.fldCodigoCC24;
      }
      set
      {
        this.pvFields.fldCodigoCC24 = value;
      }
    }

    public double fldPercentualCC24
    {
      get
      {
        return this.pvFields.fldPercentualCC24;
      }
      set
      {
        this.pvFields.fldPercentualCC24 = value;
      }
    }

    public string fldCodigoCC25
    {
      get
      {
        return this.pvFields.fldCodigoCC25;
      }
      set
      {
        this.pvFields.fldCodigoCC25 = value;
      }
    }

    public double fldPercentualCC25
    {
      get
      {
        return this.pvFields.fldPercentualCC25;
      }
      set
      {
        this.pvFields.fldPercentualCC25 = value;
      }
    }

    public int fldReservado1
    {
      get
      {
        return this.pvFields.fldReservado1;
      }
      set
      {
        this.pvFields.fldReservado1 = value;
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

    public int fldConciliacao
    {
      get
      {
        return this.pvFields.fldConciliacao;
      }
      set
      {
        this.pvFields.fldConciliacao = value;
      }
    }

    public string fldunnamed_55
    {
      get
      {
        return this.pvFields.fldunnamed_55;
      }
      set
      {
        this.pvFields.fldunnamed_55 = value;
      }
    }

    public string fldunnamed_60
    {
      get
      {
        return this.pvFields.fldunnamed_60;
      }
      set
      {
        this.pvFields.fldunnamed_60 = value;
      }
    }

    public string fldunnamed_61
    {
      get
      {
        return this.pvFields.fldunnamed_61;
      }
      set
      {
        this.pvFields.fldunnamed_61 = value;
      }
    }

    public string fldunnamed_62
    {
      get
      {
        return this.pvFields.fldunnamed_62;
      }
      set
      {
        this.pvFields.fldunnamed_62 = value;
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

    public PlContas.KeysStruct Keys
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

    public PlContas.FieldsClass Fields
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

    public PlContas.FieldsClass[] Fields_ext
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

    public PlContas()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[60];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\Geral\\PlContas.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new PlContas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new PlContas.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public PlContas(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[60];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\Geral\\PlContas.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new PlContas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new PlContas.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public PlContas(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[60];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\Geral\\PlContas.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new PlContas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new PlContas.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public PlContas(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[60];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\Geral\\PlContas.Btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new PlContas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new PlContas.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_0.sgmConta.Length < 56)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmConta.PadRight(56)), 0, this.pvPtr, 56);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmConta), 0, this.pvPtr, 56);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmIdPlano);
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 4L));
        if (this.pvKeys.idxindex_1.sgmDescricao.Length < 40)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmDescricao.PadRight(40)), 0, this.pvPtr, 40);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmDescricao), 0, this.pvPtr, 40);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_1.sgmIdPlano);
      }
      else if ((int) pKey == 2)
      {
        Translate.Cmmn_WriteInt32(pPtr, 4, this.pvKeys.idxindex_2.sgmReduzida);
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_2.sgmIdPlano);
      }
      else if ((int) pKey == 3)
      {
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_3.sgmIdPlano);
      }
      else
      {
        if ((int) pKey != 4)
          return;
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_0.sgmConta = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 56) : Marshal.PtrToStringAnsi(this.pvPtr, 56).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_0.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else if ((int) pKey == 1)
      {
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 4L));
        this.pvKeys.idxindex_1.sgmDescricao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 40) : Marshal.PtrToStringAnsi(this.pvPtr, 40).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_1.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else if ((int) pKey == 2)
      {
        this.pvKeys.idxindex_2.sgmReduzida = Translate.Cmmn_ReadInt32(pPtr4, 4);
        this.pvKeys.idxindex_2.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else if ((int) pKey == 3)
      {
        this.pvKeys.idxindex_3.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
      else
      {
        if ((int) pKey != 4)
          return;
        this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {

      PlContas plContas = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (PlContas.FieldsClass_priv));
      PlContas.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      PlContas.FieldsClass_priv fieldsClassPriv2 = obj != null ? (PlContas.FieldsClass_priv) obj : fieldsClassPriv1;
      plContas.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldIdPlano = this.pvFieldsIntern.a_000;
      this.pvFields.fldConta = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
      this.pvFields.fldDescricao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_060) : new string(this.pvFieldsIntern.a_060).Trim();
      this.pvFields.fldReduzida = this.pvFieldsIntern.a_100;
      this.pvFields.fldNivel = this.pvFieldsIntern.a_104;
      this.pvFields.fldunnamed_10 = this.pvFieldsIntern.a_105;
      this.pvFields.fldCodigoCC1 = this.pvFieldsIntern.a_107;
      this.pvFields.fldPercentualCC1 = this.pvFieldsIntern.a_149;
      this.pvFields.fldCodigoCC2 = this.pvFieldsIntern.a_157;
      this.pvFields.fldPercentualCC2 = this.pvFieldsIntern.a_199;
      this.pvFields.fldCodigoCC3 = this.pvFieldsIntern.a_207;
      this.pvFields.fldPercentualCC3 = this.pvFieldsIntern.a_249;
      this.pvFields.fldCodigoCC4 = this.pvFieldsIntern.a_257;
      this.pvFields.fldPercentualCC4 = this.pvFieldsIntern.a_299;
      this.pvFields.fldCodigoCC5 = this.pvFieldsIntern.a_307;
      this.pvFields.fldPercentualCC5 = this.pvFieldsIntern.a_349;
      this.pvFields.fldCodigoCC6 = this.pvFieldsIntern.a_357;
      this.pvFields.fldPercentualCC6 = this.pvFieldsIntern.a_399;
      this.pvFields.fldCodigoCC7 = this.pvFieldsIntern.a_407;
      this.pvFields.fldPercentualCC7 = this.pvFieldsIntern.a_449;
      this.pvFields.fldCodigoCC8 = this.pvFieldsIntern.a_457;
      this.pvFields.fldPercentualCC8 = this.pvFieldsIntern.a_499;
      this.pvFields.fldCodigoCC9 = this.pvFieldsIntern.a_507;
      this.pvFields.fldPercentualCC9 = this.pvFieldsIntern.a_549;
      this.pvFields.fldCodigoCC10 = this.pvFieldsIntern.a_557;
      this.pvFields.fldPercentualCC10 = this.pvFieldsIntern.a_599;
      this.pvFields.fldCodigoCC11 = this.pvFieldsIntern.a_607;
      this.pvFields.fldPercentualCC11 = this.pvFieldsIntern.a_649;
      this.pvFields.fldCodigoCC12 = this.pvFieldsIntern.a_657;
      this.pvFields.fldPercentualCC12 = this.pvFieldsIntern.a_699;
      this.pvFields.fldCodigoCC13 = this.pvFieldsIntern.a_707;
      this.pvFields.fldPercentualCC13 = this.pvFieldsIntern.a_749;
      this.pvFields.fldCodigoCC14 = this.pvFieldsIntern.a_757;
      this.pvFields.fldPercentualCC14 = this.pvFieldsIntern.a_799;
      this.pvFields.fldCodigoCC15 = this.pvFieldsIntern.a_807;
      this.pvFields.fldPercentualCC15 = this.pvFieldsIntern.a_849;
      this.pvFields.fldCodigoCC16 = this.pvFieldsIntern.a_857;
      this.pvFields.fldPercentualCC16 = this.pvFieldsIntern.a_899;
      this.pvFields.fldCodigoCC17 = this.pvFieldsIntern.a_907;
      this.pvFields.fldPercentualCC17 = this.pvFieldsIntern.a_949;
      this.pvFields.fldCodigoCC18 = this.pvFieldsIntern.a_957;
      this.pvFields.fldPercentualCC18 = this.pvFieldsIntern.a_999;
      this.pvFields.fldCodigoCC19 = this.pvFieldsIntern.a_1007;
      this.pvFields.fldPercentualCC19 = this.pvFieldsIntern.a_1049;
      this.pvFields.fldCodigoCC20 = this.pvFieldsIntern.a_1057;
      this.pvFields.fldPercentualCC20 = this.pvFieldsIntern.a_1099;
      this.pvFields.fldCodigoCC21 = this.pvFieldsIntern.a_1107;
      this.pvFields.fldPercentualCC21 = this.pvFieldsIntern.a_1149;
      this.pvFields.fldCodigoCC22 = this.pvFieldsIntern.a_1157;
      this.pvFields.fldPercentualCC22 = this.pvFieldsIntern.a_1199;
      this.pvFields.fldCodigoCC23 = this.pvFieldsIntern.a_1207;
      this.pvFields.fldPercentualCC23 = this.pvFieldsIntern.a_1249;
      this.pvFields.fldCodigoCC24 = this.pvFieldsIntern.a_1257;
      this.pvFields.fldPercentualCC24 = this.pvFieldsIntern.a_1299;
      this.pvFields.fldCodigoCC25 = this.pvFieldsIntern.a_1307;
      this.pvFields.fldPercentualCC25 = this.pvFieldsIntern.a_1349;
      this.pvFields.fldReservado1 = this.pvFieldsIntern.a_1357;
      this.pvFields.fldId = this.pvFieldsIntern.a_1361;
      this.pvFields.fldConciliacao = this.pvFieldsIntern.a_1365;
      this.pvFields.fldunnamed_55 = this.pvFieldsIntern.a_1369;
      this.pvFields.fldunnamed_60 = this.pvFieldsIntern.a_1389;
      this.pvFields.fldunnamed_61 = this.pvFieldsIntern.a_1449;
      this.pvFields.fldunnamed_62 = this.pvFieldsIntern.a_1505;
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
        Encoding oem = Encoding.GetEncoding(CultureInfo.CurrentCulture.TextInfo.OEMCodePage);
        Encoding ansi = System.Text.Encoding.Default; // Encoding.GetEncoding(1252); // Encoding.GetEncoding(1252); // Encoding.GetEncoding("iso-8859-1");
        //Encoding ansi = System.Text.Encoding.Unicode;
        //Encoding oem = Encoding.UTF8; // Encoding.GetEncoding(CultureInfo.CurrentCulture.TextInfo.OEMCodePage); // Encoding.UTF8; // Encoding.GetEncoding(850); // Encoding.GetEncoding("us-ascii");

        byte[] ansiBytes = ansi.GetBytes(this.pvFields.fldDescricao.PadRight(40));
        byte[] oemBytes = Encoding.Convert(ansi, oem, ansiBytes);
        //byte[] oemBytes = Encoding.UTF8.GetBytes(this.pvFields.fldDescricao.PadRight(40));
        this.pvFieldsIntern.a_060 = oem.GetString(oemBytes).ToCharArray();
        //oem.GetBytes(this.pvFields.fldDescricao.PadRight(40).Substring(0, 40)).CopyTo(this.pvFieldsIntern.a_060, 0);
      this.pvFieldsIntern.a_000 = this.pvFields.fldIdPlano;
      this.pvFieldsIntern.a_004 = this.pvFields.fldConta.PadRight(56).ToCharArray();
      //byte[] descricao =  Encoding.Convert(ansi, oem, ansi.GetBytes(this.pvFields.fldDescricao.PadRight(40).Substring(0, 40)));
      //for (int i = 0; i < this.pvFieldsIntern.a_060.Length; i++)
      //    this.pvFieldsIntern.a_060[i] = (char)descricao[i];

      //oem.GetBytes(this.pvFields.fldDescricao.PadRight(40).Substring(0, 40)).CopyTo(this.pvFieldsIntern.a_060, 0);
      //this.pvFieldsIntern.a_060 = oem.GetBytes(this.pvFields.fldDescricao.PadRight(40)).ToString().ToCharArray();
      this.pvFieldsIntern.a_100 = this.pvFields.fldReduzida;
      this.pvFieldsIntern.a_104 = this.pvFields.fldNivel;
      this.pvFieldsIntern.a_105 = this.pvFields.fldunnamed_10;
      this.pvFieldsIntern.a_107 = this.pvFields.fldCodigoCC1;
      this.pvFieldsIntern.a_149 = this.pvFields.fldPercentualCC1;
      this.pvFieldsIntern.a_157 = this.pvFields.fldCodigoCC2;
      this.pvFieldsIntern.a_199 = this.pvFields.fldPercentualCC2;
      this.pvFieldsIntern.a_207 = this.pvFields.fldCodigoCC3;
      this.pvFieldsIntern.a_249 = this.pvFields.fldPercentualCC3;
      this.pvFieldsIntern.a_257 = this.pvFields.fldCodigoCC4;
      this.pvFieldsIntern.a_299 = this.pvFields.fldPercentualCC4;
      this.pvFieldsIntern.a_307 = this.pvFields.fldCodigoCC5;
      this.pvFieldsIntern.a_349 = this.pvFields.fldPercentualCC5;
      this.pvFieldsIntern.a_357 = this.pvFields.fldCodigoCC6;
      this.pvFieldsIntern.a_399 = this.pvFields.fldPercentualCC6;
      this.pvFieldsIntern.a_407 = this.pvFields.fldCodigoCC7;
      this.pvFieldsIntern.a_449 = this.pvFields.fldPercentualCC7;
      this.pvFieldsIntern.a_457 = this.pvFields.fldCodigoCC8;
      this.pvFieldsIntern.a_499 = this.pvFields.fldPercentualCC8;
      this.pvFieldsIntern.a_507 = this.pvFields.fldCodigoCC9;
      this.pvFieldsIntern.a_549 = this.pvFields.fldPercentualCC9;
      this.pvFieldsIntern.a_557 = this.pvFields.fldCodigoCC10;
      this.pvFieldsIntern.a_599 = this.pvFields.fldPercentualCC10;
      this.pvFieldsIntern.a_607 = this.pvFields.fldCodigoCC11;
      this.pvFieldsIntern.a_649 = this.pvFields.fldPercentualCC11;
      this.pvFieldsIntern.a_657 = this.pvFields.fldCodigoCC12;
      this.pvFieldsIntern.a_699 = this.pvFields.fldPercentualCC12;
      this.pvFieldsIntern.a_707 = this.pvFields.fldCodigoCC13;
      this.pvFieldsIntern.a_749 = this.pvFields.fldPercentualCC13;
      this.pvFieldsIntern.a_757 = this.pvFields.fldCodigoCC14;
      this.pvFieldsIntern.a_799 = this.pvFields.fldPercentualCC14;
      this.pvFieldsIntern.a_807 = this.pvFields.fldCodigoCC15;
      this.pvFieldsIntern.a_849 = this.pvFields.fldPercentualCC15;
      this.pvFieldsIntern.a_857 = this.pvFields.fldCodigoCC16;
      this.pvFieldsIntern.a_899 = this.pvFields.fldPercentualCC16;
      this.pvFieldsIntern.a_907 = this.pvFields.fldCodigoCC17;
      this.pvFieldsIntern.a_949 = this.pvFields.fldPercentualCC17;
      this.pvFieldsIntern.a_957 = this.pvFields.fldCodigoCC18;
      this.pvFieldsIntern.a_999 = this.pvFields.fldPercentualCC18;
      this.pvFieldsIntern.a_1007 = this.pvFields.fldCodigoCC19;
      this.pvFieldsIntern.a_1049 = this.pvFields.fldPercentualCC19;
      this.pvFieldsIntern.a_1057 = this.pvFields.fldCodigoCC20;
      this.pvFieldsIntern.a_1099 = this.pvFields.fldPercentualCC20;
      this.pvFieldsIntern.a_1107 = this.pvFields.fldCodigoCC21;
      this.pvFieldsIntern.a_1149 = this.pvFields.fldPercentualCC21;
      this.pvFieldsIntern.a_1157 = this.pvFields.fldCodigoCC22;
      this.pvFieldsIntern.a_1199 = this.pvFields.fldPercentualCC22;
      this.pvFieldsIntern.a_1207 = this.pvFields.fldCodigoCC23;
      this.pvFieldsIntern.a_1249 = this.pvFields.fldPercentualCC23;
      this.pvFieldsIntern.a_1257 = this.pvFields.fldCodigoCC24;
      this.pvFieldsIntern.a_1299 = this.pvFields.fldPercentualCC24;
      this.pvFieldsIntern.a_1307 = this.pvFields.fldCodigoCC25;
      this.pvFieldsIntern.a_1349 = this.pvFields.fldPercentualCC25;
      this.pvFieldsIntern.a_1357 = this.pvFields.fldReservado1;
      this.pvFieldsIntern.a_1361 = this.pvFields.fldId;
      this.pvFieldsIntern.a_1365 = this.pvFields.fldConciliacao;
      this.pvFieldsIntern.a_1369 = this.pvFields.fldunnamed_55;
      this.pvFieldsIntern.a_1389 = this.pvFields.fldunnamed_60;
      this.pvFieldsIntern.a_1449 = this.pvFields.fldunnamed_61;
      this.pvFieldsIntern.a_1505 = this.pvFields.fldunnamed_62;
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
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldConta.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_060 = this.pvFieldsExtr[index].fldDescricao.PadRight(40).ToCharArray();
        this.pvFieldsIntern.a_100 = this.pvFieldsExtr[index].fldReduzida;
        this.pvFieldsIntern.a_104 = this.pvFieldsExtr[index].fldNivel;
        this.pvFieldsIntern.a_105 = this.pvFieldsExtr[index].fldunnamed_10;
        this.pvFieldsIntern.a_107 = this.pvFieldsExtr[index].fldCodigoCC1;
        this.pvFieldsIntern.a_149 = this.pvFieldsExtr[index].fldPercentualCC1;
        this.pvFieldsIntern.a_157 = this.pvFieldsExtr[index].fldCodigoCC2;
        this.pvFieldsIntern.a_199 = this.pvFieldsExtr[index].fldPercentualCC2;
        this.pvFieldsIntern.a_207 = this.pvFieldsExtr[index].fldCodigoCC3;
        this.pvFieldsIntern.a_249 = this.pvFieldsExtr[index].fldPercentualCC3;
        this.pvFieldsIntern.a_257 = this.pvFieldsExtr[index].fldCodigoCC4;
        this.pvFieldsIntern.a_299 = this.pvFieldsExtr[index].fldPercentualCC4;
        this.pvFieldsIntern.a_307 = this.pvFieldsExtr[index].fldCodigoCC5;
        this.pvFieldsIntern.a_349 = this.pvFieldsExtr[index].fldPercentualCC5;
        this.pvFieldsIntern.a_357 = this.pvFieldsExtr[index].fldCodigoCC6;
        this.pvFieldsIntern.a_399 = this.pvFieldsExtr[index].fldPercentualCC6;
        this.pvFieldsIntern.a_407 = this.pvFieldsExtr[index].fldCodigoCC7;
        this.pvFieldsIntern.a_449 = this.pvFieldsExtr[index].fldPercentualCC7;
        this.pvFieldsIntern.a_457 = this.pvFieldsExtr[index].fldCodigoCC8;
        this.pvFieldsIntern.a_499 = this.pvFieldsExtr[index].fldPercentualCC8;
        this.pvFieldsIntern.a_507 = this.pvFieldsExtr[index].fldCodigoCC9;
        this.pvFieldsIntern.a_549 = this.pvFieldsExtr[index].fldPercentualCC9;
        this.pvFieldsIntern.a_557 = this.pvFieldsExtr[index].fldCodigoCC10;
        this.pvFieldsIntern.a_599 = this.pvFieldsExtr[index].fldPercentualCC10;
        this.pvFieldsIntern.a_607 = this.pvFieldsExtr[index].fldCodigoCC11;
        this.pvFieldsIntern.a_649 = this.pvFieldsExtr[index].fldPercentualCC11;
        this.pvFieldsIntern.a_657 = this.pvFieldsExtr[index].fldCodigoCC12;
        this.pvFieldsIntern.a_699 = this.pvFieldsExtr[index].fldPercentualCC12;
        this.pvFieldsIntern.a_707 = this.pvFieldsExtr[index].fldCodigoCC13;
        this.pvFieldsIntern.a_749 = this.pvFieldsExtr[index].fldPercentualCC13;
        this.pvFieldsIntern.a_757 = this.pvFieldsExtr[index].fldCodigoCC14;
        this.pvFieldsIntern.a_799 = this.pvFieldsExtr[index].fldPercentualCC14;
        this.pvFieldsIntern.a_807 = this.pvFieldsExtr[index].fldCodigoCC15;
        this.pvFieldsIntern.a_849 = this.pvFieldsExtr[index].fldPercentualCC15;
        this.pvFieldsIntern.a_857 = this.pvFieldsExtr[index].fldCodigoCC16;
        this.pvFieldsIntern.a_899 = this.pvFieldsExtr[index].fldPercentualCC16;
        this.pvFieldsIntern.a_907 = this.pvFieldsExtr[index].fldCodigoCC17;
        this.pvFieldsIntern.a_949 = this.pvFieldsExtr[index].fldPercentualCC17;
        this.pvFieldsIntern.a_957 = this.pvFieldsExtr[index].fldCodigoCC18;
        this.pvFieldsIntern.a_999 = this.pvFieldsExtr[index].fldPercentualCC18;
        this.pvFieldsIntern.a_1007 = this.pvFieldsExtr[index].fldCodigoCC19;
        this.pvFieldsIntern.a_1049 = this.pvFieldsExtr[index].fldPercentualCC19;
        this.pvFieldsIntern.a_1057 = this.pvFieldsExtr[index].fldCodigoCC20;
        this.pvFieldsIntern.a_1099 = this.pvFieldsExtr[index].fldPercentualCC20;
        this.pvFieldsIntern.a_1107 = this.pvFieldsExtr[index].fldCodigoCC21;
        this.pvFieldsIntern.a_1149 = this.pvFieldsExtr[index].fldPercentualCC21;
        this.pvFieldsIntern.a_1157 = this.pvFieldsExtr[index].fldCodigoCC22;
        this.pvFieldsIntern.a_1199 = this.pvFieldsExtr[index].fldPercentualCC22;
        this.pvFieldsIntern.a_1207 = this.pvFieldsExtr[index].fldCodigoCC23;
        this.pvFieldsIntern.a_1249 = this.pvFieldsExtr[index].fldPercentualCC23;
        this.pvFieldsIntern.a_1257 = this.pvFieldsExtr[index].fldCodigoCC24;
        this.pvFieldsIntern.a_1299 = this.pvFieldsExtr[index].fldPercentualCC24;
        this.pvFieldsIntern.a_1307 = this.pvFieldsExtr[index].fldCodigoCC25;
        this.pvFieldsIntern.a_1349 = this.pvFieldsExtr[index].fldPercentualCC25;
        this.pvFieldsIntern.a_1357 = this.pvFieldsExtr[index].fldReservado1;
        this.pvFieldsIntern.a_1361 = this.pvFieldsExtr[index].fldId;
        this.pvFieldsIntern.a_1365 = this.pvFieldsExtr[index].fldConciliacao;
        this.pvFieldsIntern.a_1369 = this.pvFieldsExtr[index].fldunnamed_55;
        this.pvFieldsIntern.a_1389 = this.pvFieldsExtr[index].fldunnamed_60;
        this.pvFieldsIntern.a_1449 = this.pvFieldsExtr[index].fldunnamed_61;
        this.pvFieldsIntern.a_1505 = this.pvFieldsExtr[index].fldunnamed_62;
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 1539);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 1539));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(PlContas.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(PlContas.OpenModes Mode)
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

    public virtual short btrInsert(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrInsert(PlContas.KeyName Key_nr)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrUpdate(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num;
    }

    public virtual short btrUpdate(PlContas.KeyName Key_nr)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
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

    public virtual short btrGetEqual(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(PlContas.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetNext(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetNext(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetNext(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(PlContas.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetNext(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetNext(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(PlContas.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(PlContas.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetGreater(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetGreaterThanOrEqual(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(PlContas.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetGreaterThanOrEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLessThan(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(PlContas.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLessThan(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLessThanOrEqual(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(PlContas.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLessThanOrEqual(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetFirst(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(PlContas.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetFirst(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLast(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(PlContas.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetLast(PlContas.KeyName Key_nr, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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
      short DataBufferLength = (short) 1539;
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

    public virtual short btrGetDirectRecord(PlContas.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(PlContas.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(PlContas.KeyName Key_nr, IntPtr Position, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(PlContas.KeyName Key_nr, IntPtr Position, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
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
      return this.btrStepNext(PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(PlContas.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num = IntPtr.Zero;
      short DataBufferLength = Position == num || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(PlContas.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(PlContas.KeyName Key_nr, byte[] ClientId)
    {
      short DataBufferLength = checked ((short) (1541 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num;
    }

    public virtual short btrInsertExtended(PlContas.KeyName Key_nr)
    {
      short DataBufferLength = checked ((short) (1541 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) DataBufferLength);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= PlContas.KeyName.index_0 && (int) num == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num;
    }

    public virtual short btrGetByPercentage(PlContas.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, PlContas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(PlContas.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, PlContas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(PlContas.KeyName Key_nr, short Percentage, PlContas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(PlContas.KeyName Key_nr, short Percentage, PlContas.RecordLocks Lock_Bias)
    {
      short DataBufferLength = (short) 1539;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) DataBufferLength);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, DataBufferLength);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(PlContas.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(PlContas.KeyName Key_nr, ref short Percentage)
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
      private PlContas.KeysStruct.struct_01 idxindex_1_priv;
      private PlContas.KeysStruct.struct_02 idxindex_2_priv;
      private PlContas.KeysStruct.struct_03 idxindex_3_priv;
      private PlContas.KeysStruct.struct_04 idxUK_Id_priv;
      private PlContas.KeysStruct.struct_00 idxindex_0_priv;

      public PlContas.KeysStruct.struct_01 idxindex_1
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

      public PlContas.KeysStruct.struct_02 idxindex_2
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

      public PlContas.KeysStruct.struct_03 idxindex_3
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

      public PlContas.KeysStruct.struct_04 idxUK_Id
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

      public PlContas.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new PlContas.KeysStruct.struct_01();
        this.idxindex_2_priv = new PlContas.KeysStruct.struct_02();
        this.idxindex_3_priv = new PlContas.KeysStruct.struct_03();
        this.idxUK_Id_priv = new PlContas.KeysStruct.struct_04();
        this.idxindex_0_priv = new PlContas.KeysStruct.struct_00();
      }

      public class struct_00
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

        public struct_00()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmConta_priv = string.Empty;
        }
      }

      public class struct_01
      {
        private int sgmIdPlano_priv;
        private string sgmDescricao_priv;

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

        public string sgmDescricao
        {
          get
          {
            return this.sgmDescricao_priv;
          }
          set
          {
            this.sgmDescricao_priv = value;
          }
        }

        public struct_01()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmDescricao_priv = string.Empty;
        }
      }

      public class struct_02
      {
        private int sgmIdPlano_priv;
        private int sgmReduzida_priv;

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

        public int sgmReduzida
        {
          get
          {
            return this.sgmReduzida_priv;
          }
          set
          {
            this.sgmReduzida_priv = value;
          }
        }

        public struct_02()
        {
          
          this.sgmIdPlano_priv = 0;
          this.sgmReduzida_priv = 0;
        }
      }

      public class struct_03
      {
        private int sgmIdPlano_priv;

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

        public struct_03()
        {
          
          this.sgmIdPlano_priv = 0;
        }
      }

      public class struct_04
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

        public struct_04()
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
      index_3 = 3,
      UK_Id = 4,
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

    [StructLayout(LayoutKind.Sequential, Size = 1539, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_004;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_060;
      internal int a_100;
      [MarshalAs(UnmanagedType.U1)]
      internal byte a_104;
      internal short a_105;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_107;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_149;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_157;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_199;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_207;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_249;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_257;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_299;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_307;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_349;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_357;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_399;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_407;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_449;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_457;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_499;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_507;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_549;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_557;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_599;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_607;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_649;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_657;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_699;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_707;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_749;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_757;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_799;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_807;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_849;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_857;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_899;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_907;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_949;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_957;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_999;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1007;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1049;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1057;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1099;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1107;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1149;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1157;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1199;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1207;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1249;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1257;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1299;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 42)]
      internal string a_1307;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_1349;
      internal int a_1357;
      internal int a_1361;
      internal int a_1365;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 20)]
      internal string a_1369;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 60)]
      internal string a_1389;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 56)]
      internal string a_1449;
      [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 34)]
      internal string a_1505;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldIdPlano_priv;
      private string fldConta_priv;
      private string fldDescricao_priv;
      private int fldReduzida_priv;
      private byte fldNivel_priv;
      private short fldunnamed_10_priv;
      private string fldCodigoCC1_priv;
      private double fldPercentualCC1_priv;
      private string fldCodigoCC2_priv;
      private double fldPercentualCC2_priv;
      private string fldCodigoCC3_priv;
      private double fldPercentualCC3_priv;
      private string fldCodigoCC4_priv;
      private double fldPercentualCC4_priv;
      private string fldCodigoCC5_priv;
      private double fldPercentualCC5_priv;
      private string fldCodigoCC6_priv;
      private double fldPercentualCC6_priv;
      private string fldCodigoCC7_priv;
      private double fldPercentualCC7_priv;
      private string fldCodigoCC8_priv;
      private double fldPercentualCC8_priv;
      private string fldCodigoCC9_priv;
      private double fldPercentualCC9_priv;
      private string fldCodigoCC10_priv;
      private double fldPercentualCC10_priv;
      private string fldCodigoCC11_priv;
      private double fldPercentualCC11_priv;
      private string fldCodigoCC12_priv;
      private double fldPercentualCC12_priv;
      private string fldCodigoCC13_priv;
      private double fldPercentualCC13_priv;
      private string fldCodigoCC14_priv;
      private double fldPercentualCC14_priv;
      private string fldCodigoCC15_priv;
      private double fldPercentualCC15_priv;
      private string fldCodigoCC16_priv;
      private double fldPercentualCC16_priv;
      private string fldCodigoCC17_priv;
      private double fldPercentualCC17_priv;
      private string fldCodigoCC18_priv;
      private double fldPercentualCC18_priv;
      private string fldCodigoCC19_priv;
      private double fldPercentualCC19_priv;
      private string fldCodigoCC20_priv;
      private double fldPercentualCC20_priv;
      private string fldCodigoCC21_priv;
      private double fldPercentualCC21_priv;
      private string fldCodigoCC22_priv;
      private double fldPercentualCC22_priv;
      private string fldCodigoCC23_priv;
      private double fldPercentualCC23_priv;
      private string fldCodigoCC24_priv;
      private double fldPercentualCC24_priv;
      private string fldCodigoCC25_priv;
      private double fldPercentualCC25_priv;
      private int fldReservado1_priv;
      private int fldId_priv;
      private int fldConciliacao_priv;
      private string fldunnamed_55_priv;
      private string fldunnamed_60_priv;
      private string fldunnamed_61_priv;
      private string fldunnamed_62_priv;
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

      public string fldDescricao
      {
        get
        {
          return this.fldDescricao_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldDescricao_priv, value, false) == 0)
            return;
          this.fldDescricao_priv = value;
          this.OnPropertyChanged("fldDescricao");
        }
      }

      public int fldReduzida
      {
        get
        {
          return this.fldReduzida_priv;
        }
        set
        {
          if (this.fldReduzida_priv == value)
            return;
          this.fldReduzida_priv = value;
          this.OnPropertyChanged("fldReduzida");
        }
      }

      public byte fldNivel
      {
        get
        {
          return this.fldNivel_priv;
        }
        set
        {
          if ((int) this.fldNivel_priv == (int) value)
            return;
          this.fldNivel_priv = value;
          this.OnPropertyChanged("fldNivel");
        }
      }

      public short fldunnamed_10
      {
        get
        {
          return this.fldunnamed_10_priv;
        }
        set
        {
          if ((int) this.fldunnamed_10_priv == (int) value)
            return;
          this.fldunnamed_10_priv = value;
          this.OnPropertyChanged("fldunnamed_10");
        }
      }

      public string fldCodigoCC1
      {
        get
        {
          return this.fldCodigoCC1_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC1_priv, value, false) == 0)
            return;
          this.fldCodigoCC1_priv = value;
          this.OnPropertyChanged("fldCodigoCC1");
        }
      }

      public double fldPercentualCC1
      {
        get
        {
          return this.fldPercentualCC1_priv;
        }
        set
        {
          if (this.fldPercentualCC1_priv == value)
            return;
          this.fldPercentualCC1_priv = value;
          this.OnPropertyChanged("fldPercentualCC1");
        }
      }

      public string fldCodigoCC2
      {
        get
        {
          return this.fldCodigoCC2_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC2_priv, value, false) == 0)
            return;
          this.fldCodigoCC2_priv = value;
          this.OnPropertyChanged("fldCodigoCC2");
        }
      }

      public double fldPercentualCC2
      {
        get
        {
          return this.fldPercentualCC2_priv;
        }
        set
        {
          if (this.fldPercentualCC2_priv == value)
            return;
          this.fldPercentualCC2_priv = value;
          this.OnPropertyChanged("fldPercentualCC2");
        }
      }

      public string fldCodigoCC3
      {
        get
        {
          return this.fldCodigoCC3_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC3_priv, value, false) == 0)
            return;
          this.fldCodigoCC3_priv = value;
          this.OnPropertyChanged("fldCodigoCC3");
        }
      }

      public double fldPercentualCC3
      {
        get
        {
          return this.fldPercentualCC3_priv;
        }
        set
        {
          if (this.fldPercentualCC3_priv == value)
            return;
          this.fldPercentualCC3_priv = value;
          this.OnPropertyChanged("fldPercentualCC3");
        }
      }

      public string fldCodigoCC4
      {
        get
        {
          return this.fldCodigoCC4_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC4_priv, value, false) == 0)
            return;
          this.fldCodigoCC4_priv = value;
          this.OnPropertyChanged("fldCodigoCC4");
        }
      }

      public double fldPercentualCC4
      {
        get
        {
          return this.fldPercentualCC4_priv;
        }
        set
        {
          if (this.fldPercentualCC4_priv == value)
            return;
          this.fldPercentualCC4_priv = value;
          this.OnPropertyChanged("fldPercentualCC4");
        }
      }

      public string fldCodigoCC5
      {
        get
        {
          return this.fldCodigoCC5_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC5_priv, value, false) == 0)
            return;
          this.fldCodigoCC5_priv = value;
          this.OnPropertyChanged("fldCodigoCC5");
        }
      }

      public double fldPercentualCC5
      {
        get
        {
          return this.fldPercentualCC5_priv;
        }
        set
        {
          if (this.fldPercentualCC5_priv == value)
            return;
          this.fldPercentualCC5_priv = value;
          this.OnPropertyChanged("fldPercentualCC5");
        }
      }

      public string fldCodigoCC6
      {
        get
        {
          return this.fldCodigoCC6_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC6_priv, value, false) == 0)
            return;
          this.fldCodigoCC6_priv = value;
          this.OnPropertyChanged("fldCodigoCC6");
        }
      }

      public double fldPercentualCC6
      {
        get
        {
          return this.fldPercentualCC6_priv;
        }
        set
        {
          if (this.fldPercentualCC6_priv == value)
            return;
          this.fldPercentualCC6_priv = value;
          this.OnPropertyChanged("fldPercentualCC6");
        }
      }

      public string fldCodigoCC7
      {
        get
        {
          return this.fldCodigoCC7_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC7_priv, value, false) == 0)
            return;
          this.fldCodigoCC7_priv = value;
          this.OnPropertyChanged("fldCodigoCC7");
        }
      }

      public double fldPercentualCC7
      {
        get
        {
          return this.fldPercentualCC7_priv;
        }
        set
        {
          if (this.fldPercentualCC7_priv == value)
            return;
          this.fldPercentualCC7_priv = value;
          this.OnPropertyChanged("fldPercentualCC7");
        }
      }

      public string fldCodigoCC8
      {
        get
        {
          return this.fldCodigoCC8_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC8_priv, value, false) == 0)
            return;
          this.fldCodigoCC8_priv = value;
          this.OnPropertyChanged("fldCodigoCC8");
        }
      }

      public double fldPercentualCC8
      {
        get
        {
          return this.fldPercentualCC8_priv;
        }
        set
        {
          if (this.fldPercentualCC8_priv == value)
            return;
          this.fldPercentualCC8_priv = value;
          this.OnPropertyChanged("fldPercentualCC8");
        }
      }

      public string fldCodigoCC9
      {
        get
        {
          return this.fldCodigoCC9_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC9_priv, value, false) == 0)
            return;
          this.fldCodigoCC9_priv = value;
          this.OnPropertyChanged("fldCodigoCC9");
        }
      }

      public double fldPercentualCC9
      {
        get
        {
          return this.fldPercentualCC9_priv;
        }
        set
        {
          if (this.fldPercentualCC9_priv == value)
            return;
          this.fldPercentualCC9_priv = value;
          this.OnPropertyChanged("fldPercentualCC9");
        }
      }

      public string fldCodigoCC10
      {
        get
        {
          return this.fldCodigoCC10_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC10_priv, value, false) == 0)
            return;
          this.fldCodigoCC10_priv = value;
          this.OnPropertyChanged("fldCodigoCC10");
        }
      }

      public double fldPercentualCC10
      {
        get
        {
          return this.fldPercentualCC10_priv;
        }
        set
        {
          if (this.fldPercentualCC10_priv == value)
            return;
          this.fldPercentualCC10_priv = value;
          this.OnPropertyChanged("fldPercentualCC10");
        }
      }

      public string fldCodigoCC11
      {
        get
        {
          return this.fldCodigoCC11_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC11_priv, value, false) == 0)
            return;
          this.fldCodigoCC11_priv = value;
          this.OnPropertyChanged("fldCodigoCC11");
        }
      }

      public double fldPercentualCC11
      {
        get
        {
          return this.fldPercentualCC11_priv;
        }
        set
        {
          if (this.fldPercentualCC11_priv == value)
            return;
          this.fldPercentualCC11_priv = value;
          this.OnPropertyChanged("fldPercentualCC11");
        }
      }

      public string fldCodigoCC12
      {
        get
        {
          return this.fldCodigoCC12_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC12_priv, value, false) == 0)
            return;
          this.fldCodigoCC12_priv = value;
          this.OnPropertyChanged("fldCodigoCC12");
        }
      }

      public double fldPercentualCC12
      {
        get
        {
          return this.fldPercentualCC12_priv;
        }
        set
        {
          if (this.fldPercentualCC12_priv == value)
            return;
          this.fldPercentualCC12_priv = value;
          this.OnPropertyChanged("fldPercentualCC12");
        }
      }

      public string fldCodigoCC13
      {
        get
        {
          return this.fldCodigoCC13_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC13_priv, value, false) == 0)
            return;
          this.fldCodigoCC13_priv = value;
          this.OnPropertyChanged("fldCodigoCC13");
        }
      }

      public double fldPercentualCC13
      {
        get
        {
          return this.fldPercentualCC13_priv;
        }
        set
        {
          if (this.fldPercentualCC13_priv == value)
            return;
          this.fldPercentualCC13_priv = value;
          this.OnPropertyChanged("fldPercentualCC13");
        }
      }

      public string fldCodigoCC14
      {
        get
        {
          return this.fldCodigoCC14_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC14_priv, value, false) == 0)
            return;
          this.fldCodigoCC14_priv = value;
          this.OnPropertyChanged("fldCodigoCC14");
        }
      }

      public double fldPercentualCC14
      {
        get
        {
          return this.fldPercentualCC14_priv;
        }
        set
        {
          if (this.fldPercentualCC14_priv == value)
            return;
          this.fldPercentualCC14_priv = value;
          this.OnPropertyChanged("fldPercentualCC14");
        }
      }

      public string fldCodigoCC15
      {
        get
        {
          return this.fldCodigoCC15_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC15_priv, value, false) == 0)
            return;
          this.fldCodigoCC15_priv = value;
          this.OnPropertyChanged("fldCodigoCC15");
        }
      }

      public double fldPercentualCC15
      {
        get
        {
          return this.fldPercentualCC15_priv;
        }
        set
        {
          if (this.fldPercentualCC15_priv == value)
            return;
          this.fldPercentualCC15_priv = value;
          this.OnPropertyChanged("fldPercentualCC15");
        }
      }

      public string fldCodigoCC16
      {
        get
        {
          return this.fldCodigoCC16_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC16_priv, value, false) == 0)
            return;
          this.fldCodigoCC16_priv = value;
          this.OnPropertyChanged("fldCodigoCC16");
        }
      }

      public double fldPercentualCC16
      {
        get
        {
          return this.fldPercentualCC16_priv;
        }
        set
        {
          if (this.fldPercentualCC16_priv == value)
            return;
          this.fldPercentualCC16_priv = value;
          this.OnPropertyChanged("fldPercentualCC16");
        }
      }

      public string fldCodigoCC17
      {
        get
        {
          return this.fldCodigoCC17_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC17_priv, value, false) == 0)
            return;
          this.fldCodigoCC17_priv = value;
          this.OnPropertyChanged("fldCodigoCC17");
        }
      }

      public double fldPercentualCC17
      {
        get
        {
          return this.fldPercentualCC17_priv;
        }
        set
        {
          if (this.fldPercentualCC17_priv == value)
            return;
          this.fldPercentualCC17_priv = value;
          this.OnPropertyChanged("fldPercentualCC17");
        }
      }

      public string fldCodigoCC18
      {
        get
        {
          return this.fldCodigoCC18_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC18_priv, value, false) == 0)
            return;
          this.fldCodigoCC18_priv = value;
          this.OnPropertyChanged("fldCodigoCC18");
        }
      }

      public double fldPercentualCC18
      {
        get
        {
          return this.fldPercentualCC18_priv;
        }
        set
        {
          if (this.fldPercentualCC18_priv == value)
            return;
          this.fldPercentualCC18_priv = value;
          this.OnPropertyChanged("fldPercentualCC18");
        }
      }

      public string fldCodigoCC19
      {
        get
        {
          return this.fldCodigoCC19_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC19_priv, value, false) == 0)
            return;
          this.fldCodigoCC19_priv = value;
          this.OnPropertyChanged("fldCodigoCC19");
        }
      }

      public double fldPercentualCC19
      {
        get
        {
          return this.fldPercentualCC19_priv;
        }
        set
        {
          if (this.fldPercentualCC19_priv == value)
            return;
          this.fldPercentualCC19_priv = value;
          this.OnPropertyChanged("fldPercentualCC19");
        }
      }

      public string fldCodigoCC20
      {
        get
        {
          return this.fldCodigoCC20_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC20_priv, value, false) == 0)
            return;
          this.fldCodigoCC20_priv = value;
          this.OnPropertyChanged("fldCodigoCC20");
        }
      }

      public double fldPercentualCC20
      {
        get
        {
          return this.fldPercentualCC20_priv;
        }
        set
        {
          if (this.fldPercentualCC20_priv == value)
            return;
          this.fldPercentualCC20_priv = value;
          this.OnPropertyChanged("fldPercentualCC20");
        }
      }

      public string fldCodigoCC21
      {
        get
        {
          return this.fldCodigoCC21_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC21_priv, value, false) == 0)
            return;
          this.fldCodigoCC21_priv = value;
          this.OnPropertyChanged("fldCodigoCC21");
        }
      }

      public double fldPercentualCC21
      {
        get
        {
          return this.fldPercentualCC21_priv;
        }
        set
        {
          if (this.fldPercentualCC21_priv == value)
            return;
          this.fldPercentualCC21_priv = value;
          this.OnPropertyChanged("fldPercentualCC21");
        }
      }

      public string fldCodigoCC22
      {
        get
        {
          return this.fldCodigoCC22_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC22_priv, value, false) == 0)
            return;
          this.fldCodigoCC22_priv = value;
          this.OnPropertyChanged("fldCodigoCC22");
        }
      }

      public double fldPercentualCC22
      {
        get
        {
          return this.fldPercentualCC22_priv;
        }
        set
        {
          if (this.fldPercentualCC22_priv == value)
            return;
          this.fldPercentualCC22_priv = value;
          this.OnPropertyChanged("fldPercentualCC22");
        }
      }

      public string fldCodigoCC23
      {
        get
        {
          return this.fldCodigoCC23_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC23_priv, value, false) == 0)
            return;
          this.fldCodigoCC23_priv = value;
          this.OnPropertyChanged("fldCodigoCC23");
        }
      }

      public double fldPercentualCC23
      {
        get
        {
          return this.fldPercentualCC23_priv;
        }
        set
        {
          if (this.fldPercentualCC23_priv == value)
            return;
          this.fldPercentualCC23_priv = value;
          this.OnPropertyChanged("fldPercentualCC23");
        }
      }

      public string fldCodigoCC24
      {
        get
        {
          return this.fldCodigoCC24_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC24_priv, value, false) == 0)
            return;
          this.fldCodigoCC24_priv = value;
          this.OnPropertyChanged("fldCodigoCC24");
        }
      }

      public double fldPercentualCC24
      {
        get
        {
          return this.fldPercentualCC24_priv;
        }
        set
        {
          if (this.fldPercentualCC24_priv == value)
            return;
          this.fldPercentualCC24_priv = value;
          this.OnPropertyChanged("fldPercentualCC24");
        }
      }

      public string fldCodigoCC25
      {
        get
        {
          return this.fldCodigoCC25_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldCodigoCC25_priv, value, false) == 0)
            return;
          this.fldCodigoCC25_priv = value;
          this.OnPropertyChanged("fldCodigoCC25");
        }
      }

      public double fldPercentualCC25
      {
        get
        {
          return this.fldPercentualCC25_priv;
        }
        set
        {
          if (this.fldPercentualCC25_priv == value)
            return;
          this.fldPercentualCC25_priv = value;
          this.OnPropertyChanged("fldPercentualCC25");
        }
      }

      public int fldReservado1
      {
        get
        {
          return this.fldReservado1_priv;
        }
        set
        {
          if (this.fldReservado1_priv == value)
            return;
          this.fldReservado1_priv = value;
          this.OnPropertyChanged("fldReservado1");
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

      public int fldConciliacao
      {
        get
        {
          return this.fldConciliacao_priv;
        }
        set
        {
          if (this.fldConciliacao_priv == value)
            return;
          this.fldConciliacao_priv = value;
          this.OnPropertyChanged("fldConciliacao");
        }
      }

      public string fldunnamed_55
      {
        get
        {
          return this.fldunnamed_55_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_55_priv, value, false) == 0)
            return;
          this.fldunnamed_55_priv = value;
          this.OnPropertyChanged("fldunnamed_55");
        }
      }

      public string fldunnamed_60
      {
        get
        {
          return this.fldunnamed_60_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_60_priv, value, false) == 0)
            return;
          this.fldunnamed_60_priv = value;
          this.OnPropertyChanged("fldunnamed_60");
        }
      }

      public string fldunnamed_61
      {
        get
        {
          return this.fldunnamed_61_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_61_priv, value, false) == 0)
            return;
          this.fldunnamed_61_priv = value;
          this.OnPropertyChanged("fldunnamed_61");
        }
      }

      public string fldunnamed_62
      {
        get
        {
          return this.fldunnamed_62_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_62_priv, value, false) == 0)
            return;
          this.fldunnamed_62_priv = value;
          this.OnPropertyChanged("fldunnamed_62");
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
        this.fldConta_priv = string.Empty;
        this.fldDescricao_priv = string.Empty;
        this.fldReduzida_priv = 0;
        this.fldNivel_priv = (byte) 0;
        this.fldunnamed_10_priv = (short) 0;
        this.fldCodigoCC1_priv = string.Empty;
        this.fldPercentualCC1_priv = 0.0;
        this.fldCodigoCC2_priv = string.Empty;
        this.fldPercentualCC2_priv = 0.0;
        this.fldCodigoCC3_priv = string.Empty;
        this.fldPercentualCC3_priv = 0.0;
        this.fldCodigoCC4_priv = string.Empty;
        this.fldPercentualCC4_priv = 0.0;
        this.fldCodigoCC5_priv = string.Empty;
        this.fldPercentualCC5_priv = 0.0;
        this.fldCodigoCC6_priv = string.Empty;
        this.fldPercentualCC6_priv = 0.0;
        this.fldCodigoCC7_priv = string.Empty;
        this.fldPercentualCC7_priv = 0.0;
        this.fldCodigoCC8_priv = string.Empty;
        this.fldPercentualCC8_priv = 0.0;
        this.fldCodigoCC9_priv = string.Empty;
        this.fldPercentualCC9_priv = 0.0;
        this.fldCodigoCC10_priv = string.Empty;
        this.fldPercentualCC10_priv = 0.0;
        this.fldCodigoCC11_priv = string.Empty;
        this.fldPercentualCC11_priv = 0.0;
        this.fldCodigoCC12_priv = string.Empty;
        this.fldPercentualCC12_priv = 0.0;
        this.fldCodigoCC13_priv = string.Empty;
        this.fldPercentualCC13_priv = 0.0;
        this.fldCodigoCC14_priv = string.Empty;
        this.fldPercentualCC14_priv = 0.0;
        this.fldCodigoCC15_priv = string.Empty;
        this.fldPercentualCC15_priv = 0.0;
        this.fldCodigoCC16_priv = string.Empty;
        this.fldPercentualCC16_priv = 0.0;
        this.fldCodigoCC17_priv = string.Empty;
        this.fldPercentualCC17_priv = 0.0;
        this.fldCodigoCC18_priv = string.Empty;
        this.fldPercentualCC18_priv = 0.0;
        this.fldCodigoCC19_priv = string.Empty;
        this.fldPercentualCC19_priv = 0.0;
        this.fldCodigoCC20_priv = string.Empty;
        this.fldPercentualCC20_priv = 0.0;
        this.fldCodigoCC21_priv = string.Empty;
        this.fldPercentualCC21_priv = 0.0;
        this.fldCodigoCC22_priv = string.Empty;
        this.fldPercentualCC22_priv = 0.0;
        this.fldCodigoCC23_priv = string.Empty;
        this.fldPercentualCC23_priv = 0.0;
        this.fldCodigoCC24_priv = string.Empty;
        this.fldPercentualCC24_priv = 0.0;
        this.fldCodigoCC25_priv = string.Empty;
        this.fldPercentualCC25_priv = 0.0;
        this.fldReservado1_priv = 0;
        this.fldId_priv = 0;
        this.fldConciliacao_priv = 0;
        this.fldunnamed_55_priv = string.Empty;
        this.fldunnamed_60_priv = string.Empty;
        this.fldunnamed_61_priv = string.Empty;
        this.fldunnamed_62_priv = string.Empty;
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
