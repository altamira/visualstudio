// Type: Trial.Notas
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 7DD3C76A-4CAB-486D-B060-66CF5D1BE672
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
  public class Notas
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
    private Notas.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private Notas.FieldsClass pvFields;
    private Notas.FieldsClass[] pvFieldsExtr;
    private Notas.FieldsClass_priv pvFieldsIntern;
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

    public string fldOperacao
    {
      get
      {
        return this.pvFields.fldOperacao;
      }
      set
      {
        this.pvFields.fldOperacao = value;
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

    public short fldunnamed_4
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

    public int fldunnamed_5
    {
      get
      {
        return this.pvFields.fldunnamed_5;
      }
      set
      {
        this.pvFields.fldunnamed_5 = value;
      }
    }

    public string fldData
    {
      get
      {
        return this.pvFields.fldData;
      }
      set
      {
        this.pvFields.fldData = value;
      }
    }

    public string fldEmissao
    {
      get
      {
        return this.pvFields.fldEmissao;
      }
      set
      {
        this.pvFields.fldEmissao = value;
      }
    }

    public string fldSerie
    {
      get
      {
        return this.pvFields.fldSerie;
      }
      set
      {
        this.pvFields.fldSerie = value;
      }
    }

    public string fldEspecie
    {
      get
      {
        return this.pvFields.fldEspecie;
      }
      set
      {
        this.pvFields.fldEspecie = value;
      }
    }

    public int fldNumero
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

    public int fldNumeroAte
    {
      get
      {
        return this.pvFields.fldNumeroAte;
      }
      set
      {
        this.pvFields.fldNumeroAte = value;
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

    public short fldSituacao
    {
      get
      {
        return this.pvFields.fldSituacao;
      }
      set
      {
        this.pvFields.fldSituacao = value;
      }
    }

    public string fldUF
    {
      get
      {
        return this.pvFields.fldUF;
      }
      set
      {
        this.pvFields.fldUF = value;
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

    public string fldObservacao
    {
      get
      {
        return this.pvFields.fldObservacao;
      }
      set
      {
        this.pvFields.fldObservacao = value;
      }
    }

    public double fldValorContabil
    {
      get
      {
        return this.pvFields.fldValorContabil;
      }
      set
      {
        this.pvFields.fldValorContabil = value;
      }
    }

    public short fldunnamed_17
    {
      get
      {
        return this.pvFields.fldunnamed_17;
      }
      set
      {
        this.pvFields.fldunnamed_17 = value;
      }
    }

    public double fldBaseCalculoICMS1
    {
      get
      {
        return this.pvFields.fldBaseCalculoICMS1;
      }
      set
      {
        this.pvFields.fldBaseCalculoICMS1 = value;
      }
    }

    public double fldBaseCalculoICMS2
    {
      get
      {
        return this.pvFields.fldBaseCalculoICMS2;
      }
      set
      {
        this.pvFields.fldBaseCalculoICMS2 = value;
      }
    }

    public double fldBaseCalculoICMS3
    {
      get
      {
        return this.pvFields.fldBaseCalculoICMS3;
      }
      set
      {
        this.pvFields.fldBaseCalculoICMS3 = value;
      }
    }

    public double fldBaseCalculoICMS4
    {
      get
      {
        return this.pvFields.fldBaseCalculoICMS4;
      }
      set
      {
        this.pvFields.fldBaseCalculoICMS4 = value;
      }
    }

    public double fldBaseCalculoICMS5
    {
      get
      {
        return this.pvFields.fldBaseCalculoICMS5;
      }
      set
      {
        this.pvFields.fldBaseCalculoICMS5 = value;
      }
    }

    public double fldAliquotaICMS1
    {
      get
      {
        return this.pvFields.fldAliquotaICMS1;
      }
      set
      {
        this.pvFields.fldAliquotaICMS1 = value;
      }
    }

    public double fldAliquotaICMS2
    {
      get
      {
        return this.pvFields.fldAliquotaICMS2;
      }
      set
      {
        this.pvFields.fldAliquotaICMS2 = value;
      }
    }

    public double fldAliquotaICMS3
    {
      get
      {
        return this.pvFields.fldAliquotaICMS3;
      }
      set
      {
        this.pvFields.fldAliquotaICMS3 = value;
      }
    }

    public double fldAliquotaICMS4
    {
      get
      {
        return this.pvFields.fldAliquotaICMS4;
      }
      set
      {
        this.pvFields.fldAliquotaICMS4 = value;
      }
    }

    public double fldAliquotaICMS5
    {
      get
      {
        return this.pvFields.fldAliquotaICMS5;
      }
      set
      {
        this.pvFields.fldAliquotaICMS5 = value;
      }
    }

    public double fldValorICMS1
    {
      get
      {
        return this.pvFields.fldValorICMS1;
      }
      set
      {
        this.pvFields.fldValorICMS1 = value;
      }
    }

    public double fldValorICMS2
    {
      get
      {
        return this.pvFields.fldValorICMS2;
      }
      set
      {
        this.pvFields.fldValorICMS2 = value;
      }
    }

    public double fldValorICMS3
    {
      get
      {
        return this.pvFields.fldValorICMS3;
      }
      set
      {
        this.pvFields.fldValorICMS3 = value;
      }
    }

    public double fldValorICMS4
    {
      get
      {
        return this.pvFields.fldValorICMS4;
      }
      set
      {
        this.pvFields.fldValorICMS4 = value;
      }
    }

    public double fldValorICMS5
    {
      get
      {
        return this.pvFields.fldValorICMS5;
      }
      set
      {
        this.pvFields.fldValorICMS5 = value;
      }
    }

    public double fldIsentoICMS1
    {
      get
      {
        return this.pvFields.fldIsentoICMS1;
      }
      set
      {
        this.pvFields.fldIsentoICMS1 = value;
      }
    }

    public double fldIsentoICMS2
    {
      get
      {
        return this.pvFields.fldIsentoICMS2;
      }
      set
      {
        this.pvFields.fldIsentoICMS2 = value;
      }
    }

    public double fldIsentoICMS3
    {
      get
      {
        return this.pvFields.fldIsentoICMS3;
      }
      set
      {
        this.pvFields.fldIsentoICMS3 = value;
      }
    }

    public double fldIsentoICMS4
    {
      get
      {
        return this.pvFields.fldIsentoICMS4;
      }
      set
      {
        this.pvFields.fldIsentoICMS4 = value;
      }
    }

    public double fldIsentoICMS5
    {
      get
      {
        return this.pvFields.fldIsentoICMS5;
      }
      set
      {
        this.pvFields.fldIsentoICMS5 = value;
      }
    }

    public double fldOutrosICMS1
    {
      get
      {
        return this.pvFields.fldOutrosICMS1;
      }
      set
      {
        this.pvFields.fldOutrosICMS1 = value;
      }
    }

    public double fldOutrosICMS2
    {
      get
      {
        return this.pvFields.fldOutrosICMS2;
      }
      set
      {
        this.pvFields.fldOutrosICMS2 = value;
      }
    }

    public double fldOutrosICMS3
    {
      get
      {
        return this.pvFields.fldOutrosICMS3;
      }
      set
      {
        this.pvFields.fldOutrosICMS3 = value;
      }
    }

    public double fldOutrosICMS4
    {
      get
      {
        return this.pvFields.fldOutrosICMS4;
      }
      set
      {
        this.pvFields.fldOutrosICMS4 = value;
      }
    }

    public double fldOutrosICMS5
    {
      get
      {
        return this.pvFields.fldOutrosICMS5;
      }
      set
      {
        this.pvFields.fldOutrosICMS5 = value;
      }
    }

    public short fldTipoLancamento1
    {
      get
      {
        return this.pvFields.fldTipoLancamento1;
      }
      set
      {
        this.pvFields.fldTipoLancamento1 = value;
      }
    }

    public short fldTipoLancamento2
    {
      get
      {
        return this.pvFields.fldTipoLancamento2;
      }
      set
      {
        this.pvFields.fldTipoLancamento2 = value;
      }
    }

    public short fldTipoLancamento3
    {
      get
      {
        return this.pvFields.fldTipoLancamento3;
      }
      set
      {
        this.pvFields.fldTipoLancamento3 = value;
      }
    }

    public short fldTipoLancamento4
    {
      get
      {
        return this.pvFields.fldTipoLancamento4;
      }
      set
      {
        this.pvFields.fldTipoLancamento4 = value;
      }
    }

    public short fldTipoLancamento5
    {
      get
      {
        return this.pvFields.fldTipoLancamento5;
      }
      set
      {
        this.pvFields.fldTipoLancamento5 = value;
      }
    }

    public double fldBaseCalculoIPI
    {
      get
      {
        return this.pvFields.fldBaseCalculoIPI;
      }
      set
      {
        this.pvFields.fldBaseCalculoIPI = value;
      }
    }

    public double fldValorIPI
    {
      get
      {
        return this.pvFields.fldValorIPI;
      }
      set
      {
        this.pvFields.fldValorIPI = value;
      }
    }

    public double fldIsentoIPI
    {
      get
      {
        return this.pvFields.fldIsentoIPI;
      }
      set
      {
        this.pvFields.fldIsentoIPI = value;
      }
    }

    public double fldOutrasIPI
    {
      get
      {
        return this.pvFields.fldOutrasIPI;
      }
      set
      {
        this.pvFields.fldOutrasIPI = value;
      }
    }

    public double fldICMSFonte
    {
      get
      {
        return this.pvFields.fldICMSFonte;
      }
      set
      {
        this.pvFields.fldICMSFonte = value;
      }
    }

    public double fldDesconto
    {
      get
      {
        return this.pvFields.fldDesconto;
      }
      set
      {
        this.pvFields.fldDesconto = value;
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

    public double fldAVista
    {
      get
      {
        return this.pvFields.fldAVista;
      }
      set
      {
        this.pvFields.fldAVista = value;
      }
    }

    public double fldAPrazo
    {
      get
      {
        return this.pvFields.fldAPrazo;
      }
      set
      {
        this.pvFields.fldAPrazo = value;
      }
    }

    public short fldunnamed_24
    {
      get
      {
        return this.pvFields.fldunnamed_24;
      }
      set
      {
        this.pvFields.fldunnamed_24 = value;
      }
    }

    public short fldunnamed_208
    {
      get
      {
        return this.pvFields.fldunnamed_208;
      }
      set
      {
        this.pvFields.fldunnamed_208 = value;
      }
    }

    public string fldunnamed_67
    {
      get
      {
        return this.pvFields.fldunnamed_67;
      }
      set
      {
        this.pvFields.fldunnamed_67 = value;
      }
    }

    public string fldunnamed_68
    {
      get
      {
        return this.pvFields.fldunnamed_68;
      }
      set
      {
        this.pvFields.fldunnamed_68 = value;
      }
    }

    public short fldunnamed_71
    {
      get
      {
        return this.pvFields.fldunnamed_71;
      }
      set
      {
        this.pvFields.fldunnamed_71 = value;
      }
    }

    public int fldunnamed_207
    {
      get
      {
        return this.pvFields.fldunnamed_207;
      }
      set
      {
        this.pvFields.fldunnamed_207 = value;
      }
    }

    public int fldunnamed_126
    {
      get
      {
        return this.pvFields.fldunnamed_126;
      }
      set
      {
        this.pvFields.fldunnamed_126 = value;
      }
    }

    public short fldCentenaCFOP
    {
      get
      {
        return this.pvFields.fldCentenaCFOP;
      }
      set
      {
        this.pvFields.fldCentenaCFOP = value;
      }
    }

    public string fldunnamed_72
    {
      get
      {
        return this.pvFields.fldunnamed_72;
      }
      set
      {
        this.pvFields.fldunnamed_72 = value;
      }
    }

    public double fldPISIsento
    {
      get
      {
        return this.pvFields.fldPISIsento;
      }
      set
      {
        this.pvFields.fldPISIsento = value;
      }
    }

    public double fldunnamed_66
    {
      get
      {
        return this.pvFields.fldunnamed_66;
      }
      set
      {
        this.pvFields.fldunnamed_66 = value;
      }
    }

    public double fldBaseICMSFonte
    {
      get
      {
        return this.pvFields.fldBaseICMSFonte;
      }
      set
      {
        this.pvFields.fldBaseICMSFonte = value;
      }
    }

    public double fldAbatimento
    {
      get
      {
        return this.pvFields.fldAbatimento;
      }
      set
      {
        this.pvFields.fldAbatimento = value;
      }
    }

    public double fldCofinsIsento
    {
      get
      {
        return this.pvFields.fldCofinsIsento;
      }
      set
      {
        this.pvFields.fldCofinsIsento = value;
      }
    }

    public double fldPVV
    {
      get
      {
        return this.pvFields.fldPVV;
      }
      set
      {
        this.pvFields.fldPVV = value;
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

    public Notas.KeysStruct Keys
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

    public Notas.FieldsClass Fields
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

    public Notas.FieldsClass[] Fields_ext
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

    public Notas()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[180];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\Notas.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new Notas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new Notas.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public Notas(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[180];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\Notas.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new Notas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new Notas.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public Notas(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[180];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\Notas.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new Notas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new Notas.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public Notas(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[180];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\Phoenix\\empresas\\ALTAMIRA\\2013\\Notas.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new Notas.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new Notas.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
      {
        Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_0.sgmunnamed_4);
        Translate.Cmmn_WriteInt16(pPtr, 3, this.pvKeys.idxindex_0.sgmunnamed_3);
        Translate.Cmmn_WriteInt32(pPtr, 5, this.pvKeys.idxindex_0.sgmNumero);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_0.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_0.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_1.sgmunnamed_4);
        Translate.Cmmn_WriteInt32(pPtr, 3, this.pvKeys.idxindex_1.sgmNumero);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 7L));
        if (this.pvKeys.idxindex_1.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_1.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 2)
      {
        Translate.Cmmn_WriteInt32(pPtr, 1, this.pvKeys.idxindex_2.sgmNumero);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 5L));
        if (this.pvKeys.idxindex_2.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_2.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_2.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 3)
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
      else if ((int) pKey == 4)
      {
        Translate.Cmmn_WriteInt32(pPtr, 2, this.pvKeys.idxindex_4.sgmunnamed_5);
        Translate.Cmmn_WriteInt32(pPtr, 6, this.pvKeys.idxindex_4.sgmNumero);
        Translate.Cmmn_WriteInt16(pPtr, 0, this.pvKeys.idxindex_4.sgmunnamed_4);
      }
      else if ((int) pKey == 5)
      {
        Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_5.sgmunnamed_4);
        Translate.Cmmn_WriteInt16(pPtr, 3, this.pvKeys.idxindex_5.sgmunnamed_2);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_5.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 6)
      {
        Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_6.sgmunnamed_4);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 3L));
        if (this.pvKeys.idxindex_6.sgmCNPJ.Length < 21)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_6.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_6.sgmCNPJ), 0, this.pvPtr, 21);
        this.pvPtr = IntPtr.Zero;
        Translate.Cmmn_WriteInt16(pPtr, 24, this.pvKeys.idxindex_6.sgmunnamed_3);
        Translate.Cmmn_WriteInt32(pPtr, 26, this.pvKeys.idxindex_6.sgmNumero);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_6.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_6.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_6.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 7)
          return;
        Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_7.sgmunnamed_4);
        this.pvPtr = new IntPtr(checked (pPtr.ToInt64() + 0L));
        if (this.pvKeys.idxindex_7.sgmOperacao.Length < 1)
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_7.sgmOperacao.PadRight(1)), 0, this.pvPtr, 1);
        else
          Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_7.sgmOperacao), 0, this.pvPtr, 1);
        this.pvPtr = IntPtr.Zero;
      }
    }

    private void KBtoVar(ref IntPtr pPtr4, short pKey)
    {
      if ((int) pKey == 0)
      {
        this.pvKeys.idxindex_0.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 1);
        this.pvKeys.idxindex_0.sgmunnamed_3 = Translate.Cmmn_ReadInt16(pPtr4, 3);
        this.pvKeys.idxindex_0.sgmNumero = Translate.Cmmn_ReadInt32(pPtr4, 5);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_0.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 1)
      {
        this.pvKeys.idxindex_1.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 1);
        this.pvKeys.idxindex_1.sgmNumero = Translate.Cmmn_ReadInt32(pPtr4, 3);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 7L));
        this.pvKeys.idxindex_1.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_1.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 2)
      {
        this.pvKeys.idxindex_2.sgmNumero = Translate.Cmmn_ReadInt32(pPtr4, 1);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 5L));
        this.pvKeys.idxindex_2.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_2.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 3)
        this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
      else if ((int) pKey == 4)
      {
        this.pvKeys.idxindex_4.sgmunnamed_5 = Translate.Cmmn_ReadInt32(pPtr4, 2);
        this.pvKeys.idxindex_4.sgmNumero = Translate.Cmmn_ReadInt32(pPtr4, 6);
        this.pvKeys.idxindex_4.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 0);
      }
      else if ((int) pKey == 5)
      {
        this.pvKeys.idxindex_5.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 1);
        this.pvKeys.idxindex_5.sgmunnamed_2 = Translate.Cmmn_ReadInt16(pPtr4, 3);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_5.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else if ((int) pKey == 6)
      {
        this.pvKeys.idxindex_6.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 1);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 3L));
        this.pvKeys.idxindex_6.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
        this.pvPtr = IntPtr.Zero;
        this.pvKeys.idxindex_6.sgmunnamed_3 = Translate.Cmmn_ReadInt16(pPtr4, 24);
        this.pvKeys.idxindex_6.sgmNumero = Translate.Cmmn_ReadInt32(pPtr4, 26);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_6.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
      else
      {
        if ((int) pKey != 7)
          return;
        this.pvKeys.idxindex_7.sgmunnamed_4 = Translate.Cmmn_ReadInt16(pPtr4, 1);
        this.pvPtr = new IntPtr(checked (pPtr4.ToInt64() + 0L));
        this.pvKeys.idxindex_7.sgmOperacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
        this.pvPtr = IntPtr.Zero;
      }
    }

    private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
    {
      Notas notas = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (Notas.FieldsClass_priv));
      Notas.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      Notas.FieldsClass_priv fieldsClassPriv2 = obj != null ? (Notas.FieldsClass_priv) obj : fieldsClassPriv1;
      notas.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldId = this.pvFieldsIntern.a_000;
      this.pvFields.fldOperacao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
      this.pvFields.fldunnamed_2 = this.pvFieldsIntern.a_005;
      this.pvFields.fldunnamed_3 = this.pvFieldsIntern.a_007;
      this.pvFields.fldunnamed_4 = this.pvFieldsIntern.a_009;
      this.pvFields.fldunnamed_5 = this.pvFieldsIntern.a_011;
      this.pvFields.fldData = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_015) : new string(this.pvFieldsIntern.a_015).Trim();
      this.pvFields.fldEmissao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_020) : new string(this.pvFieldsIntern.a_020).Trim();
      this.pvFields.fldSerie = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_025) : new string(this.pvFieldsIntern.a_025).Trim();
      this.pvFields.fldEspecie = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_030) : new string(this.pvFieldsIntern.a_030).Trim();
      this.pvFields.fldNumero = this.pvFieldsIntern.a_035;
      this.pvFields.fldNumeroAte = this.pvFieldsIntern.a_039;
      this.pvFields.fldCNPJ = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_043) : new string(this.pvFieldsIntern.a_043).Trim();
      this.pvFields.fldSituacao = this.pvFieldsIntern.a_064;
      this.pvFields.fldUF = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_066) : new string(this.pvFieldsIntern.a_066).Trim();
      this.pvFields.fldContaContabil = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_068) : new string(this.pvFieldsIntern.a_068).Trim();
      this.pvFields.fldObservacao = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_080) : new string(this.pvFieldsIntern.a_080).Trim();
      this.pvFields.fldValorContabil = this.pvFieldsIntern.a_100;
      this.pvFields.fldunnamed_17 = this.pvFieldsIntern.a_108;
      this.pvFields.fldBaseCalculoICMS1 = this.pvFieldsIntern.a_110;
      this.pvFields.fldBaseCalculoICMS2 = this.pvFieldsIntern.a_118;
      this.pvFields.fldBaseCalculoICMS3 = this.pvFieldsIntern.a_126;
      this.pvFields.fldBaseCalculoICMS4 = this.pvFieldsIntern.a_134;
      this.pvFields.fldBaseCalculoICMS5 = this.pvFieldsIntern.a_142;
      this.pvFields.fldAliquotaICMS1 = this.pvFieldsIntern.a_150;
      this.pvFields.fldAliquotaICMS2 = this.pvFieldsIntern.a_158;
      this.pvFields.fldAliquotaICMS3 = this.pvFieldsIntern.a_166;
      this.pvFields.fldAliquotaICMS4 = this.pvFieldsIntern.a_174;
      this.pvFields.fldAliquotaICMS5 = this.pvFieldsIntern.a_182;
      this.pvFields.fldValorICMS1 = this.pvFieldsIntern.a_190;
      this.pvFields.fldValorICMS2 = this.pvFieldsIntern.a_198;
      this.pvFields.fldValorICMS3 = this.pvFieldsIntern.a_206;
      this.pvFields.fldValorICMS4 = this.pvFieldsIntern.a_214;
      this.pvFields.fldValorICMS5 = this.pvFieldsIntern.a_222;
      this.pvFields.fldIsentoICMS1 = this.pvFieldsIntern.a_230;
      this.pvFields.fldIsentoICMS2 = this.pvFieldsIntern.a_238;
      this.pvFields.fldIsentoICMS3 = this.pvFieldsIntern.a_246;
      this.pvFields.fldIsentoICMS4 = this.pvFieldsIntern.a_254;
      this.pvFields.fldIsentoICMS5 = this.pvFieldsIntern.a_262;
      this.pvFields.fldOutrosICMS1 = this.pvFieldsIntern.a_270;
      this.pvFields.fldOutrosICMS2 = this.pvFieldsIntern.a_278;
      this.pvFields.fldOutrosICMS3 = this.pvFieldsIntern.a_286;
      this.pvFields.fldOutrosICMS4 = this.pvFieldsIntern.a_294;
      this.pvFields.fldOutrosICMS5 = this.pvFieldsIntern.a_302;
      this.pvFields.fldTipoLancamento1 = this.pvFieldsIntern.a_310;
      this.pvFields.fldTipoLancamento2 = this.pvFieldsIntern.a_312;
      this.pvFields.fldTipoLancamento3 = this.pvFieldsIntern.a_314;
      this.pvFields.fldTipoLancamento4 = this.pvFieldsIntern.a_316;
      this.pvFields.fldTipoLancamento5 = this.pvFieldsIntern.a_318;
      this.pvFields.fldBaseCalculoIPI = this.pvFieldsIntern.a_320;
      this.pvFields.fldValorIPI = this.pvFieldsIntern.a_328;
      this.pvFields.fldIsentoIPI = this.pvFieldsIntern.a_336;
      this.pvFields.fldOutrasIPI = this.pvFieldsIntern.a_344;
      this.pvFields.fldICMSFonte = this.pvFieldsIntern.a_352;
      this.pvFields.fldDesconto = this.pvFieldsIntern.a_360;
      this.pvFields.fldMunicipio = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_368) : new string(this.pvFieldsIntern.a_368).Trim();
      this.pvFields.fldAVista = this.pvFieldsIntern.a_376;
      this.pvFields.fldAPrazo = this.pvFieldsIntern.a_384;
      this.pvFields.fldunnamed_24 = this.pvFieldsIntern.a_392;
      this.pvFields.fldunnamed_208 = this.pvFieldsIntern.a_394;
      this.pvFields.fldunnamed_67 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_396) : new string(this.pvFieldsIntern.a_396).Trim();
      this.pvFields.fldunnamed_68 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_576) : new string(this.pvFieldsIntern.a_576).Trim();
      this.pvFields.fldunnamed_71 = this.pvFieldsIntern.a_616;
      this.pvFields.fldunnamed_207 = this.pvFieldsIntern.a_618;
      this.pvFields.fldunnamed_126 = this.pvFieldsIntern.a_622;
      this.pvFields.fldCentenaCFOP = this.pvFieldsIntern.a_626;
      this.pvFields.fldunnamed_72 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_628) : new string(this.pvFieldsIntern.a_628).Trim();
      this.pvFields.fldPISIsento = this.pvFieldsIntern.a_662;
      this.pvFields.fldunnamed_66 = this.pvFieldsIntern.a_670;
      this.pvFields.fldBaseICMSFonte = this.pvFieldsIntern.a_678;
      this.pvFields.fldAbatimento = this.pvFieldsIntern.a_686;
      this.pvFields.fldCofinsIsento = this.pvFieldsIntern.a_694;
      this.pvFields.fldPVV = this.pvFieldsIntern.a_702;
      this.pvFields.fldunnamed_62 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_710) : new string(this.pvFieldsIntern.a_710).Trim();
      this.pvFields.fldunnamed_60 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_720) : new string(this.pvFieldsIntern.a_720).Trim();
      if (this.pvTrimStrings)
        this.pvFields.fldunnamed_61 = new string(this.pvFieldsIntern.a_730).Trim();
      else
        this.pvFields.fldunnamed_61 = new string(this.pvFieldsIntern.a_730);
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldId;
      this.pvFieldsIntern.a_004 = this.pvFields.fldOperacao.PadRight(1).ToCharArray();
      this.pvFieldsIntern.a_005 = this.pvFields.fldunnamed_2;
      this.pvFieldsIntern.a_007 = this.pvFields.fldunnamed_3;
      this.pvFieldsIntern.a_009 = this.pvFields.fldunnamed_4;
      this.pvFieldsIntern.a_011 = this.pvFields.fldunnamed_5;
      this.pvFieldsIntern.a_015 = this.pvFields.fldData.PadRight(5).ToCharArray();
      this.pvFieldsIntern.a_020 = this.pvFields.fldEmissao.PadRight(5).ToCharArray();
      this.pvFieldsIntern.a_025 = this.pvFields.fldSerie.PadRight(5).ToCharArray();
      this.pvFieldsIntern.a_030 = this.pvFields.fldEspecie.PadRight(5).ToCharArray();
      this.pvFieldsIntern.a_035 = this.pvFields.fldNumero;
      this.pvFieldsIntern.a_039 = this.pvFields.fldNumeroAte;
      this.pvFieldsIntern.a_043 = this.pvFields.fldCNPJ.PadRight(21).ToCharArray();
      this.pvFieldsIntern.a_064 = this.pvFields.fldSituacao;
      this.pvFieldsIntern.a_066 = this.pvFields.fldUF.PadRight(2).ToCharArray();
      this.pvFieldsIntern.a_068 = this.pvFields.fldContaContabil.PadRight(12).ToCharArray();
      this.pvFieldsIntern.a_080 = this.pvFields.fldObservacao.PadRight(20).ToCharArray();
      this.pvFieldsIntern.a_100 = this.pvFields.fldValorContabil;
      this.pvFieldsIntern.a_108 = this.pvFields.fldunnamed_17;
      this.pvFieldsIntern.a_110 = this.pvFields.fldBaseCalculoICMS1;
      this.pvFieldsIntern.a_118 = this.pvFields.fldBaseCalculoICMS2;
      this.pvFieldsIntern.a_126 = this.pvFields.fldBaseCalculoICMS3;
      this.pvFieldsIntern.a_134 = this.pvFields.fldBaseCalculoICMS4;
      this.pvFieldsIntern.a_142 = this.pvFields.fldBaseCalculoICMS5;
      this.pvFieldsIntern.a_150 = this.pvFields.fldAliquotaICMS1;
      this.pvFieldsIntern.a_158 = this.pvFields.fldAliquotaICMS2;
      this.pvFieldsIntern.a_166 = this.pvFields.fldAliquotaICMS3;
      this.pvFieldsIntern.a_174 = this.pvFields.fldAliquotaICMS4;
      this.pvFieldsIntern.a_182 = this.pvFields.fldAliquotaICMS5;
      this.pvFieldsIntern.a_190 = this.pvFields.fldValorICMS1;
      this.pvFieldsIntern.a_198 = this.pvFields.fldValorICMS2;
      this.pvFieldsIntern.a_206 = this.pvFields.fldValorICMS3;
      this.pvFieldsIntern.a_214 = this.pvFields.fldValorICMS4;
      this.pvFieldsIntern.a_222 = this.pvFields.fldValorICMS5;
      this.pvFieldsIntern.a_230 = this.pvFields.fldIsentoICMS1;
      this.pvFieldsIntern.a_238 = this.pvFields.fldIsentoICMS2;
      this.pvFieldsIntern.a_246 = this.pvFields.fldIsentoICMS3;
      this.pvFieldsIntern.a_254 = this.pvFields.fldIsentoICMS4;
      this.pvFieldsIntern.a_262 = this.pvFields.fldIsentoICMS5;
      this.pvFieldsIntern.a_270 = this.pvFields.fldOutrosICMS1;
      this.pvFieldsIntern.a_278 = this.pvFields.fldOutrosICMS2;
      this.pvFieldsIntern.a_286 = this.pvFields.fldOutrosICMS3;
      this.pvFieldsIntern.a_294 = this.pvFields.fldOutrosICMS4;
      this.pvFieldsIntern.a_302 = this.pvFields.fldOutrosICMS5;
      this.pvFieldsIntern.a_310 = this.pvFields.fldTipoLancamento1;
      this.pvFieldsIntern.a_312 = this.pvFields.fldTipoLancamento2;
      this.pvFieldsIntern.a_314 = this.pvFields.fldTipoLancamento3;
      this.pvFieldsIntern.a_316 = this.pvFields.fldTipoLancamento4;
      this.pvFieldsIntern.a_318 = this.pvFields.fldTipoLancamento5;
      this.pvFieldsIntern.a_320 = this.pvFields.fldBaseCalculoIPI;
      this.pvFieldsIntern.a_328 = this.pvFields.fldValorIPI;
      this.pvFieldsIntern.a_336 = this.pvFields.fldIsentoIPI;
      this.pvFieldsIntern.a_344 = this.pvFields.fldOutrasIPI;
      this.pvFieldsIntern.a_352 = this.pvFields.fldICMSFonte;
      this.pvFieldsIntern.a_360 = this.pvFields.fldDesconto;
      this.pvFieldsIntern.a_368 = this.pvFields.fldMunicipio.PadRight(8).ToCharArray();
      this.pvFieldsIntern.a_376 = this.pvFields.fldAVista;
      this.pvFieldsIntern.a_384 = this.pvFields.fldAPrazo;
      this.pvFieldsIntern.a_392 = this.pvFields.fldunnamed_24;
      this.pvFieldsIntern.a_394 = this.pvFields.fldunnamed_208;
      this.pvFieldsIntern.a_396 = this.pvFields.fldunnamed_67.PadRight(180).ToCharArray();
      this.pvFieldsIntern.a_576 = this.pvFields.fldunnamed_68.PadRight(40).ToCharArray();
      this.pvFieldsIntern.a_616 = this.pvFields.fldunnamed_71;
      this.pvFieldsIntern.a_618 = this.pvFields.fldunnamed_207;
      this.pvFieldsIntern.a_622 = this.pvFields.fldunnamed_126;
      this.pvFieldsIntern.a_626 = this.pvFields.fldCentenaCFOP;
      this.pvFieldsIntern.a_628 = this.pvFields.fldunnamed_72.PadRight(34).ToCharArray();
      this.pvFieldsIntern.a_662 = this.pvFields.fldPISIsento;
      this.pvFieldsIntern.a_670 = this.pvFields.fldunnamed_66;
      this.pvFieldsIntern.a_678 = this.pvFields.fldBaseICMSFonte;
      this.pvFieldsIntern.a_686 = this.pvFields.fldAbatimento;
      this.pvFieldsIntern.a_694 = this.pvFields.fldCofinsIsento;
      this.pvFieldsIntern.a_702 = this.pvFields.fldPVV;
      this.pvFieldsIntern.a_710 = this.pvFields.fldunnamed_62.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_720 = this.pvFields.fldunnamed_60.PadRight(10).ToCharArray();
      this.pvFieldsIntern.a_730 = this.pvFields.fldunnamed_61.PadRight(40).ToCharArray();
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
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldOperacao.PadRight(1).ToCharArray();
        this.pvFieldsIntern.a_005 = this.pvFieldsExtr[index].fldunnamed_2;
        this.pvFieldsIntern.a_007 = this.pvFieldsExtr[index].fldunnamed_3;
        this.pvFieldsIntern.a_009 = this.pvFieldsExtr[index].fldunnamed_4;
        this.pvFieldsIntern.a_011 = this.pvFieldsExtr[index].fldunnamed_5;
        this.pvFieldsIntern.a_015 = this.pvFieldsExtr[index].fldData.PadRight(5).ToCharArray();
        this.pvFieldsIntern.a_020 = this.pvFieldsExtr[index].fldEmissao.PadRight(5).ToCharArray();
        this.pvFieldsIntern.a_025 = this.pvFieldsExtr[index].fldSerie.PadRight(5).ToCharArray();
        this.pvFieldsIntern.a_030 = this.pvFieldsExtr[index].fldEspecie.PadRight(5).ToCharArray();
        this.pvFieldsIntern.a_035 = this.pvFieldsExtr[index].fldNumero;
        this.pvFieldsIntern.a_039 = this.pvFieldsExtr[index].fldNumeroAte;
        this.pvFieldsIntern.a_043 = this.pvFieldsExtr[index].fldCNPJ.PadRight(21).ToCharArray();
        this.pvFieldsIntern.a_064 = this.pvFieldsExtr[index].fldSituacao;
        this.pvFieldsIntern.a_066 = this.pvFieldsExtr[index].fldUF.PadRight(2).ToCharArray();
        this.pvFieldsIntern.a_068 = this.pvFieldsExtr[index].fldContaContabil.PadRight(12).ToCharArray();
        this.pvFieldsIntern.a_080 = this.pvFieldsExtr[index].fldObservacao.PadRight(20).ToCharArray();
        this.pvFieldsIntern.a_100 = this.pvFieldsExtr[index].fldValorContabil;
        this.pvFieldsIntern.a_108 = this.pvFieldsExtr[index].fldunnamed_17;
        this.pvFieldsIntern.a_110 = this.pvFieldsExtr[index].fldBaseCalculoICMS1;
        this.pvFieldsIntern.a_118 = this.pvFieldsExtr[index].fldBaseCalculoICMS2;
        this.pvFieldsIntern.a_126 = this.pvFieldsExtr[index].fldBaseCalculoICMS3;
        this.pvFieldsIntern.a_134 = this.pvFieldsExtr[index].fldBaseCalculoICMS4;
        this.pvFieldsIntern.a_142 = this.pvFieldsExtr[index].fldBaseCalculoICMS5;
        this.pvFieldsIntern.a_150 = this.pvFieldsExtr[index].fldAliquotaICMS1;
        this.pvFieldsIntern.a_158 = this.pvFieldsExtr[index].fldAliquotaICMS2;
        this.pvFieldsIntern.a_166 = this.pvFieldsExtr[index].fldAliquotaICMS3;
        this.pvFieldsIntern.a_174 = this.pvFieldsExtr[index].fldAliquotaICMS4;
        this.pvFieldsIntern.a_182 = this.pvFieldsExtr[index].fldAliquotaICMS5;
        this.pvFieldsIntern.a_190 = this.pvFieldsExtr[index].fldValorICMS1;
        this.pvFieldsIntern.a_198 = this.pvFieldsExtr[index].fldValorICMS2;
        this.pvFieldsIntern.a_206 = this.pvFieldsExtr[index].fldValorICMS3;
        this.pvFieldsIntern.a_214 = this.pvFieldsExtr[index].fldValorICMS4;
        this.pvFieldsIntern.a_222 = this.pvFieldsExtr[index].fldValorICMS5;
        this.pvFieldsIntern.a_230 = this.pvFieldsExtr[index].fldIsentoICMS1;
        this.pvFieldsIntern.a_238 = this.pvFieldsExtr[index].fldIsentoICMS2;
        this.pvFieldsIntern.a_246 = this.pvFieldsExtr[index].fldIsentoICMS3;
        this.pvFieldsIntern.a_254 = this.pvFieldsExtr[index].fldIsentoICMS4;
        this.pvFieldsIntern.a_262 = this.pvFieldsExtr[index].fldIsentoICMS5;
        this.pvFieldsIntern.a_270 = this.pvFieldsExtr[index].fldOutrosICMS1;
        this.pvFieldsIntern.a_278 = this.pvFieldsExtr[index].fldOutrosICMS2;
        this.pvFieldsIntern.a_286 = this.pvFieldsExtr[index].fldOutrosICMS3;
        this.pvFieldsIntern.a_294 = this.pvFieldsExtr[index].fldOutrosICMS4;
        this.pvFieldsIntern.a_302 = this.pvFieldsExtr[index].fldOutrosICMS5;
        this.pvFieldsIntern.a_310 = this.pvFieldsExtr[index].fldTipoLancamento1;
        this.pvFieldsIntern.a_312 = this.pvFieldsExtr[index].fldTipoLancamento2;
        this.pvFieldsIntern.a_314 = this.pvFieldsExtr[index].fldTipoLancamento3;
        this.pvFieldsIntern.a_316 = this.pvFieldsExtr[index].fldTipoLancamento4;
        this.pvFieldsIntern.a_318 = this.pvFieldsExtr[index].fldTipoLancamento5;
        this.pvFieldsIntern.a_320 = this.pvFieldsExtr[index].fldBaseCalculoIPI;
        this.pvFieldsIntern.a_328 = this.pvFieldsExtr[index].fldValorIPI;
        this.pvFieldsIntern.a_336 = this.pvFieldsExtr[index].fldIsentoIPI;
        this.pvFieldsIntern.a_344 = this.pvFieldsExtr[index].fldOutrasIPI;
        this.pvFieldsIntern.a_352 = this.pvFieldsExtr[index].fldICMSFonte;
        this.pvFieldsIntern.a_360 = this.pvFieldsExtr[index].fldDesconto;
        this.pvFieldsIntern.a_368 = this.pvFieldsExtr[index].fldMunicipio.PadRight(8).ToCharArray();
        this.pvFieldsIntern.a_376 = this.pvFieldsExtr[index].fldAVista;
        this.pvFieldsIntern.a_384 = this.pvFieldsExtr[index].fldAPrazo;
        this.pvFieldsIntern.a_392 = this.pvFieldsExtr[index].fldunnamed_24;
        this.pvFieldsIntern.a_394 = this.pvFieldsExtr[index].fldunnamed_208;
        this.pvFieldsIntern.a_396 = this.pvFieldsExtr[index].fldunnamed_67.PadRight(180).ToCharArray();
        this.pvFieldsIntern.a_576 = this.pvFieldsExtr[index].fldunnamed_68.PadRight(40).ToCharArray();
        this.pvFieldsIntern.a_616 = this.pvFieldsExtr[index].fldunnamed_71;
        this.pvFieldsIntern.a_618 = this.pvFieldsExtr[index].fldunnamed_207;
        this.pvFieldsIntern.a_622 = this.pvFieldsExtr[index].fldunnamed_126;
        this.pvFieldsIntern.a_626 = this.pvFieldsExtr[index].fldCentenaCFOP;
        this.pvFieldsIntern.a_628 = this.pvFieldsExtr[index].fldunnamed_72.PadRight(34).ToCharArray();
        this.pvFieldsIntern.a_662 = this.pvFieldsExtr[index].fldPISIsento;
        this.pvFieldsIntern.a_670 = this.pvFieldsExtr[index].fldunnamed_66;
        this.pvFieldsIntern.a_678 = this.pvFieldsExtr[index].fldBaseICMSFonte;
        this.pvFieldsIntern.a_686 = this.pvFieldsExtr[index].fldAbatimento;
        this.pvFieldsIntern.a_694 = this.pvFieldsExtr[index].fldCofinsIsento;
        this.pvFieldsIntern.a_702 = this.pvFieldsExtr[index].fldPVV;
        this.pvFieldsIntern.a_710 = this.pvFieldsExtr[index].fldunnamed_62.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_720 = this.pvFieldsExtr[index].fldunnamed_60.PadRight(10).ToCharArray();
        this.pvFieldsIntern.a_730 = this.pvFieldsExtr[index].fldunnamed_61.PadRight(40).ToCharArray();
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 770);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 770));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(Notas.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(Notas.OpenModes Mode)
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

    public virtual short btrInsert(Notas.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 770;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(Notas.KeyName Key_nr)
    {
      short num1 = (short) 770;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(Notas.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 770;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(Notas.KeyName Key_nr)
    {
      short num1 = (short) 770;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(Notas.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetNext(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetNext(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetNext(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(Notas.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetNext(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetNext(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(Notas.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(Notas.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(Notas.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(Notas.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetGreater(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetGreaterThanOrEqual(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(Notas.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetGreaterThanOrEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLessThan(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(Notas.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLessThan(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLessThanOrEqual(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(Notas.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLessThanOrEqual(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetFirst(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(Notas.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetFirst(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLast(Notas.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(Notas.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
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

    public virtual short btrGetLast(Notas.KeyName Key_nr, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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
      short num1 = (short) 770;
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

    public virtual short btrGetDirectRecord(Notas.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(Notas.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(Notas.KeyName Key_nr, IntPtr Position, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(Notas.KeyName Key_nr, IntPtr Position, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
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
      return this.btrStepNext(Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(Notas.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(Notas.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(Notas.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (772 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(Notas.KeyName Key_nr)
    {
      short num1 = checked ((short) (772 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= Notas.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(Notas.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, Notas.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(Notas.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, Notas.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(Notas.KeyName Key_nr, short Percentage, Notas.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(Notas.KeyName Key_nr, short Percentage, Notas.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 770;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(Notas.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(Notas.KeyName Key_nr, ref short Percentage)
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
      private Notas.KeysStruct.struct_02 idxindex_2_priv;
      private Notas.KeysStruct.struct_04 idxindex_4_priv;
      private Notas.KeysStruct.struct_06 idxindex_6_priv;
      private Notas.KeysStruct.struct_01 idxindex_1_priv;
      private Notas.KeysStruct.struct_03 idxUK_Id_priv;
      private Notas.KeysStruct.struct_05 idxindex_5_priv;
      private Notas.KeysStruct.struct_07 idxindex_7_priv;
      private Notas.KeysStruct.struct_00 idxindex_0_priv;

      public Notas.KeysStruct.struct_02 idxindex_2
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

      public Notas.KeysStruct.struct_04 idxindex_4
      {
        get
        {
          return this.idxindex_4_priv;
        }
        set
        {
          this.idxindex_4_priv = value;
        }
      }

      public Notas.KeysStruct.struct_06 idxindex_6
      {
        get
        {
          return this.idxindex_6_priv;
        }
        set
        {
          this.idxindex_6_priv = value;
        }
      }

      public Notas.KeysStruct.struct_01 idxindex_1
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

      public Notas.KeysStruct.struct_03 idxUK_Id
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

      public Notas.KeysStruct.struct_05 idxindex_5
      {
        get
        {
          return this.idxindex_5_priv;
        }
        set
        {
          this.idxindex_5_priv = value;
        }
      }

      public Notas.KeysStruct.struct_07 idxindex_7
      {
        get
        {
          return this.idxindex_7_priv;
        }
        set
        {
          this.idxindex_7_priv = value;
        }
      }

      public Notas.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_2_priv = new Notas.KeysStruct.struct_02();
        this.idxindex_4_priv = new Notas.KeysStruct.struct_04();
        this.idxindex_6_priv = new Notas.KeysStruct.struct_06();
        this.idxindex_1_priv = new Notas.KeysStruct.struct_01();
        this.idxUK_Id_priv = new Notas.KeysStruct.struct_03();
        this.idxindex_5_priv = new Notas.KeysStruct.struct_05();
        this.idxindex_7_priv = new Notas.KeysStruct.struct_07();
        this.idxindex_0_priv = new Notas.KeysStruct.struct_00();
      }

      public class struct_00
      {
        private string sgmOperacao_priv;
        private short sgmunnamed_4_priv;
        private short sgmunnamed_3_priv;
        private int sgmNumero_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public short sgmunnamed_4
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

        public int sgmNumero
        {
          get
          {
            return this.sgmNumero_priv;
          }
          set
          {
            this.sgmNumero_priv = value;
          }
        }

        public struct_00()
        {
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmunnamed_4_priv = (short) 0;
          this.sgmunnamed_3_priv = (short) 0;
          this.sgmNumero_priv = 0;
        }
      }

      public class struct_01
      {
        private string sgmOperacao_priv;
        private short sgmunnamed_4_priv;
        private int sgmNumero_priv;
        private string sgmCNPJ_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public short sgmunnamed_4
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

        public int sgmNumero
        {
          get
          {
            return this.sgmNumero_priv;
          }
          set
          {
            this.sgmNumero_priv = value;
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

        public struct_01()
        {
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmunnamed_4_priv = (short) 0;
          this.sgmNumero_priv = 0;
          this.sgmCNPJ_priv = string.Empty;
        }
      }

      public class struct_02
      {
        private string sgmOperacao_priv;
        private int sgmNumero_priv;
        private string sgmCNPJ_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public int sgmNumero
        {
          get
          {
            return this.sgmNumero_priv;
          }
          set
          {
            this.sgmNumero_priv = value;
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
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmNumero_priv = 0;
          this.sgmCNPJ_priv = string.Empty;
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

      public class struct_04
      {
        private short sgmunnamed_4_priv;
        private int sgmunnamed_5_priv;
        private int sgmNumero_priv;

        public short sgmunnamed_4
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

        public int sgmunnamed_5
        {
          get
          {
            return this.sgmunnamed_5_priv;
          }
          set
          {
            this.sgmunnamed_5_priv = value;
          }
        }

        public int sgmNumero
        {
          get
          {
            return this.sgmNumero_priv;
          }
          set
          {
            this.sgmNumero_priv = value;
          }
        }

        public struct_04()
        {
          
          this.sgmunnamed_4_priv = (short) 0;
          this.sgmunnamed_5_priv = 0;
          this.sgmNumero_priv = 0;
        }
      }

      public class struct_05
      {
        private string sgmOperacao_priv;
        private short sgmunnamed_4_priv;
        private short sgmunnamed_2_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public short sgmunnamed_4
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

        public struct_05()
        {
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmunnamed_4_priv = (short) 0;
          this.sgmunnamed_2_priv = (short) 0;
        }
      }

      public class struct_06
      {
        private string sgmOperacao_priv;
        private short sgmunnamed_4_priv;
        private string sgmCNPJ_priv;
        private short sgmunnamed_3_priv;
        private int sgmNumero_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public short sgmunnamed_4
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

        public int sgmNumero
        {
          get
          {
            return this.sgmNumero_priv;
          }
          set
          {
            this.sgmNumero_priv = value;
          }
        }

        public struct_06()
        {
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmunnamed_4_priv = (short) 0;
          this.sgmCNPJ_priv = string.Empty;
          this.sgmunnamed_3_priv = (short) 0;
          this.sgmNumero_priv = 0;
        }
      }

      public class struct_07
      {
        private string sgmOperacao_priv;
        private short sgmunnamed_4_priv;

        public string sgmOperacao
        {
          get
          {
            return this.sgmOperacao_priv;
          }
          set
          {
            this.sgmOperacao_priv = value;
          }
        }

        public short sgmunnamed_4
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

        public struct_07()
        {
          
          this.sgmOperacao_priv = string.Empty;
          this.sgmunnamed_4_priv = (short) 0;
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
      index_4 = 4,
      index_5 = 5,
      index_6 = 6,
      index_7 = 7,
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

    [StructLayout(LayoutKind.Sequential, Size = 770, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
      internal char[] a_004;
      internal short a_005;
      internal short a_007;
      internal short a_009;
      internal int a_011;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
      internal char[] a_015;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
      internal char[] a_020;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
      internal char[] a_025;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
      internal char[] a_030;
      internal int a_035;
      internal int a_039;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 21)]
      internal char[] a_043;
      internal short a_064;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
      internal char[] a_066;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
      internal char[] a_068;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
      internal char[] a_080;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_100;
      internal short a_108;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_110;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_118;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_126;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_134;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_142;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_150;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_158;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_166;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_174;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_182;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_190;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_198;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_206;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_214;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_222;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_230;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_238;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_246;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_254;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_262;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_270;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_278;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_286;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_294;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_302;
      internal short a_310;
      internal short a_312;
      internal short a_314;
      internal short a_316;
      internal short a_318;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_320;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_328;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_336;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_344;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_352;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_360;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
      internal char[] a_368;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_376;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_384;
      internal short a_392;
      internal short a_394;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 180)]
      internal char[] a_396;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_576;
      internal short a_616;
      internal int a_618;
      internal int a_622;
      internal short a_626;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 34)]
      internal char[] a_628;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_662;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_670;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_678;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_686;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_694;
      [MarshalAs(UnmanagedType.R8)]
      internal double a_702;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_710;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
      internal char[] a_720;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
      internal char[] a_730;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldId_priv;
      private string fldOperacao_priv;
      private short fldunnamed_2_priv;
      private short fldunnamed_3_priv;
      private short fldunnamed_4_priv;
      private int fldunnamed_5_priv;
      private string fldData_priv;
      private string fldEmissao_priv;
      private string fldSerie_priv;
      private string fldEspecie_priv;
      private int fldNumero_priv;
      private int fldNumeroAte_priv;
      private string fldCNPJ_priv;
      private short fldSituacao_priv;
      private string fldUF_priv;
      private string fldContaContabil_priv;
      private string fldObservacao_priv;
      private double fldValorContabil_priv;
      private short fldunnamed_17_priv;
      private double fldBaseCalculoICMS1_priv;
      private double fldBaseCalculoICMS2_priv;
      private double fldBaseCalculoICMS3_priv;
      private double fldBaseCalculoICMS4_priv;
      private double fldBaseCalculoICMS5_priv;
      private double fldAliquotaICMS1_priv;
      private double fldAliquotaICMS2_priv;
      private double fldAliquotaICMS3_priv;
      private double fldAliquotaICMS4_priv;
      private double fldAliquotaICMS5_priv;
      private double fldValorICMS1_priv;
      private double fldValorICMS2_priv;
      private double fldValorICMS3_priv;
      private double fldValorICMS4_priv;
      private double fldValorICMS5_priv;
      private double fldIsentoICMS1_priv;
      private double fldIsentoICMS2_priv;
      private double fldIsentoICMS3_priv;
      private double fldIsentoICMS4_priv;
      private double fldIsentoICMS5_priv;
      private double fldOutrosICMS1_priv;
      private double fldOutrosICMS2_priv;
      private double fldOutrosICMS3_priv;
      private double fldOutrosICMS4_priv;
      private double fldOutrosICMS5_priv;
      private short fldTipoLancamento1_priv;
      private short fldTipoLancamento2_priv;
      private short fldTipoLancamento3_priv;
      private short fldTipoLancamento4_priv;
      private short fldTipoLancamento5_priv;
      private double fldBaseCalculoIPI_priv;
      private double fldValorIPI_priv;
      private double fldIsentoIPI_priv;
      private double fldOutrasIPI_priv;
      private double fldICMSFonte_priv;
      private double fldDesconto_priv;
      private string fldMunicipio_priv;
      private double fldAVista_priv;
      private double fldAPrazo_priv;
      private short fldunnamed_24_priv;
      private short fldunnamed_208_priv;
      private string fldunnamed_67_priv;
      private string fldunnamed_68_priv;
      private short fldunnamed_71_priv;
      private int fldunnamed_207_priv;
      private int fldunnamed_126_priv;
      private short fldCentenaCFOP_priv;
      private string fldunnamed_72_priv;
      private double fldPISIsento_priv;
      private double fldunnamed_66_priv;
      private double fldBaseICMSFonte_priv;
      private double fldAbatimento_priv;
      private double fldCofinsIsento_priv;
      private double fldPVV_priv;
      private string fldunnamed_62_priv;
      private string fldunnamed_60_priv;
      private string fldunnamed_61_priv;
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

      public string fldOperacao
      {
        get
        {
          return this.fldOperacao_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldOperacao_priv, value, false) == 0)
            return;
          this.fldOperacao_priv = value;
          this.OnPropertyChanged("fldOperacao");
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

      public short fldunnamed_4
      {
        get
        {
          return this.fldunnamed_4_priv;
        }
        set
        {
          if ((int) this.fldunnamed_4_priv == (int) value)
            return;
          this.fldunnamed_4_priv = value;
          this.OnPropertyChanged("fldunnamed_4");
        }
      }

      public int fldunnamed_5
      {
        get
        {
          return this.fldunnamed_5_priv;
        }
        set
        {
          if (this.fldunnamed_5_priv == value)
            return;
          this.fldunnamed_5_priv = value;
          this.OnPropertyChanged("fldunnamed_5");
        }
      }

      public string fldData
      {
        get
        {
          return this.fldData_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldData_priv, value, false) == 0)
            return;
          this.fldData_priv = value;
          this.OnPropertyChanged("fldData");
        }
      }

      public string fldEmissao
      {
        get
        {
          return this.fldEmissao_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEmissao_priv, value, false) == 0)
            return;
          this.fldEmissao_priv = value;
          this.OnPropertyChanged("fldEmissao");
        }
      }

      public string fldSerie
      {
        get
        {
          return this.fldSerie_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldSerie_priv, value, false) == 0)
            return;
          this.fldSerie_priv = value;
          this.OnPropertyChanged("fldSerie");
        }
      }

      public string fldEspecie
      {
        get
        {
          return this.fldEspecie_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldEspecie_priv, value, false) == 0)
            return;
          this.fldEspecie_priv = value;
          this.OnPropertyChanged("fldEspecie");
        }
      }

      public int fldNumero
      {
        get
        {
          return this.fldNumero_priv;
        }
        set
        {
          if (this.fldNumero_priv == value)
            return;
          this.fldNumero_priv = value;
          this.OnPropertyChanged("fldNumero");
        }
      }

      public int fldNumeroAte
      {
        get
        {
          return this.fldNumeroAte_priv;
        }
        set
        {
          if (this.fldNumeroAte_priv == value)
            return;
          this.fldNumeroAte_priv = value;
          this.OnPropertyChanged("fldNumeroAte");
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

      public short fldSituacao
      {
        get
        {
          return this.fldSituacao_priv;
        }
        set
        {
          if ((int) this.fldSituacao_priv == (int) value)
            return;
          this.fldSituacao_priv = value;
          this.OnPropertyChanged("fldSituacao");
        }
      }

      public string fldUF
      {
        get
        {
          return this.fldUF_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldUF_priv, value, false) == 0)
            return;
          this.fldUF_priv = value;
          this.OnPropertyChanged("fldUF");
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

      public string fldObservacao
      {
        get
        {
          return this.fldObservacao_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldObservacao_priv, value, false) == 0)
            return;
          this.fldObservacao_priv = value;
          this.OnPropertyChanged("fldObservacao");
        }
      }

      public double fldValorContabil
      {
        get
        {
          return this.fldValorContabil_priv;
        }
        set
        {
          if (this.fldValorContabil_priv == value)
            return;
          this.fldValorContabil_priv = value;
          this.OnPropertyChanged("fldValorContabil");
        }
      }

      public short fldunnamed_17
      {
        get
        {
          return this.fldunnamed_17_priv;
        }
        set
        {
          if ((int) this.fldunnamed_17_priv == (int) value)
            return;
          this.fldunnamed_17_priv = value;
          this.OnPropertyChanged("fldunnamed_17");
        }
      }

      public double fldBaseCalculoICMS1
      {
        get
        {
          return this.fldBaseCalculoICMS1_priv;
        }
        set
        {
          if (this.fldBaseCalculoICMS1_priv == value)
            return;
          this.fldBaseCalculoICMS1_priv = value;
          this.OnPropertyChanged("fldBaseCalculoICMS1");
        }
      }

      public double fldBaseCalculoICMS2
      {
        get
        {
          return this.fldBaseCalculoICMS2_priv;
        }
        set
        {
          if (this.fldBaseCalculoICMS2_priv == value)
            return;
          this.fldBaseCalculoICMS2_priv = value;
          this.OnPropertyChanged("fldBaseCalculoICMS2");
        }
      }

      public double fldBaseCalculoICMS3
      {
        get
        {
          return this.fldBaseCalculoICMS3_priv;
        }
        set
        {
          if (this.fldBaseCalculoICMS3_priv == value)
            return;
          this.fldBaseCalculoICMS3_priv = value;
          this.OnPropertyChanged("fldBaseCalculoICMS3");
        }
      }

      public double fldBaseCalculoICMS4
      {
        get
        {
          return this.fldBaseCalculoICMS4_priv;
        }
        set
        {
          if (this.fldBaseCalculoICMS4_priv == value)
            return;
          this.fldBaseCalculoICMS4_priv = value;
          this.OnPropertyChanged("fldBaseCalculoICMS4");
        }
      }

      public double fldBaseCalculoICMS5
      {
        get
        {
          return this.fldBaseCalculoICMS5_priv;
        }
        set
        {
          if (this.fldBaseCalculoICMS5_priv == value)
            return;
          this.fldBaseCalculoICMS5_priv = value;
          this.OnPropertyChanged("fldBaseCalculoICMS5");
        }
      }

      public double fldAliquotaICMS1
      {
        get
        {
          return this.fldAliquotaICMS1_priv;
        }
        set
        {
          if (this.fldAliquotaICMS1_priv == value)
            return;
          this.fldAliquotaICMS1_priv = value;
          this.OnPropertyChanged("fldAliquotaICMS1");
        }
      }

      public double fldAliquotaICMS2
      {
        get
        {
          return this.fldAliquotaICMS2_priv;
        }
        set
        {
          if (this.fldAliquotaICMS2_priv == value)
            return;
          this.fldAliquotaICMS2_priv = value;
          this.OnPropertyChanged("fldAliquotaICMS2");
        }
      }

      public double fldAliquotaICMS3
      {
        get
        {
          return this.fldAliquotaICMS3_priv;
        }
        set
        {
          if (this.fldAliquotaICMS3_priv == value)
            return;
          this.fldAliquotaICMS3_priv = value;
          this.OnPropertyChanged("fldAliquotaICMS3");
        }
      }

      public double fldAliquotaICMS4
      {
        get
        {
          return this.fldAliquotaICMS4_priv;
        }
        set
        {
          if (this.fldAliquotaICMS4_priv == value)
            return;
          this.fldAliquotaICMS4_priv = value;
          this.OnPropertyChanged("fldAliquotaICMS4");
        }
      }

      public double fldAliquotaICMS5
      {
        get
        {
          return this.fldAliquotaICMS5_priv;
        }
        set
        {
          if (this.fldAliquotaICMS5_priv == value)
            return;
          this.fldAliquotaICMS5_priv = value;
          this.OnPropertyChanged("fldAliquotaICMS5");
        }
      }

      public double fldValorICMS1
      {
        get
        {
          return this.fldValorICMS1_priv;
        }
        set
        {
          if (this.fldValorICMS1_priv == value)
            return;
          this.fldValorICMS1_priv = value;
          this.OnPropertyChanged("fldValorICMS1");
        }
      }

      public double fldValorICMS2
      {
        get
        {
          return this.fldValorICMS2_priv;
        }
        set
        {
          if (this.fldValorICMS2_priv == value)
            return;
          this.fldValorICMS2_priv = value;
          this.OnPropertyChanged("fldValorICMS2");
        }
      }

      public double fldValorICMS3
      {
        get
        {
          return this.fldValorICMS3_priv;
        }
        set
        {
          if (this.fldValorICMS3_priv == value)
            return;
          this.fldValorICMS3_priv = value;
          this.OnPropertyChanged("fldValorICMS3");
        }
      }

      public double fldValorICMS4
      {
        get
        {
          return this.fldValorICMS4_priv;
        }
        set
        {
          if (this.fldValorICMS4_priv == value)
            return;
          this.fldValorICMS4_priv = value;
          this.OnPropertyChanged("fldValorICMS4");
        }
      }

      public double fldValorICMS5
      {
        get
        {
          return this.fldValorICMS5_priv;
        }
        set
        {
          if (this.fldValorICMS5_priv == value)
            return;
          this.fldValorICMS5_priv = value;
          this.OnPropertyChanged("fldValorICMS5");
        }
      }

      public double fldIsentoICMS1
      {
        get
        {
          return this.fldIsentoICMS1_priv;
        }
        set
        {
          if (this.fldIsentoICMS1_priv == value)
            return;
          this.fldIsentoICMS1_priv = value;
          this.OnPropertyChanged("fldIsentoICMS1");
        }
      }

      public double fldIsentoICMS2
      {
        get
        {
          return this.fldIsentoICMS2_priv;
        }
        set
        {
          if (this.fldIsentoICMS2_priv == value)
            return;
          this.fldIsentoICMS2_priv = value;
          this.OnPropertyChanged("fldIsentoICMS2");
        }
      }

      public double fldIsentoICMS3
      {
        get
        {
          return this.fldIsentoICMS3_priv;
        }
        set
        {
          if (this.fldIsentoICMS3_priv == value)
            return;
          this.fldIsentoICMS3_priv = value;
          this.OnPropertyChanged("fldIsentoICMS3");
        }
      }

      public double fldIsentoICMS4
      {
        get
        {
          return this.fldIsentoICMS4_priv;
        }
        set
        {
          if (this.fldIsentoICMS4_priv == value)
            return;
          this.fldIsentoICMS4_priv = value;
          this.OnPropertyChanged("fldIsentoICMS4");
        }
      }

      public double fldIsentoICMS5
      {
        get
        {
          return this.fldIsentoICMS5_priv;
        }
        set
        {
          if (this.fldIsentoICMS5_priv == value)
            return;
          this.fldIsentoICMS5_priv = value;
          this.OnPropertyChanged("fldIsentoICMS5");
        }
      }

      public double fldOutrosICMS1
      {
        get
        {
          return this.fldOutrosICMS1_priv;
        }
        set
        {
          if (this.fldOutrosICMS1_priv == value)
            return;
          this.fldOutrosICMS1_priv = value;
          this.OnPropertyChanged("fldOutrosICMS1");
        }
      }

      public double fldOutrosICMS2
      {
        get
        {
          return this.fldOutrosICMS2_priv;
        }
        set
        {
          if (this.fldOutrosICMS2_priv == value)
            return;
          this.fldOutrosICMS2_priv = value;
          this.OnPropertyChanged("fldOutrosICMS2");
        }
      }

      public double fldOutrosICMS3
      {
        get
        {
          return this.fldOutrosICMS3_priv;
        }
        set
        {
          if (this.fldOutrosICMS3_priv == value)
            return;
          this.fldOutrosICMS3_priv = value;
          this.OnPropertyChanged("fldOutrosICMS3");
        }
      }

      public double fldOutrosICMS4
      {
        get
        {
          return this.fldOutrosICMS4_priv;
        }
        set
        {
          if (this.fldOutrosICMS4_priv == value)
            return;
          this.fldOutrosICMS4_priv = value;
          this.OnPropertyChanged("fldOutrosICMS4");
        }
      }

      public double fldOutrosICMS5
      {
        get
        {
          return this.fldOutrosICMS5_priv;
        }
        set
        {
          if (this.fldOutrosICMS5_priv == value)
            return;
          this.fldOutrosICMS5_priv = value;
          this.OnPropertyChanged("fldOutrosICMS5");
        }
      }

      public short fldTipoLancamento1
      {
        get
        {
          return this.fldTipoLancamento1_priv;
        }
        set
        {
          if ((int) this.fldTipoLancamento1_priv == (int) value)
            return;
          this.fldTipoLancamento1_priv = value;
          this.OnPropertyChanged("fldTipoLancamento1");
        }
      }

      public short fldTipoLancamento2
      {
        get
        {
          return this.fldTipoLancamento2_priv;
        }
        set
        {
          if ((int) this.fldTipoLancamento2_priv == (int) value)
            return;
          this.fldTipoLancamento2_priv = value;
          this.OnPropertyChanged("fldTipoLancamento2");
        }
      }

      public short fldTipoLancamento3
      {
        get
        {
          return this.fldTipoLancamento3_priv;
        }
        set
        {
          if ((int) this.fldTipoLancamento3_priv == (int) value)
            return;
          this.fldTipoLancamento3_priv = value;
          this.OnPropertyChanged("fldTipoLancamento3");
        }
      }

      public short fldTipoLancamento4
      {
        get
        {
          return this.fldTipoLancamento4_priv;
        }
        set
        {
          if ((int) this.fldTipoLancamento4_priv == (int) value)
            return;
          this.fldTipoLancamento4_priv = value;
          this.OnPropertyChanged("fldTipoLancamento4");
        }
      }

      public short fldTipoLancamento5
      {
        get
        {
          return this.fldTipoLancamento5_priv;
        }
        set
        {
          if ((int) this.fldTipoLancamento5_priv == (int) value)
            return;
          this.fldTipoLancamento5_priv = value;
          this.OnPropertyChanged("fldTipoLancamento5");
        }
      }

      public double fldBaseCalculoIPI
      {
        get
        {
          return this.fldBaseCalculoIPI_priv;
        }
        set
        {
          if (this.fldBaseCalculoIPI_priv == value)
            return;
          this.fldBaseCalculoIPI_priv = value;
          this.OnPropertyChanged("fldBaseCalculoIPI");
        }
      }

      public double fldValorIPI
      {
        get
        {
          return this.fldValorIPI_priv;
        }
        set
        {
          if (this.fldValorIPI_priv == value)
            return;
          this.fldValorIPI_priv = value;
          this.OnPropertyChanged("fldValorIPI");
        }
      }

      public double fldIsentoIPI
      {
        get
        {
          return this.fldIsentoIPI_priv;
        }
        set
        {
          if (this.fldIsentoIPI_priv == value)
            return;
          this.fldIsentoIPI_priv = value;
          this.OnPropertyChanged("fldIsentoIPI");
        }
      }

      public double fldOutrasIPI
      {
        get
        {
          return this.fldOutrasIPI_priv;
        }
        set
        {
          if (this.fldOutrasIPI_priv == value)
            return;
          this.fldOutrasIPI_priv = value;
          this.OnPropertyChanged("fldOutrasIPI");
        }
      }

      public double fldICMSFonte
      {
        get
        {
          return this.fldICMSFonte_priv;
        }
        set
        {
          if (this.fldICMSFonte_priv == value)
            return;
          this.fldICMSFonte_priv = value;
          this.OnPropertyChanged("fldICMSFonte");
        }
      }

      public double fldDesconto
      {
        get
        {
          return this.fldDesconto_priv;
        }
        set
        {
          if (this.fldDesconto_priv == value)
            return;
          this.fldDesconto_priv = value;
          this.OnPropertyChanged("fldDesconto");
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

      public double fldAVista
      {
        get
        {
          return this.fldAVista_priv;
        }
        set
        {
          if (this.fldAVista_priv == value)
            return;
          this.fldAVista_priv = value;
          this.OnPropertyChanged("fldAVista");
        }
      }

      public double fldAPrazo
      {
        get
        {
          return this.fldAPrazo_priv;
        }
        set
        {
          if (this.fldAPrazo_priv == value)
            return;
          this.fldAPrazo_priv = value;
          this.OnPropertyChanged("fldAPrazo");
        }
      }

      public short fldunnamed_24
      {
        get
        {
          return this.fldunnamed_24_priv;
        }
        set
        {
          if ((int) this.fldunnamed_24_priv == (int) value)
            return;
          this.fldunnamed_24_priv = value;
          this.OnPropertyChanged("fldunnamed_24");
        }
      }

      public short fldunnamed_208
      {
        get
        {
          return this.fldunnamed_208_priv;
        }
        set
        {
          if ((int) this.fldunnamed_208_priv == (int) value)
            return;
          this.fldunnamed_208_priv = value;
          this.OnPropertyChanged("fldunnamed_208");
        }
      }

      public string fldunnamed_67
      {
        get
        {
          return this.fldunnamed_67_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_67_priv, value, false) == 0)
            return;
          this.fldunnamed_67_priv = value;
          this.OnPropertyChanged("fldunnamed_67");
        }
      }

      public string fldunnamed_68
      {
        get
        {
          return this.fldunnamed_68_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_68_priv, value, false) == 0)
            return;
          this.fldunnamed_68_priv = value;
          this.OnPropertyChanged("fldunnamed_68");
        }
      }

      public short fldunnamed_71
      {
        get
        {
          return this.fldunnamed_71_priv;
        }
        set
        {
          if ((int) this.fldunnamed_71_priv == (int) value)
            return;
          this.fldunnamed_71_priv = value;
          this.OnPropertyChanged("fldunnamed_71");
        }
      }

      public int fldunnamed_207
      {
        get
        {
          return this.fldunnamed_207_priv;
        }
        set
        {
          if (this.fldunnamed_207_priv == value)
            return;
          this.fldunnamed_207_priv = value;
          this.OnPropertyChanged("fldunnamed_207");
        }
      }

      public int fldunnamed_126
      {
        get
        {
          return this.fldunnamed_126_priv;
        }
        set
        {
          if (this.fldunnamed_126_priv == value)
            return;
          this.fldunnamed_126_priv = value;
          this.OnPropertyChanged("fldunnamed_126");
        }
      }

      public short fldCentenaCFOP
      {
        get
        {
          return this.fldCentenaCFOP_priv;
        }
        set
        {
          if ((int) this.fldCentenaCFOP_priv == (int) value)
            return;
          this.fldCentenaCFOP_priv = value;
          this.OnPropertyChanged("fldCentenaCFOP");
        }
      }

      public string fldunnamed_72
      {
        get
        {
          return this.fldunnamed_72_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldunnamed_72_priv, value, false) == 0)
            return;
          this.fldunnamed_72_priv = value;
          this.OnPropertyChanged("fldunnamed_72");
        }
      }

      public double fldPISIsento
      {
        get
        {
          return this.fldPISIsento_priv;
        }
        set
        {
          if (this.fldPISIsento_priv == value)
            return;
          this.fldPISIsento_priv = value;
          this.OnPropertyChanged("fldPISIsento");
        }
      }

      public double fldunnamed_66
      {
        get
        {
          return this.fldunnamed_66_priv;
        }
        set
        {
          if (this.fldunnamed_66_priv == value)
            return;
          this.fldunnamed_66_priv = value;
          this.OnPropertyChanged("fldunnamed_66");
        }
      }

      public double fldBaseICMSFonte
      {
        get
        {
          return this.fldBaseICMSFonte_priv;
        }
        set
        {
          if (this.fldBaseICMSFonte_priv == value)
            return;
          this.fldBaseICMSFonte_priv = value;
          this.OnPropertyChanged("fldBaseICMSFonte");
        }
      }

      public double fldAbatimento
      {
        get
        {
          return this.fldAbatimento_priv;
        }
        set
        {
          if (this.fldAbatimento_priv == value)
            return;
          this.fldAbatimento_priv = value;
          this.OnPropertyChanged("fldAbatimento");
        }
      }

      public double fldCofinsIsento
      {
        get
        {
          return this.fldCofinsIsento_priv;
        }
        set
        {
          if (this.fldCofinsIsento_priv == value)
            return;
          this.fldCofinsIsento_priv = value;
          this.OnPropertyChanged("fldCofinsIsento");
        }
      }

      public double fldPVV
      {
        get
        {
          return this.fldPVV_priv;
        }
        set
        {
          if (this.fldPVV_priv == value)
            return;
          this.fldPVV_priv = value;
          this.OnPropertyChanged("fldPVV");
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
        this.fldOperacao_priv = string.Empty;
        this.fldunnamed_2_priv = (short) 0;
        this.fldunnamed_3_priv = (short) 0;
        this.fldunnamed_4_priv = (short) 0;
        this.fldunnamed_5_priv = 0;
        this.fldData_priv = string.Empty;
        this.fldEmissao_priv = string.Empty;
        this.fldSerie_priv = string.Empty;
        this.fldEspecie_priv = string.Empty;
        this.fldNumero_priv = 0;
        this.fldNumeroAte_priv = 0;
        this.fldCNPJ_priv = string.Empty;
        this.fldSituacao_priv = (short) 0;
        this.fldUF_priv = string.Empty;
        this.fldContaContabil_priv = string.Empty;
        this.fldObservacao_priv = string.Empty;
        this.fldValorContabil_priv = 0.0;
        this.fldunnamed_17_priv = (short) 0;
        this.fldBaseCalculoICMS1_priv = 0.0;
        this.fldBaseCalculoICMS2_priv = 0.0;
        this.fldBaseCalculoICMS3_priv = 0.0;
        this.fldBaseCalculoICMS4_priv = 0.0;
        this.fldBaseCalculoICMS5_priv = 0.0;
        this.fldAliquotaICMS1_priv = 0.0;
        this.fldAliquotaICMS2_priv = 0.0;
        this.fldAliquotaICMS3_priv = 0.0;
        this.fldAliquotaICMS4_priv = 0.0;
        this.fldAliquotaICMS5_priv = 0.0;
        this.fldValorICMS1_priv = 0.0;
        this.fldValorICMS2_priv = 0.0;
        this.fldValorICMS3_priv = 0.0;
        this.fldValorICMS4_priv = 0.0;
        this.fldValorICMS5_priv = 0.0;
        this.fldIsentoICMS1_priv = 0.0;
        this.fldIsentoICMS2_priv = 0.0;
        this.fldIsentoICMS3_priv = 0.0;
        this.fldIsentoICMS4_priv = 0.0;
        this.fldIsentoICMS5_priv = 0.0;
        this.fldOutrosICMS1_priv = 0.0;
        this.fldOutrosICMS2_priv = 0.0;
        this.fldOutrosICMS3_priv = 0.0;
        this.fldOutrosICMS4_priv = 0.0;
        this.fldOutrosICMS5_priv = 0.0;
        this.fldTipoLancamento1_priv = (short) 0;
        this.fldTipoLancamento2_priv = (short) 0;
        this.fldTipoLancamento3_priv = (short) 0;
        this.fldTipoLancamento4_priv = (short) 0;
        this.fldTipoLancamento5_priv = (short) 0;
        this.fldBaseCalculoIPI_priv = 0.0;
        this.fldValorIPI_priv = 0.0;
        this.fldIsentoIPI_priv = 0.0;
        this.fldOutrasIPI_priv = 0.0;
        this.fldICMSFonte_priv = 0.0;
        this.fldDesconto_priv = 0.0;
        this.fldMunicipio_priv = string.Empty;
        this.fldAVista_priv = 0.0;
        this.fldAPrazo_priv = 0.0;
        this.fldunnamed_24_priv = (short) 0;
        this.fldunnamed_208_priv = (short) 0;
        this.fldunnamed_67_priv = string.Empty;
        this.fldunnamed_68_priv = string.Empty;
        this.fldunnamed_71_priv = (short) 0;
        this.fldunnamed_207_priv = 0;
        this.fldunnamed_126_priv = 0;
        this.fldCentenaCFOP_priv = (short) 0;
        this.fldunnamed_72_priv = string.Empty;
        this.fldPISIsento_priv = 0.0;
        this.fldunnamed_66_priv = 0.0;
        this.fldBaseICMSFonte_priv = 0.0;
        this.fldAbatimento_priv = 0.0;
        this.fldCofinsIsento_priv = 0.0;
        this.fldPVV_priv = 0.0;
        this.fldunnamed_62_priv = string.Empty;
        this.fldunnamed_60_priv = string.Empty;
        this.fldunnamed_61_priv = string.Empty;
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
