// Type: Trial.Lctos
// Assembly: Trial, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 6E601A57-5983-4400-B739-789834EA97CC
// Assembly location: C:\Documents and Settings\alessandro\Desktop\Trial.dll

using lybtrcom;
using Microsoft.VisualBasic.CompilerServices;
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace CONTMATIC.Empresas
{
    public class Lctos
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
        private Lctos.KeysStruct pvKeys;
        private bool pvTrimStrings;
        private Lctos.FieldsClass pvFields;
        private Lctos.FieldsClass[] pvFieldsExtr;
        private Lctos.FieldsClass_priv pvFieldsIntern;
        private Globals.StatExtended pvStatExt;
        private Globals.StatInfo pvStatInfo;

        public int fldLancamento
        {
            get
            {
                return this.pvFields.fldLancamento;
            }
            set
            {
                this.pvFields.fldLancamento = value;
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

        public string fldCCRDebito
        {
            get
            {
                return this.pvFields.fldCCRDebito;
            }
            set
            {
                this.pvFields.fldCCRDebito = value;
            }
        }

        public string fldCCDebito
        {
            get
            {
                return this.pvFields.fldCCDebito;
            }
            set
            {
                this.pvFields.fldCCDebito = value;
            }
        }

        public string fldCCRCredito
        {
            get
            {
                return this.pvFields.fldCCRCredito;
            }
            set
            {
                this.pvFields.fldCCRCredito = value;
            }
        }

        public string fldCCCredito
        {
            get
            {
                return this.pvFields.fldCCCredito;
            }
            set
            {
                this.pvFields.fldCCCredito = value;
            }
        }

        public int fldHistorico
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

        public double fldValor
        {
            get
            {
                return this.pvFields.fldValor;
            }
            set
            {
                this.pvFields.fldValor = value;
            }
        }

        public string fldOrigem
        {
            get
            {
                return this.pvFields.fldOrigem;
            }
            set
            {
                this.pvFields.fldOrigem = value;
            }
        }

        public int fldLote
        {
            get
            {
                return this.pvFields.fldLote;
            }
            set
            {
                this.pvFields.fldLote = value;
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

        public double fldunnamed_113
        {
            get
            {
                return this.pvFields.fldunnamed_113;
            }
            set
            {
                this.pvFields.fldunnamed_113 = value;
            }
        }

        public string fldunnamed_114
        {
            get
            {
                return this.pvFields.fldunnamed_114;
            }
            set
            {
                this.pvFields.fldunnamed_114 = value;
            }
        }

        public double fldunnamed_111
        {
            get
            {
                return this.pvFields.fldunnamed_111;
            }
            set
            {
                this.pvFields.fldunnamed_111 = value;
            }
        }

        public string fldunnamed_112
        {
            get
            {
                return this.pvFields.fldunnamed_112;
            }
            set
            {
                this.pvFields.fldunnamed_112 = value;
            }
        }

        public double fldunnamed_109
        {
            get
            {
                return this.pvFields.fldunnamed_109;
            }
            set
            {
                this.pvFields.fldunnamed_109 = value;
            }
        }

        public string fldunnamed_110
        {
            get
            {
                return this.pvFields.fldunnamed_110;
            }
            set
            {
                this.pvFields.fldunnamed_110 = value;
            }
        }

        public double fldunnamed_107
        {
            get
            {
                return this.pvFields.fldunnamed_107;
            }
            set
            {
                this.pvFields.fldunnamed_107 = value;
            }
        }

        public string fldunnamed_108
        {
            get
            {
                return this.pvFields.fldunnamed_108;
            }
            set
            {
                this.pvFields.fldunnamed_108 = value;
            }
        }

        public double fldunnamed_105
        {
            get
            {
                return this.pvFields.fldunnamed_105;
            }
            set
            {
                this.pvFields.fldunnamed_105 = value;
            }
        }

        public string fldunnamed_106
        {
            get
            {
                return this.pvFields.fldunnamed_106;
            }
            set
            {
                this.pvFields.fldunnamed_106 = value;
            }
        }

        public double fldunnamed_103
        {
            get
            {
                return this.pvFields.fldunnamed_103;
            }
            set
            {
                this.pvFields.fldunnamed_103 = value;
            }
        }

        public string fldunnamed_104
        {
            get
            {
                return this.pvFields.fldunnamed_104;
            }
            set
            {
                this.pvFields.fldunnamed_104 = value;
            }
        }

        public double fldunnamed_101
        {
            get
            {
                return this.pvFields.fldunnamed_101;
            }
            set
            {
                this.pvFields.fldunnamed_101 = value;
            }
        }

        public string fldunnamed_102
        {
            get
            {
                return this.pvFields.fldunnamed_102;
            }
            set
            {
                this.pvFields.fldunnamed_102 = value;
            }
        }

        public double fldunnamed_99
        {
            get
            {
                return this.pvFields.fldunnamed_99;
            }
            set
            {
                this.pvFields.fldunnamed_99 = value;
            }
        }

        public string fldunnamed_100
        {
            get
            {
                return this.pvFields.fldunnamed_100;
            }
            set
            {
                this.pvFields.fldunnamed_100 = value;
            }
        }

        public double fldunnamed_97
        {
            get
            {
                return this.pvFields.fldunnamed_97;
            }
            set
            {
                this.pvFields.fldunnamed_97 = value;
            }
        }

        public string fldunnamed_98
        {
            get
            {
                return this.pvFields.fldunnamed_98;
            }
            set
            {
                this.pvFields.fldunnamed_98 = value;
            }
        }

        public double fldunnamed_95
        {
            get
            {
                return this.pvFields.fldunnamed_95;
            }
            set
            {
                this.pvFields.fldunnamed_95 = value;
            }
        }

        public string fldunnamed_96
        {
            get
            {
                return this.pvFields.fldunnamed_96;
            }
            set
            {
                this.pvFields.fldunnamed_96 = value;
            }
        }

        public double fldunnamed_230
        {
            get
            {
                return this.pvFields.fldunnamed_230;
            }
            set
            {
                this.pvFields.fldunnamed_230 = value;
            }
        }

        public string fldunnamed_231
        {
            get
            {
                return this.pvFields.fldunnamed_231;
            }
            set
            {
                this.pvFields.fldunnamed_231 = value;
            }
        }

        public double fldunnamed_232
        {
            get
            {
                return this.pvFields.fldunnamed_232;
            }
            set
            {
                this.pvFields.fldunnamed_232 = value;
            }
        }

        public string fldunnamed_233
        {
            get
            {
                return this.pvFields.fldunnamed_233;
            }
            set
            {
                this.pvFields.fldunnamed_233 = value;
            }
        }

        public double fldunnamed_93
        {
            get
            {
                return this.pvFields.fldunnamed_93;
            }
            set
            {
                this.pvFields.fldunnamed_93 = value;
            }
        }

        public string fldunnamed_94
        {
            get
            {
                return this.pvFields.fldunnamed_94;
            }
            set
            {
                this.pvFields.fldunnamed_94 = value;
            }
        }

        public double fldunnamed_92
        {
            get
            {
                return this.pvFields.fldunnamed_92;
            }
            set
            {
                this.pvFields.fldunnamed_92 = value;
            }
        }

        public string fldunnamed_91
        {
            get
            {
                return this.pvFields.fldunnamed_91;
            }
            set
            {
                this.pvFields.fldunnamed_91 = value;
            }
        }

        public double fldunnamed_90
        {
            get
            {
                return this.pvFields.fldunnamed_90;
            }
            set
            {
                this.pvFields.fldunnamed_90 = value;
            }
        }

        public string fldunnamed_89
        {
            get
            {
                return this.pvFields.fldunnamed_89;
            }
            set
            {
                this.pvFields.fldunnamed_89 = value;
            }
        }

        public double fldunnamed_88
        {
            get
            {
                return this.pvFields.fldunnamed_88;
            }
            set
            {
                this.pvFields.fldunnamed_88 = value;
            }
        }

        public string fldunnamed_87
        {
            get
            {
                return this.pvFields.fldunnamed_87;
            }
            set
            {
                this.pvFields.fldunnamed_87 = value;
            }
        }

        public double fldunnamed_86
        {
            get
            {
                return this.pvFields.fldunnamed_86;
            }
            set
            {
                this.pvFields.fldunnamed_86 = value;
            }
        }

        public string fldunnamed_85
        {
            get
            {
                return this.pvFields.fldunnamed_85;
            }
            set
            {
                this.pvFields.fldunnamed_85 = value;
            }
        }

        public double fldunnamed_84
        {
            get
            {
                return this.pvFields.fldunnamed_84;
            }
            set
            {
                this.pvFields.fldunnamed_84 = value;
            }
        }

        public string fldunnamed_83
        {
            get
            {
                return this.pvFields.fldunnamed_83;
            }
            set
            {
                this.pvFields.fldunnamed_83 = value;
            }
        }

        public double fldunnamed_82
        {
            get
            {
                return this.pvFields.fldunnamed_82;
            }
            set
            {
                this.pvFields.fldunnamed_82 = value;
            }
        }

        public string fldunnamed_81
        {
            get
            {
                return this.pvFields.fldunnamed_81;
            }
            set
            {
                this.pvFields.fldunnamed_81 = value;
            }
        }

        public double fldunnamed_80
        {
            get
            {
                return this.pvFields.fldunnamed_80;
            }
            set
            {
                this.pvFields.fldunnamed_80 = value;
            }
        }

        public string fldunnamed_79
        {
            get
            {
                return this.pvFields.fldunnamed_79;
            }
            set
            {
                this.pvFields.fldunnamed_79 = value;
            }
        }

        public double fldunnamed_78
        {
            get
            {
                return this.pvFields.fldunnamed_78;
            }
            set
            {
                this.pvFields.fldunnamed_78 = value;
            }
        }

        public string fldunnamed_77
        {
            get
            {
                return this.pvFields.fldunnamed_77;
            }
            set
            {
                this.pvFields.fldunnamed_77 = value;
            }
        }

        public double fldunnamed_76
        {
            get
            {
                return this.pvFields.fldunnamed_76;
            }
            set
            {
                this.pvFields.fldunnamed_76 = value;
            }
        }

        public string fldunnamed_75
        {
            get
            {
                return this.pvFields.fldunnamed_75;
            }
            set
            {
                this.pvFields.fldunnamed_75 = value;
            }
        }

        public double fldunnamed_74
        {
            get
            {
                return this.pvFields.fldunnamed_74;
            }
            set
            {
                this.pvFields.fldunnamed_74 = value;
            }
        }

        public string fldunnamed_73
        {
            get
            {
                return this.pvFields.fldunnamed_73;
            }
            set
            {
                this.pvFields.fldunnamed_73 = value;
            }
        }

        public double fldunnamed_72
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

        public string fldunnamed_71
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

        public double fldunnamed_70
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

        public string fldunnamed_69
        {
            get
            {
                return this.pvFields.fldunnamed_69;
            }
            set
            {
                this.pvFields.fldunnamed_69 = value;
            }
        }

        public double fldunnamed_68
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

        public string fldunnamed_65
        {
            get
            {
                return this.pvFields.fldunnamed_65;
            }
            set
            {
                this.pvFields.fldunnamed_65 = value;
            }
        }

        public double fldunnamed_64
        {
            get
            {
                return this.pvFields.fldunnamed_64;
            }
            set
            {
                this.pvFields.fldunnamed_64 = value;
            }
        }

        public string fldunnamed_63
        {
            get
            {
                return this.pvFields.fldunnamed_63;
            }
            set
            {
                this.pvFields.fldunnamed_63 = value;
            }
        }

        public double fldunnamed_62
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

        public double fldunnamed_60
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

        public string fldunnamed_59
        {
            get
            {
                return this.pvFields.fldunnamed_59;
            }
            set
            {
                this.pvFields.fldunnamed_59 = value;
            }
        }

        public double fldunnamed_58
        {
            get
            {
                return this.pvFields.fldunnamed_58;
            }
            set
            {
                this.pvFields.fldunnamed_58 = value;
            }
        }

        public string fldunnamed_57
        {
            get
            {
                return this.pvFields.fldunnamed_57;
            }
            set
            {
                this.pvFields.fldunnamed_57 = value;
            }
        }

        public double fldunnamed_56
        {
            get
            {
                return this.pvFields.fldunnamed_56;
            }
            set
            {
                this.pvFields.fldunnamed_56 = value;
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

        public double fldunnamed_54
        {
            get
            {
                return this.pvFields.fldunnamed_54;
            }
            set
            {
                this.pvFields.fldunnamed_54 = value;
            }
        }

        public string fldunnamed_53
        {
            get
            {
                return this.pvFields.fldunnamed_53;
            }
            set
            {
                this.pvFields.fldunnamed_53 = value;
            }
        }

        public double fldunnamed_52
        {
            get
            {
                return this.pvFields.fldunnamed_52;
            }
            set
            {
                this.pvFields.fldunnamed_52 = value;
            }
        }

        public string fldunnamed_51
        {
            get
            {
                return this.pvFields.fldunnamed_51;
            }
            set
            {
                this.pvFields.fldunnamed_51 = value;
            }
        }

        public double fldunnamed_50
        {
            get
            {
                return this.pvFields.fldunnamed_50;
            }
            set
            {
                this.pvFields.fldunnamed_50 = value;
            }
        }

        public string fldunnamed_49
        {
            get
            {
                return this.pvFields.fldunnamed_49;
            }
            set
            {
                this.pvFields.fldunnamed_49 = value;
            }
        }

        public double fldunnamed_48
        {
            get
            {
                return this.pvFields.fldunnamed_48;
            }
            set
            {
                this.pvFields.fldunnamed_48 = value;
            }
        }

        public string fldunnamed_47
        {
            get
            {
                return this.pvFields.fldunnamed_47;
            }
            set
            {
                this.pvFields.fldunnamed_47 = value;
            }
        }

        public double fldunnamed_46
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

        public string fldunnamed_45
        {
            get
            {
                return this.pvFields.fldunnamed_45;
            }
            set
            {
                this.pvFields.fldunnamed_45 = value;
            }
        }

        public double fldunnamed_44
        {
            get
            {
                return this.pvFields.fldunnamed_44;
            }
            set
            {
                this.pvFields.fldunnamed_44 = value;
            }
        }

        public string fldunnamed_43
        {
            get
            {
                return this.pvFields.fldunnamed_43;
            }
            set
            {
                this.pvFields.fldunnamed_43 = value;
            }
        }

        public double fldunnamed_42
        {
            get
            {
                return this.pvFields.fldunnamed_42;
            }
            set
            {
                this.pvFields.fldunnamed_42 = value;
            }
        }

        public string fldunnamed_41
        {
            get
            {
                return this.pvFields.fldunnamed_41;
            }
            set
            {
                this.pvFields.fldunnamed_41 = value;
            }
        }

        public double fldunnamed_40
        {
            get
            {
                return this.pvFields.fldunnamed_40;
            }
            set
            {
                this.pvFields.fldunnamed_40 = value;
            }
        }

        public string fldunnamed_39
        {
            get
            {
                return this.pvFields.fldunnamed_39;
            }
            set
            {
                this.pvFields.fldunnamed_39 = value;
            }
        }

        public double fldunnamed_38
        {
            get
            {
                return this.pvFields.fldunnamed_38;
            }
            set
            {
                this.pvFields.fldunnamed_38 = value;
            }
        }

        public string fldunnamed_37
        {
            get
            {
                return this.pvFields.fldunnamed_37;
            }
            set
            {
                this.pvFields.fldunnamed_37 = value;
            }
        }

        public double fldunnamed_36
        {
            get
            {
                return this.pvFields.fldunnamed_36;
            }
            set
            {
                this.pvFields.fldunnamed_36 = value;
            }
        }

        public string fldunnamed_35
        {
            get
            {
                return this.pvFields.fldunnamed_35;
            }
            set
            {
                this.pvFields.fldunnamed_35 = value;
            }
        }

        public double fldunnamed_34
        {
            get
            {
                return this.pvFields.fldunnamed_34;
            }
            set
            {
                this.pvFields.fldunnamed_34 = value;
            }
        }

        public string fldunnamed_33
        {
            get
            {
                return this.pvFields.fldunnamed_33;
            }
            set
            {
                this.pvFields.fldunnamed_33 = value;
            }
        }

        public double fldunnamed_32
        {
            get
            {
                return this.pvFields.fldunnamed_32;
            }
            set
            {
                this.pvFields.fldunnamed_32 = value;
            }
        }

        public string fldunnamed_31
        {
            get
            {
                return this.pvFields.fldunnamed_31;
            }
            set
            {
                this.pvFields.fldunnamed_31 = value;
            }
        }

        public double fldunnamed_30
        {
            get
            {
                return this.pvFields.fldunnamed_30;
            }
            set
            {
                this.pvFields.fldunnamed_30 = value;
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

        public double fldunnamed_28
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

        public string fldunnamed_27
        {
            get
            {
                return this.pvFields.fldunnamed_27;
            }
            set
            {
                this.pvFields.fldunnamed_27 = value;
            }
        }

        public double fldunnamed_26
        {
            get
            {
                return this.pvFields.fldunnamed_26;
            }
            set
            {
                this.pvFields.fldunnamed_26 = value;
            }
        }

        public string fldunnamed_25
        {
            get
            {
                return this.pvFields.fldunnamed_25;
            }
            set
            {
                this.pvFields.fldunnamed_25 = value;
            }
        }

        public double fldunnamed_24
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

        public string fldunnamed_23
        {
            get
            {
                return this.pvFields.fldunnamed_23;
            }
            set
            {
                this.pvFields.fldunnamed_23 = value;
            }
        }

        public double fldunnamed_22
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

        public double fldunnamed_21
        {
            get
            {
                return this.pvFields.fldunnamed_21;
            }
            set
            {
                this.pvFields.fldunnamed_21 = value;
            }
        }

        public string fldunnamed_234
        {
            get
            {
                return this.pvFields.fldunnamed_234;
            }
            set
            {
                this.pvFields.fldunnamed_234 = value;
            }
        }

        public string fldunnamed_7
        {
            get
            {
                return this.pvFields.fldunnamed_7;
            }
            set
            {
                this.pvFields.fldunnamed_7 = value;
            }
        }

        public short fldMes
        {
            get
            {
                return this.pvFields.fldMes;
            }
            set
            {
                this.pvFields.fldMes = value;
            }
        }

        public short fldDia
        {
            get
            {
                return this.pvFields.fldDia;
            }
            set
            {
                this.pvFields.fldDia = value;
            }
        }

        public int fldSequencia
        {
            get
            {
                return this.pvFields.fldSequencia;
            }
            set
            {
                this.pvFields.fldSequencia = value;
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

        public Lctos.KeysStruct Keys
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

        public Lctos.FieldsClass Fields
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

        public Lctos.FieldsClass[] Fields_ext
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

        public Lctos()
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[200];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\EMPRESAS\\ALTAMIRA\\2013\\..\\2012\\Lctos.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new Lctos.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new Lctos.FieldsClass();
            this.pvFieldsIntern.initi();
        }

        public Lctos(bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[200];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\EMPRESAS\\ALTAMIRA\\2013\\..\\2012\\Lctos.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new Lctos.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new Lctos.FieldsClass();
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        public Lctos(string DataPath)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[200];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\EMPRESAS\\ALTAMIRA\\2013\\..\\2012\\Lctos.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new Lctos.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new Lctos.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvFieldsIntern.initi();
        }

        public Lctos(string DataPath, bool Trim_Strings)
        {
            this.pvPB = new byte[128];
            this.pbKBL = (short)byte.MaxValue;
            this.pvStBld = new StringBuilder();
            this.pvaBt = new byte[200];
            this.pva16 = new ushort[1];
            this.pva32 = new uint[1];
            this.pva64 = new ulong[1];
            this.pvaSng = new float[1];
            this.pvaDbl = new double[1];
            this.pvDataPath = "C:\\PHOENIX\\EMPRESAS\\ALTAMIRA\\2013\\..\\2012\\Lctos.btr";
            this.pvDirectory = string.Empty;
            this.pvOwnerName = string.Empty;
            this.pvKeys = new Lctos.KeysStruct();
            this.pvTrimStrings = false;
            this.pvFields = new Lctos.FieldsClass();
            this.pvDataPath = Path.Combine(DataPath, Path.GetFileName(this.pvDataPath));
            this.pvTrimStrings = Trim_Strings;
            this.pvFieldsIntern.initi();
        }

        private void VartoKB(ref IntPtr pPtr, short pKey)
        {
            if ((int)pKey == 0)
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_0.sgmLancamento);
            else if ((int)pKey == 1)
            {
                Translate.Cmmn_WriteInt16(pPtr, 2, this.pvKeys.idxindex_1.sgmDia);
                Translate.Cmmn_WriteInt32(pPtr, 4, this.pvKeys.idxindex_1.sgmunnamed_5);
                Translate.Cmmn_WriteInt32(pPtr, 8, this.pvKeys.idxindex_1.sgmunnamed_4);
                Translate.Cmmn_WriteInt16(pPtr, 0, this.pvKeys.idxindex_1.sgmMes);
            }
            else if ((int)pKey == 2)
            {
                Translate.Cmmn_WriteInt32(pPtr, 4, this.pvKeys.idxindex_2.sgmunnamed_4);
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_2.sgmunnamed_5);
            }
            else if ((int)pKey == 3)
            {
                Translate.Cmmn_WriteInt32(pPtr, 1, this.pvKeys.idxindex_3.sgmLote);
                Translate.Cmmn_WriteInt16(pPtr, 5, this.pvKeys.idxindex_3.sgmMes);
                Translate.Cmmn_WriteInt16(pPtr, 7, this.pvKeys.idxindex_3.sgmDia);
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.idxindex_3.sgmOrigem.Length < 1)
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_3.sgmOrigem.PadRight(1)), 0, this.pvPtr, 1);
                else
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_3.sgmOrigem), 0, this.pvPtr, 1);
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 4)
            {
                Translate.Cmmn_WriteInt16(pPtr, 1, this.pvKeys.idxindex_4.sgmMes);
                Translate.Cmmn_WriteInt16(pPtr, 3, this.pvKeys.idxindex_4.sgmDia);
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.idxindex_4.sgmOrigem.Length < 1)
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_4.sgmOrigem.PadRight(1)), 0, this.pvPtr, 1);
                else
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_4.sgmOrigem), 0, this.pvPtr, 1);
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 5)
            {
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 1L));
                if (this.pvKeys.idxindex_5.sgmunnamed_7.Length < 8)
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmunnamed_7.PadRight(8)), 0, this.pvPtr, 8);
                else
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmunnamed_7), 0, this.pvPtr, 8);
                this.pvPtr = IntPtr.Zero;
                Translate.Cmmn_WriteInt16(pPtr, 9, this.pvKeys.idxindex_5.sgmMes);
                this.pvPtr = new IntPtr(checked(pPtr.ToInt64() + 0L));
                if (this.pvKeys.idxindex_5.sgmOrigem.Length < 1)
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmOrigem.PadRight(1)), 0, this.pvPtr, 1);
                else
                    Marshal.Copy(Encoding.Default.GetBytes(this.pvKeys.idxindex_5.sgmOrigem), 0, this.pvPtr, 1);
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 6)
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxindex_6.sgmSequencia);
            else if ((int)pKey == 7)
            {
                Translate.Cmmn_WriteInt32(pPtr, 0, this.pvKeys.idxUK_Id.sgmId);
            }
            else
            {
                if ((int)pKey != 8)
                    return;
                Translate.Cmmn_WriteInt32(pPtr, 2, this.pvKeys.idxindex_8.sgmSequencia);
                Translate.Cmmn_WriteInt16(pPtr, 0, this.pvKeys.idxindex_8.sgmMes);
            }
        }

        private void KBtoVar(ref IntPtr pPtr4, short pKey)
        {
            if ((int)pKey == 0)
                this.pvKeys.idxindex_0.sgmLancamento = Translate.Cmmn_ReadInt32(pPtr4, 0);
            else if ((int)pKey == 1)
            {
                this.pvKeys.idxindex_1.sgmDia = Translate.Cmmn_ReadInt16(pPtr4, 2);
                this.pvKeys.idxindex_1.sgmunnamed_5 = Translate.Cmmn_ReadInt32(pPtr4, 4);
                this.pvKeys.idxindex_1.sgmunnamed_4 = Translate.Cmmn_ReadInt32(pPtr4, 8);
                this.pvKeys.idxindex_1.sgmMes = Translate.Cmmn_ReadInt16(pPtr4, 0);
            }
            else if ((int)pKey == 2)
            {
                this.pvKeys.idxindex_2.sgmunnamed_4 = Translate.Cmmn_ReadInt32(pPtr4, 4);
                this.pvKeys.idxindex_2.sgmunnamed_5 = Translate.Cmmn_ReadInt32(pPtr4, 0);
            }
            else if ((int)pKey == 3)
            {
                this.pvKeys.idxindex_3.sgmLote = Translate.Cmmn_ReadInt32(pPtr4, 1);
                this.pvKeys.idxindex_3.sgmMes = Translate.Cmmn_ReadInt16(pPtr4, 5);
                this.pvKeys.idxindex_3.sgmDia = Translate.Cmmn_ReadInt16(pPtr4, 7);
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.idxindex_3.sgmOrigem = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 4)
            {
                this.pvKeys.idxindex_4.sgmMes = Translate.Cmmn_ReadInt16(pPtr4, 1);
                this.pvKeys.idxindex_4.sgmDia = Translate.Cmmn_ReadInt16(pPtr4, 3);
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.idxindex_4.sgmOrigem = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 5)
            {
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 1L));
                this.pvKeys.idxindex_5.sgmunnamed_7 = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 8) : Marshal.PtrToStringAnsi(this.pvPtr, 8).Trim();
                this.pvPtr = IntPtr.Zero;
                this.pvKeys.idxindex_5.sgmMes = Translate.Cmmn_ReadInt16(pPtr4, 9);
                this.pvPtr = new IntPtr(checked(pPtr4.ToInt64() + 0L));
                this.pvKeys.idxindex_5.sgmOrigem = !this.pvTrimStrings ? Marshal.PtrToStringAnsi(this.pvPtr, 1) : Marshal.PtrToStringAnsi(this.pvPtr, 1).Trim();
                this.pvPtr = IntPtr.Zero;
            }
            else if ((int)pKey == 6)
                this.pvKeys.idxindex_6.sgmSequencia = Translate.Cmmn_ReadInt32(pPtr4, 0);
            else if ((int)pKey == 7)
            {
                this.pvKeys.idxUK_Id.sgmId = Translate.Cmmn_ReadInt32(pPtr4, 0);
            }
            else
            {
                if ((int)pKey != 8)
                    return;
                this.pvKeys.idxindex_8.sgmSequencia = Translate.Cmmn_ReadInt32(pPtr4, 2);
                this.pvKeys.idxindex_8.sgmMes = Translate.Cmmn_ReadInt16(pPtr4, 0);
            }
        }

        private void DBtoStruct(ref IntPtr pPtr1, short pDBL)
        {
            Lctos lctos = this;
            object obj = Marshal.PtrToStructure(pPtr1, typeof(Lctos.FieldsClass_priv));
            Lctos.FieldsClass_priv fieldsClassPriv1 = new FieldsClass_priv();
            Lctos.FieldsClass_priv fieldsClassPriv2 = obj != null ? (Lctos.FieldsClass_priv)obj : fieldsClassPriv1;
            lctos.pvFieldsIntern = fieldsClassPriv2;
            this.pvFields.fldLancamento = this.pvFieldsIntern.a_000;
            this.pvFields.fldData = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_004) : new string(this.pvFieldsIntern.a_004).Trim();
            this.pvFields.fldCCRDebito = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_009) : new string(this.pvFieldsIntern.a_009).Trim();
            this.pvFields.fldCCDebito = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_016) : new string(this.pvFieldsIntern.a_016).Trim();
            this.pvFields.fldCCRCredito = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_072) : new string(this.pvFieldsIntern.a_072).Trim();
            this.pvFields.fldCCCredito = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_079) : new string(this.pvFieldsIntern.a_079).Trim();
            this.pvFields.fldHistorico = this.pvFieldsIntern.a_135;
            this.pvFields.fldComplemento = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_139) : new string(this.pvFieldsIntern.a_139).Trim();
            this.pvFields.fldValor = this.pvFieldsIntern.a_339;
            this.pvFields.fldOrigem = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_347) : new string(this.pvFieldsIntern.a_347).Trim();
            this.pvFields.fldLote = this.pvFieldsIntern.a_348;
            this.pvFields.fldunnamed_4 = this.pvFieldsIntern.a_352;
            this.pvFields.fldunnamed_5 = this.pvFieldsIntern.a_356;
            this.pvFields.fldunnamed_6 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_360) : new string(this.pvFieldsIntern.a_360).Trim();
            this.pvFields.fldunnamed_113 = this.pvFieldsIntern.a_402;
            this.pvFields.fldunnamed_114 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_410) : new string(this.pvFieldsIntern.a_410).Trim();
            this.pvFields.fldunnamed_111 = this.pvFieldsIntern.a_452;
            this.pvFields.fldunnamed_112 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_460) : new string(this.pvFieldsIntern.a_460).Trim();
            this.pvFields.fldunnamed_109 = this.pvFieldsIntern.a_502;
            this.pvFields.fldunnamed_110 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_510) : new string(this.pvFieldsIntern.a_510).Trim();
            this.pvFields.fldunnamed_107 = this.pvFieldsIntern.a_552;
            this.pvFields.fldunnamed_108 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_560) : new string(this.pvFieldsIntern.a_560).Trim();
            this.pvFields.fldunnamed_105 = this.pvFieldsIntern.a_602;
            this.pvFields.fldunnamed_106 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_610) : new string(this.pvFieldsIntern.a_610).Trim();
            this.pvFields.fldunnamed_103 = this.pvFieldsIntern.a_652;
            this.pvFields.fldunnamed_104 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_660) : new string(this.pvFieldsIntern.a_660).Trim();
            this.pvFields.fldunnamed_101 = this.pvFieldsIntern.a_702;
            this.pvFields.fldunnamed_102 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_710) : new string(this.pvFieldsIntern.a_710).Trim();
            this.pvFields.fldunnamed_99 = this.pvFieldsIntern.a_752;
            this.pvFields.fldunnamed_100 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_760) : new string(this.pvFieldsIntern.a_760).Trim();
            this.pvFields.fldunnamed_97 = this.pvFieldsIntern.a_802;
            this.pvFields.fldunnamed_98 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_810) : new string(this.pvFieldsIntern.a_810).Trim();
            this.pvFields.fldunnamed_95 = this.pvFieldsIntern.a_852;
            this.pvFields.fldunnamed_96 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_860) : new string(this.pvFieldsIntern.a_860).Trim();
            this.pvFields.fldunnamed_230 = this.pvFieldsIntern.a_902;
            this.pvFields.fldunnamed_231 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_910) : new string(this.pvFieldsIntern.a_910).Trim();
            this.pvFields.fldunnamed_232 = this.pvFieldsIntern.a_952;
            this.pvFields.fldunnamed_233 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_960) : new string(this.pvFieldsIntern.a_960).Trim();
            this.pvFields.fldunnamed_93 = this.pvFieldsIntern.a_1002;
            this.pvFields.fldunnamed_94 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1010) : new string(this.pvFieldsIntern.a_1010).Trim();
            this.pvFields.fldunnamed_92 = this.pvFieldsIntern.a_1052;
            this.pvFields.fldunnamed_91 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1060) : new string(this.pvFieldsIntern.a_1060).Trim();
            this.pvFields.fldunnamed_90 = this.pvFieldsIntern.a_1102;
            this.pvFields.fldunnamed_89 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1110) : new string(this.pvFieldsIntern.a_1110).Trim();
            this.pvFields.fldunnamed_88 = this.pvFieldsIntern.a_1152;
            this.pvFields.fldunnamed_87 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1160) : new string(this.pvFieldsIntern.a_1160).Trim();
            this.pvFields.fldunnamed_86 = this.pvFieldsIntern.a_1202;
            this.pvFields.fldunnamed_85 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1210) : new string(this.pvFieldsIntern.a_1210).Trim();
            this.pvFields.fldunnamed_84 = this.pvFieldsIntern.a_1252;
            this.pvFields.fldunnamed_83 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1260) : new string(this.pvFieldsIntern.a_1260).Trim();
            this.pvFields.fldunnamed_82 = this.pvFieldsIntern.a_1302;
            this.pvFields.fldunnamed_81 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1310) : new string(this.pvFieldsIntern.a_1310).Trim();
            this.pvFields.fldunnamed_80 = this.pvFieldsIntern.a_1352;
            this.pvFields.fldunnamed_79 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1360) : new string(this.pvFieldsIntern.a_1360).Trim();
            this.pvFields.fldunnamed_78 = this.pvFieldsIntern.a_1402;
            this.pvFields.fldunnamed_77 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1410) : new string(this.pvFieldsIntern.a_1410).Trim();
            this.pvFields.fldunnamed_76 = this.pvFieldsIntern.a_1452;
            this.pvFields.fldunnamed_75 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1460) : new string(this.pvFieldsIntern.a_1460).Trim();
            this.pvFields.fldunnamed_74 = this.pvFieldsIntern.a_1502;
            this.pvFields.fldunnamed_73 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1510) : new string(this.pvFieldsIntern.a_1510).Trim();
            this.pvFields.fldunnamed_72 = this.pvFieldsIntern.a_1552;
            this.pvFields.fldunnamed_71 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1560) : new string(this.pvFieldsIntern.a_1560).Trim();
            this.pvFields.fldunnamed_70 = this.pvFieldsIntern.a_1602;
            this.pvFields.fldunnamed_69 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1610) : new string(this.pvFieldsIntern.a_1610).Trim();
            this.pvFields.fldunnamed_68 = this.pvFieldsIntern.a_1652;
            this.pvFields.fldunnamed_67 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1660) : new string(this.pvFieldsIntern.a_1660).Trim();
            this.pvFields.fldunnamed_66 = this.pvFieldsIntern.a_1702;
            this.pvFields.fldunnamed_65 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1710) : new string(this.pvFieldsIntern.a_1710).Trim();
            this.pvFields.fldunnamed_64 = this.pvFieldsIntern.a_1752;
            this.pvFields.fldunnamed_63 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1760) : new string(this.pvFieldsIntern.a_1760).Trim();
            this.pvFields.fldunnamed_62 = this.pvFieldsIntern.a_1802;
            this.pvFields.fldunnamed_61 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1810) : new string(this.pvFieldsIntern.a_1810).Trim();
            this.pvFields.fldunnamed_60 = this.pvFieldsIntern.a_1852;
            this.pvFields.fldunnamed_59 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1860) : new string(this.pvFieldsIntern.a_1860).Trim();
            this.pvFields.fldunnamed_58 = this.pvFieldsIntern.a_1902;
            this.pvFields.fldunnamed_57 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1910) : new string(this.pvFieldsIntern.a_1910).Trim();
            this.pvFields.fldunnamed_56 = this.pvFieldsIntern.a_1952;
            this.pvFields.fldunnamed_55 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_1960) : new string(this.pvFieldsIntern.a_1960).Trim();
            this.pvFields.fldunnamed_54 = this.pvFieldsIntern.a_2002;
            this.pvFields.fldunnamed_53 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2010) : new string(this.pvFieldsIntern.a_2010).Trim();
            this.pvFields.fldunnamed_52 = this.pvFieldsIntern.a_2052;
            this.pvFields.fldunnamed_51 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2060) : new string(this.pvFieldsIntern.a_2060).Trim();
            this.pvFields.fldunnamed_50 = this.pvFieldsIntern.a_2102;
            this.pvFields.fldunnamed_49 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2110) : new string(this.pvFieldsIntern.a_2110).Trim();
            this.pvFields.fldunnamed_48 = this.pvFieldsIntern.a_2152;
            this.pvFields.fldunnamed_47 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2160) : new string(this.pvFieldsIntern.a_2160).Trim();
            this.pvFields.fldunnamed_46 = this.pvFieldsIntern.a_2202;
            this.pvFields.fldunnamed_45 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2210) : new string(this.pvFieldsIntern.a_2210).Trim();
            this.pvFields.fldunnamed_44 = this.pvFieldsIntern.a_2252;
            this.pvFields.fldunnamed_43 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2260) : new string(this.pvFieldsIntern.a_2260).Trim();
            this.pvFields.fldunnamed_42 = this.pvFieldsIntern.a_2302;
            this.pvFields.fldunnamed_41 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2310) : new string(this.pvFieldsIntern.a_2310).Trim();
            this.pvFields.fldunnamed_40 = this.pvFieldsIntern.a_2352;
            this.pvFields.fldunnamed_39 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2360) : new string(this.pvFieldsIntern.a_2360).Trim();
            this.pvFields.fldunnamed_38 = this.pvFieldsIntern.a_2402;
            this.pvFields.fldunnamed_37 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2410) : new string(this.pvFieldsIntern.a_2410).Trim();
            this.pvFields.fldunnamed_36 = this.pvFieldsIntern.a_2452;
            this.pvFields.fldunnamed_35 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2460) : new string(this.pvFieldsIntern.a_2460).Trim();
            this.pvFields.fldunnamed_34 = this.pvFieldsIntern.a_2502;
            this.pvFields.fldunnamed_33 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2510) : new string(this.pvFieldsIntern.a_2510).Trim();
            this.pvFields.fldunnamed_32 = this.pvFieldsIntern.a_2552;
            this.pvFields.fldunnamed_31 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2560) : new string(this.pvFieldsIntern.a_2560).Trim();
            this.pvFields.fldunnamed_30 = this.pvFieldsIntern.a_2602;
            this.pvFields.fldunnamed_29 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2610) : new string(this.pvFieldsIntern.a_2610).Trim();
            this.pvFields.fldunnamed_28 = this.pvFieldsIntern.a_2652;
            this.pvFields.fldunnamed_27 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2660) : new string(this.pvFieldsIntern.a_2660).Trim();
            this.pvFields.fldunnamed_26 = this.pvFieldsIntern.a_2702;
            this.pvFields.fldunnamed_25 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2710) : new string(this.pvFieldsIntern.a_2710).Trim();
            this.pvFields.fldunnamed_24 = this.pvFieldsIntern.a_2752;
            this.pvFields.fldunnamed_23 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2760) : new string(this.pvFieldsIntern.a_2760).Trim();
            this.pvFields.fldunnamed_22 = this.pvFieldsIntern.a_2802;
            this.pvFields.fldunnamed_20 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2810) : new string(this.pvFieldsIntern.a_2810).Trim();
            this.pvFields.fldunnamed_21 = this.pvFieldsIntern.a_2852;
            this.pvFields.fldunnamed_234 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2860) : new string(this.pvFieldsIntern.a_2860).Trim();
            this.pvFields.fldunnamed_7 = !this.pvTrimStrings ? new string(this.pvFieldsIntern.a_2861) : new string(this.pvFieldsIntern.a_2861).Trim();
            this.pvFields.fldMes = this.pvFieldsIntern.a_2869;
            this.pvFields.fldDia = this.pvFieldsIntern.a_2871;
            this.pvFields.fldSequencia = this.pvFieldsIntern.a_2873;
            this.pvFields.fldId = this.pvFieldsIntern.a_2877;
            if (this.pvTrimStrings)
                this.pvFields.fldunnamed_12 = new string(this.pvFieldsIntern.a_2881).Trim();
            else
                this.pvFields.fldunnamed_12 = new string(this.pvFieldsIntern.a_2881);
        }

        private void StructtoDB(ref IntPtr pPtr2)
        {
            this.pvFieldsIntern.a_000 = this.pvFields.fldLancamento;
            this.pvFieldsIntern.a_004 = this.pvFields.fldData.PadRight(5).ToCharArray();
            this.pvFieldsIntern.a_009 = this.pvFields.fldCCRDebito.PadRight(7).ToCharArray();
            this.pvFieldsIntern.a_016 = this.pvFields.fldCCDebito.PadRight(56).ToCharArray();
            this.pvFieldsIntern.a_072 = this.pvFields.fldCCRCredito.PadRight(7).ToCharArray();
            this.pvFieldsIntern.a_079 = this.pvFields.fldCCCredito.PadRight(56).ToCharArray();
            this.pvFieldsIntern.a_135 = this.pvFields.fldHistorico;
            this.pvFieldsIntern.a_139 = this.pvFields.fldComplemento.PadRight(200).ToCharArray();
            this.pvFieldsIntern.a_339 = this.pvFields.fldValor;
            this.pvFieldsIntern.a_347 = this.pvFields.fldOrigem.PadRight(1).ToCharArray();
            this.pvFieldsIntern.a_348 = this.pvFields.fldLote;
            this.pvFieldsIntern.a_352 = this.pvFields.fldunnamed_4;
            this.pvFieldsIntern.a_356 = this.pvFields.fldunnamed_5;
            this.pvFieldsIntern.a_360 = this.pvFields.fldunnamed_6.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_402 = this.pvFields.fldunnamed_113;
            this.pvFieldsIntern.a_410 = this.pvFields.fldunnamed_114.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_452 = this.pvFields.fldunnamed_111;
            this.pvFieldsIntern.a_460 = this.pvFields.fldunnamed_112.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_502 = this.pvFields.fldunnamed_109;
            this.pvFieldsIntern.a_510 = this.pvFields.fldunnamed_110.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_552 = this.pvFields.fldunnamed_107;
            this.pvFieldsIntern.a_560 = this.pvFields.fldunnamed_108.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_602 = this.pvFields.fldunnamed_105;
            this.pvFieldsIntern.a_610 = this.pvFields.fldunnamed_106.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_652 = this.pvFields.fldunnamed_103;
            this.pvFieldsIntern.a_660 = this.pvFields.fldunnamed_104.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_702 = this.pvFields.fldunnamed_101;
            this.pvFieldsIntern.a_710 = this.pvFields.fldunnamed_102.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_752 = this.pvFields.fldunnamed_99;
            this.pvFieldsIntern.a_760 = this.pvFields.fldunnamed_100.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_802 = this.pvFields.fldunnamed_97;
            this.pvFieldsIntern.a_810 = this.pvFields.fldunnamed_98.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_852 = this.pvFields.fldunnamed_95;
            this.pvFieldsIntern.a_860 = this.pvFields.fldunnamed_96.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_902 = this.pvFields.fldunnamed_230;
            this.pvFieldsIntern.a_910 = this.pvFields.fldunnamed_231.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_952 = this.pvFields.fldunnamed_232;
            this.pvFieldsIntern.a_960 = this.pvFields.fldunnamed_233.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1002 = this.pvFields.fldunnamed_93;
            this.pvFieldsIntern.a_1010 = this.pvFields.fldunnamed_94.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1052 = this.pvFields.fldunnamed_92;
            this.pvFieldsIntern.a_1060 = this.pvFields.fldunnamed_91.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1102 = this.pvFields.fldunnamed_90;
            this.pvFieldsIntern.a_1110 = this.pvFields.fldunnamed_89.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1152 = this.pvFields.fldunnamed_88;
            this.pvFieldsIntern.a_1160 = this.pvFields.fldunnamed_87.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1202 = this.pvFields.fldunnamed_86;
            this.pvFieldsIntern.a_1210 = this.pvFields.fldunnamed_85.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1252 = this.pvFields.fldunnamed_84;
            this.pvFieldsIntern.a_1260 = this.pvFields.fldunnamed_83.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1302 = this.pvFields.fldunnamed_82;
            this.pvFieldsIntern.a_1310 = this.pvFields.fldunnamed_81.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1352 = this.pvFields.fldunnamed_80;
            this.pvFieldsIntern.a_1360 = this.pvFields.fldunnamed_79.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1402 = this.pvFields.fldunnamed_78;
            this.pvFieldsIntern.a_1410 = this.pvFields.fldunnamed_77.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1452 = this.pvFields.fldunnamed_76;
            this.pvFieldsIntern.a_1460 = this.pvFields.fldunnamed_75.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1502 = this.pvFields.fldunnamed_74;
            this.pvFieldsIntern.a_1510 = this.pvFields.fldunnamed_73.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1552 = this.pvFields.fldunnamed_72;
            this.pvFieldsIntern.a_1560 = this.pvFields.fldunnamed_71.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1602 = this.pvFields.fldunnamed_70;
            this.pvFieldsIntern.a_1610 = this.pvFields.fldunnamed_69.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1652 = this.pvFields.fldunnamed_68;
            this.pvFieldsIntern.a_1660 = this.pvFields.fldunnamed_67.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1702 = this.pvFields.fldunnamed_66;
            this.pvFieldsIntern.a_1710 = this.pvFields.fldunnamed_65.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1752 = this.pvFields.fldunnamed_64;
            this.pvFieldsIntern.a_1760 = this.pvFields.fldunnamed_63.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1802 = this.pvFields.fldunnamed_62;
            this.pvFieldsIntern.a_1810 = this.pvFields.fldunnamed_61.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1852 = this.pvFields.fldunnamed_60;
            this.pvFieldsIntern.a_1860 = this.pvFields.fldunnamed_59.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1902 = this.pvFields.fldunnamed_58;
            this.pvFieldsIntern.a_1910 = this.pvFields.fldunnamed_57.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_1952 = this.pvFields.fldunnamed_56;
            this.pvFieldsIntern.a_1960 = this.pvFields.fldunnamed_55.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2002 = this.pvFields.fldunnamed_54;
            this.pvFieldsIntern.a_2010 = this.pvFields.fldunnamed_53.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2052 = this.pvFields.fldunnamed_52;
            this.pvFieldsIntern.a_2060 = this.pvFields.fldunnamed_51.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2102 = this.pvFields.fldunnamed_50;
            this.pvFieldsIntern.a_2110 = this.pvFields.fldunnamed_49.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2152 = this.pvFields.fldunnamed_48;
            this.pvFieldsIntern.a_2160 = this.pvFields.fldunnamed_47.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2202 = this.pvFields.fldunnamed_46;
            this.pvFieldsIntern.a_2210 = this.pvFields.fldunnamed_45.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2252 = this.pvFields.fldunnamed_44;
            this.pvFieldsIntern.a_2260 = this.pvFields.fldunnamed_43.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2302 = this.pvFields.fldunnamed_42;
            this.pvFieldsIntern.a_2310 = this.pvFields.fldunnamed_41.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2352 = this.pvFields.fldunnamed_40;
            this.pvFieldsIntern.a_2360 = this.pvFields.fldunnamed_39.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2402 = this.pvFields.fldunnamed_38;
            this.pvFieldsIntern.a_2410 = this.pvFields.fldunnamed_37.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2452 = this.pvFields.fldunnamed_36;
            this.pvFieldsIntern.a_2460 = this.pvFields.fldunnamed_35.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2502 = this.pvFields.fldunnamed_34;
            this.pvFieldsIntern.a_2510 = this.pvFields.fldunnamed_33.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2552 = this.pvFields.fldunnamed_32;
            this.pvFieldsIntern.a_2560 = this.pvFields.fldunnamed_31.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2602 = this.pvFields.fldunnamed_30;
            this.pvFieldsIntern.a_2610 = this.pvFields.fldunnamed_29.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2652 = this.pvFields.fldunnamed_28;
            this.pvFieldsIntern.a_2660 = this.pvFields.fldunnamed_27.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2702 = this.pvFields.fldunnamed_26;
            this.pvFieldsIntern.a_2710 = this.pvFields.fldunnamed_25.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2752 = this.pvFields.fldunnamed_24;
            this.pvFieldsIntern.a_2760 = this.pvFields.fldunnamed_23.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2802 = this.pvFields.fldunnamed_22;
            this.pvFieldsIntern.a_2810 = this.pvFields.fldunnamed_20.PadRight(42).ToCharArray();
            this.pvFieldsIntern.a_2852 = this.pvFields.fldunnamed_21;
            this.pvFieldsIntern.a_2860 = this.pvFields.fldunnamed_234.PadRight(1).ToCharArray();
            this.pvFieldsIntern.a_2861 = this.pvFields.fldunnamed_7.PadRight(8).ToCharArray();
            this.pvFieldsIntern.a_2869 = this.pvFields.fldMes;
            this.pvFieldsIntern.a_2871 = this.pvFields.fldDia;
            this.pvFieldsIntern.a_2873 = this.pvFields.fldSequencia;
            this.pvFieldsIntern.a_2877 = this.pvFields.fldId;
            this.pvFieldsIntern.a_2881 = this.pvFields.fldunnamed_12.PadRight(200).ToCharArray();
            Marshal.StructureToPtr((object)this.pvFieldsIntern, pPtr2, true);
        }

        private void VartoDB_ext(ref IntPtr pPtr3)
        {
            Translate.Cmmn_WriteInt16(pPtr3, checked((short)this.pvFieldsExtr.Length));
            short num1 = (short)2;
            int index = 0;
            while (index < this.pvFieldsExtr.Length)
            {
                this.pvFieldsIntern.a_000 = this.pvFieldsExtr[index].fldLancamento;
                this.pvFieldsIntern.a_004 = this.pvFieldsExtr[index].fldData.PadRight(5).ToCharArray();
                this.pvFieldsIntern.a_009 = this.pvFieldsExtr[index].fldCCRDebito.PadRight(7).ToCharArray();
                this.pvFieldsIntern.a_016 = this.pvFieldsExtr[index].fldCCDebito.PadRight(56).ToCharArray();
                this.pvFieldsIntern.a_072 = this.pvFieldsExtr[index].fldCCRCredito.PadRight(7).ToCharArray();
                this.pvFieldsIntern.a_079 = this.pvFieldsExtr[index].fldCCCredito.PadRight(56).ToCharArray();
                this.pvFieldsIntern.a_135 = this.pvFieldsExtr[index].fldHistorico;
                this.pvFieldsIntern.a_139 = this.pvFieldsExtr[index].fldComplemento.PadRight(200).ToCharArray();
                this.pvFieldsIntern.a_339 = this.pvFieldsExtr[index].fldValor;
                this.pvFieldsIntern.a_347 = this.pvFieldsExtr[index].fldOrigem.PadRight(1).ToCharArray();
                this.pvFieldsIntern.a_348 = this.pvFieldsExtr[index].fldLote;
                this.pvFieldsIntern.a_352 = this.pvFieldsExtr[index].fldunnamed_4;
                this.pvFieldsIntern.a_356 = this.pvFieldsExtr[index].fldunnamed_5;
                this.pvFieldsIntern.a_360 = this.pvFieldsExtr[index].fldunnamed_6.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_402 = this.pvFieldsExtr[index].fldunnamed_113;
                this.pvFieldsIntern.a_410 = this.pvFieldsExtr[index].fldunnamed_114.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_452 = this.pvFieldsExtr[index].fldunnamed_111;
                this.pvFieldsIntern.a_460 = this.pvFieldsExtr[index].fldunnamed_112.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_502 = this.pvFieldsExtr[index].fldunnamed_109;
                this.pvFieldsIntern.a_510 = this.pvFieldsExtr[index].fldunnamed_110.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_552 = this.pvFieldsExtr[index].fldunnamed_107;
                this.pvFieldsIntern.a_560 = this.pvFieldsExtr[index].fldunnamed_108.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_602 = this.pvFieldsExtr[index].fldunnamed_105;
                this.pvFieldsIntern.a_610 = this.pvFieldsExtr[index].fldunnamed_106.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_652 = this.pvFieldsExtr[index].fldunnamed_103;
                this.pvFieldsIntern.a_660 = this.pvFieldsExtr[index].fldunnamed_104.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_702 = this.pvFieldsExtr[index].fldunnamed_101;
                this.pvFieldsIntern.a_710 = this.pvFieldsExtr[index].fldunnamed_102.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_752 = this.pvFieldsExtr[index].fldunnamed_99;
                this.pvFieldsIntern.a_760 = this.pvFieldsExtr[index].fldunnamed_100.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_802 = this.pvFieldsExtr[index].fldunnamed_97;
                this.pvFieldsIntern.a_810 = this.pvFieldsExtr[index].fldunnamed_98.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_852 = this.pvFieldsExtr[index].fldunnamed_95;
                this.pvFieldsIntern.a_860 = this.pvFieldsExtr[index].fldunnamed_96.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_902 = this.pvFieldsExtr[index].fldunnamed_230;
                this.pvFieldsIntern.a_910 = this.pvFieldsExtr[index].fldunnamed_231.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_952 = this.pvFieldsExtr[index].fldunnamed_232;
                this.pvFieldsIntern.a_960 = this.pvFieldsExtr[index].fldunnamed_233.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1002 = this.pvFieldsExtr[index].fldunnamed_93;
                this.pvFieldsIntern.a_1010 = this.pvFieldsExtr[index].fldunnamed_94.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1052 = this.pvFieldsExtr[index].fldunnamed_92;
                this.pvFieldsIntern.a_1060 = this.pvFieldsExtr[index].fldunnamed_91.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1102 = this.pvFieldsExtr[index].fldunnamed_90;
                this.pvFieldsIntern.a_1110 = this.pvFieldsExtr[index].fldunnamed_89.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1152 = this.pvFieldsExtr[index].fldunnamed_88;
                this.pvFieldsIntern.a_1160 = this.pvFieldsExtr[index].fldunnamed_87.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1202 = this.pvFieldsExtr[index].fldunnamed_86;
                this.pvFieldsIntern.a_1210 = this.pvFieldsExtr[index].fldunnamed_85.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1252 = this.pvFieldsExtr[index].fldunnamed_84;
                this.pvFieldsIntern.a_1260 = this.pvFieldsExtr[index].fldunnamed_83.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1302 = this.pvFieldsExtr[index].fldunnamed_82;
                this.pvFieldsIntern.a_1310 = this.pvFieldsExtr[index].fldunnamed_81.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1352 = this.pvFieldsExtr[index].fldunnamed_80;
                this.pvFieldsIntern.a_1360 = this.pvFieldsExtr[index].fldunnamed_79.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1402 = this.pvFieldsExtr[index].fldunnamed_78;
                this.pvFieldsIntern.a_1410 = this.pvFieldsExtr[index].fldunnamed_77.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1452 = this.pvFieldsExtr[index].fldunnamed_76;
                this.pvFieldsIntern.a_1460 = this.pvFieldsExtr[index].fldunnamed_75.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1502 = this.pvFieldsExtr[index].fldunnamed_74;
                this.pvFieldsIntern.a_1510 = this.pvFieldsExtr[index].fldunnamed_73.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1552 = this.pvFieldsExtr[index].fldunnamed_72;
                this.pvFieldsIntern.a_1560 = this.pvFieldsExtr[index].fldunnamed_71.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1602 = this.pvFieldsExtr[index].fldunnamed_70;
                this.pvFieldsIntern.a_1610 = this.pvFieldsExtr[index].fldunnamed_69.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1652 = this.pvFieldsExtr[index].fldunnamed_68;
                this.pvFieldsIntern.a_1660 = this.pvFieldsExtr[index].fldunnamed_67.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1702 = this.pvFieldsExtr[index].fldunnamed_66;
                this.pvFieldsIntern.a_1710 = this.pvFieldsExtr[index].fldunnamed_65.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1752 = this.pvFieldsExtr[index].fldunnamed_64;
                this.pvFieldsIntern.a_1760 = this.pvFieldsExtr[index].fldunnamed_63.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1802 = this.pvFieldsExtr[index].fldunnamed_62;
                this.pvFieldsIntern.a_1810 = this.pvFieldsExtr[index].fldunnamed_61.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1852 = this.pvFieldsExtr[index].fldunnamed_60;
                this.pvFieldsIntern.a_1860 = this.pvFieldsExtr[index].fldunnamed_59.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1902 = this.pvFieldsExtr[index].fldunnamed_58;
                this.pvFieldsIntern.a_1910 = this.pvFieldsExtr[index].fldunnamed_57.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_1952 = this.pvFieldsExtr[index].fldunnamed_56;
                this.pvFieldsIntern.a_1960 = this.pvFieldsExtr[index].fldunnamed_55.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2002 = this.pvFieldsExtr[index].fldunnamed_54;
                this.pvFieldsIntern.a_2010 = this.pvFieldsExtr[index].fldunnamed_53.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2052 = this.pvFieldsExtr[index].fldunnamed_52;
                this.pvFieldsIntern.a_2060 = this.pvFieldsExtr[index].fldunnamed_51.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2102 = this.pvFieldsExtr[index].fldunnamed_50;
                this.pvFieldsIntern.a_2110 = this.pvFieldsExtr[index].fldunnamed_49.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2152 = this.pvFieldsExtr[index].fldunnamed_48;
                this.pvFieldsIntern.a_2160 = this.pvFieldsExtr[index].fldunnamed_47.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2202 = this.pvFieldsExtr[index].fldunnamed_46;
                this.pvFieldsIntern.a_2210 = this.pvFieldsExtr[index].fldunnamed_45.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2252 = this.pvFieldsExtr[index].fldunnamed_44;
                this.pvFieldsIntern.a_2260 = this.pvFieldsExtr[index].fldunnamed_43.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2302 = this.pvFieldsExtr[index].fldunnamed_42;
                this.pvFieldsIntern.a_2310 = this.pvFieldsExtr[index].fldunnamed_41.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2352 = this.pvFieldsExtr[index].fldunnamed_40;
                this.pvFieldsIntern.a_2360 = this.pvFieldsExtr[index].fldunnamed_39.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2402 = this.pvFieldsExtr[index].fldunnamed_38;
                this.pvFieldsIntern.a_2410 = this.pvFieldsExtr[index].fldunnamed_37.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2452 = this.pvFieldsExtr[index].fldunnamed_36;
                this.pvFieldsIntern.a_2460 = this.pvFieldsExtr[index].fldunnamed_35.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2502 = this.pvFieldsExtr[index].fldunnamed_34;
                this.pvFieldsIntern.a_2510 = this.pvFieldsExtr[index].fldunnamed_33.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2552 = this.pvFieldsExtr[index].fldunnamed_32;
                this.pvFieldsIntern.a_2560 = this.pvFieldsExtr[index].fldunnamed_31.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2602 = this.pvFieldsExtr[index].fldunnamed_30;
                this.pvFieldsIntern.a_2610 = this.pvFieldsExtr[index].fldunnamed_29.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2652 = this.pvFieldsExtr[index].fldunnamed_28;
                this.pvFieldsIntern.a_2660 = this.pvFieldsExtr[index].fldunnamed_27.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2702 = this.pvFieldsExtr[index].fldunnamed_26;
                this.pvFieldsIntern.a_2710 = this.pvFieldsExtr[index].fldunnamed_25.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2752 = this.pvFieldsExtr[index].fldunnamed_24;
                this.pvFieldsIntern.a_2760 = this.pvFieldsExtr[index].fldunnamed_23.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2802 = this.pvFieldsExtr[index].fldunnamed_22;
                this.pvFieldsIntern.a_2810 = this.pvFieldsExtr[index].fldunnamed_20.PadRight(42).ToCharArray();
                this.pvFieldsIntern.a_2852 = this.pvFieldsExtr[index].fldunnamed_21;
                this.pvFieldsIntern.a_2860 = this.pvFieldsExtr[index].fldunnamed_234.PadRight(1).ToCharArray();
                this.pvFieldsIntern.a_2861 = this.pvFieldsExtr[index].fldunnamed_7.PadRight(8).ToCharArray();
                this.pvFieldsIntern.a_2869 = this.pvFieldsExtr[index].fldMes;
                this.pvFieldsIntern.a_2871 = this.pvFieldsExtr[index].fldDia;
                this.pvFieldsIntern.a_2873 = this.pvFieldsExtr[index].fldSequencia;
                this.pvFieldsIntern.a_2877 = this.pvFieldsExtr[index].fldId;
                this.pvFieldsIntern.a_2881 = this.pvFieldsExtr[index].fldunnamed_12.PadRight(200).ToCharArray();
                Translate.Cmmn_WriteInt16(pPtr3, (int)num1, (short)3081);
                short num2 = checked((short)((int)num1 + 2));
                this.pvPtr = new IntPtr(checked(pPtr3.ToInt64() + (long)num2));
                Marshal.StructureToPtr((object)this.pvFieldsIntern, this.pvPtr, true);
                this.pvPtr = IntPtr.Zero;
                num1 = checked((short)((int)num2 + 3081));
                checked { ++index; }
            }
        }

        public virtual short btrOpen(Lctos.OpenModes Mode, byte[] ClientId)
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

        public virtual short btrOpen(Lctos.OpenModes Mode)
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

        public virtual short btrInsert(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = (short)3081;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALLID((short)2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrInsert(Lctos.KeyName Key_nr)
        {
            short num1 = (short)3081;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALL((short)2, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrUpdate(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = (short)3081;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALLID((short)3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr2);
            return num2;
        }

        public virtual short btrUpdate(Lctos.KeyName Key_nr)
        {
            short num1 = (short)3081;
            IntPtr pPtr2 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.StructtoDB(ref pPtr2);
            short num2 = Func.BTRCALL((short)3, this.pvPB, pPtr2, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
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

        public virtual short btrGetEqual(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetEqual(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetEqual(Lctos.KeyName Key_nr)
        {
            return this.btrGetEqual(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetNext(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetNext(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetNext(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(Lctos.KeyName Key_nr)
        {
            return this.btrGetNext(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetNext(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetNext(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetNext(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetNext(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetNext(Key_nr, ref KeyBuffer, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr)
        {
            return this.btrGetPrevious(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer, byte[] ClientId)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetPrevious(Lctos.KeyName Key_nr, ref IntPtr KeyBuffer)
        {
            return this.btrGetPrevious(Key_nr, ref KeyBuffer, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreater(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreater(Lctos.KeyName Key_nr)
        {
            return this.btrGetGreater(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreater(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetGreater(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetGreaterThanOrEqual(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetGreaterThanOrEqual(Lctos.KeyName Key_nr)
        {
            return this.btrGetGreaterThanOrEqual(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetGreaterThanOrEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetGreaterThanOrEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLessThan(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThan(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThan(Lctos.KeyName Key_nr)
        {
            return this.btrGetLessThan(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThan(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLessThan(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLessThanOrEqual(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLessThanOrEqual(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLessThanOrEqual(Lctos.KeyName Key_nr)
        {
            return this.btrGetLessThanOrEqual(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLessThanOrEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLessThanOrEqual(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetFirst(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetFirst(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetFirst(Lctos.KeyName Key_nr)
        {
            return this.btrGetFirst(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetFirst(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetFirst(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLast(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            return this.btrGetLast(Key_nr, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetLast(Lctos.KeyName Key_nr)
        {
            return this.btrGetLast(Key_nr, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetLast(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
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

        public virtual short btrGetLast(Lctos.KeyName Key_nr, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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
            short num1 = (short)3081;
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

        public virtual short btrGetDirectRecord(Lctos.KeyName Key_nr, IntPtr Position, byte[] ClientId)
        {
            return this.btrGetDirectRecord(Key_nr, Position, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetDirectRecord(Lctos.KeyName Key_nr, IntPtr Position)
        {
            return this.btrGetDirectRecord(Key_nr, Position, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetDirectRecord(Lctos.KeyName Key_nr, IntPtr Position, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt32(pPtr1, 0, Translate.Cmmn_ReadInt32(Position, 0));
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 23)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetDirectRecord(Lctos.KeyName Key_nr, IntPtr Position, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
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
            return this.btrStepNext(Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepNext()
        {
            return this.btrStepNext(Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepNext(Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepNext(Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 24)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrUnlock(Lctos.Unlock UnlockKey, IntPtr Position, byte[] ClientId)
        {
            IntPtr num1 = IntPtr.Zero;
            short num2 = Position == num1 || Position == IntPtr.Zero ? (short)0 : (short)4;
            return Func.BTRCALLID((short)27, this.pvPB, Position, ref num2, IntPtr.Zero, (short)0, checked((short)UnlockKey), ClientId);
        }

        public virtual short btrUnlock(Lctos.Unlock UnlockKey, IntPtr Position)
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
            return this.btrStepFirst(Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepFirst()
        {
            return this.btrStepFirst(Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepFirst(Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepFirst(Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 33)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(byte[] ClientId)
        {
            return this.btrStepLast(Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepLast()
        {
            return this.btrStepLast(Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepLast(Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepLast(Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 34)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(byte[] ClientId)
        {
            return this.btrStepPrevious(Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrStepPrevious()
        {
            return this.btrStepPrevious(Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrStepPrevious(Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0, ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrStepPrevious(Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 35)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, (short)0);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrInsertExtended(Lctos.KeyName Key_nr, byte[] ClientId)
        {
            short num1 = checked((short)(3083 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num2 = Func.BTRCALLID((short)40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr), ClientId);
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num2;
        }

        public virtual short btrInsertExtended(Lctos.KeyName Key_nr)
        {
            short num1 = checked((short)(3083 * this.pvFieldsExtr.Length + 2));
            IntPtr pPtr3 = Marshal.AllocHGlobal((int)num1);
            IntPtr pPtr4 = Marshal.AllocHGlobal((int)this.pbKBL);
            this.VartoDB_ext(ref pPtr3);
            short num2 = Func.BTRCALL((short)40, this.pvPB, pPtr3, ref num1, pPtr4, this.pbKBL, checked((short)Key_nr));
            if (Key_nr >= Lctos.KeyName.index_0 && (int)num2 == 0)
                this.KBtoVar(ref pPtr4, checked((short)Key_nr));
            this.pvStatExt.AmountInserted = Translate.Cmmn_ReadInt16(pPtr3, 0);
            Marshal.FreeHGlobal(pPtr4);
            Marshal.FreeHGlobal(pPtr3);
            return num2;
        }

        public virtual short btrGetByPercentage(Lctos.KeyName Key_nr, short Percentage, byte[] ClientId)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, Lctos.RecordLocks.NoRecordLock, ClientId);
        }

        public virtual short btrGetByPercentage(Lctos.KeyName Key_nr, short Percentage)
        {
            return this.btrGetByPercentage(Key_nr, Percentage, Lctos.RecordLocks.NoRecordLock);
        }

        public virtual short btrGetByPercentage(Lctos.KeyName Key_nr, short Percentage, Lctos.RecordLocks Lock_Bias, byte[] ClientId)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALLID(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr), ClientId);
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrGetByPercentage(Lctos.KeyName Key_nr, short Percentage, Lctos.RecordLocks Lock_Bias)
        {
            short pDBL = (short)3081;
            IntPtr pPtr1 = Marshal.AllocHGlobal((int)pDBL);
            Translate.Cmmn_WriteInt16(pPtr1, 0, Percentage);
            short num = Func.BTRCALL(checked((short)((int)(short)Lock_Bias + 44)), this.pvPB, pPtr1, ref pDBL, IntPtr.Zero, (short)0, checked((short)Key_nr));
            if ((int)num == 0)
                this.DBtoStruct(ref pPtr1, pDBL);
            Marshal.FreeHGlobal(pPtr1);
            return num;
        }

        public virtual short btrFindPercentage(Lctos.KeyName Key_nr, ref short Percentage, byte[] ClientId)
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

        public virtual short btrFindPercentage(Lctos.KeyName Key_nr, ref short Percentage)
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
            private Lctos.KeysStruct.struct_02 idxindex_2_priv;
            private Lctos.KeysStruct.struct_04 idxindex_4_priv;
            private Lctos.KeysStruct.struct_06 idxindex_6_priv;
            private Lctos.KeysStruct.struct_08 idxindex_8_priv;
            private Lctos.KeysStruct.struct_01 idxindex_1_priv;
            private Lctos.KeysStruct.struct_03 idxindex_3_priv;
            private Lctos.KeysStruct.struct_05 idxindex_5_priv;
            private Lctos.KeysStruct.struct_07 idxUK_Id_priv;
            private Lctos.KeysStruct.struct_00 idxindex_0_priv;

            public Lctos.KeysStruct.struct_02 idxindex_2
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

            public Lctos.KeysStruct.struct_04 idxindex_4
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

            public Lctos.KeysStruct.struct_06 idxindex_6
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

            public Lctos.KeysStruct.struct_08 idxindex_8
            {
                get
                {
                    return this.idxindex_8_priv;
                }
                set
                {
                    this.idxindex_8_priv = value;
                }
            }

            public Lctos.KeysStruct.struct_01 idxindex_1
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

            public Lctos.KeysStruct.struct_03 idxindex_3
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

            public Lctos.KeysStruct.struct_05 idxindex_5
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

            public Lctos.KeysStruct.struct_07 idxUK_Id
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

            public Lctos.KeysStruct.struct_00 idxindex_0
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
                this.idxindex_2_priv = new Lctos.KeysStruct.struct_02();
                this.idxindex_4_priv = new Lctos.KeysStruct.struct_04();
                this.idxindex_6_priv = new Lctos.KeysStruct.struct_06();
                this.idxindex_8_priv = new Lctos.KeysStruct.struct_08();
                this.idxindex_1_priv = new Lctos.KeysStruct.struct_01();
                this.idxindex_3_priv = new Lctos.KeysStruct.struct_03();
                this.idxindex_5_priv = new Lctos.KeysStruct.struct_05();
                this.idxUK_Id_priv = new Lctos.KeysStruct.struct_07();
                this.idxindex_0_priv = new Lctos.KeysStruct.struct_00();
            }

            public class struct_00
            {
                private int sgmLancamento_priv;

                public int sgmLancamento
                {
                    get
                    {
                        return this.sgmLancamento_priv;
                    }
                    set
                    {
                        this.sgmLancamento_priv = value;
                    }
                }

                public struct_00()
                {
                    this.sgmLancamento_priv = 0;
                }
            }

            public class struct_01
            {
                private short sgmMes_priv;
                private short sgmDia_priv;
                private int sgmunnamed_5_priv;
                private int sgmunnamed_4_priv;

                public short sgmMes
                {
                    get
                    {
                        return this.sgmMes_priv;
                    }
                    set
                    {
                        this.sgmMes_priv = value;
                    }
                }

                public short sgmDia
                {
                    get
                    {
                        return this.sgmDia_priv;
                    }
                    set
                    {
                        this.sgmDia_priv = value;
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

                public struct_01()
                {
                    this.sgmMes_priv = (short)0;
                    this.sgmDia_priv = (short)0;
                    this.sgmunnamed_5_priv = 0;
                    this.sgmunnamed_4_priv = 0;
                }
            }

            public class struct_02
            {
                private int sgmunnamed_5_priv;
                private int sgmunnamed_4_priv;

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

                public struct_02()
                {
                    this.sgmunnamed_5_priv = 0;
                    this.sgmunnamed_4_priv = 0;
                }
            }

            public class struct_03
            {
                private string sgmOrigem_priv;
                private int sgmLote_priv;
                private short sgmMes_priv;
                private short sgmDia_priv;

                public string sgmOrigem
                {
                    get
                    {
                        return this.sgmOrigem_priv;
                    }
                    set
                    {
                        this.sgmOrigem_priv = value;
                    }
                }

                public int sgmLote
                {
                    get
                    {
                        return this.sgmLote_priv;
                    }
                    set
                    {
                        this.sgmLote_priv = value;
                    }
                }

                public short sgmMes
                {
                    get
                    {
                        return this.sgmMes_priv;
                    }
                    set
                    {
                        this.sgmMes_priv = value;
                    }
                }

                public short sgmDia
                {
                    get
                    {
                        return this.sgmDia_priv;
                    }
                    set
                    {
                        this.sgmDia_priv = value;
                    }
                }

                public struct_03()
                {
                    this.sgmOrigem_priv = string.Empty;
                    this.sgmLote_priv = 0;
                    this.sgmMes_priv = (short)0;
                    this.sgmDia_priv = (short)0;
                }
            }

            public class struct_04
            {
                private string sgmOrigem_priv;
                private short sgmMes_priv;
                private short sgmDia_priv;

                public string sgmOrigem
                {
                    get
                    {
                        return this.sgmOrigem_priv;
                    }
                    set
                    {
                        this.sgmOrigem_priv = value;
                    }
                }

                public short sgmMes
                {
                    get
                    {
                        return this.sgmMes_priv;
                    }
                    set
                    {
                        this.sgmMes_priv = value;
                    }
                }

                public short sgmDia
                {
                    get
                    {
                        return this.sgmDia_priv;
                    }
                    set
                    {
                        this.sgmDia_priv = value;
                    }
                }

                public struct_04()
                {
                    this.sgmOrigem_priv = string.Empty;
                    this.sgmMes_priv = (short)0;
                    this.sgmDia_priv = (short)0;
                }
            }

            public class struct_05
            {
                private string sgmOrigem_priv;
                private string sgmunnamed_7_priv;
                private short sgmMes_priv;

                public string sgmOrigem
                {
                    get
                    {
                        return this.sgmOrigem_priv;
                    }
                    set
                    {
                        this.sgmOrigem_priv = value;
                    }
                }

                public string sgmunnamed_7
                {
                    get
                    {
                        return this.sgmunnamed_7_priv;
                    }
                    set
                    {
                        this.sgmunnamed_7_priv = value;
                    }
                }

                public short sgmMes
                {
                    get
                    {
                        return this.sgmMes_priv;
                    }
                    set
                    {
                        this.sgmMes_priv = value;
                    }
                }

                public struct_05()
                {
                    this.sgmOrigem_priv = string.Empty;
                    this.sgmunnamed_7_priv = string.Empty;
                    this.sgmMes_priv = (short)0;
                }
            }

            public class struct_06
            {
                private int sgmSequencia_priv;

                public int sgmSequencia
                {
                    get
                    {
                        return this.sgmSequencia_priv;
                    }
                    set
                    {
                        this.sgmSequencia_priv = value;
                    }
                }

                public struct_06()
                {
                    this.sgmSequencia_priv = 0;
                }
            }

            public class struct_07
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

                public struct_07()
                {
                    this.sgmId_priv = 0;
                }
            }

            public class struct_08
            {
                private short sgmMes_priv;
                private int sgmSequencia_priv;

                public short sgmMes
                {
                    get
                    {
                        return this.sgmMes_priv;
                    }
                    set
                    {
                        this.sgmMes_priv = value;
                    }
                }

                public int sgmSequencia
                {
                    get
                    {
                        return this.sgmSequencia_priv;
                    }
                    set
                    {
                        this.sgmSequencia_priv = value;
                    }
                }

                public struct_08()
                {
                    this.sgmMes_priv = (short)0;
                    this.sgmSequencia_priv = 0;
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
            index_4 = 4,
            index_5 = 5,
            index_6 = 6,
            UK_Id = 7,
            index_8 = 8,
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

        [StructLayout(LayoutKind.Sequential, Size = 3081, Pack = 1)]
        internal struct FieldsClass_priv
        {
            internal int a_000;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
            internal char[] a_004;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
            internal char[] a_009;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
            internal char[] a_016;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
            internal char[] a_072;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 56)]
            internal char[] a_079;
            internal int a_135;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 200)]
            internal char[] a_139;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_339;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
            internal char[] a_347;
            internal int a_348;
            internal int a_352;
            internal int a_356;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_360;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_402;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_410;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_452;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_460;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_502;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_510;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_552;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_560;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_602;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_610;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_652;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_660;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_702;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_710;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_752;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_760;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_802;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_810;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_852;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_860;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_902;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_910;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_952;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_960;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1002;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1010;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1052;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1060;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1102;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1110;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1152;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1160;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1202;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1210;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1252;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1260;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1302;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1310;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1352;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1360;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1402;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1410;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1452;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1460;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1502;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1510;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1552;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1560;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1602;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1610;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1652;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1660;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1702;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1710;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1752;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1760;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1802;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1810;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1852;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1860;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1902;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1910;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_1952;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_1960;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2002;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2010;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2052;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2060;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2102;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2110;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2152;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2160;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2202;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2210;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2252;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2260;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2302;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2310;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2352;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2360;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2402;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2410;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2452;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2460;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2502;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2510;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2552;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2560;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2602;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2610;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2652;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2660;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2702;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2710;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2752;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2760;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2802;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 42)]
            internal char[] a_2810;
            [MarshalAs(UnmanagedType.R8)]
            internal double a_2852;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
            internal char[] a_2860;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            internal char[] a_2861;
            internal short a_2869;
            internal short a_2871;
            internal int a_2873;
            internal int a_2877;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 200)]
            internal char[] a_2881;

            internal void initi()
            {
            }
        }

        public class FieldsClass : INotifyPropertyChanged
        {
            private int fldLancamento_priv;
            private string fldData_priv;
            private string fldCCRDebito_priv;
            private string fldCCDebito_priv;
            private string fldCCRCredito_priv;
            private string fldCCCredito_priv;
            private int fldHistorico_priv;
            private string fldComplemento_priv;
            private double fldValor_priv;
            private string fldOrigem_priv;
            private int fldLote_priv;
            private int fldunnamed_4_priv;
            private int fldunnamed_5_priv;
            private string fldunnamed_6_priv;
            private double fldunnamed_113_priv;
            private string fldunnamed_114_priv;
            private double fldunnamed_111_priv;
            private string fldunnamed_112_priv;
            private double fldunnamed_109_priv;
            private string fldunnamed_110_priv;
            private double fldunnamed_107_priv;
            private string fldunnamed_108_priv;
            private double fldunnamed_105_priv;
            private string fldunnamed_106_priv;
            private double fldunnamed_103_priv;
            private string fldunnamed_104_priv;
            private double fldunnamed_101_priv;
            private string fldunnamed_102_priv;
            private double fldunnamed_99_priv;
            private string fldunnamed_100_priv;
            private double fldunnamed_97_priv;
            private string fldunnamed_98_priv;
            private double fldunnamed_95_priv;
            private string fldunnamed_96_priv;
            private double fldunnamed_230_priv;
            private string fldunnamed_231_priv;
            private double fldunnamed_232_priv;
            private string fldunnamed_233_priv;
            private double fldunnamed_93_priv;
            private string fldunnamed_94_priv;
            private double fldunnamed_92_priv;
            private string fldunnamed_91_priv;
            private double fldunnamed_90_priv;
            private string fldunnamed_89_priv;
            private double fldunnamed_88_priv;
            private string fldunnamed_87_priv;
            private double fldunnamed_86_priv;
            private string fldunnamed_85_priv;
            private double fldunnamed_84_priv;
            private string fldunnamed_83_priv;
            private double fldunnamed_82_priv;
            private string fldunnamed_81_priv;
            private double fldunnamed_80_priv;
            private string fldunnamed_79_priv;
            private double fldunnamed_78_priv;
            private string fldunnamed_77_priv;
            private double fldunnamed_76_priv;
            private string fldunnamed_75_priv;
            private double fldunnamed_74_priv;
            private string fldunnamed_73_priv;
            private double fldunnamed_72_priv;
            private string fldunnamed_71_priv;
            private double fldunnamed_70_priv;
            private string fldunnamed_69_priv;
            private double fldunnamed_68_priv;
            private string fldunnamed_67_priv;
            private double fldunnamed_66_priv;
            private string fldunnamed_65_priv;
            private double fldunnamed_64_priv;
            private string fldunnamed_63_priv;
            private double fldunnamed_62_priv;
            private string fldunnamed_61_priv;
            private double fldunnamed_60_priv;
            private string fldunnamed_59_priv;
            private double fldunnamed_58_priv;
            private string fldunnamed_57_priv;
            private double fldunnamed_56_priv;
            private string fldunnamed_55_priv;
            private double fldunnamed_54_priv;
            private string fldunnamed_53_priv;
            private double fldunnamed_52_priv;
            private string fldunnamed_51_priv;
            private double fldunnamed_50_priv;
            private string fldunnamed_49_priv;
            private double fldunnamed_48_priv;
            private string fldunnamed_47_priv;
            private double fldunnamed_46_priv;
            private string fldunnamed_45_priv;
            private double fldunnamed_44_priv;
            private string fldunnamed_43_priv;
            private double fldunnamed_42_priv;
            private string fldunnamed_41_priv;
            private double fldunnamed_40_priv;
            private string fldunnamed_39_priv;
            private double fldunnamed_38_priv;
            private string fldunnamed_37_priv;
            private double fldunnamed_36_priv;
            private string fldunnamed_35_priv;
            private double fldunnamed_34_priv;
            private string fldunnamed_33_priv;
            private double fldunnamed_32_priv;
            private string fldunnamed_31_priv;
            private double fldunnamed_30_priv;
            private string fldunnamed_29_priv;
            private double fldunnamed_28_priv;
            private string fldunnamed_27_priv;
            private double fldunnamed_26_priv;
            private string fldunnamed_25_priv;
            private double fldunnamed_24_priv;
            private string fldunnamed_23_priv;
            private double fldunnamed_22_priv;
            private string fldunnamed_20_priv;
            private double fldunnamed_21_priv;
            private string fldunnamed_234_priv;
            private string fldunnamed_7_priv;
            private short fldMes_priv;
            private short fldDia_priv;
            private int fldSequencia_priv;
            private int fldId_priv;
            private string fldunnamed_12_priv;

            private PropertyChangedEventHandler PropertyChangedEvent;

            public int fldLancamento
            {
                get
                {
                    return this.fldLancamento_priv;
                }
                set
                {
                    if (this.fldLancamento_priv == value)
                        return;
                    this.fldLancamento_priv = value;
                    this.OnPropertyChanged("fldLancamento");
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

            public string fldCCRDebito
            {
                get
                {
                    return this.fldCCRDebito_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldCCRDebito_priv, value, false) == 0)
                        return;
                    this.fldCCRDebito_priv = value;
                    this.OnPropertyChanged("fldCCRDebito");
                }
            }

            public string fldCCDebito
            {
                get
                {
                    return this.fldCCDebito_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldCCDebito_priv, value, false) == 0)
                        return;
                    this.fldCCDebito_priv = value;
                    this.OnPropertyChanged("fldCCDebito");
                }
            }

            public string fldCCRCredito
            {
                get
                {
                    return this.fldCCRCredito_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldCCRCredito_priv, value, false) == 0)
                        return;
                    this.fldCCRCredito_priv = value;
                    this.OnPropertyChanged("fldCCRCredito");
                }
            }

            public string fldCCCredito
            {
                get
                {
                    return this.fldCCCredito_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldCCCredito_priv, value, false) == 0)
                        return;
                    this.fldCCCredito_priv = value;
                    this.OnPropertyChanged("fldCCCredito");
                }
            }

            public int fldHistorico
            {
                get
                {
                    return this.fldHistorico_priv;
                }
                set
                {
                    if (this.fldHistorico_priv == value)
                        return;
                    this.fldHistorico_priv = value;
                    this.OnPropertyChanged("fldHistorico");
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

            public double fldValor
            {
                get
                {
                    return this.fldValor_priv;
                }
                set
                {
                    if (this.fldValor_priv == value)
                        return;
                    this.fldValor_priv = value;
                    this.OnPropertyChanged("fldValor");
                }
            }

            public string fldOrigem
            {
                get
                {
                    return this.fldOrigem_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldOrigem_priv, value, false) == 0)
                        return;
                    this.fldOrigem_priv = value;
                    this.OnPropertyChanged("fldOrigem");
                }
            }

            public int fldLote
            {
                get
                {
                    return this.fldLote_priv;
                }
                set
                {
                    if (this.fldLote_priv == value)
                        return;
                    this.fldLote_priv = value;
                    this.OnPropertyChanged("fldLote");
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

            public double fldunnamed_113
            {
                get
                {
                    return this.fldunnamed_113_priv;
                }
                set
                {
                    if (this.fldunnamed_113_priv == value)
                        return;
                    this.fldunnamed_113_priv = value;
                    this.OnPropertyChanged("fldunnamed_113");
                }
            }

            public string fldunnamed_114
            {
                get
                {
                    return this.fldunnamed_114_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_114_priv, value, false) == 0)
                        return;
                    this.fldunnamed_114_priv = value;
                    this.OnPropertyChanged("fldunnamed_114");
                }
            }

            public double fldunnamed_111
            {
                get
                {
                    return this.fldunnamed_111_priv;
                }
                set
                {
                    if (this.fldunnamed_111_priv == value)
                        return;
                    this.fldunnamed_111_priv = value;
                    this.OnPropertyChanged("fldunnamed_111");
                }
            }

            public string fldunnamed_112
            {
                get
                {
                    return this.fldunnamed_112_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_112_priv, value, false) == 0)
                        return;
                    this.fldunnamed_112_priv = value;
                    this.OnPropertyChanged("fldunnamed_112");
                }
            }

            public double fldunnamed_109
            {
                get
                {
                    return this.fldunnamed_109_priv;
                }
                set
                {
                    if (this.fldunnamed_109_priv == value)
                        return;
                    this.fldunnamed_109_priv = value;
                    this.OnPropertyChanged("fldunnamed_109");
                }
            }

            public string fldunnamed_110
            {
                get
                {
                    return this.fldunnamed_110_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_110_priv, value, false) == 0)
                        return;
                    this.fldunnamed_110_priv = value;
                    this.OnPropertyChanged("fldunnamed_110");
                }
            }

            public double fldunnamed_107
            {
                get
                {
                    return this.fldunnamed_107_priv;
                }
                set
                {
                    if (this.fldunnamed_107_priv == value)
                        return;
                    this.fldunnamed_107_priv = value;
                    this.OnPropertyChanged("fldunnamed_107");
                }
            }

            public string fldunnamed_108
            {
                get
                {
                    return this.fldunnamed_108_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_108_priv, value, false) == 0)
                        return;
                    this.fldunnamed_108_priv = value;
                    this.OnPropertyChanged("fldunnamed_108");
                }
            }

            public double fldunnamed_105
            {
                get
                {
                    return this.fldunnamed_105_priv;
                }
                set
                {
                    if (this.fldunnamed_105_priv == value)
                        return;
                    this.fldunnamed_105_priv = value;
                    this.OnPropertyChanged("fldunnamed_105");
                }
            }

            public string fldunnamed_106
            {
                get
                {
                    return this.fldunnamed_106_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_106_priv, value, false) == 0)
                        return;
                    this.fldunnamed_106_priv = value;
                    this.OnPropertyChanged("fldunnamed_106");
                }
            }

            public double fldunnamed_103
            {
                get
                {
                    return this.fldunnamed_103_priv;
                }
                set
                {
                    if (this.fldunnamed_103_priv == value)
                        return;
                    this.fldunnamed_103_priv = value;
                    this.OnPropertyChanged("fldunnamed_103");
                }
            }

            public string fldunnamed_104
            {
                get
                {
                    return this.fldunnamed_104_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_104_priv, value, false) == 0)
                        return;
                    this.fldunnamed_104_priv = value;
                    this.OnPropertyChanged("fldunnamed_104");
                }
            }

            public double fldunnamed_101
            {
                get
                {
                    return this.fldunnamed_101_priv;
                }
                set
                {
                    if (this.fldunnamed_101_priv == value)
                        return;
                    this.fldunnamed_101_priv = value;
                    this.OnPropertyChanged("fldunnamed_101");
                }
            }

            public string fldunnamed_102
            {
                get
                {
                    return this.fldunnamed_102_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_102_priv, value, false) == 0)
                        return;
                    this.fldunnamed_102_priv = value;
                    this.OnPropertyChanged("fldunnamed_102");
                }
            }

            public double fldunnamed_99
            {
                get
                {
                    return this.fldunnamed_99_priv;
                }
                set
                {
                    if (this.fldunnamed_99_priv == value)
                        return;
                    this.fldunnamed_99_priv = value;
                    this.OnPropertyChanged("fldunnamed_99");
                }
            }

            public string fldunnamed_100
            {
                get
                {
                    return this.fldunnamed_100_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_100_priv, value, false) == 0)
                        return;
                    this.fldunnamed_100_priv = value;
                    this.OnPropertyChanged("fldunnamed_100");
                }
            }

            public double fldunnamed_97
            {
                get
                {
                    return this.fldunnamed_97_priv;
                }
                set
                {
                    if (this.fldunnamed_97_priv == value)
                        return;
                    this.fldunnamed_97_priv = value;
                    this.OnPropertyChanged("fldunnamed_97");
                }
            }

            public string fldunnamed_98
            {
                get
                {
                    return this.fldunnamed_98_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_98_priv, value, false) == 0)
                        return;
                    this.fldunnamed_98_priv = value;
                    this.OnPropertyChanged("fldunnamed_98");
                }
            }

            public double fldunnamed_95
            {
                get
                {
                    return this.fldunnamed_95_priv;
                }
                set
                {
                    if (this.fldunnamed_95_priv == value)
                        return;
                    this.fldunnamed_95_priv = value;
                    this.OnPropertyChanged("fldunnamed_95");
                }
            }

            public string fldunnamed_96
            {
                get
                {
                    return this.fldunnamed_96_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_96_priv, value, false) == 0)
                        return;
                    this.fldunnamed_96_priv = value;
                    this.OnPropertyChanged("fldunnamed_96");
                }
            }

            public double fldunnamed_230
            {
                get
                {
                    return this.fldunnamed_230_priv;
                }
                set
                {
                    if (this.fldunnamed_230_priv == value)
                        return;
                    this.fldunnamed_230_priv = value;
                    this.OnPropertyChanged("fldunnamed_230");
                }
            }

            public string fldunnamed_231
            {
                get
                {
                    return this.fldunnamed_231_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_231_priv, value, false) == 0)
                        return;
                    this.fldunnamed_231_priv = value;
                    this.OnPropertyChanged("fldunnamed_231");
                }
            }

            public double fldunnamed_232
            {
                get
                {
                    return this.fldunnamed_232_priv;
                }
                set
                {
                    if (this.fldunnamed_232_priv == value)
                        return;
                    this.fldunnamed_232_priv = value;
                    this.OnPropertyChanged("fldunnamed_232");
                }
            }

            public string fldunnamed_233
            {
                get
                {
                    return this.fldunnamed_233_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_233_priv, value, false) == 0)
                        return;
                    this.fldunnamed_233_priv = value;
                    this.OnPropertyChanged("fldunnamed_233");
                }
            }

            public double fldunnamed_93
            {
                get
                {
                    return this.fldunnamed_93_priv;
                }
                set
                {
                    if (this.fldunnamed_93_priv == value)
                        return;
                    this.fldunnamed_93_priv = value;
                    this.OnPropertyChanged("fldunnamed_93");
                }
            }

            public string fldunnamed_94
            {
                get
                {
                    return this.fldunnamed_94_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_94_priv, value, false) == 0)
                        return;
                    this.fldunnamed_94_priv = value;
                    this.OnPropertyChanged("fldunnamed_94");
                }
            }

            public double fldunnamed_92
            {
                get
                {
                    return this.fldunnamed_92_priv;
                }
                set
                {
                    if (this.fldunnamed_92_priv == value)
                        return;
                    this.fldunnamed_92_priv = value;
                    this.OnPropertyChanged("fldunnamed_92");
                }
            }

            public string fldunnamed_91
            {
                get
                {
                    return this.fldunnamed_91_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_91_priv, value, false) == 0)
                        return;
                    this.fldunnamed_91_priv = value;
                    this.OnPropertyChanged("fldunnamed_91");
                }
            }

            public double fldunnamed_90
            {
                get
                {
                    return this.fldunnamed_90_priv;
                }
                set
                {
                    if (this.fldunnamed_90_priv == value)
                        return;
                    this.fldunnamed_90_priv = value;
                    this.OnPropertyChanged("fldunnamed_90");
                }
            }

            public string fldunnamed_89
            {
                get
                {
                    return this.fldunnamed_89_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_89_priv, value, false) == 0)
                        return;
                    this.fldunnamed_89_priv = value;
                    this.OnPropertyChanged("fldunnamed_89");
                }
            }

            public double fldunnamed_88
            {
                get
                {
                    return this.fldunnamed_88_priv;
                }
                set
                {
                    if (this.fldunnamed_88_priv == value)
                        return;
                    this.fldunnamed_88_priv = value;
                    this.OnPropertyChanged("fldunnamed_88");
                }
            }

            public string fldunnamed_87
            {
                get
                {
                    return this.fldunnamed_87_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_87_priv, value, false) == 0)
                        return;
                    this.fldunnamed_87_priv = value;
                    this.OnPropertyChanged("fldunnamed_87");
                }
            }

            public double fldunnamed_86
            {
                get
                {
                    return this.fldunnamed_86_priv;
                }
                set
                {
                    if (this.fldunnamed_86_priv == value)
                        return;
                    this.fldunnamed_86_priv = value;
                    this.OnPropertyChanged("fldunnamed_86");
                }
            }

            public string fldunnamed_85
            {
                get
                {
                    return this.fldunnamed_85_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_85_priv, value, false) == 0)
                        return;
                    this.fldunnamed_85_priv = value;
                    this.OnPropertyChanged("fldunnamed_85");
                }
            }

            public double fldunnamed_84
            {
                get
                {
                    return this.fldunnamed_84_priv;
                }
                set
                {
                    if (this.fldunnamed_84_priv == value)
                        return;
                    this.fldunnamed_84_priv = value;
                    this.OnPropertyChanged("fldunnamed_84");
                }
            }

            public string fldunnamed_83
            {
                get
                {
                    return this.fldunnamed_83_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_83_priv, value, false) == 0)
                        return;
                    this.fldunnamed_83_priv = value;
                    this.OnPropertyChanged("fldunnamed_83");
                }
            }

            public double fldunnamed_82
            {
                get
                {
                    return this.fldunnamed_82_priv;
                }
                set
                {
                    if (this.fldunnamed_82_priv == value)
                        return;
                    this.fldunnamed_82_priv = value;
                    this.OnPropertyChanged("fldunnamed_82");
                }
            }

            public string fldunnamed_81
            {
                get
                {
                    return this.fldunnamed_81_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_81_priv, value, false) == 0)
                        return;
                    this.fldunnamed_81_priv = value;
                    this.OnPropertyChanged("fldunnamed_81");
                }
            }

            public double fldunnamed_80
            {
                get
                {
                    return this.fldunnamed_80_priv;
                }
                set
                {
                    if (this.fldunnamed_80_priv == value)
                        return;
                    this.fldunnamed_80_priv = value;
                    this.OnPropertyChanged("fldunnamed_80");
                }
            }

            public string fldunnamed_79
            {
                get
                {
                    return this.fldunnamed_79_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_79_priv, value, false) == 0)
                        return;
                    this.fldunnamed_79_priv = value;
                    this.OnPropertyChanged("fldunnamed_79");
                }
            }

            public double fldunnamed_78
            {
                get
                {
                    return this.fldunnamed_78_priv;
                }
                set
                {
                    if (this.fldunnamed_78_priv == value)
                        return;
                    this.fldunnamed_78_priv = value;
                    this.OnPropertyChanged("fldunnamed_78");
                }
            }

            public string fldunnamed_77
            {
                get
                {
                    return this.fldunnamed_77_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_77_priv, value, false) == 0)
                        return;
                    this.fldunnamed_77_priv = value;
                    this.OnPropertyChanged("fldunnamed_77");
                }
            }

            public double fldunnamed_76
            {
                get
                {
                    return this.fldunnamed_76_priv;
                }
                set
                {
                    if (this.fldunnamed_76_priv == value)
                        return;
                    this.fldunnamed_76_priv = value;
                    this.OnPropertyChanged("fldunnamed_76");
                }
            }

            public string fldunnamed_75
            {
                get
                {
                    return this.fldunnamed_75_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_75_priv, value, false) == 0)
                        return;
                    this.fldunnamed_75_priv = value;
                    this.OnPropertyChanged("fldunnamed_75");
                }
            }

            public double fldunnamed_74
            {
                get
                {
                    return this.fldunnamed_74_priv;
                }
                set
                {
                    if (this.fldunnamed_74_priv == value)
                        return;
                    this.fldunnamed_74_priv = value;
                    this.OnPropertyChanged("fldunnamed_74");
                }
            }

            public string fldunnamed_73
            {
                get
                {
                    return this.fldunnamed_73_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_73_priv, value, false) == 0)
                        return;
                    this.fldunnamed_73_priv = value;
                    this.OnPropertyChanged("fldunnamed_73");
                }
            }

            public double fldunnamed_72
            {
                get
                {
                    return this.fldunnamed_72_priv;
                }
                set
                {
                    if (this.fldunnamed_72_priv == value)
                        return;
                    this.fldunnamed_72_priv = value;
                    this.OnPropertyChanged("fldunnamed_72");
                }
            }

            public string fldunnamed_71
            {
                get
                {
                    return this.fldunnamed_71_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_71_priv, value, false) == 0)
                        return;
                    this.fldunnamed_71_priv = value;
                    this.OnPropertyChanged("fldunnamed_71");
                }
            }

            public double fldunnamed_70
            {
                get
                {
                    return this.fldunnamed_70_priv;
                }
                set
                {
                    if (this.fldunnamed_70_priv == value)
                        return;
                    this.fldunnamed_70_priv = value;
                    this.OnPropertyChanged("fldunnamed_70");
                }
            }

            public string fldunnamed_69
            {
                get
                {
                    return this.fldunnamed_69_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_69_priv, value, false) == 0)
                        return;
                    this.fldunnamed_69_priv = value;
                    this.OnPropertyChanged("fldunnamed_69");
                }
            }

            public double fldunnamed_68
            {
                get
                {
                    return this.fldunnamed_68_priv;
                }
                set
                {
                    if (this.fldunnamed_68_priv == value)
                        return;
                    this.fldunnamed_68_priv = value;
                    this.OnPropertyChanged("fldunnamed_68");
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

            public string fldunnamed_65
            {
                get
                {
                    return this.fldunnamed_65_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_65_priv, value, false) == 0)
                        return;
                    this.fldunnamed_65_priv = value;
                    this.OnPropertyChanged("fldunnamed_65");
                }
            }

            public double fldunnamed_64
            {
                get
                {
                    return this.fldunnamed_64_priv;
                }
                set
                {
                    if (this.fldunnamed_64_priv == value)
                        return;
                    this.fldunnamed_64_priv = value;
                    this.OnPropertyChanged("fldunnamed_64");
                }
            }

            public string fldunnamed_63
            {
                get
                {
                    return this.fldunnamed_63_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_63_priv, value, false) == 0)
                        return;
                    this.fldunnamed_63_priv = value;
                    this.OnPropertyChanged("fldunnamed_63");
                }
            }

            public double fldunnamed_62
            {
                get
                {
                    return this.fldunnamed_62_priv;
                }
                set
                {
                    if (this.fldunnamed_62_priv == value)
                        return;
                    this.fldunnamed_62_priv = value;
                    this.OnPropertyChanged("fldunnamed_62");
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

            public double fldunnamed_60
            {
                get
                {
                    return this.fldunnamed_60_priv;
                }
                set
                {
                    if (this.fldunnamed_60_priv == value)
                        return;
                    this.fldunnamed_60_priv = value;
                    this.OnPropertyChanged("fldunnamed_60");
                }
            }

            public string fldunnamed_59
            {
                get
                {
                    return this.fldunnamed_59_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_59_priv, value, false) == 0)
                        return;
                    this.fldunnamed_59_priv = value;
                    this.OnPropertyChanged("fldunnamed_59");
                }
            }

            public double fldunnamed_58
            {
                get
                {
                    return this.fldunnamed_58_priv;
                }
                set
                {
                    if (this.fldunnamed_58_priv == value)
                        return;
                    this.fldunnamed_58_priv = value;
                    this.OnPropertyChanged("fldunnamed_58");
                }
            }

            public string fldunnamed_57
            {
                get
                {
                    return this.fldunnamed_57_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_57_priv, value, false) == 0)
                        return;
                    this.fldunnamed_57_priv = value;
                    this.OnPropertyChanged("fldunnamed_57");
                }
            }

            public double fldunnamed_56
            {
                get
                {
                    return this.fldunnamed_56_priv;
                }
                set
                {
                    if (this.fldunnamed_56_priv == value)
                        return;
                    this.fldunnamed_56_priv = value;
                    this.OnPropertyChanged("fldunnamed_56");
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

            public double fldunnamed_54
            {
                get
                {
                    return this.fldunnamed_54_priv;
                }
                set
                {
                    if (this.fldunnamed_54_priv == value)
                        return;
                    this.fldunnamed_54_priv = value;
                    this.OnPropertyChanged("fldunnamed_54");
                }
            }

            public string fldunnamed_53
            {
                get
                {
                    return this.fldunnamed_53_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_53_priv, value, false) == 0)
                        return;
                    this.fldunnamed_53_priv = value;
                    this.OnPropertyChanged("fldunnamed_53");
                }
            }

            public double fldunnamed_52
            {
                get
                {
                    return this.fldunnamed_52_priv;
                }
                set
                {
                    if (this.fldunnamed_52_priv == value)
                        return;
                    this.fldunnamed_52_priv = value;
                    this.OnPropertyChanged("fldunnamed_52");
                }
            }

            public string fldunnamed_51
            {
                get
                {
                    return this.fldunnamed_51_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_51_priv, value, false) == 0)
                        return;
                    this.fldunnamed_51_priv = value;
                    this.OnPropertyChanged("fldunnamed_51");
                }
            }

            public double fldunnamed_50
            {
                get
                {
                    return this.fldunnamed_50_priv;
                }
                set
                {
                    if (this.fldunnamed_50_priv == value)
                        return;
                    this.fldunnamed_50_priv = value;
                    this.OnPropertyChanged("fldunnamed_50");
                }
            }

            public string fldunnamed_49
            {
                get
                {
                    return this.fldunnamed_49_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_49_priv, value, false) == 0)
                        return;
                    this.fldunnamed_49_priv = value;
                    this.OnPropertyChanged("fldunnamed_49");
                }
            }

            public double fldunnamed_48
            {
                get
                {
                    return this.fldunnamed_48_priv;
                }
                set
                {
                    if (this.fldunnamed_48_priv == value)
                        return;
                    this.fldunnamed_48_priv = value;
                    this.OnPropertyChanged("fldunnamed_48");
                }
            }

            public string fldunnamed_47
            {
                get
                {
                    return this.fldunnamed_47_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_47_priv, value, false) == 0)
                        return;
                    this.fldunnamed_47_priv = value;
                    this.OnPropertyChanged("fldunnamed_47");
                }
            }

            public double fldunnamed_46
            {
                get
                {
                    return this.fldunnamed_46_priv;
                }
                set
                {
                    if (this.fldunnamed_46_priv == value)
                        return;
                    this.fldunnamed_46_priv = value;
                    this.OnPropertyChanged("fldunnamed_46");
                }
            }

            public string fldunnamed_45
            {
                get
                {
                    return this.fldunnamed_45_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_45_priv, value, false) == 0)
                        return;
                    this.fldunnamed_45_priv = value;
                    this.OnPropertyChanged("fldunnamed_45");
                }
            }

            public double fldunnamed_44
            {
                get
                {
                    return this.fldunnamed_44_priv;
                }
                set
                {
                    if (this.fldunnamed_44_priv == value)
                        return;
                    this.fldunnamed_44_priv = value;
                    this.OnPropertyChanged("fldunnamed_44");
                }
            }

            public string fldunnamed_43
            {
                get
                {
                    return this.fldunnamed_43_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_43_priv, value, false) == 0)
                        return;
                    this.fldunnamed_43_priv = value;
                    this.OnPropertyChanged("fldunnamed_43");
                }
            }

            public double fldunnamed_42
            {
                get
                {
                    return this.fldunnamed_42_priv;
                }
                set
                {
                    if (this.fldunnamed_42_priv == value)
                        return;
                    this.fldunnamed_42_priv = value;
                    this.OnPropertyChanged("fldunnamed_42");
                }
            }

            public string fldunnamed_41
            {
                get
                {
                    return this.fldunnamed_41_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_41_priv, value, false) == 0)
                        return;
                    this.fldunnamed_41_priv = value;
                    this.OnPropertyChanged("fldunnamed_41");
                }
            }

            public double fldunnamed_40
            {
                get
                {
                    return this.fldunnamed_40_priv;
                }
                set
                {
                    if (this.fldunnamed_40_priv == value)
                        return;
                    this.fldunnamed_40_priv = value;
                    this.OnPropertyChanged("fldunnamed_40");
                }
            }

            public string fldunnamed_39
            {
                get
                {
                    return this.fldunnamed_39_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_39_priv, value, false) == 0)
                        return;
                    this.fldunnamed_39_priv = value;
                    this.OnPropertyChanged("fldunnamed_39");
                }
            }

            public double fldunnamed_38
            {
                get
                {
                    return this.fldunnamed_38_priv;
                }
                set
                {
                    if (this.fldunnamed_38_priv == value)
                        return;
                    this.fldunnamed_38_priv = value;
                    this.OnPropertyChanged("fldunnamed_38");
                }
            }

            public string fldunnamed_37
            {
                get
                {
                    return this.fldunnamed_37_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_37_priv, value, false) == 0)
                        return;
                    this.fldunnamed_37_priv = value;
                    this.OnPropertyChanged("fldunnamed_37");
                }
            }

            public double fldunnamed_36
            {
                get
                {
                    return this.fldunnamed_36_priv;
                }
                set
                {
                    if (this.fldunnamed_36_priv == value)
                        return;
                    this.fldunnamed_36_priv = value;
                    this.OnPropertyChanged("fldunnamed_36");
                }
            }

            public string fldunnamed_35
            {
                get
                {
                    return this.fldunnamed_35_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_35_priv, value, false) == 0)
                        return;
                    this.fldunnamed_35_priv = value;
                    this.OnPropertyChanged("fldunnamed_35");
                }
            }

            public double fldunnamed_34
            {
                get
                {
                    return this.fldunnamed_34_priv;
                }
                set
                {
                    if (this.fldunnamed_34_priv == value)
                        return;
                    this.fldunnamed_34_priv = value;
                    this.OnPropertyChanged("fldunnamed_34");
                }
            }

            public string fldunnamed_33
            {
                get
                {
                    return this.fldunnamed_33_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_33_priv, value, false) == 0)
                        return;
                    this.fldunnamed_33_priv = value;
                    this.OnPropertyChanged("fldunnamed_33");
                }
            }

            public double fldunnamed_32
            {
                get
                {
                    return this.fldunnamed_32_priv;
                }
                set
                {
                    if (this.fldunnamed_32_priv == value)
                        return;
                    this.fldunnamed_32_priv = value;
                    this.OnPropertyChanged("fldunnamed_32");
                }
            }

            public string fldunnamed_31
            {
                get
                {
                    return this.fldunnamed_31_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_31_priv, value, false) == 0)
                        return;
                    this.fldunnamed_31_priv = value;
                    this.OnPropertyChanged("fldunnamed_31");
                }
            }

            public double fldunnamed_30
            {
                get
                {
                    return this.fldunnamed_30_priv;
                }
                set
                {
                    if (this.fldunnamed_30_priv == value)
                        return;
                    this.fldunnamed_30_priv = value;
                    this.OnPropertyChanged("fldunnamed_30");
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

            public double fldunnamed_28
            {
                get
                {
                    return this.fldunnamed_28_priv;
                }
                set
                {
                    if (this.fldunnamed_28_priv == value)
                        return;
                    this.fldunnamed_28_priv = value;
                    this.OnPropertyChanged("fldunnamed_28");
                }
            }

            public string fldunnamed_27
            {
                get
                {
                    return this.fldunnamed_27_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_27_priv, value, false) == 0)
                        return;
                    this.fldunnamed_27_priv = value;
                    this.OnPropertyChanged("fldunnamed_27");
                }
            }

            public double fldunnamed_26
            {
                get
                {
                    return this.fldunnamed_26_priv;
                }
                set
                {
                    if (this.fldunnamed_26_priv == value)
                        return;
                    this.fldunnamed_26_priv = value;
                    this.OnPropertyChanged("fldunnamed_26");
                }
            }

            public string fldunnamed_25
            {
                get
                {
                    return this.fldunnamed_25_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_25_priv, value, false) == 0)
                        return;
                    this.fldunnamed_25_priv = value;
                    this.OnPropertyChanged("fldunnamed_25");
                }
            }

            public double fldunnamed_24
            {
                get
                {
                    return this.fldunnamed_24_priv;
                }
                set
                {
                    if (this.fldunnamed_24_priv == value)
                        return;
                    this.fldunnamed_24_priv = value;
                    this.OnPropertyChanged("fldunnamed_24");
                }
            }

            public string fldunnamed_23
            {
                get
                {
                    return this.fldunnamed_23_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_23_priv, value, false) == 0)
                        return;
                    this.fldunnamed_23_priv = value;
                    this.OnPropertyChanged("fldunnamed_23");
                }
            }

            public double fldunnamed_22
            {
                get
                {
                    return this.fldunnamed_22_priv;
                }
                set
                {
                    if (this.fldunnamed_22_priv == value)
                        return;
                    this.fldunnamed_22_priv = value;
                    this.OnPropertyChanged("fldunnamed_22");
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

            public double fldunnamed_21
            {
                get
                {
                    return this.fldunnamed_21_priv;
                }
                set
                {
                    if (this.fldunnamed_21_priv == value)
                        return;
                    this.fldunnamed_21_priv = value;
                    this.OnPropertyChanged("fldunnamed_21");
                }
            }

            public string fldunnamed_234
            {
                get
                {
                    return this.fldunnamed_234_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_234_priv, value, false) == 0)
                        return;
                    this.fldunnamed_234_priv = value;
                    this.OnPropertyChanged("fldunnamed_234");
                }
            }

            public string fldunnamed_7
            {
                get
                {
                    return this.fldunnamed_7_priv;
                }
                set
                {
                    if (Operators.CompareString(this.fldunnamed_7_priv, value, false) == 0)
                        return;
                    this.fldunnamed_7_priv = value;
                    this.OnPropertyChanged("fldunnamed_7");
                }
            }

            public short fldMes
            {
                get
                {
                    return this.fldMes_priv;
                }
                set
                {
                    if ((int)this.fldMes_priv == (int)value)
                        return;
                    this.fldMes_priv = value;
                    this.OnPropertyChanged("fldMes");
                }
            }

            public short fldDia
            {
                get
                {
                    return this.fldDia_priv;
                }
                set
                {
                    if ((int)this.fldDia_priv == (int)value)
                        return;
                    this.fldDia_priv = value;
                    this.OnPropertyChanged("fldDia");
                }
            }

            public int fldSequencia
            {
                get
                {
                    return this.fldSequencia_priv;
                }
                set
                {
                    if (this.fldSequencia_priv == value)
                        return;
                    this.fldSequencia_priv = value;
                    this.OnPropertyChanged("fldSequencia");
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

            public event PropertyChangedEventHandler PropertyChanged;

            public FieldsClass()
            {
                this.fldLancamento_priv = 0;
                this.fldData_priv = string.Empty;
                this.fldCCRDebito_priv = string.Empty;
                this.fldCCDebito_priv = string.Empty;
                this.fldCCRCredito_priv = string.Empty;
                this.fldCCCredito_priv = string.Empty;
                this.fldHistorico_priv = 0;
                this.fldComplemento_priv = string.Empty;
                this.fldValor_priv = 0.0;
                this.fldOrigem_priv = string.Empty;
                this.fldLote_priv = 0;
                this.fldunnamed_4_priv = 0;
                this.fldunnamed_5_priv = 0;
                this.fldunnamed_6_priv = string.Empty;
                this.fldunnamed_113_priv = 0.0;
                this.fldunnamed_114_priv = string.Empty;
                this.fldunnamed_111_priv = 0.0;
                this.fldunnamed_112_priv = string.Empty;
                this.fldunnamed_109_priv = 0.0;
                this.fldunnamed_110_priv = string.Empty;
                this.fldunnamed_107_priv = 0.0;
                this.fldunnamed_108_priv = string.Empty;
                this.fldunnamed_105_priv = 0.0;
                this.fldunnamed_106_priv = string.Empty;
                this.fldunnamed_103_priv = 0.0;
                this.fldunnamed_104_priv = string.Empty;
                this.fldunnamed_101_priv = 0.0;
                this.fldunnamed_102_priv = string.Empty;
                this.fldunnamed_99_priv = 0.0;
                this.fldunnamed_100_priv = string.Empty;
                this.fldunnamed_97_priv = 0.0;
                this.fldunnamed_98_priv = string.Empty;
                this.fldunnamed_95_priv = 0.0;
                this.fldunnamed_96_priv = string.Empty;
                this.fldunnamed_230_priv = 0.0;
                this.fldunnamed_231_priv = string.Empty;
                this.fldunnamed_232_priv = 0.0;
                this.fldunnamed_233_priv = string.Empty;
                this.fldunnamed_93_priv = 0.0;
                this.fldunnamed_94_priv = string.Empty;
                this.fldunnamed_92_priv = 0.0;
                this.fldunnamed_91_priv = string.Empty;
                this.fldunnamed_90_priv = 0.0;
                this.fldunnamed_89_priv = string.Empty;
                this.fldunnamed_88_priv = 0.0;
                this.fldunnamed_87_priv = string.Empty;
                this.fldunnamed_86_priv = 0.0;
                this.fldunnamed_85_priv = string.Empty;
                this.fldunnamed_84_priv = 0.0;
                this.fldunnamed_83_priv = string.Empty;
                this.fldunnamed_82_priv = 0.0;
                this.fldunnamed_81_priv = string.Empty;
                this.fldunnamed_80_priv = 0.0;
                this.fldunnamed_79_priv = string.Empty;
                this.fldunnamed_78_priv = 0.0;
                this.fldunnamed_77_priv = string.Empty;
                this.fldunnamed_76_priv = 0.0;
                this.fldunnamed_75_priv = string.Empty;
                this.fldunnamed_74_priv = 0.0;
                this.fldunnamed_73_priv = string.Empty;
                this.fldunnamed_72_priv = 0.0;
                this.fldunnamed_71_priv = string.Empty;
                this.fldunnamed_70_priv = 0.0;
                this.fldunnamed_69_priv = string.Empty;
                this.fldunnamed_68_priv = 0.0;
                this.fldunnamed_67_priv = string.Empty;
                this.fldunnamed_66_priv = 0.0;
                this.fldunnamed_65_priv = string.Empty;
                this.fldunnamed_64_priv = 0.0;
                this.fldunnamed_63_priv = string.Empty;
                this.fldunnamed_62_priv = 0.0;
                this.fldunnamed_61_priv = string.Empty;
                this.fldunnamed_60_priv = 0.0;
                this.fldunnamed_59_priv = string.Empty;
                this.fldunnamed_58_priv = 0.0;
                this.fldunnamed_57_priv = string.Empty;
                this.fldunnamed_56_priv = 0.0;
                this.fldunnamed_55_priv = string.Empty;
                this.fldunnamed_54_priv = 0.0;
                this.fldunnamed_53_priv = string.Empty;
                this.fldunnamed_52_priv = 0.0;
                this.fldunnamed_51_priv = string.Empty;
                this.fldunnamed_50_priv = 0.0;
                this.fldunnamed_49_priv = string.Empty;
                this.fldunnamed_48_priv = 0.0;
                this.fldunnamed_47_priv = string.Empty;
                this.fldunnamed_46_priv = 0.0;
                this.fldunnamed_45_priv = string.Empty;
                this.fldunnamed_44_priv = 0.0;
                this.fldunnamed_43_priv = string.Empty;
                this.fldunnamed_42_priv = 0.0;
                this.fldunnamed_41_priv = string.Empty;
                this.fldunnamed_40_priv = 0.0;
                this.fldunnamed_39_priv = string.Empty;
                this.fldunnamed_38_priv = 0.0;
                this.fldunnamed_37_priv = string.Empty;
                this.fldunnamed_36_priv = 0.0;
                this.fldunnamed_35_priv = string.Empty;
                this.fldunnamed_34_priv = 0.0;
                this.fldunnamed_33_priv = string.Empty;
                this.fldunnamed_32_priv = 0.0;
                this.fldunnamed_31_priv = string.Empty;
                this.fldunnamed_30_priv = 0.0;
                this.fldunnamed_29_priv = string.Empty;
                this.fldunnamed_28_priv = 0.0;
                this.fldunnamed_27_priv = string.Empty;
                this.fldunnamed_26_priv = 0.0;
                this.fldunnamed_25_priv = string.Empty;
                this.fldunnamed_24_priv = 0.0;
                this.fldunnamed_23_priv = string.Empty;
                this.fldunnamed_22_priv = 0.0;
                this.fldunnamed_20_priv = string.Empty;
                this.fldunnamed_21_priv = 0.0;
                this.fldunnamed_234_priv = string.Empty;
                this.fldunnamed_7_priv = string.Empty;
                this.fldMes_priv = (short)0;
                this.fldDia_priv = (short)0;
                this.fldSequencia_priv = 0;
                this.fldId_priv = 0;
                this.fldunnamed_12_priv = string.Empty;
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
