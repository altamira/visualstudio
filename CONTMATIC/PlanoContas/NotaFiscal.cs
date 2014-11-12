using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace CONTMATIC
{
    public class NotaFiscal : INotifyPropertyChanged
    {
        private int id;

        public int Id
        {
            get { return id; }
            set { id = value; }
        }
        
        private bool selecionado;

        public bool Selecionado
        {
            get { return selecionado; }
            set { selecionado = value; OnPropertyChanged("Selecionado"); }
        }

        private bool habilitado;

        public bool Habilitado
        {
            get { return habilitado; }
            set { habilitado = value; }
        }
        
        private int numero;

        public int Numero
        {
            get { return numero; }
            set { numero = value; }
        }

        private DateTime data;

        public DateTime Data
        {
            get { return data; }
            set { data = value; }
        }

        private DateTime emissao;

        public DateTime Emissao
        {
            get { return emissao; }
            set { emissao = value; }
        }
        
        private string cnpj;

        private string operacao;

        public string Operacao
        {
            get { return operacao; }
            set { operacao = value; }
        }
        
        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }

        //private string nome;

        //public string Nome
        //{
        //    get { return nome; }
        //    set { nome = value; }
        //}

        private string classificacaofiscal;

        public string ClassificacaoFiscal
        {
            get { return classificacaofiscal; }
            set { classificacaofiscal = value; }
        }

        private short contacontabil;

        public short ContaContabil
        {
            get { return contacontabil; }
            set { contacontabil = value; if (CentenaCFOP > 0) CarregaNovaConta(); }
        }

        private short novacontacontabil;

        public short NovaContaContabil
        {
            get { return novacontacontabil; }
            set { novacontacontabil = value; }
        }
        
        private short centenacfop;

        public short CentenaCFOP
        {
            get { return centenacfop; }
            set { centenacfop = value; if (ContaContabil > 0) CarregaNovaConta(); }
        }
        
        private string especie;

        public string Especie
        {
            get { return especie; }
            set { especie = value; }
        }

        private double valorcontabil;

        public double ValorContabil
        {
            get { return valorcontabil; }
            set { valorcontabil = value; }
        }
        
        private string situacao;

        public string Situacao
        {
            get { return situacao; }
            set { situacao = value; OnPropertyChanged("Situacao"); }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged(string caller)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(caller));
            }
        }

        private void CarregaNovaConta()
        {
            try
            {
                if (Operacao == "E")
                {
                    switch (CentenaCFOP)
                    {
                        case 101:
                            switch (ContaContabil)
                            {
                                case 1:
                                    NovaContaContabil = 300;
                                    break;
                                case 2:
                                    NovaContaContabil = 301;
                                    break;
                                case 3:
                                    NovaContaContabil = 302;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 116:
                            switch (ContaContabil)
                            {
                                case 55:
                                    NovaContaContabil = 999;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 120:
                            switch (ContaContabil)
                            {
                                case 58:
                                    NovaContaContabil = 320;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 122:
                            switch (ContaContabil)
                            {
                                case 1:
                                    NovaContaContabil = 300;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 124:
                            switch (ContaContabil)
                            {
                                case 4:
                                    NovaContaContabil = 302;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 125:
                            switch (ContaContabil)
                            {
                                case 57:
                                    NovaContaContabil = 302;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 201:
                            switch (ContaContabil)
                            {
                                case 60:
                                    NovaContaContabil = 321;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 252:
                            switch (ContaContabil)
                            {
                                case 16:
                                    NovaContaContabil = 303;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 302:
                            switch (ContaContabil)
                            {
                                case 40:
                                    NovaContaContabil = 322;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 352:
                            switch (ContaContabil)
                            {
                                case 26:
                                    NovaContaContabil = 304;
                                    break;
                                case 27:
                                    NovaContaContabil = 323;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 360:
                            switch (ContaContabil)
                            {
                                case 30:
                                    NovaContaContabil = 323;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 401:
                            switch (ContaContabil)
                            {
                                case 1:
                                    NovaContaContabil = 300;
                                    break;
                                case 28:
                                    NovaContaContabil = 300;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 406:
                            switch (ContaContabil)
                            {
                                case 15:
                                    NovaContaContabil = 324;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 407:
                            switch (ContaContabil)
                            {
                                case 36:
                                    NovaContaContabil = 318;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 551:
                            switch (ContaContabil)
                            {
                                case 9:
                                    NovaContaContabil = 305;
                                    break;
                                case 10:
                                    NovaContaContabil = 306;
                                    break;
                                case 11:
                                    NovaContaContabil = 307;
                                    break;
                                case 12:
                                    NovaContaContabil = 308;
                                    break;
                                case 14:
                                    NovaContaContabil = 309;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 556:
                            switch (ContaContabil)
                            {
                                case 17:
                                    NovaContaContabil = 310;
                                    break;
                                case 18:
                                    NovaContaContabil = 311;
                                    break;
                                case 19:
                                    NovaContaContabil = 312;
                                    break;
                                case 20:
                                    NovaContaContabil = 325;
                                    break;
                                case 21:
                                    NovaContaContabil = 326;
                                    break;
                                case 22:
                                    NovaContaContabil = 313;
                                    break;
                                case 31:
                                    NovaContaContabil = 314;
                                    break;
                                case 32:
                                    NovaContaContabil = 319;
                                    break;
                                case 37:
                                    NovaContaContabil = 329;
                                    break;
                                case 41:
                                    NovaContaContabil = 330;
                                    break;
                                case 42:
                                    NovaContaContabil = 327;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 604:
                            switch (ContaContabil)
                            {
                                case 53:
                                    NovaContaContabil = 604;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 653:
                            switch (ContaContabil)
                            {
                                case 24:
                                    NovaContaContabil = 315;
                                    break;
                                case 25:
                                    NovaContaContabil = 316;
                                    break;
                                case 33:
                                    NovaContaContabil = 328;
                                    break;
                                case 34:
                                    NovaContaContabil = 317;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 902:
                            switch (ContaContabil)
                            {
                                case 46:
                                    NovaContaContabil = 902;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 903:
                            switch (ContaContabil)
                            {
                                case 46:
                                    NovaContaContabil = 999;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 908:
                            switch (ContaContabil)
                            {
                                case 45:
                                    NovaContaContabil = 908;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 912:
                            switch (ContaContabil)
                            {
                                case 47:
                                    NovaContaContabil = 912;
                                    break;
                                case 51:
                                    NovaContaContabil = 999;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 913:
                            switch (ContaContabil)
                            {
                                case 48:
                                    NovaContaContabil = 913;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 915:
                            switch (ContaContabil)
                            {
                                case 49:
                                    NovaContaContabil = 915;
                                    break;
                                case 52:
                                    NovaContaContabil = 999;
                                    break;
                                case 200:
                                    NovaContaContabil = 915;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 916:
                            switch (ContaContabil)
                            {
                                case 50:
                                    NovaContaContabil = 916;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 920:
                            switch (ContaContabil)
                            {
                                case 13:
                                    NovaContaContabil = 920;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 922:
                            switch (ContaContabil)
                            {
                                case 54:
                                    NovaContaContabil = 922;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 925:
                            switch (ContaContabil)
                            {
                                case 56:
                                    NovaContaContabil = 925;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 933:
                            switch (ContaContabil)
                            {
                                case 23:
                                    NovaContaContabil = 933;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 949:
                            switch (ContaContabil)
                            {
                                case 39:
                                    NovaContaContabil = 999;
                                    break;
                                case 59:
                                    NovaContaContabil = 949;
                                    break;
                                case 61:
                                    NovaContaContabil = 949;
                                    break;
                                case 62:
                                    NovaContaContabil = 949;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        default:
                            NovaContaContabil = 0;
                            break;
                    }
                }
                else if (Operacao == "S")
                {
                    switch (CentenaCFOP)
                    {
                        case 101:
                            switch (ContaContabil)
                            {
                                case 100:
                                    NovaContaContabil = 400;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 102:
                            switch (ContaContabil)
                            {
                                case 100:
                                    NovaContaContabil = 400;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 107:
                            switch (ContaContabil)
                            {
                                case 100:
                                    NovaContaContabil = 400;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 109:
                            switch (ContaContabil)
                            {
                                case 100:
                                    NovaContaContabil = 400;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 201:
                            switch (ContaContabil)
                            {
                                case 202:
                                    NovaContaContabil = 201;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 901:
                            switch (ContaContabil)
                            {
                                case 201:
                                    NovaContaContabil = 901;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 902:
                            switch (ContaContabil)
                            {
                                case 46:
                                    NovaContaContabil = 902;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 915:
                            switch (ContaContabil)
                            {
                                case 200:
                                    NovaContaContabil = 915;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        case 922:
                            switch (ContaContabil)
                            {
                                case 100:
                                    NovaContaContabil = 400;
                                    break;
                                default:
                                    NovaContaContabil = 0;
                                    break;
                            }
                            break;
                        default:
                            break;
                    }
                }

                if (NovaContaContabil > 0)
                {
                    Situacao = string.Format("Converter C/C", ContaContabil, NovaContaContabil);
                    Selecionado = true;
                }
                else
                {
                    if ((Operacao == "E" && (
                        (CentenaCFOP == 101 && (ContaContabil == 300 || ContaContabil == 301 || ContaContabil == 302)) ||
                        (CentenaCFOP == 116 && ContaContabil == 999) ||
                        (CentenaCFOP == 120 && ContaContabil == 320) ||
                        (CentenaCFOP == 122 && ContaContabil == 300) ||
                        (CentenaCFOP == 124 && ContaContabil == 302) ||
                        (CentenaCFOP == 125 && ContaContabil == 302) ||
                        (CentenaCFOP == 201 && ContaContabil == 321) ||
                        (CentenaCFOP == 252 && ContaContabil == 303) ||
                        (CentenaCFOP == 302 && ContaContabil == 322) ||
                        (CentenaCFOP == 352 && (ContaContabil == 304 || ContaContabil == 323)) ||
                        (CentenaCFOP == 360 && ContaContabil == 323) ||
                        (CentenaCFOP == 401 && ContaContabil == 300) ||
                        (CentenaCFOP == 406 && ContaContabil == 324) ||
                        (CentenaCFOP == 407 && ContaContabil == 318) ||
                        (CentenaCFOP == 551 && (ContaContabil == 305 || ContaContabil == 306 || ContaContabil == 307 || ContaContabil == 308 || ContaContabil == 309)) ||
                        (CentenaCFOP == 556 && (ContaContabil == 310 || ContaContabil == 311 || ContaContabil == 312 || ContaContabil == 325 || ContaContabil == 326 || ContaContabil == 313 || ContaContabil == 314 || ContaContabil == 319 || ContaContabil == 329 || ContaContabil == 330 || ContaContabil == 327)) ||
                        (CentenaCFOP == 604 && ContaContabil == 604) ||
                        (CentenaCFOP == 653 && (ContaContabil == 315 || ContaContabil == 316 || ContaContabil == 317 || ContaContabil == 328)) ||
                        (CentenaCFOP == 901 && ContaContabil == 999) ||
                        (CentenaCFOP == 902 && ContaContabil == 902) ||
                        (CentenaCFOP == 903 && ContaContabil == 999) ||
                        (CentenaCFOP == 908 && ContaContabil == 908) ||
                        (CentenaCFOP == 910 && ContaContabil == 999) ||
                        (CentenaCFOP == 911 && ContaContabil == 999) ||
                        (CentenaCFOP == 912 && (ContaContabil == 912 || ContaContabil == 999)) ||
                        (CentenaCFOP == 913 && ContaContabil == 913) ||
                        (CentenaCFOP == 915 && (ContaContabil == 915 || ContaContabil == 999)) ||
                        (CentenaCFOP == 916 && ContaContabil == 916) ||
                        (CentenaCFOP == 920 && ContaContabil == 920) ||
                        (CentenaCFOP == 922 && ContaContabil == 922) ||
                        (CentenaCFOP == 925 && ContaContabil == 925) ||
                        (CentenaCFOP == 933 && ContaContabil == 933) ||
                        (CentenaCFOP == 949 && (ContaContabil == 949 || ContaContabil == 999)) ||
                        (CentenaCFOP == 999))) || 
                        (Operacao == "S" && (
                        (CentenaCFOP == 101 && ContaContabil == 400) ||
                        (CentenaCFOP == 102 && ContaContabil == 400) ||
                        (CentenaCFOP == 107 && ContaContabil == 400) ||
                        (CentenaCFOP == 109 && ContaContabil == 400) ||
                        (CentenaCFOP == 116 && ContaContabil == 0) ||
                        (CentenaCFOP == 122 && ContaContabil == 400) ||
                        (CentenaCFOP == 124 && ContaContabil == 0) ||
                        (CentenaCFOP == 125 && ContaContabil == 0) ||
                        (CentenaCFOP == 201 && ContaContabil == 201) ||
                        (CentenaCFOP == 252 && ContaContabil == 0) ||
                        (CentenaCFOP == 235 && ContaContabil == 0) ||
                        (CentenaCFOP == 401 && ContaContabil == 400) ||
                        (CentenaCFOP == 407 && ContaContabil == 0) ||
                        (CentenaCFOP == 413 && ContaContabil == 202) ||
                        (CentenaCFOP == 501 && ContaContabil == 400) ||
                        (CentenaCFOP == 551 && ContaContabil == 551) ||
                        (CentenaCFOP == 556 && ContaContabil == 201) ||
                        (CentenaCFOP == 604 && ContaContabil == 0) ||
                        (CentenaCFOP == 653 && ContaContabil == 0) ||
                        (CentenaCFOP == 901 && ContaContabil == 901) ||
                        (CentenaCFOP == 902 && ContaContabil == 902) ||
                        (CentenaCFOP == 903 && ContaContabil == 903) ||
                        (CentenaCFOP == 910 && ContaContabil == 910) ||
                        (CentenaCFOP == 911 && ContaContabil == 911) ||
                        (CentenaCFOP == 913 && ContaContabil == 913) ||
                        (CentenaCFOP == 915 && ContaContabil == 915) ||
                        (CentenaCFOP == 916 && ContaContabil == 916) ||
                        (CentenaCFOP == 920 && ContaContabil == 920) ||
                        (CentenaCFOP == 921 && ContaContabil == 921) ||
                        (CentenaCFOP == 922 && ContaContabil == 400) ||
                        (CentenaCFOP == 925 && ContaContabil == 925) ||
                        (CentenaCFOP == 949 && (ContaContabil == 401 || ContaContabil == 949))                        
                        )))
                    {
                        Situacao = string.Format("C/C Atualizada - OK", ContaContabil);
                    }
                    else
                    {
                        Situacao = string.Format("C/C Não Cadastrada", ContaContabil);
                    }
                    Selecionado = false;
                }
            }
            catch (NotImplementedException)
            {
                Situacao = string.Format("C/C Não Cadastrada", ContaContabil);
                Selecionado = false;
            }
        }
    }
}
