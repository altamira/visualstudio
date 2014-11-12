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
            /// Representa o arquivo de Remessa do Bradesco no padrão CNAB.
            /// </summary>
            public partial class Remessa : Arquivo
            {
                #region Variaveis

                #endregion

                #region Propriedades

                #endregion

                #region Construtores

                /// <summary>
                /// Construtor da classe que representa o arquivo de Remessa no padrão CNAB do Bradesco
                /// </summary>
                public Remessa()
                    : base()
                {
                }

                /// <summary>
                /// Construtor da classe que representa o arquivo de Remessa no padrão CNAB do Bradesco
                /// </summary>
                /// <param name="Convenio"></param>
                public Remessa(Convenio Convenio)
                    : base(Convenio)
                {
                }

                #endregion

                #region Metodos

                /// <summary>
                /// Validação do registro.
                /// </summary>
                /// <returns></returns>
                public override IEnumerable<Exception> Validar()
                {
                    base.Validar();

                    foreach (Convenio c in this.Convenios)
                    {
                        foreach (Empresa e in c.Empresas)
                        {
                            foreach (Instrucao i in e.Instrucoes)
                            {
                                //if (i.TIPO_DOCUMENTO == null)
                                //    yield return new Exception("O Tipo de Documento é obrigatório.");

                                switch (i.MODALIDADE_PAGAMENTO)
                                {
                                    case MODALIDADE_PAGAMENTO.CREDITO_CONTA_CORRENTE: // 01 - Credito em Conta Corrente
                                        if (string.IsNullOrEmpty(i.ENDERECO_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Endereço do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CEP_PREFIXO) || string.IsNullOrEmpty(i.CEP_COMPLEMENTO))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o CEP é obrigatório.");

                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Código do Banco do Fornecedor é obrigatório.");

                                        if (i.BANCO_FORNECEDOR != Bancos.CODIGO.BRADESCO)
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o código do Banco do Fornecedor é obrigatório 237 - Bradesco.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                        if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO) &&
                                            uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bancos.Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Dígito Verificador do Número da Agência do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.AGENCIA_FORNECEDOR_DIGITO);

                                        if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Número da Conta Corrente do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Dígito Verificador do Número da Conta Corrente do Fornecedor é obrigatório.");

                                        if (!string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO) &&
                                            uint.Parse(i.CONTA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.CONTA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Dígito Verificador da Conta Corrente do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.CONTA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.CONTA_FORNECEDOR_DIGITO);

                                        if (string.IsNullOrEmpty(i.NUMERO_NOTA_FISCAL))
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o Número da Nota Fiscal/Fatura/Duplicata é obrigatório.");

                                        if (i.DATA_PAGAMENTO.Date != i.DATA_VENCIMENTO.Date)
                                            yield return new Exception("Na Modalidade de Pagamento Crédito em Conta Corrente o a Data de Pagamento deve ser igual a Data de Vencimento.");
                                        break;
                                    case MODALIDADE_PAGAMENTO.CHEQUE_ORDEM_PAGAMENTO: // 02 - 
                                        if (string.IsNullOrEmpty(i.ENDERECO_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Endereço do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CEP_PREFIXO) || string.IsNullOrEmpty(i.CEP_COMPLEMENTO))
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o CEP é obrigatório.");

                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Código do Banco do Fornecedor é obrigatório.");

                                        if (i.BANCO_FORNECEDOR != Bancos.CODIGO.BRADESCO)
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Código do Banco do Fornecedor é obrigatório 237 - Bradesco.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                        if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO) &&
                                            uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                            yield return new Exception("Na Modalidade de Pagamento Cheque/Ordem de Pagamento o Dígito Verificador do Número da Agência do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.AGENCIA_FORNECEDOR_DIGITO);

                                        break;
                                    case MODALIDADE_PAGAMENTO.DOC_COMPENSACAO:
                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento DOC o Código do Banco do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento DOC o Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento DOC o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                        if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO) &&
                                            uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                            yield return new Exception("Na Modalidade de Pagamento DOC o Dígito Verificador do Número da Agência do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.AGENCIA_FORNECEDOR_DIGITO);

                                        if (string.IsNullOrEmpty(i.NUMERO_NOTA_FISCAL))
                                            yield return new Exception("Na Modalidade de Pagamento DOC o Número da Nota Fiscal/Fatura/Duplicata é obrigatório.");

                                        break;
                                    case MODALIDADE_PAGAMENTO.TED:
                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento TED o Código do Banco do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento TED o Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento TED o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                        if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO) &&
                                            uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                            yield return new Exception("Na Modalidade de Pagamento TED o Dígito Verificador do Número da Agência do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.AGENCIA_FORNECEDOR_DIGITO);

                                        break;
                                    case MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_BRADESCO:
                                        if (string.IsNullOrEmpty(i.ENDERECO_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Endereço do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CEP_PREFIXO) || string.IsNullOrEmpty(i.CEP_COMPLEMENTO))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o CEP é obrigatório.");

                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Código do Banco do Fornecedor é obrigatório.");

                                        if (i.BANCO_FORNECEDOR != Bancos.CODIGO.BRADESCO)
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Código do Banco do Fornecedor é obrigatório 237 - Bradesco.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Número da Conta Corrente do Fornecedor é obrigatório.");

                                        if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO))
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos Bradesco o Dígito Verificador do Número da Conta Corrente do Fornecedor é obrigatório.");

                                        break;
                                    case MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_TERCEIROS:

                                        if (i.BANCO_FORNECEDOR == null)
                                            yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Código do Banco do Fornecedor é obrigatório.");

                                        if (i.BANCO_FORNECEDOR == Bancos.CODIGO.BRADESCO)
                                        {
                                            if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Número da Agência do Fornecedor é obrigatório.");

                                            if (string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador do Número da Agência do Fornecedor é obrigatório.");

                                            if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO) &&
                                                uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador do Número da Agência do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.AGENCIA_FORNECEDOR_DIGITO);

                                            if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Número da Conta Corrente do Fornecedor é obrigatório.");

                                            if (string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador do Número da Conta Corrente do Fornecedor é obrigatório.");

                                            if (!string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO) &&
                                                uint.Parse(i.CONTA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.CONTA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador da Conta Corrente do Fornecedor está inválido. Esperado: " + Bradesco.Modulo11(i.CONTA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()).ToString() + ", Encontrado: " + i.CONTA_FORNECEDOR_DIGITO);
                                        }
                                        else
                                        {
                                            if (i.AGENCIA_FORNECEDOR != "".PadLeft(5, '0'))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Número da Agência do Fornecedor deve ser zeros no caso do banco não ser Bradesco.");

                                            if (!string.IsNullOrEmpty(i.AGENCIA_FORNECEDOR_DIGITO))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador do Número da Agência do Fornecedor deve estar em branco no caso do banco não ser Bradesco.");

                                            if (i.CONTA_FORNECEDOR != "".PadLeft(13, '0'))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Número da Conta Corrente do Fornecedor deve ser zeros no caso do banco não ser Bradesco.");

                                            if (!string.IsNullOrEmpty(i.CONTA_FORNECEDOR_DIGITO))
                                                yield return new Exception("Na Modalidade de Pagamento Cobrança de Títulos de Terceiros o Dígito Verificador do Número da Conta Corrente do Fornecedor deve estar em branco no caso do banco não ser Bradesco.");
                                        }
                                        break;
                                }
                            }
                        }
                    }

                    //yield return null;
                }

                #endregion
            }
        }
    }
}
