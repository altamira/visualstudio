// Type: Trial.NPCCTB
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C523D594-4A3E-49D7-9D66-69FE06C83CC8
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
  public class NPCCTB
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
    private NPCCTB.KeysStruct pvKeys;
    private bool pvTrimStrings;
    private NPCCTB.FieldsClass pvFields;
    private NPCCTB.FieldsClass[] pvFieldsExtr;
    private NPCCTB.FieldsClass_priv pvFieldsIntern;
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

    public short fldGraus
    {
      get
      {
        return this.pvFields.fldGraus;
      }
      set
      {
        this.pvFields.fldGraus = value;
      }
    }

    public string fldDigitos
    {
      get
      {
        return this.pvFields.fldDigitos;
      }
      set
      {
        this.pvFields.fldDigitos = value;
      }
    }

    public string fldFormato
    {
      get
      {
        return this.pvFields.fldFormato;
      }
      set
      {
        this.pvFields.fldFormato = value;
      }
    }

    public short fldContaAtivo
    {
      get
      {
        return this.pvFields.fldContaAtivo;
      }
      set
      {
        this.pvFields.fldContaAtivo = value;
      }
    }

    public short fldContaPassivo
    {
      get
      {
        return this.pvFields.fldContaPassivo;
      }
      set
      {
        this.pvFields.fldContaPassivo = value;
      }
    }

    public short fldContaDespesa
    {
      get
      {
        return this.pvFields.fldContaDespesa;
      }
      set
      {
        this.pvFields.fldContaDespesa = value;
      }
    }

    public short fldContaReceita
    {
      get
      {
        return this.pvFields.fldContaReceita;
      }
      set
      {
        this.pvFields.fldContaReceita = value;
      }
    }

    public short fldContaCusto
    {
      get
      {
        return this.pvFields.fldContaCusto;
      }
      set
      {
        this.pvFields.fldContaCusto = value;
      }
    }

    public short fldContaResultado
    {
      get
      {
        return this.pvFields.fldContaResultado;
      }
      set
      {
        this.pvFields.fldContaResultado = value;
      }
    }

    public string fldReservado1
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

    public NPCCTB.KeysStruct Keys
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

    public NPCCTB.FieldsClass Fields
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

    public NPCCTB.FieldsClass[] Fields_ext
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

    public NPCCTB()
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[128];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\phoenix\\Geral\\NPCCTB.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new NPCCTB.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new NPCCTB.FieldsClass();
      this.pvFieldsIntern.initi();
    }

    public NPCCTB(bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[128];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\phoenix\\Geral\\NPCCTB.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new NPCCTB.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new NPCCTB.FieldsClass();
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    public NPCCTB(string DataPath)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[128];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\phoenix\\Geral\\NPCCTB.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new NPCCTB.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new NPCCTB.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvFieldsIntern.initi();
    }

    public NPCCTB(string DataPath, bool Trim_Strings)
    {
      
      this.pvPB = new byte[128];
      this.pbKBL = (short) byte.MaxValue;
      this.pvStBld = new StringBuilder();
      this.pvaBt = new byte[128];
      this.pva16 = new ushort[1];
      this.pva32 = new uint[1];
      this.pva64 = new ulong[1];
      this.pvaSng = new float[1];
      this.pvaDbl = new double[1];
      this.pvDataPath = "C:\\phoenix\\Geral\\NPCCTB.btr";
      this.pvDirectory = string.Empty;
      this.pvOwnerName = string.Empty;
      this.pvKeys = new NPCCTB.KeysStruct();
      this.pvTrimStrings = false;
      this.pvFields = new NPCCTB.FieldsClass();
      this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
      this.pvTrimStrings = Trim_Strings;
      this.pvFieldsIntern.initi();
    }

    private void VartoKB(ref IntPtr pPtr, short pKey)
    {
      if ((int) pKey == 0)
        Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmIdPlano);
      else if ((int) pKey == 1)
      {
        Translate.Cmmn_WriteInt16(pPtr, 0, this.pvKeys.idxindex_1.sgmGraus);
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
        this.pvKeys.idxindex_0.sgmIdPlano = Translate.Cmmn_ReadInt32(pPtr4, 0);
      else if ((int) pKey == 1)
      {
        this.pvKeys.idxindex_1.sgmGraus = Translate.Cmmn_ReadInt16(pPtr4, 0);
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
      NPCCTB npcctb = this;
      object obj = Marshal.PtrToStructure(pPtr1, typeof (NPCCTB.FieldsClass_priv));
      NPCCTB.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
      NPCCTB.FieldsClass_priv fieldsClassPriv2 = obj != null ? (NPCCTB.FieldsClass_priv) obj : fieldsClassPriv1;
      npcctb.pvFieldsIntern = fieldsClassPriv2;
      this.pvFields.fldIdPlano = this.pvFieldsIntern.a_000;
      this.pvFields.fldGraus = this.pvFieldsIntern.a_004;
      this.pvFields.fldDigitos = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_006) : new string(this.pvFieldsIntern.a_006).Trim();
      this.pvFields.fldFormato = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_024) : new string(this.pvFieldsIntern.a_024).Trim();
      this.pvFields.fldContaAtivo = this.pvFieldsIntern.a_082;
      this.pvFields.fldContaPassivo = this.pvFieldsIntern.a_084;
      this.pvFields.fldContaDespesa = this.pvFieldsIntern.a_086;
      this.pvFields.fldContaReceita = this.pvFieldsIntern.a_088;
      this.pvFields.fldContaCusto = this.pvFieldsIntern.a_090;
      this.pvFields.fldContaResultado = this.pvFieldsIntern.a_092;
      this.pvFields.fldReservado1 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_094) : new string(this.pvFieldsIntern.a_094).Trim();
      this.pvFields.fldId = this.pvFieldsIntern.a_150;
      if (this.pvTrimStrings)
        this.pvFields.fldReservado2 = new string(this.pvFieldsIntern.a_154).Trim();
      else
        this.pvFields.fldReservado2 = new string(this.pvFieldsIntern.a_154);
    }

    private void StructtoDB(ref IntPtr pPtr2)
    {
      this.pvFieldsIntern.a_000 = this.pvFields.fldIdPlano;
      this.pvFieldsIntern.a_004 = this.pvFields.fldGraus;
      this.pvFieldsIntern.a_006 = this.pvFields.fldDigitos.PadRight(18).ToCharArray();
      this.pvFieldsIntern.a_024 = this.pvFields.fldFormato.PadRight(58).ToCharArray();
      this.pvFieldsIntern.a_082 = this.pvFields.fldContaAtivo;
      this.pvFieldsIntern.a_084 = this.pvFields.fldContaPassivo;
      this.pvFieldsIntern.a_086 = this.pvFields.fldContaDespesa;
      this.pvFieldsIntern.a_088 = this.pvFields.fldContaReceita;
      this.pvFieldsIntern.a_090 = this.pvFields.fldContaCusto;
      this.pvFieldsIntern.a_092 = this.pvFields.fldContaResultado;
      this.pvFieldsIntern.a_094 = this.pvFields.fldReservado1.PadRight(56).ToCharArray();
      this.pvFieldsIntern.a_150 = this.pvFields.fldId;
      this.pvFieldsIntern.a_154 = this.pvFields.fldReservado2.PadRight(128).ToCharArray();
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
        this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldGraus;
        this.pvFieldsIntern.a_006 = this.pvFieldsExtr[index].fldDigitos.PadRight(18).ToCharArray();
        this.pvFieldsIntern.a_024 = this.pvFieldsExtr[index].fldFormato.PadRight(58).ToCharArray();
        this.pvFieldsIntern.a_082 = this.pvFieldsExtr[index].fldContaAtivo;
        this.pvFieldsIntern.a_084 = this.pvFieldsExtr[index].fldContaPassivo;
        this.pvFieldsIntern.a_086 = this.pvFieldsExtr[index].fldContaDespesa;
        this.pvFieldsIntern.a_088 = this.pvFieldsExtr[index].fldContaReceita;
        this.pvFieldsIntern.a_090 = this.pvFieldsExtr[index].fldContaCusto;
        this.pvFieldsIntern.a_092 = this.pvFieldsExtr[index].fldContaResultado;
        this.pvFieldsIntern.a_094 = this.pvFieldsExtr[index].fldReservado1.PadRight(56).ToCharArray();
        this.pvFieldsIntern.a_150 = this.pvFieldsExtr[index].fldId;
        this.pvFieldsIntern.a_154 = this.pvFieldsExtr[index].fldReservado2.PadRight(128).ToCharArray();
        Translate.Cmmn_WriteInt16(pPtr3, (int) num1, (short) 282);
        short num2 = checked ((short) ((int) num1 + 2));
        this.pvPtr = new IntPtr(checked (pPtr3.ToInt64() + (long) num2));
        Marshal.StructureToPtr((object) this.pvFieldsIntern, this.pvPtr, true);
        this.pvPtr = IntPtr.Zero;
        num1 = checked ((short) ((int) num2 + 282));
        checked { ++index; }
      }
    }

    public virtual short btrOpen(NPCCTB.OpenModes Mode, byte[] ClientId)
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

    public virtual short btrOpen(NPCCTB.OpenModes Mode)
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

    public virtual short btrInsert(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 282;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrInsert(NPCCTB.KeyName Key_nr)
    {
      short num1 = (short) 282;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = (short) 282;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALLID((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr2);
      return num2;
    }

    public virtual short btrUpdate(NPCCTB.KeyName Key_nr)
    {
      short num1 = (short) 282;
      IntPtr pPtr2 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.StructtoDB(ref pPtr2);
      short num2 = Func.BTRCALL((short) 3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
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

    public virtual short btrGetEqual(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetEqual(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetNext(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetNext(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetNext(Key_nr, ref KeyBuffer, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetPrevious(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetPrevious(NPCCTB.KeyName Key_nr, ref IntPtr KeyBuffer)
    {
      return this.btrGetPrevious(Key_nr, ref KeyBuffer, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreater(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreater(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetGreater(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreater(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetGreater(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetGreaterThanOrEqual(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetGreaterThanOrEqual(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetGreaterThanOrEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetGreaterThanOrEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetGreaterThanOrEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLessThan(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThan(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThan(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetLessThan(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThan(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLessThan(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLessThanOrEqual(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLessThanOrEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLessThanOrEqual(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetLessThanOrEqual(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLessThanOrEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLessThanOrEqual(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetFirst(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetFirst(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetFirst(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetFirst(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetFirst(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetFirst(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLast(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      return this.btrGetLast(Key_nr, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetLast(NPCCTB.KeyName Key_nr)
    {
      return this.btrGetLast(Key_nr, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetLast(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
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

    public virtual short btrGetLast(NPCCTB.KeyName Key_nr, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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
      short num1 = (short) 282;
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

    public virtual short btrGetDirectRecord(NPCCTB.KeyName Key_nr, IntPtr Position, byte[] ClientId)
    {
      return this.btrGetDirectRecord(Key_nr, Position, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetDirectRecord(NPCCTB.KeyName Key_nr, IntPtr Position)
    {
      return this.btrGetDirectRecord(Key_nr, Position, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetDirectRecord(NPCCTB.KeyName Key_nr, IntPtr Position, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetDirectRecord(NPCCTB.KeyName Key_nr, IntPtr Position, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
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
      return this.btrStepNext(NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepNext()
    {
      return this.btrStepNext(NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepNext(NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepNext(NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrUnlock(NPCCTB.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
    {
      IntPtr num1 = IntPtr.Zero;
      short num2 = Position == num1 || Position == IntPtr.Zero ? (short) 0 : (short) 4;
      return Func.BTRCALLID((short) 27, this.pvPB, Position, ref num2, IntPtr.Zero, (short) 0, checked ((short) UnlockKey), ClientId);
    }

    public virtual short btrUnlock(NPCCTB.Unlock UnlockKey, IntPtr Position)
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
      return this.btrStepFirst(NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepFirst()
    {
      return this.btrStepFirst(NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepFirst(NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepFirst(NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(byte[] ClientId)
    {
      return this.btrStepLast(NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepLast()
    {
      return this.btrStepLast(NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepLast(NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepLast(NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(byte[] ClientId)
    {
      return this.btrStepPrevious(NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrStepPrevious()
    {
      return this.btrStepPrevious(NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrStepPrevious(NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0, ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrStepPrevious(NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, (short) 0);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrInsertExtended(NPCCTB.KeyName Key_nr, byte[] ClientId)
    {
      short num1 = checked ((short) (284 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALLID((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr), ClientId);
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrInsertExtended(NPCCTB.KeyName Key_nr)
    {
      short num1 = checked ((short) (284 * this.pvFieldsExtr.Length + 2));
      IntPtr pPtr3 = Marshal.AllocHGlobal((int) num1);
      IntPtr pPtr4 = Marshal.AllocHGlobal((int) this.pbKBL);
      this.VartoDB_ext(ref pPtr3);
      short num2 = Func.BTRCALL((short) 40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked ((short) Key_nr));
      if (Key_nr >= NPCCTB.KeyName.index_0 && (int) num2 == 0)
        this.KBtoVar(ref pPtr4, checked ((short) Key_nr));
      this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
      Marshal.FreeHGlobal(pPtr4);
      Marshal.FreeHGlobal(pPtr3);
      return num2;
    }

    public virtual short btrGetByPercentage(NPCCTB.KeyName Key_nr, short Percentage, byte[] ClientId)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, NPCCTB.RecordLocks.NoRecordLock, ClientId);
    }

    public virtual short btrGetByPercentage(NPCCTB.KeyName Key_nr, short Percentage)
    {
      return this.btrGetByPercentage(Key_nr, Percentage, NPCCTB.RecordLocks.NoRecordLock);
    }

    public virtual short btrGetByPercentage(NPCCTB.KeyName Key_nr, short Percentage, NPCCTB.RecordLocks Lock_Bias, byte[] ClientId)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALLID(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr), ClientId);
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrGetByPercentage(NPCCTB.KeyName Key_nr, short Percentage, NPCCTB.RecordLocks Lock_Bias)
    {
      short pDBL = (short) 282;
      IntPtr pPtr1 = Marshal.AllocHGlobal((int) pDBL);
      Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
      short num = Func.BTRCALL(checked ((short) ((int) (short) Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short) 0, checked ((short) Key_nr));
      if ((int) num == 0)
        this.DBtoStruct(ref pPtr1, pDBL);
      Marshal.FreeHGlobal(pPtr1);
      return num;
    }

    public virtual short btrFindPercentage(NPCCTB.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

    public virtual short btrFindPercentage(NPCCTB.KeyName Key_nr, ref short Percentage)
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
      private NPCCTB.KeysStruct.struct_01 idxindex_1_priv;
      private NPCCTB.KeysStruct.struct_02 idxUK_Id_priv;
      private NPCCTB.KeysStruct.struct_00 idxindex_0_priv;

      public NPCCTB.KeysStruct.struct_01 idxindex_1
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

      public NPCCTB.KeysStruct.struct_02 idxUK_Id
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

      public NPCCTB.KeysStruct.struct_00 idxindex_0
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
        
        this.idxindex_1_priv = new NPCCTB.KeysStruct.struct_01();
        this.idxUK_Id_priv = new NPCCTB.KeysStruct.struct_02();
        this.idxindex_0_priv = new NPCCTB.KeysStruct.struct_00();
      }

      public class struct_00
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

        public struct_00()
        {
          
          this.sgmIdPlano_priv = 0;
        }
      }

      public class struct_01
      {
        private short sgmGraus_priv;

        public short sgmGraus
        {
          get
          {
            return this.sgmGraus_priv;
          }
          set
          {
            this.sgmGraus_priv = value;
          }
        }

        public struct_01()
        {
          
          this.sgmGraus_priv = (short) 0;
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

    [StructLayout(LayoutKind.Sequential, Size = 282, Pack = 1)]
    internal struct FieldsClass_priv
    {
      internal int a_000;
      internal short a_004;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 18)]
      internal char[] a_006;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 58)]
      internal char[] a_024;
      internal short a_082;
      internal short a_084;
      internal short a_086;
      internal short a_088;
      internal short a_090;
      internal short a_092;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
      internal char[] a_094;
      internal int a_150;
      [MarshalAs(UnmanagedType.ByValArray, SizeConst = 128)]
      internal char[] a_154;

      internal void initi()
      {
      }
    }

    public class FieldsClass : INotifyPropertyChanged
    {
      private int fldIdPlano_priv;
      private short fldGraus_priv;
      private string fldDigitos_priv;
      private string fldFormato_priv;
      private short fldContaAtivo_priv;
      private short fldContaPassivo_priv;
      private short fldContaDespesa_priv;
      private short fldContaReceita_priv;
      private short fldContaCusto_priv;
      private short fldContaResultado_priv;
      private string fldReservado1_priv;
      private int fldId_priv;
      private string fldReservado2_priv;
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

      public short fldGraus
      {
        get
        {
          return this.fldGraus_priv;
        }
        set
        {
          if ((int) this.fldGraus_priv == (int) value)
            return;
          this.fldGraus_priv = value;
          this.OnPropertyChanged("fldGraus");
        }
      }

      public string fldDigitos
      {
        get
        {
          return this.fldDigitos_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldDigitos_priv, value, false) == 0)
            return;
          this.fldDigitos_priv = value;
          this.OnPropertyChanged("fldDigitos");
        }
      }

      public string fldFormato
      {
        get
        {
          return this.fldFormato_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldFormato_priv, value, false) == 0)
            return;
          this.fldFormato_priv = value;
          this.OnPropertyChanged("fldFormato");
        }
      }

      public short fldContaAtivo
      {
        get
        {
          return this.fldContaAtivo_priv;
        }
        set
        {
          if ((int) this.fldContaAtivo_priv == (int) value)
            return;
          this.fldContaAtivo_priv = value;
          this.OnPropertyChanged("fldContaAtivo");
        }
      }

      public short fldContaPassivo
      {
        get
        {
          return this.fldContaPassivo_priv;
        }
        set
        {
          if ((int) this.fldContaPassivo_priv == (int) value)
            return;
          this.fldContaPassivo_priv = value;
          this.OnPropertyChanged("fldContaPassivo");
        }
      }

      public short fldContaDespesa
      {
        get
        {
          return this.fldContaDespesa_priv;
        }
        set
        {
          if ((int) this.fldContaDespesa_priv == (int) value)
            return;
          this.fldContaDespesa_priv = value;
          this.OnPropertyChanged("fldContaDespesa");
        }
      }

      public short fldContaReceita
      {
        get
        {
          return this.fldContaReceita_priv;
        }
        set
        {
          if ((int) this.fldContaReceita_priv == (int) value)
            return;
          this.fldContaReceita_priv = value;
          this.OnPropertyChanged("fldContaReceita");
        }
      }

      public short fldContaCusto
      {
        get
        {
          return this.fldContaCusto_priv;
        }
        set
        {
          if ((int) this.fldContaCusto_priv == (int) value)
            return;
          this.fldContaCusto_priv = value;
          this.OnPropertyChanged("fldContaCusto");
        }
      }

      public short fldContaResultado
      {
        get
        {
          return this.fldContaResultado_priv;
        }
        set
        {
          if ((int) this.fldContaResultado_priv == (int) value)
            return;
          this.fldContaResultado_priv = value;
          this.OnPropertyChanged("fldContaResultado");
        }
      }

      public string fldReservado1
      {
        get
        {
          return this.fldReservado1_priv;
        }
        set
        {
          if (Operators.CompareString(this.fldReservado1_priv, value, false) == 0)
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
        this.fldGraus_priv = (short) 0;
        this.fldDigitos_priv = string.Empty;
        this.fldFormato_priv = string.Empty;
        this.fldContaAtivo_priv = (short) 0;
        this.fldContaPassivo_priv = (short) 0;
        this.fldContaDespesa_priv = (short) 0;
        this.fldContaReceita_priv = (short) 0;
        this.fldContaCusto_priv = (short) 0;
        this.fldContaResultado_priv = (short) 0;
        this.fldReservado1_priv = string.Empty;
        this.fldId_priv = 0;
        this.fldReservado2_priv = string.Empty;
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
