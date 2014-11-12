using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SA.Data.Models
{
    public class Empresa
    {
        #region Variaveis

        #endregion

        #region Propriedades

        /// <summary>
        /// CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição. Obrigatório - variável.
        /// </summary>
        [Key]
        public string CNPJ { get; set; }

        /// <summary>
        /// CNPJ/CPF - Filial. Obrigatório - variável.
        /// </summary>
        public string CNPJ_FILIAL { get; set; }

        /// <summary>
        /// CNPJ/CPF - Digito de Verificação. Obrigatório - variável.
        /// </summary>
        public string CNPJ_DIGITO { get; set; }

        /// <summary>
        /// Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo.
        /// </summary>
        public string NOME_EMPRESA { get; set; }

        #endregion
    }
}
