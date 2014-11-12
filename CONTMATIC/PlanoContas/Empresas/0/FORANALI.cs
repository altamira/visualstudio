// Type: Trial.FORANALI
// Assembly: Trial, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: FCAC68BD-9103-44D2-9019-79A8B2D8482D
// Assembly location: C:\Users\Alessandro.Holanda\Downloads\Participantes.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC.Empresas
{
    public class FORANALI
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
        private FORANALI.KeysStruct pvKeys;
        private bool pvTrimStrings;
        private FORANALI.FieldsClass pvFields;
        private FORANALI.FieldsClass[] pvFieldsExtr;
        private FORANALI.FieldsClass_priv pvFieldsIntern;
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

        public string fldunnamed_28
        {
            get
            {
                return this.pvFields.fldunnamed_28;
            }
            set
            {
                this.pvFields.fldunnamed_28 = value;
            }
        }

        public string fldunnamed_29
        {
            get
            {
                return this.pvFields.fldunnamed_29;
            }
            set
            {
                this.pvFields.fldunnamed_29 = value;
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

        public FORANALI.KeysStruct Keys
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

        public FORANALI.FieldsClass Fields
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

        public FORANALI.FieldsClass[] Fields_ext
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

        public FORANALI()
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[56];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "X:\\Empresas\\ALTAMIRA\\0\\ForAnali.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new FORANALI.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new FORANALI.FieldsClass();
            this.pvFieldsIntern.initi();
        }

        public FORANALI(bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[56];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "X:\\Empresas\\ALTAMIRA\\0\\ForAnali.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new FORANALI.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new FORANALI.FieldsClass();
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        public FORANALI(string DataPath)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[56];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "X:\\Empresas\\ALTAMIRA\\0\\ForAnali.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new FORANALI.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new FORANALI.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvFieldsIntern.initi();
        }

        public FORANALI(string DataPath, bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[56];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "X:\\Empresas\\ALTAMIRA\\0\\ForAnali.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new FORANALI.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new FORANALI.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        private void VartoKB(ref IntPtr pPtr, short pKey)
        {
            if ((int)pKey == 0)
            {
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 1L));
                if (this.pvKeys.keyindex_0.sgmCNPJ.Length < 21)
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_0.sgmCNPJ.PadRight(21)), 0, this.pvPtr, 21);
                else
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_0.sgmCNPJ), 0, this.pvPtr, 21);
                this.pvPtr = IntPtr.Zero;
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.keyindex_0.sgmClassificacao.Length < 1)
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_0.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
                else
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_0.sgmClassificacao), 0, this.pvPtr, 1);
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 1)
            {
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 1L));
                if (this.pvKeys.keyindex_1.sgmRazaoSocial.Length < 48)
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_1.sgmRazaoSocial.PadRight(48)), 0, this.pvPtr, 48);
                else
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_1.sgmRazaoSocial), 0, this.pvPtr, 48);
                this.pvPtr = IntPtr.Zero;
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.keyindex_1.sgmClassificacao.Length < 1)
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_1.sgmClassificacao.PadRight(1)), 0, this.pvPtr, 1);
                else
                    Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvKeys.keyindex_1.sgmClassificacao), 0, this.pvPtr, 1);
                this.pvPtr = IntPtr.Zero;
            }
            else
            {
                if ((int)pKey != 2)
                    return;
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.keyUK_Id.sgmId);
            }
        }

        private void KBtoVar(ref IntPtr pPtr4, short pKey)
        {
            if ((int)pKey == 0)
            {
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 1L));
                this.pvKeys.keyindex_0.sgmCNPJ = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 21) : Marshal.PtrToStringAnsi(this.pvPtr, 21).Trim();
                this.pvPtr = IntPtr.Zero;
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.keyindex_0.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 1)
            {
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 1L));
                this.pvKeys.keyindex_1.sgmRazaoSocial = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 48) : Marshal.PtrToStringAnsi(this.pvPtr, 48).Trim();
                this.pvPtr = IntPtr.Zero;
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.keyindex_1.sgmClassificacao = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else
            {
                if ((int)pKey != 2)
                    return;
                this.pvKeys.keyUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
            }
        }

        private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
        {
            FORANALI foranali = this;
            object obj = Marshal.PtrToStructure(pPtr1, typeof(FORANALI.FieldsClass_priv));
            FORANALI.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
            FORANALI.FieldsClass_priv fieldsClassPriv2 = obj != null ? (FORANALI.FieldsClass_priv)obj : fieldsClassPriv1;
            foranali.pvFieldsIntern = fieldsClassPriv2;
            this.pvFields.fldId = this.pvFieldsIntern.a_000;
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
            this.pvFields.fldunnamed_11 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_230) : new string(this.pvFieldsIntern.a_230).Trim();
            this.pvFields.fldunnamed_12 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_242) : new string(this.pvFieldsIntern.a_242).Trim();
            this.pvFields.fldInscricaoMunicipal = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_262) : new string(this.pvFieldsIntern.a_262).Trim();
            this.pvFields.fldunnamed_28 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_282) : new string(this.pvFieldsIntern.a_282).Trim();
            if (this.pvTrimStrings)
                this.pvFields.fldunnamed_29 = new string(this.pvFieldsIntern.a_302).Trim();
            else
                this.pvFields.fldunnamed_29 = new string(this.pvFieldsIntern.a_302);
        }

        private void StructtoDB(ref IntPtr pPtr2)
        {
            this.pvFieldsIntern.a_000 = this.pvFields.fldId;
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
            this.pvFieldsIntern.a_230 = this.pvFields.fldunnamed_11.PadRight(12).ToCharArray();
            this.pvFieldsIntern.a_242 = this.pvFields.fldunnamed_12.PadRight(20).ToCharArray();
            this.pvFieldsIntern.a_262 = this.pvFields.fldInscricaoMunicipal.PadRight(20).ToCharArray();
            this.pvFieldsIntern.a_282 = this.pvFields.fldunnamed_28.PadRight(20).ToCharArray();
            this.pvFieldsIntern.a_302 = this.pvFields.fldunnamed_29.PadRight(20).ToCharArray();
            Marshal.StructureToPtr((object)this.pvFieldsIntern, pPtr2, true);
        }

        private void VartoDB_ext(ref IntPtr pPtr3)
        {
            Translate.Cmmn_WriteInt16(pPtr3, checked((short)this.pvFieldsExtr.Length));
            short num1 = (short)2;
            int index = 0;
            while (index < this.pvFieldsExtr.Length)
            {
                this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldId;
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
                this.pvFieldsIntern.a_230 = this.pvFieldsExtr[index].fldunnamed_11.PadRight(12).ToCharArray();
                this.pvFieldsIntern.a_242 = this.pvFieldsExtr[index].fldunnamed_12.PadRight(20).ToCharArray();
                this.pvFieldsIntern.a_262 = this.pvFieldsExtr[index].fldInscricaoMunicipal.PadRight(20).ToCharArray();
                this.pvFieldsIntern.a_282 = this.pvFieldsExtr[index].fldunnamed_28.PadRight(20).ToCharArray();
                this.pvFieldsIntern.a_302 = this.pvFieldsExtr[index].fldunnamed_29.PadRight(20).ToCharArray();
                Translate.Cmmn_WriteInt16(pPtr3, (int)num1, (short)322);
                short num2 = checked((short)((int)num1 + 2));
                this.pvPtr = new IntPtr(checked(pPtr3.ToInt64() + (long)num2));
                Marshal.StructureToPtr((object)this.pvFieldsIntern, this.pvPtr, true);
                this.pvPtr = IntPtr.Zero;
                num1 = checked((short)((int)num2 + 322));
                checked { ++index; }
            }
        }

        public virtual short btrOpen(FORANALI.OpenModes Mode, byte[] ClientId)
        {
            string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
            short num1 = checked((short)(s.Length + 1));
            IntPtr num2 = Marshal.AllocHGlobal((int)num1);
            short DataBufferLength;
            IntPtr num3;
            if (this.pvOwnerName.Trim().Length == 0)
            {
                DataBufferLength = (short)0;
                num3 = IntPtr.Zero;
            }
            else
            {
                DataBufferLength = checked((short)(this.pvOwnerName.Length + 1));
                num3 = Marshal.AllocHGlobal((int)DataBufferLength);
                Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvOwnerName), 0, num3, checked((int)DataBufferLength - 1));
                Translate.Cmmn_WriteByte(num3, checked((int)DataBufferLength - 1), (byte)0);
            }
            Marshal.Copy(Encoding.GetEncoding(437).GetBytes(s), 0, num2, checked((int)num1 - 1));
            Translate.Cmmn_WriteByte(num2, checked((int)num1 - 2), (byte)0);
            short num4 = Func.BTRCALLID((short)0, this.pvPB, num3, ref DataBufferLength, num2, (short)byte.MaxValue, checked((short)Mode), ClientId);
            if ((int)DataBufferLength > 0)
                Marshal.FreeHGlobal(num3);
            Marshal.FreeHGlobal(num2);
            return num4;
        }

        public virtual short btrOpen(FORANALI.OpenModes Mode)
        {
            string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
            short num1 = checked((short)(s.Length + 1));
            IntPtr num2 = Marshal.AllocHGlobal((int)num1);
            short DataBufferLength;
            IntPtr num3;
            if (this.pvOwnerName.Trim().Length == 0)
            {
                DataBufferLength = (short)0;
                num3 = IntPtr.Zero;
            }
            else
            {
                DataBufferLength = checked((short)(this.pvOwnerName.Length + 1));
                num3 = Marshal.AllocHGlobal((int)DataBufferLength);
                Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvOwnerName), 0, num3, checked((int)DataBufferLength - 1));
                Translate.Cmmn_WriteByte(num3, checked((int)DataBufferLength - 1), (byte)0);
            }
            Marshal.Copy(Encoding.GetEncoding(437).GetBytes(s), 0, num2, checked((int)num1 - 1));
            Translate.Cmmn_WriteByte(num2, checked((int)num1 - 2), (byte)0);
            short num4 = Func.BTRCALL((short)0, this.pvPB, num3, ref DataBufferLength, num2, (short)byte.MaxValue, checked((short)Mode));
            if ((int)DataBufferLength > 0)
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

        public virtual short btrInsert(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num = Func.BTRCALLID((short)2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num;
        }

        public virtual short btrInsert(FORANALI.KeyName Key_nr)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num = Func.BTRCALL((short)2, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num;
        }

        public virtual short btrUpdate(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num = Func.BTRCALLID((short)3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num;
        }

        public virtual short btrUpdate(FORANALI.KeyName Key_nr)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num = Func.BTRCALL((short)3, this.pvPB, pPtr2, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
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

        public virtual short btrGetEqual(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetEqual(FORANALI.KeyName Key_nr)
        {
            return this.btrGetEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 5)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 5)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr)
        {
            return this.btrGetNext(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            else
            {
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            else
            {
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr)
        {
            return this.btrGetPrevious(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            else
            {
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            else
            {
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref DataBufferLength, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, DataBufferLength);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(FORANALI.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreater(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreater(FORANALI.KeyName Key_nr)
        {
            return this.btrGetGreater(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 8)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetGreater(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 8)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetGreaterThanOrEqual(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreaterThanOrEqual(FORANALI.KeyName Key_nr)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreaterThanOrEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 9)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetGreaterThanOrEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 9)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetLessThan(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThan(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThan(FORANALI.KeyName Key_nr)
        {
            return this.btrGetLessThan(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThan(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 10)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetLessThan(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 10)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetLessThanOrEqual(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThanOrEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThanOrEqual(FORANALI.KeyName Key_nr)
        {
            return this.btrGetLessThanOrEqual(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThanOrEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 11)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetLessThanOrEqual(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num1 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref num1, checked((short)Key_nr));
            short num2 = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 11)), this.pvPB, pPtr1, ref DataBufferLength, num1, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref num1, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(num1);
            Marshal.FreeHGlobal(pPtr1);
            return num2;
        }

        public virtual short btrGetFirst(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetFirst(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetFirst(FORANALI.KeyName Key_nr)
        {
            return this.btrGetFirst(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetFirst(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 12)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetFirst(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 12)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLast(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLast(Key_nr, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLast(FORANALI.KeyName Key_nr)
        {
            return this.btrGetLast(Key_nr, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLast(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 13)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLast(FORANALI.KeyName Key_nr, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 13)), this.pvPB, pPtr1, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, DataBufferLength);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetStat()
        {
            short DataBufferLength = (short)322;
            IntPtr num1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr num2 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num3 = Func.BTRCALL((short)15, this.pvPB, num1, ref DataBufferLength, num2, this.pbKBL, (short)-1);
            if ((int)num3 == 0)
                this.pvStatInfo.RecordLength = Translate.Cmmn_ReadInt16(num1, 0);
            if ((int)num3 == 0)
                this.pvStatInfo.PageSize = Translate.Cmmn_ReadInt16(num1, 2);
            if ((int)num3 == 0)
                this.pvStatInfo.NrOfIndexes = Translate.Cmmn_ReadByte(num1, 4);
            if ((int)num3 == 0)
                this.pvStatInfo.FileVersion = Translate.Cmmn_ReadByte(num1, 5);
            if ((int)num3 == 0)
                this.pvStatInfo.RecordCount = Translate.Cmmn_ReadInt32(num1, 6);
            Marshal.FreeHGlobal(num2);
            Marshal.FreeHGlobal(num1);
            return num3;
        }

        public virtual short btrSetDirectory(byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      ////__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = 0;
      int num5 = 0;
      byte[] ClientId1 = ClientId;
      short num6 = Func.BTRCALLID((short) num2, /*(byte[])local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

        public virtual short btrSetDirectory()
    {
      IntPtr num1 = Marshal.AllocHGlobal(checked (this.pvDirectory.Length + 1));
      Marshal.Copy(Encoding.GetEncoding(437).GetBytes(this.pvDirectory), 0, num1, this.pvDirectory.Length);
      Translate.Cmmn_WriteByte(num1, this.pvDirectory.Length, (byte) 0);
      int num2 = 17;
      // ISSUE: variable of the null type
      ////__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = 0;
      int num5 = 0;
      short num6 = Func.BTRCALL((short) num2, /*(byte[])local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5);
      Marshal.FreeHGlobal(num1);
      return num6;
    }

        public virtual short btrGetDirectory(short Disk_Drive_nr, byte[] ClientId)
    {
      IntPtr num1 = Marshal.AllocHGlobal((int) this.pbKBL);
      int num2 = 18;
      // ISSUE: variable of the null type
      ////__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = (int) this.pbKBL;
      int num5 = (int) Disk_Drive_nr;
      byte[] ClientId1 = ClientId;
      short num6 = Func.BTRCALLID((short) num2, /*(byte[])local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short) num4, (short) num5, ClientId1);
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
      ////__Null local = null;
      IntPtr DataBuffer = IntPtr.Zero;
      short num3 = (short) 0;
      // ISSUE: explicit reference operation
      // ISSUE: variable of a reference type
      short DataBufferLength = @num3;
      IntPtr KeyBuffer = num1;
      int num4 = (int) this.pbKBL;
      int num5 = (int) Disk_Drive_nr;
      short num6 = Func.BTRCALL((short)num2, /*(byte[])local*/null, DataBuffer, ref DataBufferLength, KeyBuffer, (short)num4, (short)num5);
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

        public virtual short btrGetDirectRecord(FORANALI.KeyName Key_nr, IntPtr Position, byte[] ClientId)
        {
            return this.btrGetDirectRecord(Key_nr, Position, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetDirectRecord(FORANALI.KeyName Key_nr, IntPtr Position)
        {
            return this.btrGetDirectRecord(Key_nr, Position, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetDirectRecord(FORANALI.KeyName Key_nr, IntPtr Position, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 23)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetDirectRecord(FORANALI.KeyName Key_nr, IntPtr Position, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 23)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)Key_nr));
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepNext(byte[] ClientId)
        {
            return this.btrStepNext(FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepNext()
        {
            return this.btrStepNext(FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepNext(FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepNext(FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrUnlock(FORANALI.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
        {
            IntPtr num = IntPtr.Zero;
            short DataBufferLength = Position == num || Position == IntPtr.Zero ? (short)0 : (short)4;
            return Func.BTRCALLID((short)27, this.pvPB, Position, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)UnlockKey), ClientId);
        }

        public virtual short btrUnlock(FORANALI.Unlock UnlockKey, IntPtr Position)
        {
            IntPtr num = IntPtr.Zero;
            short DataBufferLength = Position == num || Position == IntPtr.Zero ? (short)0 : (short)4;
            return Func.BTRCALL((short)27, this.pvPB, Position, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)UnlockKey));
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
            return this.btrStepFirst(FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepFirst()
        {
            return this.btrStepFirst(FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepFirst(FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepFirst(FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(byte[] ClientId)
        {
            return this.btrStepLast(FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepLast()
        {
            return this.btrStepLast(FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepLast(FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(byte[] ClientId)
        {
            return this.btrStepPrevious(FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepPrevious()
        {
            return this.btrStepPrevious(FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepPrevious(FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrInsertExtended(FORANALI.KeyName Key_nr, byte[] ClientId)
        {
            short DataBufferLength = checked((short)(324 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num = Func.BTRCALLID((short)40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num;
        }

        public virtual short btrInsertExtended(FORANALI.KeyName Key_nr)
        {
            short DataBufferLength = checked((short)(324 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num = Func.BTRCALL((short)40, this.pvPB, pPtr3, ref DataBufferLength, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= FORANALI.KeyName.index_0 && (int)num == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num;
        }

        public virtual short btrGetByPercentage(FORANALI.KeyName Key_nr, short Percentage, byte[] ClientId)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, FORANALI.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetByPercentage(FORANALI.KeyName Key_nr, short Percentage)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, FORANALI.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetByPercentage(FORANALI.KeyName Key_nr, short Percentage, FORANALI.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetByPercentage(FORANALI.KeyName Key_nr, short Percentage, FORANALI.RecordLocks Lock_Bias)
        {
            short DataBufferLength = (short)322;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)DataBufferLength);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref DataBufferLength, IntPtr.Zero, (short)0, checked((short)Key_nr));
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, DataBufferLength);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrFindPercentage(FORANALI.KeyName Key_nr, ref short Percentage, byte[] ClientId)
        {
            short DataBufferLength = (short)4;
            IntPtr num1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref pPtr, checked((short)Key_nr));
            short num2 = Func.BTRCALLID((short)45, this.pvPB, num1, ref DataBufferLength, pPtr, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
                Percentage = Translate.Cmmn_ReadInt16(num1, 0);
            Marshal.FreeHGlobal(pPtr);
            Marshal.FreeHGlobal(num1);
            return num2;
        }

        public virtual short btrFindPercentage(FORANALI.KeyName Key_nr, ref short Percentage)
        {
            short DataBufferLength = (short)4;
            IntPtr num1 = Marshal.AllocHGlobal((int)DataBufferLength);
            IntPtr pPtr = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref pPtr, checked((short)Key_nr));
            short num2 = Func.BTRCALL((short)45, this.pvPB, num1, ref DataBufferLength, pPtr, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
                Percentage = Translate.Cmmn_ReadInt16(num1, 0);
            Marshal.FreeHGlobal(pPtr);
            Marshal.FreeHGlobal(num1);
            return num2;
        }

        public class KeysStruct
        {
            private FORANALI.KeysStruct.struct_01 keyindex_1_priv;
            private FORANALI.KeysStruct.struct_02 keyUK_Id_priv;
            private FORANALI.KeysStruct.struct_00 keyindex_0_priv;

            public FORANALI.KeysStruct.struct_01 keyindex_1
            {
                get
                {
                    return this.keyindex_1_priv;
                }
                set
                {
                    this.keyindex_1_priv = value;
                }
            }

            public FORANALI.KeysStruct.struct_02 keyUK_Id
            {
                get
                {
                    return this.keyUK_Id_priv;
                }
                set
                {
                    this.keyUK_Id_priv = value;
                }
            }

            public FORANALI.KeysStruct.struct_00 keyindex_0
            {
                get
                {
                    return this.keyindex_0_priv;
                }
                set
                {
                    this.keyindex_0_priv = value;
                }
            }

            public KeysStruct()
            {
                this.keyindex_1_priv = new FORANALI.KeysStruct.struct_01();
                this.keyUK_Id_priv = new FORANALI.KeysStruct.struct_02();
                this.keyindex_0_priv = new FORANALI.KeysStruct.struct_00();
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
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 12)]
            internal char[] a_230;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            internal char[] a_242;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            internal char[] a_262;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            internal char[] a_282;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            internal char[] a_302;

            internal void initi()
            {
            }
        }

        public class FieldsClass : INotifyPropertyChanged
        {
            private int fldId_priv;
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
            private string fldunnamed_11_priv;
            private string fldunnamed_12_priv;
            private string fldInscricaoMunicipal_priv;
            private string fldunnamed_28_priv;
            private string fldunnamed_29_priv;

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

            public string fldunnamed_28
            {
                get
                {
                    return this.fldunnamed_28_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_28_priv, value, false) == 0)
                        return;
                    this.fldunnamed_28_priv = value;
                    this.OnPropertyChanged("fldunnamed_28");
                }
            }

            public string fldunnamed_29
            {
                get
                {
                    return this.fldunnamed_29_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_29_priv, value, false) == 0)
                        return;
                    this.fldunnamed_29_priv = value;
                    this.OnPropertyChanged("fldunnamed_29");
                }
            }

            public event PropertyChangedEventHandler PropertyChanged;

            public FieldsClass()
            {
                this.fldId_priv = 0;
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
                this.fldunnamed_11_priv = string.Empty;
                this.fldunnamed_12_priv = string.Empty;
                this.fldInscricaoMunicipal_priv = string.Empty;
                this.fldunnamed_28_priv = string.Empty;
                this.fldunnamed_29_priv = string.Empty;
            }

            protected internal void OnPropertyChanged(string pPropName)
            {
                PropertyChangedEventHandler changedEventHandler = null; // this.PropertyChangedEvent;
                if (changedEventHandler == null)
                    return;
                changedEventHandler((object)this, new PropertyChangedEventArgs(pPropName));
            }
        }
    }
}
