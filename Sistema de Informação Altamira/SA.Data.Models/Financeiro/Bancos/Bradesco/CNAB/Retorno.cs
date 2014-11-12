using System;
using System.Collections.Generic;
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
            /// Representa o arquivo de Retorno do Bradesco no padrão CNAB.
            /// </summary>
            public partial class Retorno : Arquivo
            {
                #region Variaveis

                #endregion

                #region Propriedades

                #endregion

                #region Construtores

                /// <summary>
                /// Construtor da classe que representa o arquivo de Retorno padrão CNAB do Bradesco
                /// </summary>
                public Retorno()
                    : base()
                {
                }

                /// <summary>
                /// Construtor da classe que representa o arquivo de Retorno padrão CNAB do Bradesco
                /// </summary>
                /// <param name="Convenio"></param>
                public Retorno(Convenio Convenio)
                    : base(Convenio)
                {
                }

                #endregion

                #region Metodos

                public override IEnumerable<Exception> Validar()
                {
                    base.Validar();

                    yield return null;
                }

                #endregion
            }
        }
    }
}
