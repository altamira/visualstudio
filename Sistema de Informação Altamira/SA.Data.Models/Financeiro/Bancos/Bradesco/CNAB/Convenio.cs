using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
    public partial class Bradesco : Banco
    {
        public partial class CNAB
        {
            /// <summary>
            /// Representa o convenio firmado com o banco para transferencia de arquivos CNAB
            /// </summary>
            public class Convenio
            {
                #region Variaveis

                private Dictionary<string, string> Dicionario = new Dictionary<string, string>();

                public Collection<Empresa> Empresas = new Collection<Empresa>();

                /// <summary>
                /// Representa o registro de Rodape do arquivo CNAB do Bradesco.
                /// </summary>
                public SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Rodape Rodape { get; set; }

                #endregion

                #region Propriedades

                /// <summary>
                /// Identificação da empresa no Banco - Será fornecido pelo Banco previamente à implantação. É único e constante para todas as empresas do Grupo, quando o processamento for centralizado. Se o processamento for descentralizado, por exemplo, por região, poderá ser fornecido um código para cada centro processador, desde que possuam CNPJ’s diferentes. Obrigatório – fixo.
                /// </summary>
                [Atributo(Sequencia = 1, Regex = @"(?<CODIGO_COMUNICACAO>\d{8})")]
                public char[] CODIGO_COMUNICACAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CODIGO_COMUNICACAO"))
                            Dicionario["CODIGO_COMUNICACAO"] = "".PadLeft(8, '0');

                        return Dicionario["CODIGO_COMUNICACAO"].PadLeft(8, '0').Substring(0, 8).ToCharArray();
                    }
                    set
                    {
                        string codigo = string.Join("", value);
                        if (codigo == null || codigo.Trim().Length > 8 || !codigo.Trim().PadLeft(8, '0').IsNumericArray(8))
                            throw new ArgumentException("Codigo de Comunicação deve ter até 8 digitos numéricos;");

                        Dicionario["CODIGO_COMUNICACAO"] = codigo.Trim().PadLeft(8, '0').Substring(0, 8);
                    }
                }

                #endregion

                #region Construtores

                public Convenio(Cabecalho Cabecalho)
                {
                    CODIGO_COMUNICACAO = Cabecalho.CODIGO_COMUNICACAO;

                    this.Empresas.Add(new Empresa(Cabecalho));

                    this.Rodape = new Rodape();
                }

                #endregion

                #region Metodos

                #endregion

            }
        }
    }
}
