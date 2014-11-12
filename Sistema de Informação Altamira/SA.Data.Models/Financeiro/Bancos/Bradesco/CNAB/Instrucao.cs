using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
    public partial class Bradesco : Banco
    {
        public partial class CNAB
        {
            /// <summary>
            /// Representa os Registros de Instrução do Arquivo padrão CNAB do Bradesco
            /// </summary>
            public partial class Instrucao : Registro
            {
                #region Variaveis

                #endregion

                #region Propriedades

                /// <summary>
                /// Tipo de Registro. Obrigatório – Fixo = “1” (UM).
                /// </summary>
                [Atributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>1)")]
                public CNAB.TIPO_REGISTRO TIPO_REGISTRO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_REGISTRO"))
                            Dicionario["TIPO_REGISTRO"] = ((int)CNAB.TIPO_REGISTRO.TRANSACAO).ToString().Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                            .Cast<CNAB.TIPO_REGISTRO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_REGISTRO"])
                            .First();
                    }
                    protected set
                    {
                        Dicionario["TIPO_REGISTRO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// Tipo de Inscrição do Fornecedor. 1 = CPF, 2 = CNPJ ou 3 = OUTROS. Se for 3 = outros, o campo a seguir deverá ser preenchido com qualquer número diferente de zero e não será consistido pelo Banco. Obrigatório – variável.
                /// </summary>
                [Atributo(Sequencia = 1, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_INSCRICAO"))
                            Dicionario["TIPO_INSCRICAO"] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.TIPO_INSCRICAO))
                            .Cast<CNAB.TIPO_INSCRICAO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_INSCRICAO"])
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_INSCRICAO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// CNPJ/CPF Base do fornecedor. Para as modalidades 01 e 05, o CNPJ/CPF poderá ser validado contra o cadastro de clientes do Banco, ou ser rejeitado e utilizado o do Banco, de acordo com o contratado no convênio. Para a modalidade 30 – será fornecido pelo Banco no arquivo de rastreamento. Para as demais modalidades - obrigatório variável.
                /// </summary>
                [Atributo(Sequencia = 2, Regex = @"(?<CNPJ>\d{9})")]
                public string CNPJ
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ"))
                            Dicionario["CNPJ"] = "".PadLeft(9, '0');

                        return Dicionario["CNPJ"].ToString().PadLeft(9, '0').Substring(0, 9);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(9, '0').IsNumericArray(9))
                            throw new ArgumentException("CNPJ deve ter 9 digitos numéricos;");

                        Dicionario["CNPJ"] = value.Trim().PadLeft(9, '0').Substring(0, 9);
                    }
                }

                /// <summary>
                /// CNPJ/CPF - Filial. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 3, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
                public string CNPJ_FILIAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ_FILIAL"))
                            Dicionario["CNPJ_FILIAL"] = "".PadLeft(4, '0');

                        return Dicionario["CNPJ_FILIAL"].ToString().PadLeft(4, '0').Substring(0, 4);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                            throw new ArgumentException("Filial deve ter 4 digitos numéricos;");

                        Dicionario["CNPJ_FILIAL"] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                    }
                }

                /// <summary>
                /// CNPJ/CPF - Digito de Verificacao. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 4, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
                public string CNPJ_DIGITO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ_DIGITO"))
                            Dicionario["CNPJ_DIGITO"] = "".PadLeft(2, '0');

                        return Dicionario["CNPJ_DIGITO"].ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                            throw new ArgumentException("Controle deve ter 2 digitos numéricos;");

                        Dicionario["CNPJ_DIGITO"] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// Nome do Fornecedor. Razão social do fornecedor. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 5, Regex = @"(?<NOME_FORNECEDOR>.{30})")]
                public string NOME_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NOME_FORNECEDOR"))
                            Dicionario["NOME_FORNECEDOR"] = "".PadRight(30, ' ');

                        return Dicionario["NOME_FORNECEDOR"].ToString().ReplaceExtendedChars().ToUpper().PadRight(30, ' ').Substring(0, 30).Trim();
                    }
                    set
                    {
                        if (value.Trim().Length < 5 || value.Trim().Length > 30)
                            throw new ArgumentException("Nome do Fornecedor deve ter no mínimo 5 e no máximo 30 caracteres;");

                        Dicionario["NOME_FORNECEDOR"] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(30, ' ').Substring(0, 30);
                    }
                }

                /// <summary>
                /// Endereço do Fornecedor. Nome da rua/Av - Número. 
                /// <para>Modalidade 01 - Crédito em Conta Corrente no Bradesco, os campos referentes a essas posições poderão ser obtidos a partir do cadastro de clientes do Banco, ou o sistema efetuar a consistência do conteúdo no arquivo-remessa, cujas condições dependerão de cadastramento prévio no sistema do Banco - campos obrigatórios - variáveis.</para>
                /// <para>Modalidades 02 - Cheque Ordem de Pagamento são campos obrigatórios - variáveis.</para>
                /// <para>Modalidade 30 - Cobrança Bradesco, essas informações constarão do arquivo de rastreamento.</para>
                /// <para>Para as demais modalidades, esses campos não serão consistidos - opcional. O sistema sempre assumirá os dados recebidos no arquivo-remessa, haja vista não emitir aviso de crédito ao fornecedor.</para>
                /// </summary>
                [Atributo(Sequencia = 6, Regex = @"(?<ENDERECO_FORNECEDOR>.{40})")]
                public string ENDERECO_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("ENDERECO_FORNECEDOR"))
                            Dicionario["ENDERECO_FORNECEDOR"] = "".PadRight(40, ' ');

                        if (Dicionario["ENDERECO_FORNECEDOR"].ToString().Trim().Length == 0)
                            return null;
                        else
                            return Dicionario["ENDERECO_FORNECEDOR"].ToString().Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                    }
                    set
                    {
                        if (value.Trim().Length > 0 && (value.Trim().Length < 5 || value.Trim().Length > 40))
                            throw new ArgumentException("Endereço deve ter no mínimo 5 e no máximo 40 caracteres;");

                        Dicionario["ENDERECO_FORNECEDOR"] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                    }
                }

                /// <summary>
                /// CEP do fornecedor. 
                /// </summary>
                [Atributo(Sequencia = 7, Regex = @"(?<CEP_PREFIXO>\d{5})")]
                public string CEP_PREFIXO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CEP_PREFIXO"))
                            Dicionario["CEP_PREFIXO"] = "".PadLeft(5, '0');

                        return Dicionario["CEP_PREFIXO"].ToString().PadLeft(5, '0').Substring(0, 5);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                            throw new ArgumentException("CEP Prefixo deve ter 5 digitos numéricos;");

                        Dicionario["CEP_PREFIXO"] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                    }
                }

                /// <summary>
                /// Complemento do CEP.
                /// </summary>
                [Atributo(Sequencia = 8, Regex = @"(?<CEP_COMPLEMENTO>\d{3})")]
                public string CEP_COMPLEMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CEP_COMPLEMENTO"))
                            Dicionario["CEP_COMPLEMENTO"] = "".PadLeft(3, '0');

                        return Dicionario["CEP_COMPLEMENTO"].ToString().PadLeft(3, '0').Substring(0, 3);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(3, '0').IsNumericArray(3))
                            throw new ArgumentException("CEP Complemento deve ter 5 digitos numéricos;");

                        Dicionario["CEP_COMPLEMENTO"] = value.Trim().PadLeft(3, '0').Substring(0, 3);
                    }
                }

                /// <summary>
                /// código do Banco do fornecedor.
                /// <para>Para a Modalidade de Pagamento 30 - Títulos em Cobrança Bradesco - obrigatório - fixo “237” e consta do arquivo de rastreamento.</para>
                /// <para>Para a Modalidade de Pagamento 01 - Crédito em Conta Corrente no Bradesco - obrigatório - fixo “237”.</para>
                /// <para>Para a Modalidade de Pagamento 02 - Cheque OP - obrigatório - fixo “237”.</para>
                /// <para>Para as Modalidades de Pagamento 03 – DOC COMPE e 08 – TED - obrigatório - variável.</para>
                /// <para>Para a Modalidade de Pagamento 31 - Títulos de Terceiros - obrigatório - extraído do código de barras.</para>
                /// <para>Para a Modalidade de Pagamento 30 - “Títulos em Cobrança Bradesco”: Obrigatório - variável. Deverá ser informado o conteúdo da base, ou seja, a mesma informação constante do arquivo de rastreamento.</para>
                /// <para>Para a Modalidade de Pagamento 01 - “Crédito em Conta Corrente no Bradesco”: Obrigatório - variável, e serão validados os dígitos de controle da Agência e da conta corrente.</para>
                /// <para>Para a Modalidade de Pagamento 02 - “Cheque OP”: Obrigatório - variável, somente o código da agência e dígito</para>
                /// <para>Para as modalidades 03 - DOC COMPE e 08 - TED: Obrigatório – variável, o sistema fará inclusive a consistência do código da agência.</para>
                /// <para>Para a Modalidade 31 - “Títulos de Terceiros”: Caso o código do Banco seja 237, todos esses campos serão obrigatórios, e, se o código do Banco for diferente de 237, não será necessário informar o código da agência/dígito e Conta-Corrente/dígito e sim preencher os campos com zeros - fixos, pois o pagamento será efetuando com base no conteúdo constante do campo Informações Complementares (posições 374 a 413), do Registro de Instrução, ou seja, campo livre do código de barras ou linha digitável.</para>
                /// </summary>
                [Atributo(Sequencia = 9, Regex = @"(?<BANCO_FORNECEDOR>000|237|\d{3})")]
                public Bancos.CODIGO? BANCO_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("BANCO_FORNECEDOR"))
                            Dicionario["BANCO_FORNECEDOR"] = "".PadLeft(3, '0');

                        if (Dicionario["BANCO_FORNECEDOR"] == "".PadLeft(3, '0'))
                            return null;

                        return Enum.GetValues(typeof(Bancos.CODIGO))
                            .Cast<Bancos.CODIGO>()
                            .Where(x => (int)x == int.Parse(Dicionario["BANCO_FORNECEDOR"]))
                            .First();
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["BANCO_FORNECEDOR"] = ((int)value.Value).ToString().PadLeft(3, '0').Substring(0, 3);
                        else
                            Dicionario["BANCO_FORNECEDOR"] = "".PadLeft(3, '0');
                    }
                }

                /// <summary>
                /// Código da agência do fornecedor.
                /// </summary>
                [Atributo(Sequencia = 10, Regex = @"(?<AGENCIA_FORNECEDOR>\d{5})")]
                public string AGENCIA_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("AGENCIA_FORNECEDOR"))
                            Dicionario["AGENCIA_FORNECEDOR"] = "".PadLeft(5, '0');

                        return Dicionario["AGENCIA_FORNECEDOR"].ToString().PadLeft(5, '0').Substring(0, 5);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                            throw new ArgumentException("Código da Agência deve ter 5 digitos numéricos;");

                        Dicionario["AGENCIA_FORNECEDOR"] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                    }
                }

                /// <summary>
                /// Dígito da agência do fornecedor.
                /// </summary>
                [Atributo(Sequencia = 11, Regex = @"(?<AGENCIA_FORNECEDOR_DIGITO>.)")]
                public string AGENCIA_FORNECEDOR_DIGITO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("AGENCIA_FORNECEDOR_DIGITO"))
                            Dicionario["AGENCIA_FORNECEDOR_DIGITO"] = "".PadLeft(1, ' ');

                        return Dicionario["AGENCIA_FORNECEDOR_DIGITO"].ToString().Substring(0, 1);
                    }
                    set
                    {
                        if (value.Trim().Length > 1)
                            throw new ArgumentException("Digito do Código da Agência deve ter 1 digitos numéricos;");

                        Dicionario["AGENCIA_FORNECEDOR_DIGITO"] = value.Trim().PadLeft(1, ' ').Substring(0, 1);
                    }
                }

                /// <summary>
                /// Conta-Corrente do fornecedor.
                /// </summary>
                [Atributo(Sequencia = 12, Regex = @"(?<CONTA_FORNECEDOR>\d{13})")]
                public string CONTA_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CONTA_FORNECEDOR"))
                            Dicionario["CONTA_FORNECEDOR"] = "".PadLeft(13, '0');

                        return Dicionario["CONTA_FORNECEDOR"].ToString().ToString().PadLeft(13, '0').Substring(0, 13);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(13, '0').Substring(0, 13).IsNumericArray(13))
                            throw new ArgumentException("Conta Corrente deve ter 13 digitos numéricos;");

                        Dicionario["CONTA_FORNECEDOR"] = value.Trim().PadLeft(13, '0').Substring(0, 13);
                    }
                }

                /// <summary>
                /// Dígito da conta do fornecedor.
                /// </summary>
                [Atributo(Sequencia = 13, Regex = @"(?<CONTA_FORNECEDOR_DIGITO>.{2})")]
                public string CONTA_FORNECEDOR_DIGITO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CONTA_FORNECEDOR_DIGITO"))
                            Dicionario["CONTA_FORNECEDOR_DIGITO"] = "".PadRight(2, ' ');

                        return Dicionario["CONTA_FORNECEDOR_DIGITO"].ToString().PadRight(2, ' ').Substring(0, 2);
                    }
                    set
                    {
                        if (value.Length > 2)
                            throw new ArgumentException("Digito da Conta Corrente do Fornecedor deve ter até 2 digitos.");

                        Dicionario["CONTA_FORNECEDOR_DIGITO"] = value.PadRight(2, ' ').Substring(0, 2);
                    }
                }

                /// <summary>
                /// Número do Pagamento. É utilizado para identificar o pagamento a ser efetuado, alterado ou excluído. Individualiza o pagamento e não pode se repetir. Gerado pelo cliente pagador quando do agendamento de pagamento por parte desse, exceto para a modalidade 30 - Títulos em Cobrança Bradesco, que é fornecido pelo Banco quando da geração do arquivo de rastreamento, o qual deverá ser mantido e informado quando da autorização de 29 agendamento, alteração ou exclusão.Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 14, Regex = @"(?<NUMERO_PAGAMENTO>.{16})")]
                public string NUMERO_PAGAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_PAGAMENTO"))
                            Dicionario["NUMERO_PAGAMENTO"] = "".PadRight(16, ' ');

                        return Dicionario["NUMERO_PAGAMENTO"].ToString().PadRight(16, ' ').Substring(0, 16);
                    }
                    set
                    {
                        if (value.Trim().Trim().Length > 16)
                            throw new Exception("O Número do Pagamento deve ser 16 digitos numéricos;");

                        Dicionario["NUMERO_PAGAMENTO"] = value.PadRight(16, ' ').Substring(0, 16);
                    }
                }

                /// <summary>
                /// <para>Carteira. Exclusivo para boleto da Cobrança Bradesco para as modalidades 30 e 31.</para>
                /// <para>MODALIDADE - 31 – Obrigatória somente para Banco igual a 237 (Bradesco), e deve ser extraído do Código de Barras ou Linha Digitável conforme roteiro da página 36. Para os demais Bancos, preencher com zeros.</para>
                /// <para>MODALIDADE - 30 – Consta do arquivo de rastreamento.</para>
                /// <para>DEMAIS MODALIDADES - Fixo zeros.</para>
                /// </summary>
                [Atributo(Sequencia = 15, Regex = @"(?<CARTEIRA>\d{3})")]
                public string CARTEIRA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CARTEIRA"))
                            Dicionario["CARTEIRA"] = "".PadLeft(3, '0');

                        return Dicionario["CARTEIRA"].ToString().PadLeft(3, '0').Substring(0, 3);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(3, '0').IsNumericArray(3))
                            throw new ArgumentException("Carteira deve ser 3 digitos numéricos;");

                        Dicionario["CARTEIRA"] = value.Trim().PadLeft(3, '0').Substring(0, 3);
                    }
                }

                /// <summary>
                /// Nosso Número.
                /// <para>MODALIDADE – 31 - Obrigatório somente quando o banco for igual a 237 (Bradesco), e deve ser extraído do Código de Barras ou Linha Digitável. Para os demais Bancos, preencher com zeros</para>
                /// <para>DEMAIS MODALIDADES - Fixo zeros</para>
                /// </summary>
                [Atributo(Sequencia = 16, Regex = @"(?<NOSSO_NUMERO>\d{12})")]
                public string NOSSO_NUMERO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NOSSO_NUMERO"))
                            Dicionario["NOSSO_NUMERO"] = "".PadRight(12, '0');

                        return Dicionario["NOSSO_NUMERO"].ToString().PadLeft(12, '0').Substring(0, 12);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(12, '0').IsNumericArray(12))
                            throw new ArgumentException("Nosso Número deve ser 12 digitos numéricos;");

                        Dicionario["NOSSO_NUMERO"] = value.Trim().PadLeft(12, '0').Substring(0, 12);
                    }
                }

                /// <summary>
                /// Seu Número. Exclusivo para modalidade 30 – título rastreado.
                /// </summary>
                [Atributo(Sequencia = 17, Regex = @"(?<SEU_NUMERO>.{15})")]
                public string SEU_NUMERO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("SEU_NUMERO"))
                            Dicionario["SEU_NUMERO"] = "".PadRight(15, ' ');

                        return Dicionario["SEU_NUMERO"].PadRight(15, ' ').Substring(0, 15);
                    }
                    set
                    {
                        if (value.Trim().Length > 15)
                            throw new ArgumentException("Seu Número deve ter no máximo 15 caracteres;");

                        Dicionario["SEU_NUMERO"] = value.PadRight(15, ' ').Substring(0, 15);
                    }
                }

                /// <summary>
                /// Data de Vencimento no formato AAAAMMDD.
                /// <para>Modalidade 31 – prevalece o fator de Vencimento da posição 191 a 194, e na ausência, a data de vencimento passa a ser obrigatório.</para>
                /// <para>Demais modalidades - Obrigatório – variável, não deve ser inferior a data do pagamento.</para>
                /// </summary>
                [Atributo(Sequencia = 18, Regex = @"(?<DATA_VENCIMENTO>\d{8})")]
                public DateTime DATA_VENCIMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DATA_VENCIMENTO"))
                            Dicionario["DATA_VENCIMENTO"] = "".PadLeft(8, '0');

                        DateTime dt;

                        DateTime.TryParseExact(Dicionario["DATA_VENCIMENTO"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                        return dt;
                    }
                    set
                    {
                        Dicionario["DATA_VENCIMENTO"] = value.ToString("yyyyMMdd");
                    }
                }

                /// <summary>
                /// Data de Emissão do documento no formato AAAAMMDD. Opcional para todas as modalidades. Fixo zeros
                /// </summary>
                [Atributo(Sequencia = 19, Regex = @"(?<DATA_EMISSAO>\d{8})")]
                public DateTime? DATA_EMISSAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DATA_EMISSAO"))
                            Dicionario["DATA_EMISSAO"] = "".PadLeft(8, '0');

                        DateTime dt;

                        if (!DateTime.TryParseExact(Dicionario["DATA_EMISSAO"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt))
                            return null;

                        return dt;
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["DATA_EMISSAO"] = value.Value.ToString("yyyyMMdd");
                        else
                            Dicionario["DATA_EMISSAO"] = "".PadLeft(8, '0');
                    }
                }

                /// <summary>
                /// Data Limite para Desconto no formato AAAAMMDD. Obrigatório, quando informado valor do Desconto.
                /// </summary>
                [Atributo(Sequencia = 20, Regex = @"(?<DATA_LIMITE_DESCONTO>\d{8})")]
                public DateTime? DATA_LIMITE_DESCONTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DATA_LIMITE_DESCONTO"))
                            Dicionario["DATA_LIMITE_DESCONTO"] = "".PadLeft(8, '0');

                        DateTime dt;

                        if (!DateTime.TryParseExact(Dicionario["DATA_LIMITE_DESCONTO"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt))
                            return null;

                        return dt;
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["DATA_LIMITE_DESCONTO"] = value.Value.ToString("yyyyMMdd");
                        else
                            Dicionario["DATA_LIMITE_DESCONTO"] = "".PadLeft(8, '0');
                    }
                }

                /// <summary>
                /// Campo fixo zero. Desconsiderar
                /// </summary>
                [Atributo(Sequencia = 21, Regex = @"(?<ZERO_FIXO>0)")]
                public string ZERO_FIXO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("ZERO_FIXO"))
                            Dicionario["ZERO_FIXO"] = "0";

                        return Dicionario["ZERO_FIXO"];
                    }
                    protected set
                    {
                        Dicionario["ZERO_FIXO"] = "0";
                    }
                }

                /// <summary>
                /// Fator de Vencimento. Será informado o fator de vencimento enviado no arquivo remessa. Refere-se a posição 6 a 9 do código de barras ou os 4 (quatro) primeiros caracteres do 5º campo da Linha Digitável, quando diferente de zeros.
                /// </summary>
                [Atributo(Sequencia = 22, Regex = @"(?<FATOR_VENCIMENTO>\d{4})")]
                public string FATOR_VENCIMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("FATOR_VENCIMENTO"))
                            Dicionario["FATOR_VENCIMENTO"] = "".PadLeft(4, '0');

                        return Dicionario["FATOR_VENCIMENTO"].ToString().PadLeft(4, '0').Substring(0, 4);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                            throw new ArgumentException("Fator Vencimento deve ser 4 digitos numéricos;");

                        Dicionario["FATOR_VENCIMENTO"] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                    }
                }

                /// <summary>
                /// Valor do Documento. 
                /// <para>MODALIDADE - 31. Deve ser informado o valor constante do código de barras ou da Linha Digitável, inclusive, se o valor for igual a zero, independente do valor a ser pago. Obrigatório – variável</para>
                /// <para>PARA MODALIDADE - 30. Consta do arquivo de rastreamento</para>
                /// <para>DEMAIS MODALIDADES - Opcional, se não houver valor do desconto ou valor do acréscimo.</para>
                /// </summary>
                [Atributo(Sequencia = 23, Regex = @"(?<VALOR_DOCUMENTO>\d{10})")]
                public decimal VALOR_DOCUMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_DOCUMENTO"))
                            Dicionario["VALOR_DOCUMENTO"] = "".PadLeft(10, '0');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_DOCUMENTO"]))
                            return 0;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_DOCUMENTO"], out d))
                            return 0;

                        return d / 100;
                    }
                    set
                    {
                        Dicionario["VALOR_DOCUMENTO"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(10, '0');
                    }
                }

                /// <summary>
                /// Valor do pagamento. 
                /// <para>Deve ser igual ao valor do documento, menos o Valor do Desconto ou mais Acréscimo, se houver. Se o Valor do documento (195 à 204) for zero, deverá ser informado o valor do pagamento. Obrigatório.</para>
                /// </summary>
                [Atributo(Sequencia = 24, Regex = @"(?<VALOR_PAGAMENTO>\d{15})")]
                public decimal VALOR_PAGAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_PAGAMENTO"))
                            Dicionario["VALOR_PAGAMENTO"] = "".PadLeft(15, '0');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_PAGAMENTO"]))
                            return 0;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_PAGAMENTO"], out d))
                            return 0;

                        return d / 100;
                    }
                    set
                    {
                        Dicionario["VALOR_PAGAMENTO"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                    }
                }

                /// <summary>
                /// Valor do Desconto. Deve ser igual ao Valor do Documento, menos o Valor do Pagamento, exceto se o Valor do Documento for igual a zeros. Obrigatório.
                /// </summary>
                [Atributo(Sequencia = 25, Regex = @"(?<VALOR_DESCONTO>\d{15})")]
                public decimal VALOR_DESCONTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_DESCONTO"))
                            Dicionario["VALOR_DESCONTO"] = "".PadLeft(15, '0');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_DESCONTO"]))
                            return 0;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_DESCONTO"], out d))
                            return 0;

                        return d / 100;
                    }
                    set
                    {
                        Dicionario["VALOR_DESCONTO"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                    }
                }

                /// <summary>
                /// Valor do Acréscimo. Deve ser igual ao Valor do Pagamento, menos o Valor do Documento, exceto se o Valor do Documento for igual a zero. Obrigatório.
                /// </summary>
                [Atributo(Sequencia = 26, Regex = @"(?<VALOR_ACRESCIMO>\d{15})")]
                public decimal VALOR_ACRESCIMO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_ACRESCIMO"))
                            Dicionario["VALOR_ACRESCIMO"] = "".PadLeft(15, '0');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_ACRESCIMO"]))
                            return 0;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_ACRESCIMO"], out d))
                            return 0;

                        return d / 100;
                    }
                    set
                    {
                        Dicionario["VALOR_ACRESCIMO"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                    }
                }

                /// <summary>
                /// <para>Tipo de Documento. Obrigatório – variável.</para>
                /// <para>01 – Nota Fiscal/Fatura</para>
                /// <para>02 - Fatura</para>
                /// <para>03 – Nota Fiscal</para>
                /// <para>04 - Duplicata</para>
                /// <para>05 – Outros</para>
                /// <remarks>O Sistema do Banco não tem condições de validá-lo. Assumirá, sempre, o informado pelo Pagador.</remarks>
                /// </summary>
                [Atributo(Sequencia = 27, Regex = @"(?<TIPO_DOCUMENTO>01|02|03|04|05)")]
                public CNAB.TIPO_DOCUMENTO TIPO_DOCUMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_DOCUMENTO"))
                            Dicionario["TIPO_DOCUMENTO"] = ((int)CNAB.TIPO_DOCUMENTO.OUTROS).ToString().PadLeft(2, '0').Substring(0, 2);

                        return Enum.GetValues(typeof(CNAB.TIPO_DOCUMENTO))
                            .Cast<CNAB.TIPO_DOCUMENTO>()
                            .Where(x => (int)x == int.Parse(Dicionario["TIPO_DOCUMENTO"]))
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_DOCUMENTO"] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// <para>Número Nota Fiscal/Fatura/Duplicata. Se o tipo de Documento no campo anterior for igual a 1 ou 3, este campo passa a ser numérico – obrigatório.</para>
                /// <remarks>Informado na modalidade: 01 - Crédito em Conta Corrente e constará no campo número do documento do aviso de crédito ao Fornecedor, obrigatório quando o Tipo do documento for igual a 1 ou 3.</remarks>
                /// </summary>
                [Atributo(Sequencia = 28, Regex = @"(?<NUMERO_NOTA_FISCAL>.{10})")]
                public string NUMERO_NOTA_FISCAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_NOTA_FISCAL"))
                            Dicionario["NUMERO_NOTA_FISCAL"] = "".PadRight(10, ' ');

                        return Dicionario["NUMERO_NOTA_FISCAL"].PadRight(10, ' ').Substring(0, 10).Trim();
                    }
                    set
                    {
                        if (value.Length > 10)
                            throw new ArgumentException("Número da Nota Fiscal deve ter até 10 digitos.");

                        Dicionario["NUMERO_NOTA_FISCAL"] = value.PadRight(10, ' ').Substring(0, 10);
                    }
                }

                /// <summary>
                /// Série Documento. Opcional.
                /// </summary>
                [Atributo(Sequencia = 29, Regex = @"(?<SERIE_DOCUMENTO>.{2})")]
                public string SERIE_DOCUMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("SERIE_DOCUMENTO"))
                            Dicionario["SERIE_DOCUMENTO"] = "".PadRight(2, ' ');

                        return Dicionario["SERIE_DOCUMENTO"].ToString().PadRight(2, ' ').Substring(0, 2).Trim();
                    }
                    set
                    {
                        if (value.Length > 2)
                            throw new ArgumentException("Série do Documento deve ter até 2 caracteres;");

                        Dicionario["SERIE_DOCUMENTO"] = value.PadRight(2, ' ').Substring(0, 2);
                    }
                }

                /// <summary>
                /// Modalidade de Pagamento. Identifica o modo pelo qual o repasse será feito ao Favorecido.
                /// <para>01 = Crédito em conta, 02 = Cheque OP (Ordem Pagamento), 03 = DOC COMPE, 05 = Crédito em Conta Real Time, 08 = TED, 30 = Rastreamento de Títulos (Exclusivo para o arquivo de rastreamento, caso contrário deverá ser agendado como título terceiro) e 31 = Títulos Terceiros.</para>
                /// </summary>
                [Atributo(Sequencia = 30, Regex = @"(?<MODALIDADE_PAGAMENTO>01|02|03|05|08|30|31)")]
                public CNAB.MODALIDADE_PAGAMENTO MODALIDADE_PAGAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("MODALIDADE_PAGAMENTO"))
                            Dicionario["MODALIDADE_PAGAMENTO"] = ((int)CNAB.MODALIDADE_PAGAMENTO.CREDITO_CONTA_CORRENTE).ToString().PadLeft(2, '0').Substring(0, 2);

                        return Enum.GetValues(typeof(CNAB.MODALIDADE_PAGAMENTO))
                            .Cast<CNAB.MODALIDADE_PAGAMENTO>()
                            .Where(x => ((int)x) == int.Parse(Dicionario["MODALIDADE_PAGAMENTO"]))
                            .First();
                    }
                    set
                    {
                        Dicionario["MODALIDADE_PAGAMENTO"] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// <para>Data para efetivação do pagamento no formato AAAAMMDD (opcional). Quando não informada, o sistema assume a data constante do campo Vencimento.</para>
                /// <para>Quando no campo informação de retorno contiver o código “BW” – pagamento efetuado, esta data será a de pagamento (quitação).</para>
                /// <remarks>Este campo deverá ser igual a data de vencimento (posições 166 a 173), não podendo ser inferior a data do processamento, para as modalidades 1, 2 e 3. Campo obrigatório para Lista de Débito.</remarks>
                /// </summary>
                [Atributo(Sequencia = 31, Regex = @"(?<DATA_PAGAMENTO>\d{8})")]
                public DateTime DATA_PAGAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DATA_PAGAMENTO"))
                            Dicionario["DATA_PAGAMENTO"] = "".PadLeft(8, '0');

                        DateTime dt;

                        DateTime.TryParseExact(Dicionario["DATA_PAGAMENTO"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                        return dt;
                    }
                    set
                    {
                        Dicionario["DATA_PAGAMENTO"] = value.ToString("yyyyMMdd");
                    }
                }

                /// <summary>
                /// Moeda (CÓDIGO CNAB). Obrigatório – Fixo branco.
                /// </summary>
                [Atributo(Sequencia = 32, Regex = @"(?<MOEDA>.{3})")]
                public string MOEDA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("MOEDA"))
                            Dicionario["MOEDA"] = "".PadRight(3, ' ');

                        return Dicionario["MOEDA"].ToString().PadRight(3, ' ').Substring(0, 3).Trim();
                    }
                    set
                    {
                        if (value.Length > 3)
                            throw new ArgumentException("Moeda deve ter até 3 caracteres.");

                        Dicionario["MOEDA"] = value.PadRight(3, ' ').Substring(0, 3);
                    }
                }

                /// <summary>
                /// <para>Situação do Agendamento. Sempre preencher com o código “01” para arquivo de Remessa.</para>
                /// <para>No arquivo de rastreamento: </para>
                /// <para>01 - NÃO PAGO</para>
                /// <para>05 - BAIXA COBR SEM PAGAMENTO</para>
                /// <para>06 - BAIXA COBR COM PAGAMENTO</para>
                /// <para>07 - COM INST DE PROTESTO</para>
                /// <para>08 - TRANSF PARA CARTÓRIO</para>
                /// <para>09 - BAIXADO PELO DESCONTO</para>
                /// <para>No arquivo de Estorno de Cheque OP:</para>
                /// <para>11 - CHEQUE OP ESTORNADO</para>
                /// <para>No arquivo de Doc Devolvido:</para>
                /// <para>02 – PAGO</para>
                /// <para>No arquivo de confirmação de agendamento:</para>
                /// <para>01 - NÃO PAGO</para>
                /// <para>No arquivo de confirmação de pagamento:</para>
                /// <para>02 – PAGO</para>
                /// <para>22 – Cheque O.P. Emitido</para>
                /// <para>No arquivo de Pagamento Não Efetuado:</para>
                /// <para>01 – NÃO PAGO</para>
                /// </summary>
                [Atributo(Sequencia = 33, Regex = @"(?<SITUACAO_AGENDAMENTO>01|02|05|06|07|08|09|11|22)")]
                public CNAB.SITUACAO_AGENDAMENTO SITUACAO_AGENDAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("SITUACAO_AGENDAMENTO"))
                            Dicionario["SITUACAO_AGENDAMENTO"] = ((int)CNAB.SITUACAO_AGENDAMENTO.NAO_PAGO).ToString().PadLeft(2).Substring(0, 2);

                        return Enum.GetValues(typeof(CNAB.SITUACAO_AGENDAMENTO))
                            .Cast<CNAB.SITUACAO_AGENDAMENTO>()
                            .Where(x => (int)x == int.Parse(Dicionario["SITUACAO_AGENDAMENTO"]))
                            .First();
                    }
                    set
                    {
                        //if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                        //    throw new ArgumentException("Situação do Agendamento deve ser 2 digitos numéricos;");

                        Dicionario["SITUACAO_AGENDAMENTO"] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// <para>Informação de Retorno 1. Campo válido somente para o arquivo retorno.</para>
                /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                /// </summary>
                [Atributo(Sequencia = 34, Regex = @"(?<INFO_RETORNO_1>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                public CNAB.Ocorrencia? INFO_RETORNO_1
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFO_RETORNO_1"))
                            Dicionario["INFO_RETORNO_1"] = "".PadLeft(2, ' ');

                        if (Dicionario["INFO_RETORNO_1"].Trim().Length == 0)
                            return null;

                        return CNAB.Ocorrencias[Dicionario["INFO_RETORNO_1"]];
                    }
                    set
                    {
                        if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                            Dicionario["INFO_RETORNO_1"] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                        else if (value.HasValue)
                            throw new ArgumentException("O valor para INFO_RETORNO_1 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                        else
                            Dicionario["INFO_RETORNO_1"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Informação de Retorno 2. Campo válido somente para o arquivo retorno.</para>
                /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                /// </summary>
                [Atributo(Sequencia = 35, Regex = @"(?<INFO_RETORNO_2>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                public CNAB.Ocorrencia? INFO_RETORNO_2
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFO_RETORNO_2"))
                            Dicionario["INFO_RETORNO_2"] = "".PadLeft(2, ' ');

                        if (Dicionario["INFO_RETORNO_2"].Trim().Length == 0)
                            return null;

                        return CNAB.Ocorrencias[Dicionario["INFO_RETORNO_2"]];
                    }
                    set
                    {
                        if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                            Dicionario["INFO_RETORNO_2"] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                        else if (value.HasValue)
                            throw new ArgumentException("O valor para INFO_RETORNO_2 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                        else
                            Dicionario["INFO_RETORNO_2"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Informação de Retorno 3. Campo válido somente para o arquivo retorno.</para>
                /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                /// </summary>
                [Atributo(Sequencia = 36, Regex = @"(?<INFO_RETORNO_3>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                public CNAB.Ocorrencia? INFO_RETORNO_3
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFO_RETORNO_3"))
                            Dicionario["INFO_RETORNO_3"] = "".PadLeft(2, ' ');

                        if (Dicionario["INFO_RETORNO_3"].Trim().Length == 0)
                            return null;

                        return CNAB.Ocorrencias[Dicionario["INFO_RETORNO_3"]];
                    }
                    set
                    {
                        if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                            Dicionario["INFO_RETORNO_3"] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                        else if (value.HasValue)
                            throw new ArgumentException("O valor para INFO_RETORNO_3 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                        else
                            Dicionario["INFO_RETORNO_3"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Informação de Retorno 4. Campo válido somente para o arquivo retorno.</para>
                /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                /// </summary>
                [Atributo(Sequencia = 37, Regex = @"(?<INFO_RETORNO_4>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                public CNAB.Ocorrencia? INFO_RETORNO_4
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFO_RETORNO_4"))
                            Dicionario["INFO_RETORNO_4"] = "".PadLeft(2, ' ');

                        if (Dicionario["INFO_RETORNO_4"].Trim().Length == 0)
                            return null;

                        return CNAB.Ocorrencias[Dicionario["INFO_RETORNO_4"]];
                    }
                    set
                    {
                        if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                            Dicionario["INFO_RETORNO_4"] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                        else if (value.HasValue)
                            throw new ArgumentException("O valor para INFO_RETORNO_4 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                        else
                            Dicionario["INFO_RETORNO_4"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Informação de Retorno 5. Campo válido somente para o arquivo retorno.</para>
                /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                /// </summary>
                [Atributo(Sequencia = 38, Regex = @"(?<INFO_RETORNO_5>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                public CNAB.Ocorrencia? INFO_RETORNO_5
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFO_RETORNO_5"))
                            Dicionario["INFO_RETORNO_5"] = "".PadLeft(2, ' ');

                        if (Dicionario["INFO_RETORNO_5"].Trim().Length == 0)
                            return null;

                        return CNAB.Ocorrencias[Dicionario["INFO_RETORNO_5"]];
                    }
                    set
                    {
                        if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                            Dicionario["INFO_RETORNO_5"] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                        else if (value.HasValue)
                            throw new ArgumentException("O valor para INFO_RETORNO_5 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                        else
                            Dicionario["INFO_RETORNO_5"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Tipo de Movimento. Obrigatório – variável.</para>
                /// <para>Arquivo de Remessa:</para>
                /// <para>0 - Inclusão. Deverá ser informado para qualquer pagamento a ser efetuado, exceto quando a modalidade na posição 264 a 265 do Registro de Instrução, for 30 - títulos em Cobrança Bradesco, esse campo deverá constar com o código 5 = alteração.</para>
                /// <para>5 - Alteração. Altera os dados de um pagamento agendado ( data e valor ).</para>
                /// <para>9 - Exclusão. Retira o registro da base de dados do Banco.</para>
                /// <para>Arquivo de Retorno:</para>
                /// <para>0 – INCLUSÃO</para>
                /// <para>1 - INCLUSÃO TÍTULO CART.</para>
                /// <para>2 - ALTERAÇÃO TÍTULO</para>
                /// <para>3 - BAIXA TÍTULO CART.</para>
                /// <para>5 – ALTERAÇÃO</para>
                /// <para>9 - EXCLUSÃO</para>
                /// <remarks>
                /// <para>0, 5 OU 9 = Referem-se a confirmação do agendamento efetuado.</para>
                /// <para>1, 2 OU 3 = Referem-se aos títulos em Cobrança Bradesco rastreados</para>
                /// <para>TAMBÉM 2 = Confirmação de pagamentos efetuados de títulos rastreados</para>
                /// <para>5= Confirmação de pagamentos efetuados para as demais modalidades</para>
                /// </remarks>
                /// </summary>
                [Atributo(Sequencia = 39, Regex = @"(?<TIPO_MOVIMENTO>0|1|2|3|5|9)")]
                public CNAB.TIPO_MOVIMENTO TIPO_MOVIMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_MOVIMENTO"))
                            Dicionario["TIPO_MOVIMENTO"] = ((int)CNAB.TIPO_MOVIMENTO.NAO_ESPECIFICADO).ToString().Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.TIPO_MOVIMENTO))
                            .Cast<CNAB.TIPO_MOVIMENTO>()
                            .Where(x => (int)x == int.Parse(Dicionario["TIPO_MOVIMENTO"]))
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_MOVIMENTO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// <para>Código do Movimento. Válido somente para arquivo de Remessa. 00 – Autoriza Agendamento, 25 – Desautoriza Agendamento ou 50 – Efetuar Alegação. Obrigatório – variável.</para>
                /// <remarks>Quando na posição 289 a 289, campo Tipo de Movimento = “9” - exclusão, este campo ( 290 a 291) será desconsiderado, podendo ser igual a brancos.</remarks>
                /// </summary>
                [Atributo(Sequencia = 40, Regex = @"(?<CODIGO_MOVIMENTO>\s\s|00|25|50)")]
                public CNAB.CODIGO_MOVIMENTO? CODIGO_MOVIMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CODIGO_MOVIMENTO"))
                            Dicionario["CODIGO_MOVIMENTO"] = "".PadLeft(2, ' ');

                        if (Dicionario["CODIGO_MOVIMENTO"] == "".PadLeft(2, ' '))
                            return null;

                        return Enum.GetValues(typeof(CNAB.CODIGO_MOVIMENTO))
                            .Cast<CNAB.CODIGO_MOVIMENTO>()
                            .Where(x => (int)x == int.Parse(Dicionario["CODIGO_MOVIMENTO"]))
                            .First();
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["CODIGO_MOVIMENTO"] = ((int)value.Value).ToString().PadLeft(2, '0').Substring(0, 2);
                        else
                            Dicionario["CODIGO_MOVIMENTO"] = "".PadLeft(2, ' ');
                    }
                }

                /// <summary>
                /// <para>Endereço do Sacador/avalista. Somente para títulos Bradesco Rastreados, demais modalidades será desconsiderado – fixo brancos.</para>
                /// </summary>
                [Atributo(Sequencia = 41, Regex = @"(?<ENDERECO_SACADO>.{40})", DDA = true)]
                public string ENDERECO_SACADO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("ENDERECO_SACADO"))
                            Dicionario["ENDERECO_SACADO"] = "".PadRight(40, ' ');

                        return Dicionario["ENDERECO_SACADO"];
                    }
                    set
                    {
                        if (value.Length > 40)
                            throw new ArgumentException("Endereço do Sacado deve ter até 40 caracteres.");

                        Dicionario["ENDERECO_SACADO"] = value.PadLeft(40, ' ').Substring(0, 40);
                    }
                }

                /// <summary>
                /// Horário para consulta de saldo para as modalidades real time. 02 – Cheque OP, 05 – Credito em conta real time ou 08 – TED. Opcional, quando não informado, o Sistema consultará em todos os processamentos.
                /// </summary>
                [Atributo(Sequencia = 42, Regex = @"(?<HORARIO_CONSULTA_SALDO>.{4})", Escritural = true)]
                public DateTime? HORARIO_CONSULTA_SALDO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("HORARIO_CONSULTA_SALDO"))
                            Dicionario["HORARIO_CONSULTA_SALDO"] = "".PadRight(4, ' ');

                        if (Dicionario["HORARIO_CONSULTA_SALDO"] == "".PadRight(4, ' '))
                            return null;

                        DateTime dt;

                        if (!DateTime.TryParseExact(Dicionario["HORARIO_CONSULTA_SALDO"], "HHmm", null, System.Globalization.DateTimeStyles.None, out dt))
                            return null;

                        return dt;
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["HORARIO_CONSULTA_SALDO"] = value.Value.ToString("HHmm");
                        else
                            Dicionario["HORARIO_CONSULTA_SALDO"] = "".PadLeft(4, ' ');
                    }
                }

                /// <summary>
                /// <para>Saldo disponível no momento da consulta. Válido somente para o arquivo retorno.</para>
                /// </summary>
                /// <remarks>Saldo disponível esta definido na documentação como alfanumérico !?!?. Não ha explicação sobre o formato dos dados deste campo no arquivo de Retorno.</remarks>
                [Atributo(Sequencia = 43, Regex = @"(?<SALDO_DISPONIVEL>.{15})", Escritural = true)]
                public decimal? SALDO_DISPONIVEL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("SALDO_DISPONIVEL"))
                            Dicionario["SALDO_DISPONIVEL"] = "".PadLeft(15, ' ');

                        if (Dicionario["SALDO_DISPONIVEL"] == "".PadLeft(15, ' '))
                            return null;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["SALDO_DISPONIVEL"], out d))
                            return null;

                        return d / 100;
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["SALDO_DISPONIVEL"] = value.Value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                        else
                            Dicionario["SALDO_DISPONIVEL"] = "".PadLeft(15, ' ');

                    }
                }

                /// <summary>
                /// Valor da taxa pré funding. Válido somente para o arquivo retorno.
                /// </summary>
                [Atributo(Sequencia = 44, Regex = @"(?<VALOR_TAXA_PREFUNDING>.{15})", Escritural = true)]
                public decimal? VALOR_TAXA_PREFUNDING
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_TAXA_PREFUNDING"))
                            Dicionario["VALOR_TAXA_PREFUNDING"] = "".PadLeft(15, ' ');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_TAXA_PREFUNDING"]))
                            return null;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_TAXA_PREFUNDING"], out d))
                            return null;

                        return d / 100;
                    }
                    set
                    {
                        if (!value.HasValue)
                            Dicionario["VALOR_TAXA_PREFUNDING"] = "".PadLeft(15, ' ');
                        else
                            Dicionario["VALOR_TAXA_PREFUNDING"] = value.Value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                    }
                }

                /// <summary>
                /// Posição 326 A 331. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 45, Regex = @"(?<RESERVADO_USO_BANCO_1>.{6})", Escritural = true)]
                public string RESERVADO_USO_BANCO_1
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_1"))
                            Dicionario["RESERVADO_USO_BANCO_1"] = "".PadRight(6, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_1"].PadRight(6, ' ').Substring(0, 6);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_1"] = value.PadRight(6, ' ').Substring(0, 6);
                    }
                }

                /// <summary>
                /// <para>Sacador/avalista. Somente para títulos em cobrança, demais modalidades será desconsiderado – fixo brancos.</para>
                /// <para>Utilizado somente para títulos. Objetiva identificar o fornecedor quando o título foi descontado com terceiros e colocado em Cobrança bancária.</para>
                /// <remarks><para>Para Títulos Bradesco Rastreado:</para>
                /// <para>O CNPJ/CPF do Sacador Avalista será informado na posição 399 a 413.</para>
                /// <para>O endereço do Sacador Avalista será informado na posição 292 a 331.</para>
                /// </remarks>
                /// </summary>
                [Atributo(Sequencia = 46, Regex = @"(?<NOME_SACADO>.{40})")]
                public string NOME_SACADO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NOME_SACADO"))
                            Dicionario["NOME_SACADO"] = "".PadRight(40, ' ');

                        return Dicionario["NOME_SACADO"].PadRight(40, ' ').Substring(0, 40);
                    }
                    set
                    {
                        if (value.Trim().Length > 40)
                            throw new ArgumentException("Nome do Sacado deve ter até 40 caracteres.");

                        Dicionario["NOME_SACADO"] = value.PadRight(40, ' ').Substring(0, 40);
                    }
                }

                /// <summary>
                /// Posição 372 A 372. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 47, Regex = @"(?<RESERVADO_USO_BANCO_2>.)")]
                public string RESERVADO_USO_BANCO_2
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_2"))
                            Dicionario["RESERVADO_USO_BANCO_2"] = "".PadRight(1, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_2"].PadRight(1, ' ').Substring(0, 1);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_2"] = value.PadRight(1, ' ').Substring(0, 1);
                    }
                }

                /// <summary>
                /// <para>Nível da Informação de Retorno. Campo válido somente para arquivo retorno.</para>
                /// <para>1 = Invalida o arquivo</para>
                /// <para>2 = Invalida o registro</para>
                /// <para>3 = A tarefa foi executada</para>
                /// </summary>
                [Atributo(Sequencia = 48, Regex = @"(?<NIVEL_INFORMACAO_RETORNO>.)")]
                public CNAB.NIVEL_INFORMACAO_RETORNO? NIVEL_INFORMACAO_RETORNO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NIVEL_INFORMACAO_RETORNO"))
                            Dicionario["NIVEL_INFORMACAO_RETORNO"] = "".PadLeft(1, ' ');

                        if (Dicionario["NIVEL_INFORMACAO_RETORNO"].Trim().Length == 0)
                            return null;

                        return Enum.GetValues(typeof(CNAB.NIVEL_INFORMACAO_RETORNO))
                            .Cast<CNAB.NIVEL_INFORMACAO_RETORNO>()
                            .Where(x => (int)x == int.Parse(Dicionario["NIVEL_INFORMACAO_RETORNO"].Replace(' ', '0')))
                            .First();
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["NIVEL_INFORMACAO_RETORNO"] = ((int)value.Value).ToString().Substring(0, 1);
                        else
                            Dicionario["NIVEL_INFORMACAO_RETORNO"] = "".PadLeft(1, ' ');
                    }
                }

                /// <summary>
                /// Informações complementares. Decomposição das informações em função da modalidade de pagamento.
                /// </summary>
                [Atributo(Sequencia = 49, Regex = @"(?<INFORMACAO_COMPLEMENTAR>.{40})")]
                public string INFORMACAO_COMPLEMENTAR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("INFORMACAO_COMPLEMENTAR"))
                            Dicionario["INFORMACAO_COMPLEMENTAR"] = "".PadRight(40, ' ');

                        return Dicionario["INFORMACAO_COMPLEMENTAR"].ToString().PadRight(40, ' ').Substring(0, 40);
                    }
                    set
                    {
                        if (value.Length > 40)
                            throw new ArgumentException("Informação Complementar deve ter até 40 caracteres.");

                        Dicionario["INFORMACAO_COMPLEMENTAR"] = value.PadRight(40, ' ').Substring(0, 40);
                    }
                }

                /// <summary>
                /// <para>Código de área na empresa. Uso da empresa – para identificar a origem do pagamento. Opcional.</para>
                /// <para>Quando Tipo de Processamento = “1”, ( posição 106 a 106 do Registro header ) o conteúdo deste campo será branco.</para>
                /// </summary>
                [Atributo(Sequencia = 50, Regex = @"(?<CODIGO_AREA_EMPRESA>.{2})")]
                public string CODIGO_AREA_EMPRESA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CODIGO_AREA_EMPRESA"))
                            Dicionario["CODIGO_AREA_EMPRESA"] = "".PadRight(2, ' ');

                        return Dicionario["CODIGO_AREA_EMPRESA"].PadRight(2, ' ').Substring(0, 2);
                    }
                    set
                    {
                        if (value.Length > 2)
                            throw new ArgumentException("Código de Área da Empresa deve ser 2 digitos.");

                        Dicionario["CODIGO_AREA_EMPRESA"] = value.PadRight(2, ' ').Substring(0, 2);
                    }
                }

                /// <summary>
                /// <para>Uso da empresa – Para que seja devolvido no arquivo retorno, depende de cadastramento no Banco. Opcional.</para>
                /// <para>Será confirmado o conteúdo da remessa.</para>
                /// </summary>
                [Atributo(Sequencia = 51, Regex = @"(?<RESERVADO_USO_EMPRESA>.{35})")]
                public string RESERVADO_USO_EMPRESA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_EMPRESA"))
                            Dicionario["RESERVADO_USO_EMPRESA"] = "".PadRight(35, ' ');

                        return Dicionario["RESERVADO_USO_EMPRESA"].PadRight(35, ' ').Substring(0, 35).Trim();
                    }
                    set
                    {
                        if (value.Length > 35)
                            throw new ArgumentException("Informação de Uso da Empresa deve ter até 35 caracteres.");

                        Dicionario["RESERVADO_USO_EMPRESA"] = value.PadRight(35, ' ').Substring(0, 35);
                    }
                }

                /// <summary>
                /// Posição 451 A 472. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 52, Regex = @"(?<RESERVADO_USO_BANCO_3>.{22})")]
                public string RESERVADO_USO_BANCO_3
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_3"))
                            Dicionario["RESERVADO_USO_BANCO_3"] = "".PadRight(22, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_3"].PadRight(22, ' ').Substring(0, 22);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_3"] = value.PadRight(22, ' ').Substring(0, 22);
                    }
                }

                /// <summary>
                /// Código de lançamento. Exclusivo para as modalidades 01, 02, 03, 05 e 08. Indica o código de lançamento no extrato de conta corrente.
                /// <remarks>A Empresa pagadora terá que informar ao Banco os códigos de lançamento para débito/crédito (modalidades 01,02, 03, 05 e 08) a serem utilizados, para que sejam previamente cadastrados. Código de lançamento esta definido com string por que os códigos variam pois são cadastrados pela agencia detentora da conta.</remarks>
                /// </summary>
                [Atributo(Sequencia = 53, Regex = @"(?<CODIGO_LANCAMENTO>\d{5})")]
                public string CODIGO_LANCAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CODIGO_LANCAMENTO"))
                            Dicionario["CODIGO_LANCAMENTO"] = "".PadLeft(5, '0');

                        return Dicionario["CODIGO_LANCAMENTO"];
                    }
                    set
                    {
                        Dicionario["CODIGO_LANCAMENTO"] = value.PadLeft(5, '0').Substring(0, 5);
                    }
                }

                /// <summary>
                /// Posição 478 A 478. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 54, Regex = @"(?<RESERVADO_USO_BANCO_4>.)")]
                public string RESERVADO_USO_BANCO_4
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_4"))
                            Dicionario["RESERVADO_USO_BANCO_4"] = "".PadRight(1, ' ').Substring(0, 1);

                        return Dicionario["RESERVADO_USO_BANCO_4"].PadRight(1, ' ').Substring(0, 1);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_4"] = value.PadRight(1, ' ').Substring(0, 1);
                    }
                }

                /// <summary>
                /// <para>Tipo de conta do fornecedor. Exclusivo para as modalidades 01 e 05. Obrigatória - variável.</para>
                /// <para>Exclusivo para as modalidades 01 e 05</para>
                /// <para>1 = Indica que o credito ao fornecedor será realizado em conta corrente</para>
                /// <para>2 = Indica que o credito ao fornecedor será realizado em conta de poupança</para>
                /// </summary>
                [Atributo(Sequencia = 55, Regex = @"(?<TIPO_CONTA_FORNECEDOR>\s|1|2)")]
                public CNAB.TIPO_CONTA_FORNECEDOR? TIPO_CONTA_FORNECEDOR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_CONTA_FORNECEDOR"))
                            Dicionario["TIPO_CONTA_FORNECEDOR"] = "".PadLeft(1, ' ');

                        if (Dicionario["TIPO_CONTA_FORNECEDOR"] == "".PadLeft(1, ' '))
                            return null;

                        return Enum.GetValues(typeof(CNAB.TIPO_CONTA_FORNECEDOR))
                            .Cast<CNAB.TIPO_CONTA_FORNECEDOR>()
                            .Where(x => (int)x == int.Parse(Dicionario["TIPO_CONTA_FORNECEDOR"]))
                            .First();
                    }
                    set
                    {
                        if (value.HasValue)
                            Dicionario["TIPO_CONTA_FORNECEDOR"] = ((int)value).ToString().PadLeft(1, ' ').Substring(0, 1);
                        else
                            Dicionario["TIPO_CONTA_FORNECEDOR"] = "".PadLeft(1, ' ');
                    }
                }

                /// <summary>
                /// Conta complementar. Obrigatório quando o cliente pagador possuir mais de uma Conta para débito dos pagamentos. Deverá ser solicitado ao Banco.
                /// <para>Se a empresa pagadora tiver várias contas abertas com o mesmo CNPJ, todas as contas poderão ser previamente cadastradas e indicadas para débito, bastando indicar neste campo o código correspondente à conta de débito cadastrado no Banco.</para>
                /// <remarks>Obrigatório quando o cliente pagador for optante pelo pagamento diferenciado, ou seja contas de débito diferenciadas.</remarks>
                /// </summary>
                [Atributo(Sequencia = 56, Regex = @"(?<CONTA_COMPLEMENTAR>\d{7})")]
                public string CONTA_COMPLEMENTAR
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CONTA_COMPLEMENTAR"))
                            Dicionario["CONTA_COMPLEMENTAR"] = "".PadLeft(7, '0');

                        return Dicionario["CONTA_COMPLEMENTAR"].ToString().PadLeft(7, '0').Substring(0, 7);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(7, '0').IsNumericArray(7))
                            throw new ArgumentException("Conta Complementar deve ter até 7 digitos numéricos;");

                        Dicionario["CONTA_COMPLEMENTAR"] = value.Trim().PadLeft(7, '0').Substring(0, 7);
                    }
                }

                /// <summary>
                /// Posição 487 A 494. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 57, Regex = @"(?<RESERVADO_USO_BANCO_5>.{8})")]
                public string RESERVADO_USO_BANCO_5
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_5"))
                            Dicionario["RESERVADO_USO_BANCO_5"] = "".PadRight(8, ' ').Substring(0, 8);

                        return Dicionario["RESERVADO_USO_BANCO_5"].PadRight(8, ' ').Substring(0, 8);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_5"] = value.PadRight(8, ' ').Substring(0, 8);
                    }
                }

                /// <summary>
                /// Número sequencial do registro. Número sequencial – O Primeiro registro de operação sempre será o registro “000002”, e assim sucessivamente. Obrigatório – variável.
                /// </summary>
                [Atributo(Sequencia = 58, Regex = @"(?<NUMERO_SEQUENCIAL>\d{6})")]
                public UInt32 NUMERO_SEQUENCIAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_SEQUENCIAL"))
                            Dicionario["NUMERO_SEQUENCIAL"] = "".PadRight(6, '0');

                        return UInt32.Parse(Dicionario["NUMERO_SEQUENCIAL"]);
                    }
                    set
                    {
                        //if (!value.Trim().PadLeft(6, '0').IsNumericArray(6))
                        //    throw new ArgumentException("Número Sequencial deve ter até 6 digitos numéricos;");

                        Dicionario["NUMERO_SEQUENCIAL"] = ((int)value).ToString().PadLeft(6, '0').Substring(0, 6);
                    }
                }

                /// <summary>
                /// Representação numérica do codigo de barras
                /// </summary>
                public string CODIGO_BARRAS
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CODIGO_BARRAS"))
                            Dicionario["CODIGO_BARRAS"] = "".PadRight(44, '0');

                        return Dicionario["CODIGO_BARRAS"];
                    }
                    set
                    {
                        //if (!value.HasValue)
                        //    Dicionario["CODIGO_BARRAS"] = "".PadRight(44, '0');
                        //else 
                        if (!value.Trim().PadLeft(44, '0').IsNumericArray(44))
                            throw new ArgumentException("Codigo de Barras deve ter 44 digitos numéricos;");

                        Dicionario["CODIGO_BARRAS"] = value.Trim().PadLeft(44, '0').Substring(0, 44);
                    }
                }

                /// <summary>
                /// Representação numérica do codigo de barras
                /// </summary>
                public string LINHA_DIGITAVEL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("LINHA_DIGITAVEL"))
                            Dicionario["LINHA_DIGITAVEL"] = "".PadRight(47, '0');

                        return Dicionario["LINHA_DIGITAVEL"];
                    }
                    set
                    {
                        //if (!value.HasValue)
                        //    Dicionario["LINHA_DIGITAVEL"] = "".PadRight(47, '0');
                        //else 
                        if (!value.Trim().PadLeft(47, '0').IsNumericArray(47))
                            throw new ArgumentException("Linha Digitável deve ter 47 digitos numéricos;");

                        CodigoBarras c = new CodigoBarras(value);

                        BANCO_FORNECEDOR = c.IDENTIFICACAO_BANCO;
                        NOSSO_NUMERO = c.NOSSO_NUMERO;
                        AGENCIA_FORNECEDOR = c.AGENCIA;
                        //AGENCIA_FORNECEDOR_DIGITO = c.DIGITO_VERIFICADOR;
                        //FATOR_VENCIMENTO = c.FATOR_VENCIMENTO;
                        VALOR_PAGAMENTO = c.VALOR;
                        CARTEIRA = c.CARTEIRA;

                        Dicionario["LINHA_DIGITAVEL"] = value.Trim().PadLeft(47, '0').Substring(0, 47);
                    }
                }

                #endregion

                #region Construtores

                /// <summary>
                /// Construtor da classe Instrução
                /// </summary>
                public Instrucao()
                {
                    this.Reset();
                }

                public Instrucao(Bradesco.CodigoBarras CodigoBarras)
                {
                    this.Reset();

                    this.TIPO_INSCRICAO = TIPO_INSCRICAO;
                    this.CNPJ = CNPJ;
                    this.CNPJ_FILIAL = CNPJ_FILIAL;
                    this.CNPJ_DIGITO = CNPJ_DIGITO;
                    this.NOME_FORNECEDOR = NOME_FORNECEDOR;
                    this.ENDERECO_FORNECEDOR = ENDERECO_FORNECEDOR;
                    this.CEP_PREFIXO = CEP_PREFIXO;
                    this.CEP_COMPLEMENTO = CEP_COMPLEMENTO;
                    this.TIPO_DOCUMENTO = TIPO_DOCUMENTO;
                    this.NUMERO_NOTA_FISCAL = NUMERO_NOTA_FISCAL;
                    this.SERIE_DOCUMENTO = SERIE_DOCUMENTO;
                    this.MODALIDADE_PAGAMENTO = MODALIDADE_PAGAMENTO;
                    this.SITUACAO_AGENDAMENTO = SITUACAO_AGENDAMENTO;
                    this.TIPO_MOVIMENTO = TIPO_MOVIMENTO;
                    this.CODIGO_MOVIMENTO = CODIGO_MOVIMENTO;
                    this.HORARIO_CONSULTA_SALDO = HORARIO_CONSULTA_SALDO;
                    this.DATA_PAGAMENTO = DATA_PAGAMENTO;
                    this.NOME_SACADO = NOME_SACADO;
                    this.CODIGO_AREA_EMPRESA = CODIGO_AREA_EMPRESA;
                    this.RESERVADO_USO_EMPRESA = RESERVADO_USO_EMPRESA;
                    this.CODIGO_LANCAMENTO = CODIGO_LANCAMENTO;
                    this.TIPO_CONTA_FORNECEDOR = TIPO_CONTA_FORNECEDOR;
                    this.CONTA_COMPLEMENTAR = CONTA_COMPLEMENTAR;                    
                }

                /// <summary>
                /// Construtor da classe.
                /// </summary>
                /// <param name="TIPO_INSCRICAO"></param>
                /// <param name="CNPJ"></param>
                /// <param name="CNPJ_FILIAL"></param>
                /// <param name="CNPJ_DIGITO"></param>
                /// <param name="NOME_FORNECEDOR"></param>
                /// <param name="ENDERECO_FORNECEDOR"></param>
                /// <param name="CEP_PREFIXO"></param>
                /// <param name="CEP_COMPLEMENTO"></param>
                /// <param name="CODIGO_BARRAS"></param>
                /// <param name="CARTEIRA"></param>
                /// <param name="NOSSO_NUMERO"></param>
                /// <param name="SEU_NUMERO"></param>
                /// <param name="DATA_VENCIMENTO"></param>
                /// <param name="DATA_EMISSAO"></param>
                /// <param name="DATA_LIMITE_DESCONTO"></param>
                /// <param name="VALOR_DOCUMENTO"></param>
                /// <param name="VALOR_PAGAMENTO"></param>
                /// <param name="VALOR_DESCONTO"></param>
                /// <param name="VALOR_ACRESCIMO"></param>
                /// <param name="TIPO_DOCUMENTO"></param>
                /// <param name="NUMERO_NOTA_FISCAL"></param>
                /// <param name="SERIE_DOCUMENTO"></param>
                /// <param name="MODALIDADE_PAGAMENTO"></param>
                /// <param name="SITUACAO_AGENDAMENTO"></param>
                /// <param name="TIPO_MOVIMENTO"></param>
                /// <param name="CODIGO_MOVIMENTO"></param>
                /// <param name="HORARIO_CONSULTA_SALDO"></param>
                /// <param name="DATA_PAGAMENTO"></param>
                /// <param name="NOME_SACADO"></param>
                /// <param name="CODIGO_AREA_EMPRESA"></param>
                /// <param name="RESERVADO_USO_EMPRESA"></param>
                /// <param name="CODIGO_LANCAMENTO"></param>
                /// <param name="TIPO_CONTA_FORNECEDOR"></param>
                /// <param name="CONTA_COMPLEMENTAR"></param>
                public Instrucao(
                    CNAB.TIPO_INSCRICAO TIPO_INSCRICAO,
                    string CNPJ,
                    string CNPJ_FILIAL,
                    string CNPJ_DIGITO,
                    string NOME_FORNECEDOR,
                    string ENDERECO_FORNECEDOR,
                    string CEP_PREFIXO,
                    string CEP_COMPLEMENTO,
                    string CODIGO_BARRAS,
                    string CARTEIRA,
                    string NOSSO_NUMERO,
                    string SEU_NUMERO,
                    DateTime DATA_VENCIMENTO,
                    DateTime DATA_EMISSAO,
                    DateTime DATA_LIMITE_DESCONTO,
                    decimal VALOR_DOCUMENTO,
                    decimal VALOR_PAGAMENTO,
                    decimal VALOR_DESCONTO,
                    decimal VALOR_ACRESCIMO,
                    CNAB.TIPO_DOCUMENTO TIPO_DOCUMENTO,
                    string NUMERO_NOTA_FISCAL,
                    string SERIE_DOCUMENTO,
                    CNAB.MODALIDADE_PAGAMENTO MODALIDADE_PAGAMENTO,
                    CNAB.SITUACAO_AGENDAMENTO SITUACAO_AGENDAMENTO,
                    CNAB.TIPO_MOVIMENTO TIPO_MOVIMENTO,
                    CNAB.CODIGO_MOVIMENTO CODIGO_MOVIMENTO,
                    DateTime HORARIO_CONSULTA_SALDO,
                    DateTime DATA_PAGAMENTO,
                    string NOME_SACADO,
                    string CODIGO_AREA_EMPRESA,
                    string RESERVADO_USO_EMPRESA,
                    //CNAB.CODIGO_LANCAMENTO CODIGO_LANCAMENTO,
                    string CODIGO_LANCAMENTO,
                    CNAB.TIPO_CONTA_FORNECEDOR TIPO_CONTA_FORNECEDOR,
                    string CONTA_COMPLEMENTAR)
                {
                    Reset();

                    this.TIPO_INSCRICAO = TIPO_INSCRICAO;
                    this.CNPJ = CNPJ;
                    this.CNPJ_FILIAL = CNPJ_FILIAL;
                    this.CNPJ_DIGITO = CNPJ_DIGITO;
                    this.NOME_FORNECEDOR = NOME_FORNECEDOR;
                    this.ENDERECO_FORNECEDOR = ENDERECO_FORNECEDOR;
                    this.CEP_PREFIXO = CEP_PREFIXO;
                    this.CEP_COMPLEMENTO = CEP_COMPLEMENTO;
                    this.TIPO_DOCUMENTO = TIPO_DOCUMENTO;
                    this.NUMERO_NOTA_FISCAL = NUMERO_NOTA_FISCAL;
                    this.SERIE_DOCUMENTO = SERIE_DOCUMENTO;
                    this.MODALIDADE_PAGAMENTO = MODALIDADE_PAGAMENTO;
                    this.SITUACAO_AGENDAMENTO = SITUACAO_AGENDAMENTO;
                    this.TIPO_MOVIMENTO = TIPO_MOVIMENTO;
                    this.CODIGO_MOVIMENTO = CODIGO_MOVIMENTO;
                    this.HORARIO_CONSULTA_SALDO = HORARIO_CONSULTA_SALDO;
                    this.DATA_PAGAMENTO = DATA_PAGAMENTO;
                    this.NOME_SACADO = NOME_SACADO;
                    this.CODIGO_AREA_EMPRESA = CODIGO_AREA_EMPRESA;
                    this.RESERVADO_USO_EMPRESA = RESERVADO_USO_EMPRESA;
                    this.CODIGO_LANCAMENTO = CODIGO_LANCAMENTO;
                    this.TIPO_CONTA_FORNECEDOR = TIPO_CONTA_FORNECEDOR;
                    this.CONTA_COMPLEMENTAR = CONTA_COMPLEMENTAR;

                }

                /// <summary>
                /// Construtor da classe
                /// </summary>
                /// <param name="Registro">Linha do arquivo CNAB a ser analisada</param>
                public Instrucao(string Registro)
                {
                    this._Registro = Registro;

                    Parse();
                }

                #endregion

                #region Metodos

                /// <summary>
                /// Inicializa os dados do registro com valores padrão
                /// </summary>
                public new void Reset()
                {
                    Dicionario.Clear();
                    base.Reset();
                }

                /// <summary>
                /// Gera uma lista de propriedades representando cada campo do registro com base na modalidade de pagamento
                /// </summary>
                /// <returns></returns>
                public override PropertyInfo[] Propriedades()
                {
                    if (MODALIDADE_PAGAMENTO == CNAB.MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_BRADESCO)
                        return GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                                })
                                .Where(x => !x.Attribute.Escritural)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                                .Select(x => x.Property)
                            //.Select(x => x.Attribute.Regex)
                                .ToArray();
                    else
                        return GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                                })
                                .Where(x => !x.Attribute.DDA)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                                .Select(x => x.Property)
                            //.Select(x => x.Attribute.Regex)
                                .ToArray();
                }

                /// <summary>
                /// Gera a expressão regular para validação dos campos do registro
                /// </summary>
                /// <returns></returns>
                public override string ExpressaoRegular()
                {
                    string[] Expressao;

                    if (MODALIDADE_PAGAMENTO == CNAB.MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_BRADESCO)
                        Expressao = GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                                })
                                .Where(x => x.Attribute != null)
                                .Where(x => !x.Attribute.Escritural)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                            //.Select(x => x.Property)
                                .Select(x => x.Attribute.Regex)
                                .ToArray();
                    else
                        Expressao = GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                                })
                                .Where(x => x.Attribute != null)
                                .Where(x => !x.Attribute.DDA)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                            //.Select(x => x.Property)
                                .Select(x => x.Attribute.Regex)
                                .ToArray();

                    return "^" + String.Join("", Expressao) + "$";
                }

                /// <summary>
                /// Analisa e carrega os dados do registro nas respectivas propriedades da classe Instrução 
                /// </summary>
                /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
                public override bool Parse()
                {
                    Regex regex = new Regex(@"^(?:.{263})(?<MODALIDADE_PAGAMENTO>01|02|03|05|08|30|31)", RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Multiline);
                    Match match = regex.Match(_Registro);

                    if (!match.Success)
                        throw new Exception("Registro CNAB inválido. A Modalide de Pagamento do registro Instrucao não estão de acordo com o formato esperado. Registro:[" + _Registro + "], Expressão de Validação:[^(?:.{263})(?<MODALIDADE_PAGAMENTO>01|02|03|05|08|30|31)]");

                    Dictionary<string, string> dicionario = regex.GetGroupNames()
                        .Where(name => match.Groups[name].Success && match.Groups[name].Captures.Count > 0 && match.Groups[name].Index > 0)
                        .ToDictionary(name => name, name => match.Groups[name].Value);

                    //if (dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)) 
                    //    && !String.IsNullOrEmpty(dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)])
                    //    && dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)].Trim().Length == 2
                    //    && dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)].Trim().IsNumericArray(2)
                    //    && dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)].Trim() == ((int)CNAB.MODALIDADE_PAGAMENTO.RASTREAMENTO_TITULOS_BRADESCO).ToString())
                    //    return new Transacao_DDA(Registro);
                    //else
                    //    return new Transacao_Escritural(Registro);

                    if (Parse(dicionario))
                    {
                        regex = new Regex(ExpressaoRegular(), RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Multiline);
                        match = regex.Match(_Registro);

                        if (!match.Success)
                            throw new Exception("Registro CNAB inválido. O dados do registro " + this.GetType().Name + " não estão de acordo com o formato esperado. Registro:[" + _Registro + "], Expressão de Validação:[" + ExpressaoRegular() + "]");

                        dicionario = regex.GetGroupNames()
                            .Where(name => match.Groups[name].Success && match.Groups[name].Captures.Count > 0 && name != "0" /*&& match.Groups[name].Index > 0*/)
                            .ToDictionary(name => name, name => match.Groups[name].Value);
                    }

                    try
                    {
                        return base.Parse(dicionario);
                    }
                    catch (Exception e)
                    {
                        throw new Exception(MODALIDADE_PAGAMENTO == CNAB.MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_BRADESCO ? "Titulo DDA " : "Titulo Escritural " + e.Message);
                    }
                }

                /// <summary>
                /// Gerar registro  
                /// </summary>
                /// <param name="Stream">Fluxo de dados onde será escrito o registro</param>
                /// <returns>Retorna verdadeiro se o registro for gerado com sucesso.</returns>
                public override bool Write(StreamWriter Stream)
                {
                    //base.Write(this, Stream, Dicionario);

                    StringBuilder s = new StringBuilder();

                    PropertyInfo currentProp = null;
                    try
                    {
                        foreach (PropertyInfo p in Propriedades())
                        {
                            currentProp = p;
                            if (Dicionario.ContainsKey(p.Name) && !String.IsNullOrEmpty(Dicionario[p.Name]))
                            {
                                s.Append(Dicionario[p.Name]);
                            }
                            else
                                throw new ArgumentException("Os dados para o campo " + p.Name + " não foi encontrado.");
                        }
                    }
                    catch (ArgumentException a)
                    {
                        throw new ArgumentException(a.Message);
                    }
                    catch (Exception e)
                    {
                        throw new Exception(e.Message);
                    }

                    Stream.WriteLine(s.ToString());

                    return true;
                }

                #endregion
            }

        }
    }
}
