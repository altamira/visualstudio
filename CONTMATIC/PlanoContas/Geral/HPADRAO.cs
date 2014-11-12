// Type: Trial.HPADRAO
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 21EA38C8-8E3A-4764-8216-50D72DA77FBB
// Assembly location: C:\Documents and Settings\alessandro\Desktop\Trial.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC.Geral
{
    public class HPADRAO
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
        private HPADRAO.KeysStruct pvKeys;
        private bool pvTrimStrings;
        private HPADRAO.FieldsClass pvFields;
        private HPADRAO.FieldsClass[] pvFieldsExtr;
        private HPADRAO.FieldsClass_priv pvFieldsIntern;
        private Globals.StatExtended pvStatExt;
        private Globals.StatInfo pvStatInfo;

        public int fldCodigo
        {
            get
            {
                return this.pvFields.fldCodigo;
            }
            set
            {
                this.pvFields.fldCodigo = value;
            }
        }

        public string fldHistorico
        {
            get
            {
                return this.pvFields.fldHistorico;
            }
            set
            {
                this.pvFields.fldHistorico = value;
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

        public string fldunnamed_3
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

        public HPADRAO.KeysStruct Keys
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

        public HPADRAO.FieldsClass Fields
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

        public HPADRAO.FieldsClass[] Fields_ext
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

        public HPADRAO()
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[43];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\GERAL\\HPADRAO.BTR";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new HPADRAO.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new HPADRAO.FieldsClass();
            this.pvFieldsIntern.initi();
        }

        public HPADRAO(bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[43];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\GERAL\\HPADRAO.BTR";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new HPADRAO.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new HPADRAO.FieldsClass();
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        public HPADRAO(string DataPath)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[43];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\GERAL\\HPADRAO.BTR";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new HPADRAO.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new HPADRAO.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvFieldsIntern.initi();
        }

        public HPADRAO(string DataPath, bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[43];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\GERAL\\HPADRAO.BTR";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new HPADRAO.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new HPADRAO.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        private void VartoKB(ref IntPtr pPtr, short pKey)
        {
            if ((int)pKey == 0)
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmCodigo);
            else if ((int)pKey == 1)
            {
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.idxindex_1.sgmHistorico.Length < 40)
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmHistorico.PadRight(40)), 0, this.pvPtr, 40);
                else
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_1.sgmHistorico), 0, this.pvPtr, 40);
                this.pvPtr = IntPtr.Zero;
            }
            else
            {
                if ((int)pKey != 2)
                    return;
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
            }
        }

        private void KBtoVar(ref IntPtr pPtr4, short pKey)
        {
            if ((int)pKey == 0)
                this.pvKeys.idxindex_0.sgmCodigo = Translate.Cmmn_ReadInt32(pPtr4, 0);
            else if ((int)pKey == 1)
            {
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.idxindex_1.sgmHistorico = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 40) : Marshal.PtrToStringAnsi(this.pvPtr, 40).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else
            {
                if ((int)pKey != 2)
                    return;
                this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
            }
        }

        private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
        {
            HPADRAO hpadrao = this;
            object obj = Marshal.PtrToStructure(pPtr1, typeof(HPADRAO.FieldsClass_priv));
            HPADRAO.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
            HPADRAO.FieldsClass_priv fieldsClassPriv2 = obj != null ? (HPADRAO.FieldsClass_priv)obj : fieldsClassPriv1;
            hpadrao.pvFieldsIntern = fieldsClassPriv2;
            this.pvFields.fldCodigo = this.pvFieldsIntern.a_000;
            this.pvFields.fldHistorico = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
            this.pvFields.fldId = this.pvFieldsIntern.a_044;
            if (this.pvTrimStrings)
                this.pvFields.fldunnamed_3 = new string(this.pvFieldsIntern.a_048).Trim();
            else
                this.pvFields.fldunnamed_3 = new string(this.pvFieldsIntern.a_048);
        }

        private void StructtoDB(ref IntPtr pPtr2)
        {
            this.pvFieldsIntern.a_000 = this.pvFields.fldCodigo;
            this.pvFieldsIntern.a_004 = this.pvFields.fldHistorico.PadRight(40).ToCharArray();
            this.pvFieldsIntern.a_044 = this.pvFields.fldId;
            this.pvFieldsIntern.a_048 = this.pvFields.fldunnamed_3.PadRight(43).ToCharArray();
            Marshal.StructureToPtr((object)this.pvFieldsIntern, pPtr2, true);
        }

        private void VartoDB_ext(ref IntPtr pPtr3)
        {
            Translate.Cmmn_WriteInt16(pPtr3, checked((short)this.pvFieldsExtr.Length));
            short num1 = (short)2;
            int index = 0;
            while (index < this.pvFieldsExtr.Length)
            {
                this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldCodigo;
                this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldHistorico.PadRight(40).ToCharArray();
                this.pvFieldsIntern.a_044 = this.pvFieldsExtr[index].fldId;
                this.pvFieldsIntern.a_048 = this.pvFieldsExtr[index].fldunnamed_3.PadRight(43).ToCharArray();
                Translate.Cmmn_WriteInt16(pPtr3, (int)num1, (short)91);
                short num2 = checked((short)((int)num1 + 2));
                this.pvPtr = new IntPtr(checked(pPtr3.ToInt64() + (long)num2));
                Marshal.StructureToPtr((object)this.pvFieldsIntern, this.pvPtr, true);
                this.pvPtr = IntPtr.Zero;
                num1 = checked((short)((int)num2 + 91));
                checked { ++index; }
            }
        }

        public virtual short btrOpen(HPADRAO.OpenModes Mode, byte[] ClientId)
        {
            string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
            short num1 = checked((short)(s.Length + 1));
            IntPtr num2 = Marshal.AllocHGlobal((int)num1);
            short num3;
            IntPtr num4;
            if (this.pvOwnerName.Trim().Length == 0)
            {
                num3 = (short)0;
                num4 = IntPtr.Zero;
            }
            else
            {
                num3 = checked((short)(this.pvOwnerName.Length + 1));
                num4 = Marshal.AllocHGlobal((int)num3);
                Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num4, checked((int)num3 - 1));
                Translate.Cmmn_WriteByte(num4, checked((int)num3 - 1), (byte)0);
            }
            Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked((int)num1 - 1));
            Translate.Cmmn_WriteByte(num2, checked((int)num1 - 2), (byte)0);
            short num5 = Func.BTRCALLID((short)0, this.pvPB, num4, ref num3, num2, (short)byte.MaxValue, checked((short)Mode), ClientId);
            if ((int)num3 > 0)
                Marshal.FreeHGlobal(num4);
            Marshal.FreeHGlobal(num2);
            return num5;
        }

        public virtual short btrOpen(HPADRAO.OpenModes Mode)
        {
            string s = this.pvDataPath + Conversions.ToString(Translate.Cmmn_GetChar(32));
            short num1 = checked((short)(s.Length + 1));
            IntPtr num2 = Marshal.AllocHGlobal((int)num1);
            short num3;
            IntPtr num4;
            if (this.pvOwnerName.Trim().Length == 0)
            {
                num3 = (short)0;
                num4 = IntPtr.Zero;
            }
            else
            {
                num3 = checked((short)(this.pvOwnerName.Length + 1));
                num4 = Marshal.AllocHGlobal((int)num3);
                Marshal.Copy(Encoding.Default.GetBytes(this.pvOwnerName), 0, num4, checked((int)num3 - 1));
                Translate.Cmmn_WriteByte(num4, checked((int)num3 - 1), (byte)0);
            }
            Marshal.Copy(Encoding.Default.GetBytes(s), 0, num2, checked((int)num1 - 1));
            Translate.Cmmn_WriteByte(num2, checked((int)num1 - 2), (byte)0);
            short num5 = Func.BTRCALL((short)0, this.pvPB, num4, ref num3, num2, (short)byte.MaxValue, checked((short)Mode));
            if ((int)num3 > 0)
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

        public virtual short btrInsert(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = (short)91;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALLID((short)2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrInsert(HPADRAO.KeyName Key_nr)
        {
            short num1 = (short)91;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALL((short)2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrUpdate(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = (short)91;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALLID((short)3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrUpdate(HPADRAO.KeyName Key_nr)
        {
            short num1 = (short)91;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALL((short)3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
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

        public virtual short btrGetEqual(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetEqual(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 5)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 5)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetNext(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            else
            {
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            else
            {
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 6)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetPrevious(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            else
            {
                num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr), ClientId);
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num;
            if (KeyBuffer.Equals((object)IntPtr.Zero))
            {
                KeyBuffer = Marshal.AllocHGlobal((int)this.pbKBL);
                this.VartoKB(ref KeyBuffer, checked((short)Key_nr));
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            else
            {
                num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 7)), this.pvPB, pPtr1, ref pDBL, KeyBuffer, this.pbKBL, checked((short)Key_nr));
                if ((int)num == 0)
                    this.DBtoStruct(ref pPtr1, pDBL);
            }
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(HPADRAO.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreater(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreater(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetGreater(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 8)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetGreater(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 8)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetGreaterThanOrEqual(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreaterThanOrEqual(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreaterThanOrEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 9)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetGreaterThanOrEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 9)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLessThan(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThan(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThan(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetLessThan(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThan(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 10)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLessThan(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 10)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLessThanOrEqual(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThanOrEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThanOrEqual(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetLessThanOrEqual(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThanOrEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 11)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLessThanOrEqual(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr hglobal = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref hglobal, checked((short)Key_nr));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 11)), this.pvPB, pPtr1, ref pDBL, hglobal, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref hglobal, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(hglobal);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetFirst(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetFirst(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetFirst(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetFirst(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetFirst(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 12)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetFirst(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 12)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLast(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLast(Key_nr, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLast(HPADRAO.KeyName Key_nr)
        {
            return this.btrGetLast(Key_nr, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLast(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 13)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetLast(HPADRAO.KeyName Key_nr, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 13)), this.pvPB, pPtr1, ref pDBL, pPtr4, this.pbKBL, checked((short)Key_nr));
            if ((int)num == 0)
            {
                this.DBtoStruct(ref pPtr1, pDBL);
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            }
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetStat()
        {
            short num1 = (short)91;
            IntPtr hglobal1 = Marshal.AllocHGlobal((int)num1);
            IntPtr hglobal2 = Marshal.AllocHGlobal((int)this.pbKBL);
            short num2 = Func.BTRCALL((short)15, this.pvPB, hglobal1, ref num1, hglobal2, this.pbKBL, (short)-1);
            if ((int)num2 == 0)
                this.pvStatInfo.RecordLength = Translate.Cmmn_ReadInt16(hglobal1, 0);
            if ((int)num2 == 0)
                this.pvStatInfo.PageSize = Translate.Cmmn_ReadInt16(hglobal1, 2);
            if ((int)num2 == 0)
                this.pvStatInfo.NrOfIndexes = Translate.Cmmn_ReadByte(hglobal1, 4);
            if ((int)num2 == 0)
                this.pvStatInfo.FileVersion = Translate.Cmmn_ReadByte(hglobal1, 5);
            if ((int)num2 == 0)
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

        public virtual short btrGetDirectRecord(HPADRAO.KeyName Key_nr, IntPtr Position, byte[] ClientId)
        {
            return this.btrGetDirectRecord(Key_nr, Position, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetDirectRecord(HPADRAO.KeyName Key_nr, IntPtr Position)
        {
            return this.btrGetDirectRecord(Key_nr, Position, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetDirectRecord(HPADRAO.KeyName Key_nr, IntPtr Position, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetDirectRecord(HPADRAO.KeyName Key_nr, IntPtr Position, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr));
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepNext(byte[] ClientId)
        {
            return this.btrStepNext(HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepNext()
        {
            return this.btrStepNext(HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepNext(HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepNext(HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrUnlock(HPADRAO.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
        {
            IntPtr num1 = IntPtr.Zero;
            short num2 = Position == num1 || Position == IntPtr.Zero ? (short)0 : (short)4;
            return Func.BTRCALLID((short)27, this.pvPB, Position, ref num2, IntPtr.Zero, (short)0, checked((short)UnlockKey), ClientId);
        }

        public virtual short btrUnlock(HPADRAO.Unlock UnlockKey, IntPtr Position)
        {
            IntPtr num1 = IntPtr.Zero;
            short num2 = Position == num1 || Position == IntPtr.Zero ? (short)0 : (short)4;
            return Func.BTRCALL((short)27, this.pvPB, Position, ref num2, IntPtr.Zero, (short)0, checked((short)UnlockKey));
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
            return this.btrStepFirst(HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepFirst()
        {
            return this.btrStepFirst(HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepFirst(HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepFirst(HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(byte[] ClientId)
        {
            return this.btrStepLast(HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepLast()
        {
            return this.btrStepLast(HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepLast(HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(byte[] ClientId)
        {
            return this.btrStepPrevious(HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepPrevious()
        {
            return this.btrStepPrevious(HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepPrevious(HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrInsertExtended(HPADRAO.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = checked((short)(93 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num2 = Func.BTRCALLID((short)40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num2;
        }

        public virtual short btrInsertExtended(HPADRAO.KeyName Key_nr)
        {
            short num1 = checked((short)(93 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num2 = Func.BTRCALL((short)40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= HPADRAO.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num2;
        }

        public virtual short btrGetByPercentage(HPADRAO.KeyName Key_nr, short Percentage, byte[] ClientId)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, HPADRAO.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetByPercentage(HPADRAO.KeyName Key_nr, short Percentage)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, HPADRAO.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetByPercentage(HPADRAO.KeyName Key_nr, short Percentage, HPADRAO.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetByPercentage(HPADRAO.KeyName Key_nr, short Percentage, HPADRAO.RecordLocks Lock_Bias)
        {
            short pDBL = (short)91;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr));
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrFindPercentage(HPADRAO.KeyName Key_nr, ref short Percentage, byte[] ClientId)
        {
            short num1 = (short)4;
            IntPtr hglobal = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref pPtr, checked((short)Key_nr));
            short num2 = Func.BTRCALLID((short)45, this.pvPB, hglobal, ref num1, pPtr, this.pbKBL, checked((short)Key_nr), ClientId);
            if ((int)num2 == 0)
                Percentage = Translate.Cmmn_ReadInt16(hglobal, 0);
            Marshal.FreeHGlobal(pPtr);
            Marshal.FreeHGlobal(hglobal);
            return num2;
        }

        public virtual short btrFindPercentage(HPADRAO.KeyName Key_nr, ref short Percentage)
        {
            short num1 = (short)4;
            IntPtr hglobal = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoKB(ref pPtr, checked((short)Key_nr));
            short num2 = Func.BTRCALL((short)45, this.pvPB, hglobal, ref num1, pPtr, this.pbKBL, checked((short)Key_nr));
            if ((int)num2 == 0)
                Percentage = Translate.Cmmn_ReadInt16(hglobal, 0);
            Marshal.FreeHGlobal(pPtr);
            Marshal.FreeHGlobal(hglobal);
            return num2;
        }

        public class KeysStruct
        {
            private HPADRAO.KeysStruct.struct_01 idxindex_1_priv;
            private HPADRAO.KeysStruct.struct_02 idxUK_Id_priv;
            private HPADRAO.KeysStruct.struct_00 idxindex_0_priv;

            public HPADRAO.KeysStruct.struct_01 idxindex_1
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

            public HPADRAO.KeysStruct.struct_02 idxUK_Id
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

            public HPADRAO.KeysStruct.struct_00 idxindex_0
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
                this.idxindex_1_priv = new HPADRAO.KeysStruct.struct_01();
                this.idxUK_Id_priv = new HPADRAO.KeysStruct.struct_02();
                this.idxindex_0_priv = new HPADRAO.KeysStruct.struct_00();
            }

            public class struct_00
            {
                private int sgmCodigo_priv;

                public int sgmCodigo
                {
                    get
                    {
                        return this.sgmCodigo_priv;
                    }
                    set
                    {
                        this.sgmCodigo_priv = value;
                    }
                }

                public struct_00()
                {
                    this.sgmCodigo_priv = 0;
                }
            }

            public class struct_01
            {
                private string sgmHistorico_priv;

                public string sgmHistorico
                {
                    get
                    {
                        return this.sgmHistorico_priv;
                    }
                    set
                    {
                        this.sgmHistorico_priv = value;
                    }
                }

                public struct_01()
                {
                    this.sgmHistorico_priv = string.Empty;
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

        [StructLayout(LayoutKind.Sequential, Size = 91, Pack = 1)]
        internal struct FieldsClass_priv
        {
            internal int a_000;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
            internal char[] a_004;
            internal int a_044;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 43)]
            internal char[] a_048;

            internal void initi()
            {
            }
        }

        public class FieldsClass : INotifyPropertyChanged
        {
            private int fldCodigo_priv;
            private string fldHistorico_priv;
            private int fldId_priv;
            private string fldunnamed_3_priv;
            private PropertyChangedEventHandler PropertyChangedEvent;

            public int fldCodigo
            {
                get
                {
                    return this.fldCodigo_priv;
                }
                set
                {
                    if (this.fldCodigo_priv == value)
                        return;
                    this.fldCodigo_priv = value;
                    this.OnPropertyChanged("fldCodigo");
                }
            }

            public string fldHistorico
            {
                get
                {
                    return this.fldHistorico_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldHistorico_priv, value, false) == 0)
                        return;
                    this.fldHistorico_priv = value;
                    this.OnPropertyChanged("fldHistorico");
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

            public string fldunnamed_3
            {
                get
                {
                    return this.fldunnamed_3_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_3_priv, value, false) == 0)
                        return;
                    this.fldunnamed_3_priv = value;
                    this.OnPropertyChanged("fldunnamed_3");
                }
            }

            public event PropertyChangedEventHandler PropertyChanged;

            public FieldsClass()
            {
                this.fldCodigo_priv = 0;
                this.fldHistorico_priv = string.Empty;
                this.fldId_priv = 0;
                this.fldunnamed_3_priv = string.Empty;
            }

            protected internal void OnPropertyChanged(string pPropName)
            {
                PropertyChangedEventHandler changedEventHandler = this.PropertyChangedEvent;
                if (changedEventHandler == null)
                    return;
                changedEventHandler((object)this, new PropertyChangedEventArgs(pPropName));
            }
        }
    }
}
