using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.ObjectModel;
using System.Reflection;
using System.Globalization;

namespace SA.Data.Models.Financeiro.Bancos
{
    /// <summary>
    /// Representa os dados e as operações envolvendo bancos
    /// </summary>
    public partial class Banco
    {
        /// <summary>
        /// Representa os dados e a implementação para o banco Bradesco
        /// </summary>
        public partial class Bradesco : Banco
        {
            #region Variaveis

            #endregion

            #region Propriedades

            #endregion

            #region Construtores

            #endregion

            #region Metodos

            /// <summary>
            /// <para>Esta é função de cálculo do Módulo 11 especifica para o banco Bradesco.</para>
            /// <para>O cálculo do Módulo 11 do Bradesco utiliza pesos de 2 a 7.</para>
            /// </summary>
            /// <param name="Numero">O número a ser calculado o Módulo 11.
            /// <para>O número deve ser passado em forma de array. 
            /// </param>
            /// <returns>Inteiro, sem sinal, representando o dígito verificador do número, calculado pelo Módulo 11.</returns>
            /// <example>
            /// <para>Para transformar o número em array:</para>
            /// <para>uint i[] = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();</para>
            /// <para>uint digito = Modulo11(i);</para>
            /// </example>
            public static uint Modulo11(uint[] Numero)
            {
                uint[] peso = { 2, 3, 4, 5, 6, 7 };
                return Banco.Modulo11(Numero, peso);
            }

            #endregion

            #region SubClasses: CNAB

            /// <summary>
            /// <para>Representa os arquivos de Remessa e Retorno no padrão CNAB do Bradesco.</para>
            /// <para>Conforme Manual de Procedimentos Pag-For Bradesco – Pagamento Escritural a Fornecedores.</para>
            /// <para>4008/Comercialização de Produtos e Serviços.</para>
            /// <para>Manual Nº 4008.523.0096. Versão 04. Elaborado em: 12/07/2012.</para>
            /// <para>Layout Pag-For Bradesco Pagamento Escritural a Fornecedores.</para>
            /// </summary>
            public abstract partial class CNAB
            {
                #region Variaveis

                #endregion

                #region Enums

                /// <summary>
                /// <para>Tipo do Registro:</para>
                /// <para>0 - Cabeçalho</para>
                /// <para>1 - Instrução</para>
                /// <para>9 - Rodapé</para>
                /// </summary>
                public enum TIPO_REGISTRO
                {
                    [System.ComponentModel.Description("Cabeçalho")]
                    CABECALHO = 0,
                    [System.ComponentModel.Description("Instrução")]
                    TRANSACAO = 1,
                    [System.ComponentModel.Description("Rodape")]
                    RODAPE = 9
                }

                /// <summary>
                /// <para>Tipo de Serviço:</para>
                /// <para>Fixo "20" - Pagamento de Fornecedor</para>
                /// </summary>
                public enum TIPO_SERVICO
                {
                    [System.ComponentModel.Description("Pagamento a Fornecedor")]
                    PAGAMENTO_FORNECEDOR = 20
                }

                /// <summary>
                /// <para>Código de Origem do Arquivo:</para>
                /// <para>1 - Origem no Cliente</para>
                /// <para>2 - Origem no Banco</para>
                /// </summary>
                public enum ORIGEM_ARQUIVO
                {
                    [System.ComponentModel.Description("Origem no Cliente")]
                    ORIGEM_NO_CLIENTE = 1,
                    [System.ComponentModel.Description("Origem no Banco")]
                    ORIGEM_NO_BANCO = 2
                }

                /// <summary>
                /// <para>Tipo de Inscrição:</para>
                /// <para>1 CPF</para>
                /// <para>2 CNPJ</para>
                /// <para>3 OUTROS</para>
                /// </summary>
                public enum TIPO_INSCRICAO
                {
                    [System.ComponentModel.Description("CPF")]
                    CPF = 1,
                    [System.ComponentModel.Description("CNPJ")]
                    CNPJ = 2,
                    [System.ComponentModel.Description("Outros")]
                    OUTROS = 3
                }

                /// <summary>
                /// <para>TIPO DE PROCESSAMENTO:</para>
                /// <para>Para todas as modalidades, o sistema gera diariamente 2 (dois) tipos de arquivos-retorno, exceto para a modalidade 30 - Cobrança Bradesco, na qual são gerados 3 (três) tipos</para>
                /// <para>1 - Rastreamento de Títulos</para>
                /// <para>2 - Confirmação de Agendamento</para>
                /// <para>3 - Confirmação de Pagamento</para>
                /// </summary>
                public enum TIPO_PROCESSAMENTO
                {
                    [System.ComponentModel.Description("Desconsiderar")]
                    DESCONSIDERADO = 0,
                    [System.ComponentModel.Description("Rastreamento de Titulos")]
                    RASTREAMENTO_TITULOS = 1,
                    [System.ComponentModel.Description("Confirmação de Agendamento")]
                    CONFIRMACAO_AGENDAMENTO = 2,
                    [System.ComponentModel.Description("Confirmação de Pagamento")]
                    CONFIRMACAO_PAGAMENTO = 3
                }

                /// <summary>
                /// <para>Tipo de Documento:</para>
                /// <para>01 - NOTA FISCAL/FATURA</para>
                /// <para>02 - FATURA</para>
                /// <para>03 - NOTA FISCAL</para>
                /// <para>04 - DUPLICATA</para>
                /// <para>05 - OUTROS</para>
                /// </summary>
                public enum TIPO_DOCUMENTO
                {
                    NOTA_FISCAL_FATURA = 1,
                    FATURA = 2,
                    NOTA_FISCAL = 3,
                    DUPLICATA = 4,
                    OUTROS = 5
                }

                /// <summary>
                /// <para>Tipo de Movimento:</para>
                /// <para>Arquivo de Remessa:</para>
                /// <para>0 – INCLUSÃO</para>
                /// <para>5 – ALTERAÇÃO</para>
                /// <para>9 - EXCLUSÃO</para>
                /// <para>Arquivo de Retorno (incluindo Remessa):</para>
                /// <para>1 - INCLUSÃO TÍTULO CART.</para>
                /// <para>2 - ALTERAÇÃO TÍTULO</para>
                /// <para>3 - BAIXA TÍTULO CART.</para>
                /// </summary>
                public enum TIPO_MOVIMENTO
                {
                    NAO_ESPECIFICADO = 0,
                    INCLUSAO = 0,
                    INCLUSAO_TITULO_CARTORIO = 1,
                    ALTERACAO_TITULO = 2,
                    BAIXA_TITULO_CARTORIO = 3,
                    ALTERACAO = 5,
                    EXCLUSAO = 9,
                }

                /// <summary>
                /// <para>Código do Movimento</para>
                /// <para>00 – Autoriza agendamento /pagamento</para>
                /// <para>25 – Desautoriza agendamento / pagamento</para>
                /// <para>50 - Efeturar Alegação</para>
                /// </summary>
                public enum CODIGO_MOVIMENTO
                {
                    AUTORIZA_AGENDAMENTO = 0,
                    DESAUTORIZA_AGENDAMENTO = 25,
                    EFETUAR_ALEGACAO = 50
                }

                /// <summary>
                /// <para>Modalidade de Pagamento:</para>
                /// <para>01 - Crédito em conta</para>
                /// <para>02 - Cheque Ordem de Pagamento</para>
                /// <para>03 - DOC COMPE</para>
                /// <para>05 - Crédito em conta Real Time</para>
                /// <para>08 - TED</para>
                /// <para>30 - Título Bradesco</para>
                /// <para>31 - Títulos Terceiros</para>
                /// </summary>
                public enum MODALIDADE_PAGAMENTO
                {
                    CREDITO_CONTA_CORRENTE = 1,
                    CHEQUE_ORDEM_PAGAMENTO = 2,
                    DOC_COMPENSACAO = 3,
                    CREDITO_CONTA_REAL_TIME = 5,
                    TED = 8,
                    COBRANCA_TITULOS_BRADESCO = 30,
                    COBRANCA_TITULOS_TERCEIROS = 31
                }

                /// <summary>
                /// <para>Situação do agendamento:</para>
                /// <para>No arquivo de rastreamento:</para>
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
                public enum SITUACAO_AGENDAMENTO
                {
                    NAO_PAGO = 1,
                    BAIXA_COBRANCA_SEM_PAGAMENTO = 5,
                    BAIXA_COBRANCA_COM_PAGAMENTO = 6,
                    COM_INSTRUCAO_DE_PROTESTO = 7,
                    TRANSFERENCIA_PARA_CARTÓRIO = 8,
                    BAIXADO_PELO_DESCONTO = 9,
                    CHEQUE_ORDEM_PAGAMENTO_ESTORNADO = 11,
                    PAGO = 2,
                    CHEQUE_ORDEM_PAGAMENTO_EMITIDO = 22
                }

                /// <summary>
                /// <para>Tipo de conta do fornecedor</para>
                /// <para>1= Indica que o credito ao fornecedor será realizado em conta corrente</para>
                /// <para>2=Indica que o credito ao fornecedor será realizado em conta de poupança</para>
                /// </summary>
                public enum TIPO_CONTA_FORNECEDOR
                {
                    CONTA_CORRENTE = 1,
                    CONTA_POUPANCA = 2
                }

                /// <summary>
                /// <para>Nível da Informação de Retorno. Campo válido somente para arquivo retorno.</para>
                /// <para>1 = Invalida o arquivo</para>
                /// <para>2 = Invalida o registro</para>
                /// <para>3 = A tarefa foi executada</para>
                /// </summary>
                public enum NIVEL_INFORMACAO_RETORNO
                {
                    INVALIDA_ARQUIVO = 1,
                    INVALIDA_REGISTRO = 2,
                    INSTRUCAO_EXECUTADA = 3
                }

                /// <summary>
                /// <para>Códigos de Lançamento. CÓDIGOS DÉBITO/CRÉDITO:</para>
                /// <para>0298 PGTO FUNCIONÁRIOS*</para>
                /// <para>0469 PAGAMENTO DE SALÁRIO*</para>
                /// <para>1360 13 SALÁRIO*</para>
                /// <para>1361 FÉRIAS*</para>
                /// <para>1363 ADIANTAMENTO*</para>
                /// <para>1604 PENSIONISTA</para>
                /// <para>1646 PENSÃO ALIMENTÍCIA</para>
                /// <para>1654 RESCISÃO CONTRATUAL*</para>
                /// <para>1709 VALE TRANSPORTE*</para>
                /// <para>1710 ADTO EVENTUAL</para>
                /// <para>1711 ADTO FÉRIAS</para>
                /// <para>1712 ADTO QUINZENAL</para>
                /// <para>1713 ASSISTÊNCIA MÉDICA</para>
                /// <para>1714 ASSIST ODONTOLÓGICA</para>
                /// <para>1715 CONTR ASSISTENCIAL</para>
                /// <para>1716 CONTR.SINDICAL</para>
                /// <para>1717 CONVÊNIO FARMÁCIA</para>
                /// <para>1718 GRATIFICAÇÃO</para>
                /// <para>1719 PART EMPREG RESULT</para>
                /// <para>1720 PRÊMIOS</para>
                /// <para>1721 SEG. FUNCIONÁRIOS</para>
                /// <para>1722 ADTO 13o SALARIO*</para>
                /// <para>1723 DIÁRIAS VIAGENS</para>
                /// <para>1739 PREBENDA</para>
                /// <para>1765 VALE ALIMENTAÇÃO*</para>
                /// <para>1896 PGTO BENEFICIO*</para>
                /// <remarks>Os clientes usuários do serviço Pag-For Bradesco com convênio para pagamento de Conta Salário, deverão utilizar os códigos de lançamento acima marcados com *.</remarks>
                /// </summary>
                public enum CODIGO_LANCAMENTO
                {
                    PAGAMENTO_FUNCIONARIOS = 0298,
                    PAGAMENTO_DE_SALARIO = 0469,
                    DECIMO_TERCEIRO_SALARIO = 1360,
                    FERIAS = 1361,
                    ADIANTAMENTO = 1363,
                    PENSIONISTA = 1604,
                    PENSAO_ALIMENTICIA = 1646,
                    RESCISAO_CONTRATUAL = 1654,
                    VALE_TRANSPORTE = 1709,
                    ADIANTAMENTO_EVENTUAL = 1710,
                    ADIANTAMENTO_FERIAS = 1711,
                    ADIANTAMENTO_QUINZENAL = 1712,
                    ASSISTENCIA_MEDICA = 1713,
                    ASSISTENCIA_ODONTOLOGICA = 1714,
                    CONTRIBUICAO_ASSISTENCIAL = 1715,
                    CONTRIBUICAO_SINDICAL = 1716,
                    CONVENIO_FARMACIA = 1717,
                    GRATIFICACAO = 1718,
                    PARTICIPACAO_RESULTADOS = 1719,
                    PREMIOS = 1720,
                    SEGURO_FUNCIONARIOS = 1721,
                    ADIANTAMENTO_13_SALARIO = 1722,
                    DIARIAS_VIAGENS = 1723,
                    PREBENDA = 1739,
                    VALE_ALIMENTACAO = 1765,
                    PAGAMENTO_BENEFICIO = 1896
                }

                #endregion

                #region Dicionário de Dados

                /// <summary>
                /// Representa os campos do registro CNAB
                /// </summary>
                protected enum DADOS
                {
                    // GERAL
                    RESERVADO,
                    NUMERO_SEQUENCIAL,

                    // CABECALHO
                    TIPO_REGISTRO,
                    CODIGO_COMUNICACAO,
                    TIPO_INSCRICAO,
                    CNPJ,
                    CNPJ_FILIAL,
                    CNPJ_DIGITO,
                    NOME_EMPRESA,
                    NOME_FORNECEDOR,
                    TIPO_SERVICO,
                    ORIGEM_ARQUIVO,
                    NUMERO_REMESSA,
                    NUMERO_RETORNO,
                    DATA_ARQUIVO,
                    HORA_ARQUIVO,
                    DENSIDADE_GRAVACAO,
                    UNIDADE_DENSIDADE,
                    IDENTIFICACAO_MODULO,
                    TIPO_PROCESSAMENTO,
                    RESERVADO_EMPRESA,
                    NUMERO_LISTA_DEBITO,

                    // DETALHE
                    ENDERECO_FORNECEDOR,
                    CEP_PREFIXO,
                    CEP_COMPLEMENTO,
                    BANCO_FORNECEDOR,
                    AGENCIA_FORNECEDOR,
                    AGENCIA_FORNECEDOR_DIGITO,
                    CONTA_FORNECEDOR,
                    CONTA_FORNECEDOR_DIGITO,
                    NUMERO_PAGAMENTO,
                    CARTEIRA,
                    NOSSO_NUMERO,
                    SEU_NUMERO,
                    DATA_VENCIMENTO,
                    DATA_EMISSAO,
                    DATA_LIMITE_DESCONTO,
                    ZERO_FIXO,
                    FATOR_VENCIMENTO,
                    VALOR_DOCUMENTO,
                    VALOR_PAGAMENTO,
                    VALOR_DESCONTO,
                    VALOR_ACRESCIMO,
                    TIPO_DOCUMENTO,
                    NUMERO_NOTA_FISCAL,
                    SERIE_DOCUMENTO,
                    MODALIDADE_PAGAMENTO,
                    DATA_PAGAMENTO,
                    MOEDA,
                    SITUACAO_AGENDAMENTO,
                    INFO_RETORNO_1,
                    INFO_RETORNO_2,
                    INFO_RETORNO_3,
                    INFO_RETORNO_4,
                    INFO_RETORNO_5,
                    TIPO_MOVIMENTO,
                    CODIGO_MOVIMENTO,
                    HORARIO_CONSULTA_SALDO,
                    SALDO_DISPONIVEL,
                    VALOR_TAXA_PREFUNDING,
                    RESERVADO_USO_BANCO_1,
                    ENDERECO_SACADO,
                    NOME_SACADO,
                    RESERVADO_USO_BANCO_2,
                    NIVEL_INFORMACAO_RETORNO,
                    INFORMACAO_COMPLEMENTAR,
                    CODIGO_AREA_EMPRESA,
                    RESERVADO_USO_EMPRESA,
                    RESERVADO_USO_BANCO_3,
                    CODIGO_LANCAMENTO,
                    RESERVADO_USO_BANCO_4,
                    TIPO_CONTA_FORNECEDOR,
                    CONTA_COMPLEMENTAR,
                    RESERVADO_USO_BANCO_5,

                    // Rodape
                    QUANTIDADE_REGISTROS,
                    VALOR_TOTAL_PAGAMENTO,
                }

                #endregion

                #region Código de Ocorrência

                /// <summary>
                /// <para>PAGAMENTO A FORNECEDORES. CÓDIGOS DE OCORRÊNCIA. INFORMAÇÕES DE RETORNO/MENSAGENS DO SISTEMA</para>
                /// <para>A descrição das informações de retorno e mensagens do sistema é utilizada nas ocorrências apontadas no campo informação de retorno - posições 279 a 288 do registro de operação, com seus respectivos níveis de consistências/inconsistências.</para>
                /// <para>NÍVEL:</para>
                /// <para>1 = INCONSISTÊNCIA. INVALIDA O ARQUIVO</para>
                /// <para>2 = INCONSISTÊNCIA. INVALIDA O REGISTRO</para>
                /// <para>3 = CONSISTÊNCIA. A TAREFA FOI EXECUTADA</para>
                /// <para>REGISTRO:</para>
                /// <para>0 = HEADER</para>
                /// <para>1 = TRANSAÇÃO</para>
                /// <para>9 = TRAILLER</para>
                /// </summary>
                public struct Ocorrencia
                {
                    public string Codigo;
                    public byte Nivel;
                    public string Mensagem;
                    public byte Registro;
                };

                /// <summary>
                /// <para>PAGAMENTO A FORNECEDORES. CÓDIGOS DE OCORRÊNCIA. INFORMAÇÕES DE RETORNO/MENSAGENS DO SISTEMA</para>
                /// <para>A descrição das informações de retorno e mensagens do sistema é utilizada nas ocorrências apontadas no campo informação de retorno - posições 279 a 288 do registro de operação, com seus respectivos níveis de consistências/inconsistências.</para>
                /// <para>NÍVEL:</para>
                /// <para>1 = INCONSISTÊNCIA. INVALIDA O ARQUIVO</para>
                /// <para>2 = INCONSISTÊNCIA. INVALIDA O REGISTRO</para>
                /// <para>3 = CONSISTÊNCIA. A TAREFA FOI EXECUTADA</para>
                /// <para>REGISTRO:</para>
                /// <para>0 = HEADER</para>
                /// <para>1 = TRANSAÇÃO</para>
                /// <para>9 = TRAILLER</para>
                /// </summary>
                public static readonly Dictionary<string, Ocorrencia> Ocorrencias = new Dictionary<string, Ocorrencia>()
                {
                    //{ "  ", new Ocorrencia() { Codigo = "  ", Nivel = 3, Mensagem = "Nenhuma Ocorrência", Registro = 0 } },
                    { "AA", new Ocorrencia() { Codigo = "AA", Nivel = 1, Mensagem = "Arquivo duplicado", Registro = 0 } },
                    { "AB", new Ocorrencia() { Codigo = "AB", Nivel = 2, Mensagem = "Data limite para desconto, sem valor correspondente", Registro = 1 } },
                    { "AC", new Ocorrencia() { Codigo = "AC", Nivel = 1, Mensagem = "Tipo de serviço inválido", Registro = 0 } },
                    { "AD", new Ocorrencia() { Codigo = "AD", Nivel = 2, Mensagem = "Modalidade de pagamento inválida", Registro = 1 } },
                    { "AE", new Ocorrencia() { Codigo = "AE", Nivel = 1, Mensagem = "Tipo de inscrição e identificação do cliente pagador incompatíveis", Registro = 0 } },
                    { "AF", new Ocorrencia() { Codigo = "AF", Nivel = 2, Mensagem = "Valores não numéricos ou zerados", Registro = 1 } },
                    { "AG", new Ocorrencia() { Codigo = "AG", Nivel = 2, Mensagem = "Tipo de inscrição e identificação do favorecido incompatível", Registro = 1 } },
                    { "AJ", new Ocorrencia() { Codigo = "AJ", Nivel = 2, Mensagem = "Tipo de movimento inválido", Registro = 1 } },
                    { "AL", new Ocorrencia() { Codigo = "AL", Nivel = 2, Mensagem = "Banco, agência ou conta inválido", Registro = 1 } },
                    { "AM", new Ocorrencia() { Codigo = "AM", Nivel = 2, Mensagem = "Agência do favorecido inválida", Registro = 1 } },
                    { "AN", new Ocorrencia() { Codigo = "AN", Nivel = 2, Mensagem = "Conta corrente do favorecido inválida", Registro = 1 } },
                    { "AO", new Ocorrencia() { Codigo = "AO", Nivel = 2, Mensagem = "Nome do favorecido não informado", Registro = 1 } },
                    { "AQ", new Ocorrencia() { Codigo = "AQ", Nivel = 2, Mensagem = "Tipo de moeda inválido", Registro = 1 } },
                    { "AT", new Ocorrencia() { Codigo = "AT", Nivel = 2, Mensagem = "CGC/CPF do favorecido inválido", Registro = 1 } },
                    { "AU", new Ocorrencia() { Codigo = "AU", Nivel = 2, Mensagem = "Endereço do favorecido não informado", Registro = 1 } },
                    { "AX", new Ocorrencia() { Codigo = "AX", Nivel = 2, Mensagem = "CEP do favorecido inválido", Registro = 1 } },
                    { "AY", new Ocorrencia() { Codigo = "AY", Nivel = 2, Mensagem = "Alteração inválida; Banco anterior Bradesco", Registro = 1 } },
                    { "AZ", new Ocorrencia() { Codigo = "AZ", Nivel = 2, Mensagem = "Código de Banco do favorecido inválido", Registro = 1 } },
                    { "BD", new Ocorrencia() { Codigo = "BD", Nivel = 3, Mensagem = "Pagamento agendado", Registro = 1 } },
                    { "BE", new Ocorrencia() { Codigo = "BE", Nivel = 1, Mensagem = "Hora de gravação inválida", Registro = 0 } },
                    { "BF", new Ocorrencia() { Codigo = "BF", Nivel = 1, Mensagem = "Identificação da empresa no Banco, inválida", Registro = 0 } },
                    { "BG", new Ocorrencia() { Codigo = "BG", Nivel = 1, Mensagem = "CGC/CPF do pagador inválido", Registro = 0 } },
                    { "BH", new Ocorrencia() { Codigo = "BH", Nivel = 2, Mensagem = "Tipo de inscrição do cliente favorecido inválido", Registro = 1 } },
                    { "BI", new Ocorrencia() { Codigo = "BI", Nivel = 2, Mensagem = "Data de vencimento inválida ou não preenchida", Registro = 1 } },
                    { "BJ", new Ocorrencia() { Codigo = "BJ", Nivel = 2, Mensagem = "Data de emissão do documento inválida", Registro = 1 } },
                    { "BK", new Ocorrencia() { Codigo = "BK", Nivel = 2, Mensagem = "Tipo de inscrição do cliente favorecido não permitido", Registro = 1 } },
                    { "BL", new Ocorrencia() { Codigo = "BL", Nivel = 2, Mensagem = "Data limite para desconto inválida", Registro = 1 } },
                    { "BM", new Ocorrencia() { Codigo = "BM", Nivel = 2, Mensagem = "Data para efetivação do pagamento inválida", Registro = 1 } },
                    { "BN", new Ocorrencia() { Codigo = "BN", Nivel = 2, Mensagem = "Data para efetivação anterior a do processamento", Registro = 1 } },
                    { "BO", new Ocorrencia() { Codigo = "BO", Nivel = 1, Mensagem = "Cliente não cadastrado", Registro = 0 } },
                    { "BP", new Ocorrencia() { Codigo = "BP", Nivel = 2, Mensagem = "Identificação de Título Bradesco divergente da original", Registro = 1 } },
                    { "BQ", new Ocorrencia() { Codigo = "BQ", Nivel = 2, Mensagem = "Data do documento posterior ao vencimento", Registro = 1 } },
                    { "BT", new Ocorrencia() { Codigo = "BT", Nivel = 3, Mensagem = "Desautorização efetuada", Registro = 1 } },
                    { "BU", new Ocorrencia() { Codigo = "BU", Nivel = 3, Mensagem = "Alteração efetuada", Registro = 1 } },
                    { "BV", new Ocorrencia() { Codigo = "BV", Nivel = 3, Mensagem = "Exclusão efetuada", Registro = 1 } },
                    { "BW", new Ocorrencia() { Codigo = "BW", Nivel = 3, Mensagem = "Pagamento efetuado", Registro = 1 } },
                    { "FA", new Ocorrencia() { Codigo = "FA", Nivel = 1, Mensagem = "Código de origem inválido", Registro = 0 } },
                    { "FB", new Ocorrencia() { Codigo = "FB", Nivel = 1, Mensagem = "Data de gravação do arquivo inválida", Registro = 0 } },
                    { "FC", new Ocorrencia() { Codigo = "FC", Nivel = 2, Mensagem = "Tipo de documento inválido", Registro = 1 } },
                    { "FE", new Ocorrencia() { Codigo = "FE", Nivel = 2, Mensagem = "Número de pagamento inválido", Registro = 1 } },
                    { "FF", new Ocorrencia() { Codigo = "FF", Nivel = 2, Mensagem = "Valor do desconto sem data limite", Registro = 1 } },
                    { "FG", new Ocorrencia() { Codigo = "FG", Nivel = 2, Mensagem = "Data limite para desconto posterior ao vencimento", Registro = 1 } },
                    { "FH", new Ocorrencia() { Codigo = "FH", Nivel = 2, Mensagem = "Falta número e/ou série do documento", Registro = 1 } },
                    { "FI", new Ocorrencia() { Codigo = "FI", Nivel = 2, Mensagem = "Exclusão de agendamento não disponível", Registro = 1 } },
                    { "FJ", new Ocorrencia() { Codigo = "FJ", Nivel = 2, Mensagem = "Soma dos valores não confere", Registro = 1 } },
                    { "FK", new Ocorrencia() { Codigo = "FK", Nivel = 2, Mensagem = "Falta valor de pagamento", Registro = 1 } },
                    { "FL", new Ocorrencia() { Codigo = "FL", Nivel = 2, Mensagem = "Modalidade de pagamento inválida para o contrato", Registro = 1 } },
                    { "FM", new Ocorrencia() { Codigo = "FM", Nivel = 2, Mensagem = "Código de movimento inválido", Registro = 1 } },
                    { "FN", new Ocorrencia() { Codigo = "FN", Nivel = 2, Mensagem = "Tentativa de inclusão de registro existente", Registro = 1 } },
                    { "FO", new Ocorrencia() { Codigo = "FO", Nivel = 2, Mensagem = "Tentativa de alteração para registro inexistente", Registro = 1 } },
                    { "FP", new Ocorrencia() { Codigo = "FP", Nivel = 2, Mensagem = "Tentativa de efetivação de agendamento não disponível", Registro = 1 } },
                    { "FQ", new Ocorrencia() { Codigo = "FQ", Nivel = 2, Mensagem = "Tentativa de desautorização de agendamento não disponível", Registro = 1 } },
                    { "FR", new Ocorrencia() { Codigo = "FR", Nivel = 2, Mensagem = "Autorização de agendamento sem data de efetivação e sem data de vencimento", Registro = 1 } },
                    { "FS", new Ocorrencia() { Codigo = "FS", Nivel = 3, Mensagem = "Título em agendamento; Pedido de confirmação", Registro = 1 } },
                    { "FT", new Ocorrencia() { Codigo = "FT", Nivel = 1, Mensagem = "Tipo de inscrição do cliente pagador inválido", Registro = 0 } },
                    { "FU", new Ocorrencia() { Codigo = "FU", Nivel = 1, Mensagem = "Contrato inexistente ou inativo", Registro = 0 } },
                    { "FV", new Ocorrencia() { Codigo = "FV", Nivel = 1, Mensagem = "Cliente com convênio cancelado", Registro = 0 } },
                    { "FW", new Ocorrencia() { Codigo = "FW", Nivel = 2, Mensagem = "Valor autorizado inferior ao original", Registro = 1 } },
                    { "FX", new Ocorrencia() { Codigo = "FX", Nivel = 1, Mensagem = "Está faltando registro header", Registro = 0 } },
                    { "FZ", new Ocorrencia() { Codigo = "FZ", Nivel = 2, Mensagem = "Valor autorizado não confere para pagamento em atraso", Registro = 1 } },
                    { "F0", new Ocorrencia() { Codigo = "F0", Nivel = 2, Mensagem = "Agendamento em atraso; não permitido pelo convênio", Registro = 1 } },
                    { "F1", new Ocorrencia() { Codigo = "F1", Nivel = 2, Mensagem = "Tentativa de Agendamento com Desc. Fora do Prazo", Registro = 1 } },
                    { "F3", new Ocorrencia() { Codigo = "F3", Nivel = 2, Mensagem = "Tentativa de alteração inválida; confirmação de débito já efetuada", Registro = 1 } },
                    { "F4", new Ocorrencia() { Codigo = "F4", Nivel = 1, Mensagem = "Falta registro trailler", Registro = 9 } },
                    { "F5", new Ocorrencia() { Codigo = "F5", Nivel = 1, Mensagem = "Valor do trailler não confere", Registro = 9 } },
                    { "F6", new Ocorrencia() { Codigo = "F6", Nivel = 1, Mensagem = "Quantidade de registros do trailler não confere", Registro = 9 } },
                    { "F7", new Ocorrencia() { Codigo = "F7", Nivel = 2, Mensagem = "Tentativa de alteração inválida; pagamento já enviado ao Bradesco Instantâneo", Registro = 1 } },
                    { "F8", new Ocorrencia() { Codigo = "F8", Nivel = 2, Mensagem = "Pagamento enviado após o horário estipulado", Registro = 1 } },
                    { "F9", new Ocorrencia() { Codigo = "F9", Nivel = 2, Mensagem = "Tentativa de inclusão de registro existente em histórico", Registro = 1 } },
                    { "GA", new Ocorrencia() { Codigo = "GA", Nivel = 2, Mensagem = "Tipo de DOC/TED inválido", Registro = 1 } },
                    { "GB", new Ocorrencia() { Codigo = "GB", Nivel = 2, Mensagem = "Número do DOC/TED inválido", Registro = 1 } },
                    { "GC", new Ocorrencia() { Codigo = "GC", Nivel = 2, Mensagem = "Finalidade do DOC/TED inválida ou inexistente", Registro = 1 } },
                    { "GD", new Ocorrencia() { Codigo = "GD", Nivel = 2, Mensagem = "Conta corrente do favorecido encerrada / bloqueada", Registro = 1 } },
                    { "GE", new Ocorrencia() { Codigo = "GE", Nivel = 2, Mensagem = "Conta corrente do favorecido não recadastrada", Registro = 1 } },
                    { "GF", new Ocorrencia() { Codigo = "GF", Nivel = 2, Mensagem = "Inclusão de pagamento via modalidade 30 não permitida", Registro = 1 } },
                    { "GG", new Ocorrencia() { Codigo = "GG", Nivel = 2, Mensagem = "Campo livre do código de barras (linha digitável) inválido", Registro = 1 } },
                    { "GH", new Ocorrencia() { Codigo = "GH", Nivel = 2, Mensagem = "Dígito verificador do código de barras inválido", Registro = 1 } },
                    { "GI", new Ocorrencia() { Codigo = "GI", Nivel = 2, Mensagem = "Código da moeda da linha digitável inválido", Registro = 1 } },
                    { "GJ", new Ocorrencia() { Codigo = "GJ", Nivel = 2, Mensagem = "Conta poupança do favorecido inválida", Registro = 1 } },
                    { "GK", new Ocorrencia() { Codigo = "GK", Nivel = 2, Mensagem = "Conta poupança do favorecido não recadastrada", Registro = 1 } },
                    { "GL", new Ocorrencia() { Codigo = "GL", Nivel = 2, Mensagem = "Conta poupança do favorecido não encontrada", Registro = 1 } },
                    { "GM", new Ocorrencia() { Codigo = "GM", Nivel = 2, Mensagem = "Pagamento 3 (três) dias após o vencimento", Registro = 1 } },
                    { "GN", new Ocorrencia() { Codigo = "GN", Nivel = 2, Mensagem = "Conta complementar inválida", Registro = 1 } },
                    { "GO", new Ocorrencia() { Codigo = "GO", Nivel = 2, Mensagem = "Inclusão de DOC/TED para Banco 237 não permitido", Registro = 1 } },
                    { "GP", new Ocorrencia() { Codigo = "GP", Nivel = 2, Mensagem = "CGC/CPF do favorecido divergente do cadastro do Banco", Registro = 1 } },
                    { "GQ", new Ocorrencia() { Codigo = "GQ", Nivel = 2, Mensagem = "Tipo de DOC/TED não permitido via sistema eletrônico", Registro = 1 } },
                    { "GR", new Ocorrencia() { Codigo = "GR", Nivel = 2, Mensagem = "Alteração inválida; pagamento já enviado a agência pagadora", Registro = 1 } },
                    { "GS", new Ocorrencia() { Codigo = "GS", Nivel = 3, Mensagem = "Limite de pagamento excedido. Fale com o Gerente da sua agência", Registro = 1 } },
                    { "GT", new Ocorrencia() { Codigo = "GT", Nivel = 3, Mensagem = "Limite vencido/vencer em 30 dias", Registro = 1 } },
                    { "GU", new Ocorrencia() { Codigo = "GU", Nivel = 3, Mensagem = "Pagamento agendado por aumento de limite ou redução no total autorizado", Registro = 1 } },
                    { "GV", new Ocorrencia() { Codigo = "GV", Nivel = 3, Mensagem = "Cheque OP estornado conforme seu pedido", Registro = 1 } },
                    { "GW", new Ocorrencia() { Codigo = "GW", Nivel = 2, Mensagem = "Conta corrente ou conta poupança com razão não permitido para efetivação de crédito", Registro = 1 } },
                    { "GX", new Ocorrencia() { Codigo = "GX", Nivel = 3, Mensagem = "Cheque OP com data limite vencida", Registro = 1 } },
                    { "GY", new Ocorrencia() { Codigo = "GY", Nivel = 2, Mensagem = "Conta poupança do favorecido encerrada / bloqueada", Registro = 1 } },
                    { "GZ", new Ocorrencia() { Codigo = "GZ", Nivel = 2, Mensagem = "Conta corrente do pagador encerrada / bloqueada", Registro = 1 } },
                    { "HA", new Ocorrencia() { Codigo = "HA", Nivel = 3, Mensagem = "Agendado, débito sob consulta de saldo", Registro = 1 } },
                    { "HB", new Ocorrencia() { Codigo = "HB", Nivel = 3, Mensagem = "Pagamento não efetuado, saldo insuficiente", Registro = 1 } },
                    { "HC", new Ocorrencia() { Codigo = "HC", Nivel = 3, Mensagem = "Pagamento não efetuado, além de saldo insuficiente, conta com cadastro no DVL", Registro = 1 } },
                    { "HD", new Ocorrencia() { Codigo = "HD", Nivel = 3, Mensagem = "Pagamento não efetuado, além de saldo insuficiente, conta bloqueada", Registro = 1 } },
                    { "HE", new Ocorrencia() { Codigo = "HE", Nivel = 2, Mensagem = "Data de Vencto/Pagto fora do prazo de operação do banco", Registro = 1 } },
                    { "HF", new Ocorrencia() { Codigo = "HF", Nivel = 3, Mensagem = "Processado e debitado", Registro = 1 } },
                    { "HG", new Ocorrencia() { Codigo = "HG", Nivel = 3, Mensagem = "Processado e não debitado por saldo insuficiente", Registro = 1 } },
                    { "HI", new Ocorrencia() { Codigo = "HI", Nivel = 3, Mensagem = "Cheque OP Emitido nesta data", Registro = 1 } },
                    { "JA", new Ocorrencia() { Codigo = "JA", Nivel = 2, Mensagem = "Código de lançamento inválido", Registro = 1 } },
                    { "JB", new Ocorrencia() { Codigo = "JB", Nivel = 3, Mensagem = "DOC/TED/Títulos devolvidos e estornados", Registro = 1 } },
                    { "JC", new Ocorrencia() { Codigo = "JC", Nivel = 3, Mensagem = "Modalidade alterada de 07/CIP, para 08/STR", Registro = 1 } },
                    { "JD", new Ocorrencia() { Codigo = "JD", Nivel = 3, Mensagem = "Modalidade alterada de 07/CIP, para 03/DOC COMPE", Registro = 1 } },
                    { "JE", new Ocorrencia() { Codigo = "JE", Nivel = 3, Mensagem = "Modalidade alterada de 08/STR para 07/CIP", Registro = 1 } },
                    { "JF", new Ocorrencia() { Codigo = "JF", Nivel = 3, Mensagem = "Modalidade alterada de 08/STR para 03/COMPE", Registro = 1 } },
                    { "JG", new Ocorrencia() { Codigo = "JG", Nivel = 3, Mensagem = "Alteração de Modalidade Via Arquivo não Permitido", Registro = 1 } },
                    { "JH", new Ocorrencia() { Codigo = "JH", Nivel = 3, Mensagem = "Horário de Consulta de Saldo após Encerramento Rotina", Registro = 1 } },
                    { "JI", new Ocorrencia() { Codigo = "JI", Nivel = 3, Mensagem = "Modalidade alterada de 01/Crédito em conta para 05/Crédito em conta real time", Registro = 1 } },
                    { "JJ", new Ocorrencia() { Codigo = "JJ", Nivel = 2, Mensagem = "Horário de agendamento Inválido", Registro = 1 } },
                    { "JK", new Ocorrencia() { Codigo = "JK", Nivel = 2, Mensagem = "Tipo de conta – modalidade DOC/TED - inválido", Registro = 1 } },
                    { "JL", new Ocorrencia() { Codigo = "JL", Nivel = 3, Mensagem = "Titulo Agendado/Descontado", Registro = 1 } },
                    { "JM", new Ocorrencia() { Codigo = "JM", Nivel = 2, Mensagem = "Alteração não Permitida, Titulo Antecipado/Descontado", Registro = 1 } },
                    { "JN", new Ocorrencia() { Codigo = "JN", Nivel = 3, Mensagem = "Modalidade Alter. de 05/Crédito em Conta Real Time Para 01/Crédito em Conta", Registro = 1 } },
                    { "JO", new Ocorrencia() { Codigo = "JO", Nivel = 2, Mensagem = "Exclusão não Permitida Titulo Antecipado/Descontado", Registro = 1 } },
                    { "JP", new Ocorrencia() { Codigo = "JP", Nivel = 3, Mensagem = "Pagamento com Limite TED Excedido. Fale com o Gerente da sua agência para Autorização.", Registro = 1 } },
                    { "KO", new Ocorrencia() { Codigo = "KO", Nivel = 3, Mensagem = "Autorização para debito em conta", Registro = 0 } },
                    { "KP", new Ocorrencia() { Codigo = "KP", Nivel = 2, Mensagem = "Cliente pagador não cadastrado do PAGFOR", Registro = 0 } },
                    { "KQ", new Ocorrencia() { Codigo = "KQ", Nivel = 2, Mensagem = "Modalidade inválida para pagador em teste", Registro = 0 } },
                    { "KR", new Ocorrencia() { Codigo = "KR", Nivel = 2, Mensagem = "Banco destinatário não operante nesta data", Registro = 1 } },
                    { "KS", new Ocorrencia() { Codigo = "KS", Nivel = 3, Mensagem = "Modalidade alterada de DOC. Para TED", Registro = 1 } },
                    { "KT", new Ocorrencia() { Codigo = "KT", Nivel = 3, Mensagem = "Dt. Efetivação alterada p/ próximo MOVTO. ** TRAG", Registro = 1 } },
                    { "KV", new Ocorrencia() { Codigo = "KV", Nivel = 2, Mensagem = "CPF/CNPJ do investidor inválido ou inexistente", Registro = 1 } },
                    { "KW", new Ocorrencia() { Codigo = "KW", Nivel = 2, Mensagem = "Tipo Inscrição Investidor Inválido ou inexistente", Registro = 1 } },
                    { "KX", new Ocorrencia() { Codigo = "KX", Nivel = 2, Mensagem = "Nome do Investidor Inexistente", Registro = 1 } },
                    { "KZ", new Ocorrencia() { Codigo = "KZ", Nivel = 2, Mensagem = "Código do Investidor Inexistente", Registro = 1 } },
                    { "LA", new Ocorrencia() { Codigo = "LA", Nivel = 3, Mensagem = "Agendado. Sob Lista de Débito", Registro = 1 } },
                    { "LB", new Ocorrencia() { Codigo = "LB", Nivel = 3, Mensagem = "Pagamento não autorizado sob Lista de Débito", Registro = 1 } },
                    { "LC", new Ocorrencia() { Codigo = "LC", Nivel = 2, Mensagem = "Lista com mais de uma modalidade", Registro = 1 } },
                    { "LD", new Ocorrencia() { Codigo = "LD", Nivel = 2, Mensagem = "Lista com mais de uma data de Pagamento", Registro = 1 } },
                    { "LE", new Ocorrencia() { Codigo = "LE", Nivel = 2, Mensagem = "Número de Lista Duplicado", Registro = 1 } },
                    { "LF", new Ocorrencia() { Codigo = "LF", Nivel = 2, Mensagem = "Lista de Débito vencida e não autorizada", Registro = 1 } },
                    { "LG", new Ocorrencia() { Codigo = "LG", Nivel = 2, Mensagem = "Conta Salário não permitida para este convênio", Registro = 1 } },
                    { "LH", new Ocorrencia() { Codigo = "LH", Nivel = 2, Mensagem = "Código de Lançamento inválido para Conta Salário", Registro = 1 } },
                    { "LI", new Ocorrencia() { Codigo = "LI", Nivel = 2, Mensagem = "Finalidade de DOC / TED inválido para Salário", Registro = 1 } },
                    { "LJ", new Ocorrencia() { Codigo = "LJ", Nivel = 2, Mensagem = "Conta Salário obrigatória para este Código de Lançamento", Registro = 1 } },
                    { "LK", new Ocorrencia() { Codigo = "LK", Nivel = 2, Mensagem = "Tipo de Conta do Favorecido Inválida", Registro = 1 } },
                    { "LL", new Ocorrencia() { Codigo = "LL", Nivel = 2, Mensagem = "Nome do Favorecido Inconsistente", Registro = 1 } },
                    { "LM", new Ocorrencia() { Codigo = "LM", Nivel = 1, Mensagem = "Número de Lista de Débito Inválido", Registro = 0 } },
                    { "MA", new Ocorrencia() { Codigo = "MA", Nivel = 2, Mensagem = "Tipo conta Inválida para finalidade", Registro = 1 } },
                    { "MB", new Ocorrencia() { Codigo = "MB", Nivel = 2, Mensagem = "Conta Crédito Investimento inválida/inexistente", Registro = 1 } },
                    { "MC", new Ocorrencia() { Codigo = "MC", Nivel = 2, Mensagem = "Conta Débito Investimento Inválida/inexistente", Registro = 1 } },
                    { "MD", new Ocorrencia() { Codigo = "MD", Nivel = 2, Mensagem = "Titularidade diferente para tipo de conta", Registro = 1 } },
                    { "ME", new Ocorrencia() { Codigo = "ME", Nivel = 3, Mensagem = "Data de Pagamento Alterada devido a Feriado Local", Registro = 1 } },
                    { "MF", new Ocorrencia() { Codigo = "MF", Nivel = 3, Mensagem = "Alegação Efetuada", Registro = 1 } },
                    { "MG", new Ocorrencia() { Codigo = "MG", Nivel = 2, Mensagem = "Alegação Não Efetuada. Motivo da Alegação/Reconhecimento da Divida Inconsistente.", Registro = 1 } },
                    { "MH", new Ocorrencia() { Codigo = "MH", Nivel = 2, Mensagem = "Autorização Não Efetuada. Código de Reconhecimento da divida não permitido.", Registro = 1 } },
                    { "NC", new Ocorrencia() { Codigo = "NC", Nivel = 2, Mensagem = "Código Identificador Inválido", Registro = 1 } },
                    { "TR", new Ocorrencia() { Codigo = "TR", Nivel = 3, Mensagem = "Ag/ Conta do favorecido alterado por Transferência de agencia.", Registro = 1 } }
                };

                #endregion

                #region Definição de Atributos

                /// <summary>
                /// Representa os atributos das propriedades de classe relacionadas aos registros no arquivo CNAB.
                /// </summary>
                [AttributeUsage(AttributeTargets.Property)]
                private class CNABAtributo : Attribute
                {
                    /// <summary>
                    /// Representa a sequência em que os campos devem aparecer no arquivo CNAB.
                    /// </summary>
                    public int Sequencia { get; set; }

                    /// <summary>
                    /// Representa a expressão regular dos dados usada na validação do registro
                    /// </summary>
                    public string Regex { get; set; }

                    /// <summary>
                    /// Indica se a propriedade faz parte do registro Escritural: Modalidade de Pagamento diferente de 30 - TITULOS BRADESCO
                    /// </summary>
                    public bool Escritural { get; set; }

                    /// <summary>
                    /// Indica se a propriedade faz parte do Registro DDA: Modalidade de Pagamento igual a 30 - TITULOS BRADESCO
                    /// </summary>
                    public bool DDA { get; set; }
                }

                #endregion

                #region Metodos

                #endregion

                #region SubClasses para Cabecalho, Registro e Rodape do Arquivo CNAB

                /// <summary>
                /// Representa um registro dentro do arquivo Remessa/Retorno
                /// </summary>
                public abstract partial class Registro
                {
                    #region Variaveis

                    /// <summary>
                    /// Armazena a linha original do registro extraida do arquivo CNAB para efeito de depuração ou arquivamento para uso futuro.
                    /// </summary>
                    protected string _Registro = "";

                    /// <summary>
                    /// Este dicionário armazena os dados do registro CNAB no formato chave/valor.
                    /// </summary>
                    protected Dictionary<string, string> Dicionario = new Dictionary<string, string>();

                    #endregion

                    #region Construtores

                    public Registro()
                    {
                        Reset();
                    }

                    #endregion

                    #region Metodos

                    /// <summary>
                    /// Carrega as propriedades do Registro com valores padrão
                    /// </summary>
                    public virtual void Reset()
                    {
                        Dicionario.Clear();
                        _Registro = "";

                        var props = from prop in this.GetType().GetProperties()
                                    select prop;

                        PropertyInfo currentProp = null;

                        try
                        {
                            foreach (PropertyInfo p in props)
                            {
                                currentProp = p;
                                p.GetValue(this, null);
                            }
                        }
                        catch (Exception ex)
                        {
                            throw new Exception(currentProp.Name + ":" + ex.Message);
                        }
                    }

                    /// <summary>
                    /// Gera uma coleção com as propriedades da classe
                    /// </summary>
                    /// <returns></returns>
                    public virtual PropertyInfo[] Propriedades()
                    {
                        return GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
                                })
                                .Where(x => !x.Attribute.Escritural)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                                .Select(x => x.Property)
                            //.Select(x => x.Attribute.Regex)
                                .ToArray();
                    }

                    /// <summary>
                    /// Gera a expressão regular utilizada na validação dos campos do registro
                    /// </summary>
                    /// <returns></returns>
                    public virtual string ExpressaoRegular()
                    {
                        string[] Expressao;

                        Expressao = GetType()
                                .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                                .Select(x => new
                                {
                                    Property = x,
                                    Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
                                })
                                .Where(x => !x.Attribute.Escritural)
                                .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                            //.Select(x => x.Property)
                                .Select(x => x.Attribute.Regex)
                                .ToArray();

                        return "^" + String.Join("", Expressao) + "$";
                    }

                    /// <summary>
                    /// Analisa e carrega nas propriedades da classe os valores de cada campo do registro.
                    /// </summary>
                    /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
                    public virtual bool Parse()
                    {
                        Regex regex = new Regex(ExpressaoRegular(), RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture /*| RegexOptions.Multiline*/);

                        Match match = regex.Match(_Registro);  // Analisa 1 registro (linha) por vez

                        if (!match.Success)
                            throw new Exception("Registro CNAB inválido. O dados do registro " + this.GetType().Name + " não estão de acordo com o formato esperado. Registro:[" + _Registro + "], Expressão de Validação:[" + ExpressaoRegular() + "]");

                        Dictionary<string, string> dicionario = regex.GetGroupNames()
                            .Where(name => match.Groups[name].Success && match.Groups[name].Captures.Count > 0 && name != "0" /*&& match.Groups[name].Index > 0*/)
                            .ToDictionary(name => name, name => match.Groups[name].Value);

                        return Parse(dicionario);
                    }

                    /// <summary>
                    /// Analisa e carrega nas propriedades da classe os valores de cada campo do registro.
                    /// </summary>
                    /// <param name="dicionario">Dicionario contendo o par chave/valor a ser carregado para cada propriedade da classe, sendo o chave o nome do propriedade e valor os dados do campo.</param>
                    /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
                    protected virtual bool Parse(Dictionary<string, string> dicionario)
                    {

                        #region Modo 1 - Carrega o Dicionario de Dados com foreach

                        //foreach (string key in Parse.GetGroupNames())
                        //{
                        //    if (key != "0")
                        //        Dicionario[key] = m.Groups[key].Value;
                        //}

                        #endregion

                        #region Modo 2 - Carrega o Dicionario usando Linq:

                        //Registro = Parse.GetGroupNames()
                        //    .Where(name => m.Groups[name].Success)
                        //    .ToDictionary(name => name, name => m.Groups[name].Value);

                        #endregion

                        #region Modo 3 - Carrega via propriedades GET/SET

                        var props = from prop in this.GetType().GetProperties()
                                    select prop;

                        PropertyInfo p = null;
                        PropertyInfo currentProp = null;
                        string currentVal = "";

                        try
                        {
                            Dictionary<string, string>.KeyCollection keys = dicionario.Keys;
                            //foreach (PropertyInfo p in props)
                            foreach (string key in keys.ToArray())
                            {
                                //currentProp = p;
                                currentVal = dicionario[key];
                                p = props.Where(x => x.Name == key).First();

                                if (dicionario.ContainsKey(key) && !String.IsNullOrEmpty(dicionario[key]))
                                    if (p.PropertyType == typeof(string))
                                    {
                                        p.SetValue(this, dicionario[p.Name], null);
                                    }
                                    else if (p.PropertyType == typeof(Int32) || p.PropertyType == typeof(System.Nullable<Int32>))
                                    {
                                        Int32 i;

                                        if (Int32.TryParse(dicionario[p.Name], out i))
                                            p.SetValue(this, i, null);
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else if (p.PropertyType == typeof(uint) || p.PropertyType == typeof(System.Nullable<uint>))
                                    {
                                        uint i;

                                        if (uint.TryParse(dicionario[p.Name], out i))
                                            p.SetValue(this, i, null);
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else if (p.PropertyType == typeof(UInt32) || p.PropertyType == typeof(System.Nullable<UInt32>))
                                    {
                                        UInt32 i;

                                        if (UInt32.TryParse(dicionario[p.Name], out i))
                                            p.SetValue(this, i, null);
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else if (p.PropertyType == typeof(int) || p.PropertyType == typeof(System.Nullable<int>))
                                    {
                                        int i;

                                        if (int.TryParse(dicionario[p.Name], out i))
                                            p.SetValue(this, i, null);
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else if (p.PropertyType == typeof(decimal) || p.PropertyType == typeof(System.Nullable<decimal>))
                                    {
                                        decimal d;

                                        if (dicionario[p.Name].Trim().Length == 0)
                                            p.SetValue(this, null, null);
                                        else if (dicionario[p.Name].ToString().IsNumericArray((uint)dicionario[p.Name].Trim().Length))
                                        {
                                            if (Decimal.TryParse(dicionario[p.Name], out d))
                                                p.SetValue(this, d / 100, null);
                                            else
                                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                                        }
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");

                                    }
                                    else if (p.PropertyType == typeof(DateTime) || p.PropertyType == typeof(System.Nullable<DateTime>))
                                    {
                                        string format = "yyyyMMdd";
                                        DateTime dt;

                                        if (dicionario[p.Name].Trim().Length == 0)
                                        {
                                            p.SetValue(this, null, null);
                                            continue;
                                        }

                                        if (dicionario[p.Name].Trim().Length != 4 && dicionario[p.Name].Trim().Length != 6 && dicionario[p.Name].Trim().Length != 8)
                                            throw new InvalidDataException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");

                                        if (dicionario[p.Name].Trim().Length == 4)
                                            format = "HHmm";

                                        if (dicionario[p.Name].Trim().Length == 6)
                                            format = "HHmmss";

                                        if (DateTime.TryParseExact(dicionario[p.Name], format, null, System.Globalization.DateTimeStyles.None, out dt))
                                            p.SetValue(this, dt, null);
                                        else
                                        {
                                            if (dicionario[p.Name].Trim().CompareTo("".PadLeft(dicionario[p.Name].Trim().Length, '0')) == 0)
                                                p.SetValue(this, null, null);
                                            else
                                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido [" + format + "]: '" + dicionario[p.Name] + "'");
                                        }
                                    }
                                    else if (p.PropertyType.IsEnum || Nullable.GetUnderlyingType(p.PropertyType).IsEnum)
                                    {
                                        if (dicionario[p.Name].Trim().Length == 0)
                                            p.SetValue(this, null, null);
                                        //else if (dicionario[p.Name].Trim().CompareTo("".PadLeft(dicionario[p.Name].Trim().Length, '0')) == 0)
                                        //    p.SetValue(this, null, null);
                                        else if (dicionario[p.Name].Trim().Length > 0 && dicionario[p.Name].Trim().IsNumericArray((uint)dicionario[p.Name].Trim().Length))
                                        {
                                            try
                                            {
                                                if (Nullable.GetUnderlyingType(p.PropertyType) != null)
                                                    p.SetValue(this, Enum.Parse(Nullable.GetUnderlyingType(p.PropertyType), dicionario[p.Name].Trim(), true), null);
                                                else
                                                    p.SetValue(this, Enum.Parse(p.PropertyType, dicionario[p.Name].Trim(), true), null);
                                            }
                                            catch
                                            {
                                                p.SetValue(this, null, null);
                                            }
                                        }
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " é inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else if (Nullable.GetUnderlyingType(p.PropertyType) == typeof(CNAB.Ocorrencia) || p.PropertyType == typeof(System.Nullable<CNAB.Ocorrencia>))
                                    {
                                        if (dicionario[p.Name].Trim().Length == 0)
                                            p.SetValue(this, null, null);
                                        else if (CNAB.Ocorrencias.ContainsKey(dicionario[p.Name]))
                                            p.SetValue(this, CNAB.Ocorrencias[dicionario[p.Name]], null);
                                        else
                                            throw new ArgumentException("O valor para " + currentProp.Name + " é inválido: '" + dicionario[p.Name] + "'");
                                    }
                                    else
                                        throw new ArgumentException("Tipo desconhecido " + p.PropertyType.ToString() + " para a propriedade " + p.Name);
                                else
                                    throw new ArgumentException("O registro não tem o valor para " + currentProp.Name);
                            }
                        }
                        catch (ArgumentException a)
                        {
                            throw new ArgumentException((currentProp != null ? currentProp.Name : "") + " = [" + currentVal + "]:" + a.Message);
                        }
                        catch (Exception ex)
                        {
                            throw new Exception((currentProp != null ? currentProp.Name : "") + ":" + ex.Message);
                        }

                        #endregion

                        return true;
                    }

                    /// <summary>
                    /// Gerar registro CNAB
                    /// </summary>
                    /// <param name="Stream">Fluxo de dados onde será escrito o registro</param>
                    /// <returns>Retorna verdadeiro se o registro for gerado com sucesso.</returns>
                    public virtual bool Write(StreamWriter Stream)
                    {
                        StringBuilder s = new StringBuilder();

                        var props = from prop in this.GetType().GetProperties()
                                    select prop;

                        PropertyInfo currentProp = null;
                        try
                        {
                            foreach (PropertyInfo p in props)
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

                /// <summary>
                /// Representa o Cabecalho do Arquivo padrão CNAB do Bradesco
                /// </summary>
                /// <remarks>O sistema exige um header por Empresa/Filial. Na remessa (Empresa  Banco) para autorizações, alterações ou desautorizações de agendamentos de pagamentos, a empresa deverá gerar um arquivo mantendo a estrutura descrita nas páginas 17 e 18.</remarks>
                public partial class Cabecalho : Registro
                {
                    #region Variaveis

                    #endregion

                    #region Propriedades

                    /// <summary>
                    /// Identificação do Registro. Identificao o Tipo de Registro. Obrigatório – fixo “zero”(0).
                    /// </summary>
                    [CNABAtributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>0)")]
                    public CNAB.TIPO_REGISTRO TIPO_REGISTRO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)CNAB.TIPO_REGISTRO.CABECALHO).ToString().Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                                .Cast<CNAB.TIPO_REGISTRO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// Identificação da empresa no Banco - Será fornecido pelo Banco previamente à implantação. É único e constante para todas as empresas do Grupo, quando o processamento for centralizado. Se o processamento for descentralizado, por exemplo, por região, poderá ser fornecido um código para cada centro processador, desde que possuam CNPJ’s diferentes. Obrigatório – fixo.
                    /// </summary>
                    [CNABAtributo(Sequencia = 1, Regex = @"(?<CODIGO_COMUNICACAO>\d{8})")]
                    public string CODIGO_COMUNICACAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)] = "".PadLeft(8, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)].ToString().PadLeft(8, '0').Substring(0, 8);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(8, '0').IsNumericArray(8))
                                throw new ArgumentException("Codigo de Comunicação deve ter 8 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)] = value.Trim().PadLeft(8, '0').Substring(0, 8);
                        }
                    }

                    /// <summary>
                    /// Tipo de Inscrição da Empresa Pagadora. 1 = CPF / 2 = CNPJ / 3= OUTROS. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 2, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                    public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                            //return Dicionario[SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.DADOS.TIPO_INSCRICAO.ToString()].ToString().Substring(0, 1);
                            return Enum.GetValues(typeof(CNAB.TIPO_INSCRICAO))
                                .Cast<CNAB.TIPO_INSCRICAO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 3, Regex = @"(?<CNPJ>\d{9})")]
                    public string CNPJ
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = "".PadLeft(9, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)].ToString().PadLeft(9, '0').Substring(0, 9);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(9, '0').IsNumericArray(9))
                                throw new ArgumentException("CNPJ deve ter 9 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = value.Trim().PadLeft(9, '0').Substring(0, 9);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Filial. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 4, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
                    public string CNPJ_FILIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = "".PadLeft(4, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)].ToString().PadLeft(4, '0').Substring(0, 4);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                                throw new ArgumentException("Filial deve ter 4 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Digito de Verificação. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 5, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
                    public string CNPJ_DIGITO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = "".PadLeft(2, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)].ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                                throw new ArgumentException("Controle deve ter 2 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo.
                    /// </summary>
                    [CNABAtributo(Sequencia = 6, Regex = @"(?<NOME_EMPRESA>.{40})")]
                    public string NOME_EMPRESA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)] = "".PadRight(40, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)].ToString().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                        }
                        set
                        {
                            if (value.Trim().Length < 5 || value.Trim().Length > 40)
                                throw new ArgumentException("Nome da Empresa deve ter no mínimo 5 e no máximo 40 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                        }
                    }

                    /// <summary>
                    /// Tipo de Serviço. Obrigatório - Fixo “20” = PAGTO FORNECEDORES
                    /// </summary>
                    [CNABAtributo(Sequencia = 7, Regex = @"(?<TIPO_SERVICO>20)")]
                    public CNAB.TIPO_SERVICO TIPO_SERVICO 
                    { 
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_SERVICO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_SERVICO)] = ((int)CNAB.TIPO_SERVICO.PAGAMENTO_FORNECEDOR).ToString().PadLeft(2, '0').Substring(0, 2);

                            return Enum.GetValues(typeof(CNAB.TIPO_SERVICO))
                                .Cast<CNAB.TIPO_SERVICO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_SERVICO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_SERVICO)] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// <para>Código de origem do arquivo. 1 – Origem no Cliente, 2 – Origem no Banco. Obrigatório - Fixo “1”.</para>
                    /// <para>Código 1 - Constará do arquivo-retorno - Confirmação de agendamento</para>
                    /// <para>Código 2 - Constará do arquivo-retorno - Rastreamento da Cobrança Bradesco e confirmação de pagamentos</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 8, Regex = @"(?<ORIGEM_ARQUIVO>1|2)")]
                    public CNAB.ORIGEM_ARQUIVO ORIGEM_ARQUIVO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ORIGEM_ARQUIVO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ORIGEM_ARQUIVO)] = ((int)CNAB.ORIGEM_ARQUIVO.ORIGEM_NO_CLIENTE).ToString().PadLeft(1, '0').Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.ORIGEM_ARQUIVO))
                                .Cast<CNAB.ORIGEM_ARQUIVO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ORIGEM_ARQUIVO)]))
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ORIGEM_ARQUIVO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// Sequencial crescente para cada remessa no dia, que deverá ser controlado pelo cliente. Deve ser o mesmo para todos os header’s de um mesmo trailler. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 9, Regex = @"(?<NUMERO_REMESSA>\d{5})")]
                    public string NUMERO_REMESSA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_REMESSA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_REMESSA)] = "".PadLeft(5, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_REMESSA)].ToString().PadLeft(5, '0').Substring(0, 5);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                                throw new ArgumentException("Numero Remessa deve ter 5 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_REMESSA)] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// <para>Número do retorno. Controlado pelo Banco. Campo válido somente para o arquivo-retorno.</para> 
                    /// <para>O número do retorno é gerado através de um número sequencial iniciado em 1 e incrementado de 1 a cada arquivo originado da rotina PFEB, ou seja, apenas no rastreamento da Cobrança Bradesco e na confirmação de pagamentos.</para>
                    /// <para>No arquivo de confirmação de agendamentos é devolvido o mesmo conteúdo enviado pela empresa ou zeros quando o campo não for numérico.</para>
                    /// <remarks>Este número não deverá ser utilizado pelo cliente para controles internos, haja vista ocorrer variações nesta numeração, temporariamente sem prévio aviso.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 10, Regex = @"(?<NUMERO_RETORNO>\d{5})")]
                    public string NUMERO_RETORNO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_RETORNO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_RETORNO)] = "".PadLeft(5, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_RETORNO)].ToString().PadLeft(5, '0').Substring(0, 5);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                                throw new ArgumentException("Numero Retorno deve ter 5 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_RETORNO)] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// Data da gravação do arquivo no formato AAAAMMDD. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 11, Regex = @"(?<DATA_ARQUIVO>\d{8})")]
                    public DateTime DATA_ARQUIVO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_ARQUIVO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_ARQUIVO)] = DateTime.Now.ToString("yyyyMMdd");

                            DateTime dt;

                            DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_ARQUIVO)], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                            return dt;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_ARQUIVO)] = value.ToString("yyyyMMdd");
                        }
                    }

                    /// <summary>
                    /// Hora da gravação do arquivo no formato HHMMSS. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 12, Regex = @"(?<HORA_ARQUIVO>\d{6})")]
                    public DateTime HORA_ARQUIVO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORA_ARQUIVO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORA_ARQUIVO)] = DateTime.Now.ToString("HHmmss");

                            DateTime h;

                            DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORA_ARQUIVO)], "HHmmss", null, System.Globalization.DateTimeStyles.None, out h);

                            return h;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORA_ARQUIVO)] = value.ToString("HHmmss");
                        }
                    }

                    /// <summary>
                    /// Densidade de gravação do arquivo/fita. Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 13, Regex = @"(?<DENSIDADE_GRAVACAO>.{5})")]
                    public string DENSIDADE_GRAVACAO 
                    { 
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DENSIDADE_GRAVACAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DENSIDADE_GRAVACAO)] = "".PadRight(5, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DENSIDADE_GRAVACAO)].PadRight(5, ' ').Substring(0, 5);
                        }
                        set
                        {
                            if (value.Trim().Length > 5)
                                throw new ArgumentException("Densidade de Gravacao deve ter até 5 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DENSIDADE_GRAVACAO)] = value.Trim().PadRight(5, ' ').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// Unidade de densidade da gravação do arquivo/fita. Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 14, Regex = @"(?<UNIDADE_DENSIDADE>.{3})")]
                    public string UNIDADE_DENSIDADE
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.UNIDADE_DENSIDADE)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.UNIDADE_DENSIDADE)] = "".PadRight(3, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.UNIDADE_DENSIDADE)].PadRight(3, ' ').Substring(0, 3).Trim();
                        }
                        set
                        {
                            if (value.Trim().Length > 3)
                                throw new ArgumentException("Unidade de Densidade de Gravacao deve ter até 3 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.UNIDADE_DENSIDADE)] = value.Trim().PadRight(3, ' ').Substring(0, 3);
                        }
                    }

                    /// <summary>
                    /// Identificação Módulo Micro. Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 15, Regex = @"(?<IDENTIFICACAO_MODULO>.{5})")]
                    public string IDENTIFICACAO_MODULO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.IDENTIFICACAO_MODULO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.IDENTIFICACAO_MODULO)] = "".PadRight(5, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.IDENTIFICACAO_MODULO)].PadRight(5, ' ').Substring(0, 5);
                        }
                        set
                        {
                            if (value.Length > 5)
                                throw new ArgumentException("Identificação do Modulo deve ter até 5 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.IDENTIFICACAO_MODULO)] = value.PadRight(5, ' ').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// <para>Tipo de Processamento. Campo válido somente para o arquivo-retorno. Para todas as modalidades, o sistema gera diariamente 2 (dois) tipos de arquivos-retorno, exceto para a modalidade 30 - Cobrança Bradesco, na qual são gerados 3 (três) tipos, ou seja:</para>
                    /// <para>1 = Rastreamento da Cobrança Bradesco/Rastreamento DDA / Cheque estornado e DOC COMPE devolvido</para>
                    /// <para>2 = Confirmação de Agendamento/Inconsistência</para>
                    /// <para>3 = Confirmação de Pagamento/Pagamento não efetuado</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 16, Regex = @"(?<TIPO_PROCESSAMENTO>0|1|2|3)")]
                    public CNAB.TIPO_PROCESSAMENTO TIPO_PROCESSAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)] = ((int)CNAB.TIPO_PROCESSAMENTO.DESCONSIDERADO).ToString();

                            //return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)].ToString().Substring(0, 1);
                            return Enum.GetValues(typeof(CNAB.TIPO_PROCESSAMENTO))
                                .Cast<CNAB.TIPO_PROCESSAMENTO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// Reservado para uso da empresa. Variavel - Opcional.
                    /// </summary>
                    [CNABAtributo(Sequencia = 17, Regex = @"(?<RESERVADO_USO_EMPRESA>.{74})")]
                    public string RESERVADO_USO_EMPRESA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)] = "".PadRight(74, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)].PadRight(74, ' ').Substring(0, 74);
                        }
                        set
                        {
                            if (value.Length > 74)
                                throw new ArgumentException("Uso Empresa deve ter até 74 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)] = value.PadRight(74, ' ').Substring(0, 74);
                        }
                    }

                    /// <summary>
                    /// Posição 181 A 260. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 18, Regex = @"(?<RESERVADO_USO_BANCO_1>.{80})")]
                    public string RESERVADO_USO_BANCO_1
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)] = "".PadRight(80, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)].PadRight(80, ' ').Substring(0, 80);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)] = value.PadRight(80, ' ').Substring(0, 80);
                        }
                    }

                    /// <summary>
                    /// Posição 261 A 477. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 19, Regex = @"(?<RESERVADO_USO_BANCO_2>.{217})")]
                    public string RESERVADO_USO_BANCO_2
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)] = "".PadRight(217, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)].PadRight(217, ' ').Substring(0, 217);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)] = value.PadRight(217, ' ').Substring(0, 217);
                        }
                    }

                    /// <summary>
                    /// Número da Lista de Débito. O número da Lista de Débito deve ser Sequencial crescente e em hipótese alguma pode ser repetido. 
                    /// </summary>
                    /// <remarks>No documento de especificação fornecido pelo Banco este campo é numérico portanto deveria ser preenchido com zeros a esquerda, mas conforme arquivo de remessa do PagFor este campo é preechido com espaços. Segundo orientação do suporte este campo deve ter espaços contradizendo o documento de especificação do layout do arquivo CNAB.</remarks>
                    [CNABAtributo(Sequencia = 20, Regex = @"(?<NUMERO_LISTA_DEBITO>.{9})")]
                    public string NUMERO_LISTA_DEBITO 
                    { 
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_LISTA_DEBITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_LISTA_DEBITO)] = "".PadRight(9, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_LISTA_DEBITO)].PadRight(9, ' ').Substring(0, 9);
                        }
                        set
                        {
                            if (value.Length > 9)
                                throw new ArgumentException("Número da Lista de Débito deve ter no máximo 9 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_LISTA_DEBITO)] = value.PadRight(9, ' ').Substring(0, 9);
                        }
                    }

                    /// <summary>
                    /// Posição 487 A 494. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 21, Regex = @"(?<RESERVADO_USO_BANCO_3>.{8})")]
                    public string RESERVADO_USO_BANCO_3
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)] = "".PadRight(8, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)].PadRight(8, ' ').Substring(0, 8);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)] = value.PadRight(8, ' ').Substring(0, 8);
                        }
                    }

                    /// <summary>
                    /// Número Sequencial do Registro. Sequencial crescente de 1 a 1 no arquivo. O primeiro header será sempre 000001. Obrigatório.
                    /// </summary>
                    [CNABAtributo(Sequencia = 22, Regex = @"(?<NUMERO_SEQUENCIAL>000001)")]
                    public UInt32 NUMERO_SEQUENCIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = "1".PadLeft(6, '0');

                            return UInt32.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)]);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = ((int)value).ToString().PadLeft(6, '0').Substring(0, 6);
                        }
                    }

                    #endregion

                    #region Construtores

                    /// <summary>
                    /// Construtor da classe
                    /// </summary>
                    public Cabecalho()
                    {
                        Reset();
                    }

                    /// <summary>
                    /// Construtor da classe
                    /// </summary>
                    /// <param name="Registro"></param>
                    public Cabecalho(string Registro)
                    {
                        this._Registro = Registro;

                        Parse();
                    }

                    /// <summary>
                    /// Construtor da classe
                    /// </summary>
                    /// <param name="CODIGO_COMUNICACAO"></param>
                    /// <param name="TIPO_INSCRICAO"></param>
                    /// <param name="CNPJ"></param>
                    /// <param name="CNPJ_FILIAL"></param>
                    /// <param name="CNPJ_DIGITO"></param>
                    /// <param name="NOME_EMPRESA"></param>
                    /// <param name="NUMERO_REMESSA"></param>
                    public Cabecalho(
                        string CODIGO_COMUNICACAO, 
                        CNAB.TIPO_INSCRICAO TIPO_INSCRICAO, 
                        string CNPJ, 
                        string CNPJ_FILIAL, 
                        string CNPJ_DIGITO, 
                        string NOME_EMPRESA, 
                        string NUMERO_REMESSA)
                    {
                        Reset();

                        this.CODIGO_COMUNICACAO = CODIGO_COMUNICACAO;
                        this.TIPO_INSCRICAO = TIPO_INSCRICAO;
                        this.CNPJ = CNPJ;
                        this.CNPJ_FILIAL = CNPJ_FILIAL;
                        this.CNPJ_DIGITO = CNPJ_DIGITO;
                        this.NOME_EMPRESA = NOME_EMPRESA;
                        this.NUMERO_REMESSA = NUMERO_REMESSA;
                        this.DATA_ARQUIVO = DateTime.Now;
                        this.HORA_ARQUIVO = DATA_ARQUIVO;
                    }

                    #endregion

                    #region Metodos

                    #endregion
                }

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
                    [CNABAtributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>1)")]
                    public CNAB.TIPO_REGISTRO TIPO_REGISTRO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)CNAB.TIPO_REGISTRO.TRANSACAO).ToString().Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                                .Cast<CNAB.TIPO_REGISTRO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)])
                                .First();
                        }
                        protected set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// Tipo de Inscrição do Fornecedor. 1 = CPF, 2 = CNPJ ou 3 = OUTROS. Se for 3 = outros, o campo a seguir deverá ser preenchido com qualquer número diferente de zero e não será consistido pelo Banco. Obrigatório – variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 1, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                    public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.TIPO_INSCRICAO))
                                .Cast<CNAB.TIPO_INSCRICAO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF Base do fornecedor. Para as modalidades 01 e 05, o CNPJ/CPF poderá ser validado contra o cadastro de clientes do Banco, ou ser rejeitado e utilizado o do Banco, de acordo com o contratado no convênio. Para a modalidade 30 – será fornecido pelo Banco no arquivo de rastreamento. Para as demais modalidades - obrigatório variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 2, Regex = @"(?<CNPJ>\d{9})")]
                    public string CNPJ
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = "".PadLeft(9, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)].ToString().PadLeft(9, '0').Substring(0, 9);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(9, '0').IsNumericArray(9))
                                throw new ArgumentException("CNPJ deve ter 9 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = value.Trim().PadLeft(9, '0').Substring(0, 9);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Filial. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 3, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
                    public string CNPJ_FILIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = "".PadLeft(4, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)].ToString().PadLeft(4, '0').Substring(0, 4);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                                throw new ArgumentException("Filial deve ter 4 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Digito de Verificacao. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 4, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
                    public string CNPJ_DIGITO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = "".PadLeft(2, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)].ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                                throw new ArgumentException("Controle deve ter 2 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// Nome do Fornecedor. Razão social do fornecedor. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 5, Regex = @"(?<NOME_FORNECEDOR>.{30})")]
                    public string NOME_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_FORNECEDOR)] = "".PadRight(30, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_FORNECEDOR)].ToString().ReplaceExtendedChars().ToUpper().PadRight(30, ' ').Substring(0, 30).Trim();
                        }
                        set
                        {
                            if (value.Trim().Length < 5 || value.Trim().Length > 30)
                                throw new ArgumentException("Nome do Fornecedor deve ter no mínimo 5 e no máximo 30 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_FORNECEDOR)] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(30, ' ').Substring(0, 30);
                        }
                    }

                    /// <summary>
                    /// Endereço do Fornecedor. Nome da rua/Av - Número. 
                    /// <para>Modalidade 01 - Crédito em Conta Corrente no Bradesco, os campos referentes a essas posições poderão ser obtidos a partir do cadastro de clientes do Banco, ou o sistema efetuar a consistência do conteúdo no arquivo-remessa, cujas condições dependerão de cadastramento prévio no sistema do Banco - campos obrigatórios - variáveis.</para>
                    /// <para>Modalidades 02 - Cheque Ordem de Pagamento são campos obrigatórios - variáveis.</para>
                    /// <para>Modalidade 30 - Cobrança Bradesco, essas informações constarão do arquivo de rastreamento.</para>
                    /// <para>Para as demais modalidades, esses campos não serão consistidos - opcional. O sistema sempre assumirá os dados recebidos no arquivo-remessa, haja vista não emitir aviso de crédito ao fornecedor.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 6, Regex = @"(?<ENDERECO_FORNECEDOR>.{40})")]
                    public string ENDERECO_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_FORNECEDOR)] = "".PadRight(40, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_FORNECEDOR)].ToString().Trim().Length == 0)
                                return null;
                            else
                                return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_FORNECEDOR)].ToString().Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                        }
                        set
                        {
                            if (value.Trim().Length > 0 && (value.Trim().Length < 5 || value.Trim().Length > 40))
                                throw new ArgumentException("Endereço deve ter no mínimo 5 e no máximo 40 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_FORNECEDOR)] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                        }
                    }

                    /// <summary>
                    /// CEP do fornecedor. 
                    /// </summary>
                    [CNABAtributo(Sequencia = 7, Regex = @"(?<CEP_PREFIXO>\d{5})")]
                    public string CEP_PREFIXO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_PREFIXO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_PREFIXO)] = "".PadLeft(5, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_PREFIXO)].ToString().PadLeft(5, '0').Substring(0, 5);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                                throw new ArgumentException("CEP Prefixo deve ter 5 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_PREFIXO)] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// Complemento do CEP.
                    /// </summary>
                    [CNABAtributo(Sequencia = 8, Regex = @"(?<CEP_COMPLEMENTO>\d{3})")]
                    public string CEP_COMPLEMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_COMPLEMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_COMPLEMENTO)] = "".PadLeft(3, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_COMPLEMENTO)].ToString().PadLeft(3, '0').Substring(0, 3);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(3, '0').IsNumericArray(3))
                                throw new ArgumentException("CEP Complemento deve ter 5 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CEP_COMPLEMENTO)] = value.Trim().PadLeft(3, '0').Substring(0, 3);
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
                    [CNABAtributo(Sequencia = 9, Regex = @"(?<BANCO_FORNECEDOR>000|237{3})")]
                    public Bancos.CODIGO? BANCO_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)] = "".PadLeft(3, '0');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)] == "".PadLeft(3, '0'))
                                return null;

                            return Enum.GetValues(typeof(Bancos.CODIGO))
                                .Cast<Bancos.CODIGO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)]))
                                .First();
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)] = ((int)value.Value).ToString().PadLeft(3, '0').Substring(0, 3);
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.BANCO_FORNECEDOR)] = "".PadLeft(3, '0');
                        }
                    }

                    /// <summary>
                    /// Código da agência do fornecedor.
                    /// </summary>
                    [CNABAtributo(Sequencia = 10, Regex = @"(?<AGENCIA_FORNECEDOR>\d{5})")]
                    public string AGENCIA_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR)] = "".PadLeft(5, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR)].ToString().PadLeft(5, '0').Substring(0, 5);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                                throw new ArgumentException("Código da Agência deve ter 5 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR)] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                        }
                    }

                    /// <summary>
                    /// Dígito da agência do fornecedor.
                    /// </summary>
                    [CNABAtributo(Sequencia = 11, Regex = @"(?<AGENCIA_FORNECEDOR_DIGITO>.)")]
                    public string AGENCIA_FORNECEDOR_DIGITO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR_DIGITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR_DIGITO)] = "".PadLeft(1, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR_DIGITO)].ToString().Substring(0, 1);
                        }
                        set
                        {
                            if (value.Trim().Length > 1)
                                throw new ArgumentException("Digito do Código da Agência deve ter 1 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.AGENCIA_FORNECEDOR_DIGITO)] = value.Trim().PadLeft(1, ' ').Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// Conta-Corrente do fornecedor.
                    /// </summary>
                    [CNABAtributo(Sequencia = 12, Regex = @"(?<CONTA_FORNECEDOR>\d{13})")]
                    public string CONTA_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR)] = "".PadLeft(13, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR)].ToString().ToString().PadLeft(13, '0').Substring(0, 13);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(13, '0').Substring(0, 13).IsNumericArray(13))
                                throw new ArgumentException("Conta Corrente deve ter 13 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR)] = value.Trim().PadLeft(13, '0').Substring(0, 13);
                        }
                    }

                    /// <summary>
                    /// Dígito da conta do fornecedor.
                    /// </summary>
                    [CNABAtributo(Sequencia = 13, Regex = @"(?<CONTA_FORNECEDOR_DIGITO>.{2})")]
                    public string CONTA_FORNECEDOR_DIGITO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR_DIGITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR_DIGITO)] = "".PadLeft(2, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR_DIGITO)].ToString().PadLeft(2, ' ').Substring(0, 2);
                        }
                        set
                        {
                            if (value.Length > 2)
                                throw new ArgumentException("Digito da Conta Corrente do Fornecedor deve ter até 2 digitos.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_FORNECEDOR_DIGITO)] = value.PadLeft(2, ' ').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// Número do Pagamento. É utilizado para identificar o pagamento a ser efetuado, alterado ou excluído. Individualiza o pagamento e não pode se repetir. Gerado pelo cliente pagador quando do agendamento de pagamento por parte desse, exceto para a modalidade 30 - Títulos em Cobrança Bradesco, que é fornecido pelo Banco quando da geração do arquivo de rastreamento, o qual deverá ser mantido e informado quando da autorização de 29 agendamento, alteração ou exclusão.Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 14, Regex = @"(?<NUMERO_PAGAMENTO>.{16})")]
                    public string NUMERO_PAGAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_PAGAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_PAGAMENTO)] = "".PadRight(16, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_PAGAMENTO)].ToString().PadRight(16, ' ').Substring(0, 16);
                        }
                        set
                        {
                            if (value.Trim().Trim().Length > 16)
                                throw new Exception("O Número do Pagamento deve ser 16 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_PAGAMENTO)] = value.PadRight(16, ' ').Substring(0, 16);
                        }
                    }

                    /// <summary>
                    /// <para>Carteira. Exclusivo para boleto da Cobrança Bradesco para as modalidades 30 e 31.</para>
                    /// <para>MODALIDADE - 31 – Obrigatória somente para Banco igual a 237 (Bradesco), e deve ser extraído do Código de Barras ou Linha Digitável conforme roteiro da página 36. Para os demais Bancos, preencher com zeros.</para>
                    /// <para>MODALIDADE - 30 – Consta do arquivo de rastreamento.</para>
                    /// <para>DEMAIS MODALIDADES - Fixo zeros.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 15, Regex = @"(?<CARTEIRA>\d{3})")]
                    public string CARTEIRA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CARTEIRA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CARTEIRA)] = "".PadLeft(3, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CARTEIRA)].ToString().PadLeft(3, '0').Substring(0, 3);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(3, '0').IsNumericArray(3))
                                throw new ArgumentException("Carteira deve ser 3 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CARTEIRA)] = value.Trim().PadLeft(3, '0').Substring(0, 3);
                        }
                    }

                    /// <summary>
                    /// Nosso Número.
                    /// <para>MODALIDADE – 31 - Obrigatório somente quando o banco for igual a 237 (Bradesco), e deve ser extraído do Código de Barras ou Linha Digitável. Para os demais Bancos, preencher com zeros</para>
                    /// <para>DEMAIS MODALIDADES - Fixo zeros</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 16, Regex = @"(?<NOSSO_NUMERO>\d{12})")]
                    public string NOSSO_NUMERO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOSSO_NUMERO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOSSO_NUMERO)] = "".PadRight(12, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOSSO_NUMERO)].ToString().PadLeft(12, '0').Substring(0, 12);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(12, '0').IsNumericArray(12))
                                throw new ArgumentException("Nosso Número deve ser 12 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOSSO_NUMERO)] = value.Trim().PadLeft(12, '0').Substring(0, 12);
                        }
                    }

                    /// <summary>
                    /// Seu Número. Exclusivo para modalidade 30 – título rastreado.
                    /// </summary>
                    [CNABAtributo(Sequencia = 17, Regex = @"(?<SEU_NUMERO>.{15})")]
                    public string SEU_NUMERO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SEU_NUMERO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SEU_NUMERO)] = "".PadRight(15, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SEU_NUMERO)].PadRight(15, ' ').Substring(0, 15);
                        }
                        set
                        {
                            if (value.Trim().Length > 15)
                                throw new ArgumentException("Seu Número deve ter no máximo 15 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SEU_NUMERO)] = value.PadRight(15, ' ').Substring(0, 15);
                        }
                    }

                    /// <summary>
                    /// Data de Vencimento no formato AAAAMMDD.
                    /// <para>Modalidade 31 – prevalece o fator de Vencimento da posição 191 a 194, e na ausência, a data de vencimento passa a ser obrigatório.</para>
                    /// <para>Demais modalidades - Obrigatório – variável, não deve ser inferior a data do pagamento.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 18, Regex = @"(?<DATA_VENCIMENTO>\d{8})")]
                    public DateTime DATA_VENCIMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_VENCIMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_VENCIMENTO)] = "".PadLeft(8, '0');

                            DateTime dt;

                            DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_VENCIMENTO)], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                            return dt;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_VENCIMENTO)] = value.ToString("yyyyMMdd");
                        }
                    }

                    /// <summary>
                    /// Data de Emissão do documento no formato AAAAMMDD. Opcional para todas as modalidades. Fixo zeros
                    /// </summary>
                    [CNABAtributo(Sequencia = 19, Regex = @"(?<DATA_EMISSAO>\d{8})")]
                    public DateTime? DATA_EMISSAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_EMISSAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_EMISSAO)] = "".PadLeft(8, '0');

                            DateTime dt;

                            if (!DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_EMISSAO)], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt))
                                return null;

                            return dt;
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_EMISSAO)] = value.Value.ToString("yyyyMMdd");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_EMISSAO)] = "".PadLeft(8, '0');
                        }
                    }

                    /// <summary>
                    /// Data Limite para Desconto no formato AAAAMMDD. Obrigatório, quando informado valor do Desconto.
                    /// </summary>
                    [CNABAtributo(Sequencia = 20, Regex = @"(?<DATA_LIMITE_DESCONTO>\d{8})")]
                    public DateTime? DATA_LIMITE_DESCONTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_LIMITE_DESCONTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_LIMITE_DESCONTO)] = "".PadLeft(8, '0');

                            DateTime dt;

                            if (!DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_LIMITE_DESCONTO)], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt))
                                return null;

                            return dt;
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_LIMITE_DESCONTO)] = value.Value.ToString("yyyyMMdd");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_LIMITE_DESCONTO)] = "".PadLeft(8, '0');
                        }
                    }

                    /// <summary>
                    /// Campo fixo zero. Desconsiderar
                    /// </summary>
                    [CNABAtributo(Sequencia = 21, Regex = @"(?<ZERO_FIXO>0)")]
                    public string ZERO_FIXO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ZERO_FIXO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ZERO_FIXO)] = "0";

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ZERO_FIXO)];
                        }
                        protected set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ZERO_FIXO)] = "0";
                        }
                    }

                    /// <summary>
                    /// Fator de Vencimento. Será informado o fator de vencimento enviado no arquivo remessa. Refere-se a posição 6 a 9 do código de barras ou os 4 (quatro) primeiros caracteres do 5º campo da Linha Digitável, quando diferente de zeros.
                    /// </summary>
                    [CNABAtributo(Sequencia = 22, Regex = @"(?<FATOR_VENCIMENTO>\d{4})")]
                    public string FATOR_VENCIMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.FATOR_VENCIMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.FATOR_VENCIMENTO)] = "".PadLeft(4, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.FATOR_VENCIMENTO)].ToString().PadLeft(4, '0').Substring(0, 4);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                                throw new ArgumentException("Fator Vencimento deve ser 4 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.FATOR_VENCIMENTO)] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                        }
                    }

                    /// <summary>
                    /// Valor do Documento. 
                    /// <para>MODALIDADE - 31. Deve ser informado o valor constante do código de barras ou da Linha Digitável, inclusive, se o valor for igual a zero, independente do valor a ser pago. Obrigatório – variável</para>
                    /// <para>PARA MODALIDADE - 30. Consta do arquivo de rastreamento</para>
                    /// <para>DEMAIS MODALIDADES - Opcional, se não houver valor do desconto ou valor do acréscimo.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 23, Regex = @"(?<VALOR_DOCUMENTO>\d{10})")]
                    public decimal VALOR_DOCUMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DOCUMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DOCUMENTO)] = "".PadLeft(10, '0');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DOCUMENTO)]))
                                return 0;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DOCUMENTO)], out d))
                                return 0;

                            return d / 100;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DOCUMENTO)] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(10, '0');
                        }
                    }

                    /// <summary>
                    /// Valor do pagamento. 
                    /// <para>Deve ser igual ao valor do documento, menos o Valor do Desconto ou mais Acréscimo, se houver. Se o Valor do documento (195 à 204) for zero, deverá ser informado o valor do pagamento. Obrigatório.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 24, Regex = @"(?<VALOR_PAGAMENTO>\d{15})")]
                    public decimal VALOR_PAGAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_PAGAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_PAGAMENTO)] = "".PadLeft(15, '0');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_PAGAMENTO)]))
                                return 0;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_PAGAMENTO)], out d))
                                return 0;

                            return d / 100;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_PAGAMENTO)] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                        }
                    }

                    /// <summary>
                    /// Valor do Desconto. Deve ser igual ao Valor do Documento, menos o Valor do Pagamento, exceto se o Valor do Documento for igual a zeros. Obrigatório.
                    /// </summary>
                    [CNABAtributo(Sequencia = 25, Regex = @"(?<VALOR_DESCONTO>\d{15})")]
                    public decimal VALOR_DESCONTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DESCONTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DESCONTO)] = "".PadLeft(15, '0');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DESCONTO)]))
                                return 0;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DESCONTO)], out d))
                                return 0;

                            return d / 100;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_DESCONTO)] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                        }
                    }

                    /// <summary>
                    /// Valor do Acréscimo. Deve ser igual ao Valor do Pagamento, menos o Valor do Documento, exceto se o Valor do Documento for igual a zero. Obrigatório.
                    /// </summary>
                    [CNABAtributo(Sequencia = 26, Regex = @"(?<VALOR_ACRESCIMO>\d{15})")]
                    public decimal VALOR_ACRESCIMO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_ACRESCIMO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_ACRESCIMO)] = "".PadLeft(15, '0');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_ACRESCIMO)]))
                                return 0;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_ACRESCIMO)], out d))
                                return 0;

                            return d / 100;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_ACRESCIMO)] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
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
                    [CNABAtributo(Sequencia = 27, Regex = @"(?<TIPO_DOCUMENTO>01|02|03|04|05)")]
                    public CNAB.TIPO_DOCUMENTO TIPO_DOCUMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_DOCUMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_DOCUMENTO)] = ((int)CNAB.TIPO_DOCUMENTO.OUTROS).ToString().PadLeft(2, '0').Substring(0, 2);

                            //return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_DOCUMENTO)].ToString().PadLeft(2, '0').Substring(0, 2);
                            return Enum.GetValues(typeof(CNAB.TIPO_DOCUMENTO))
                                .Cast<CNAB.TIPO_DOCUMENTO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_DOCUMENTO)]))
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_DOCUMENTO)] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// <para>Número Nota Fiscal/Fatura/Duplicata. Se o tipo de Documento no campo anterior for igual a 1 ou 3, este campo passa a ser numérico – obrigatório.</para>
                    /// <remarks>Informado na modalidade: 01 - Crédito em Conta Corrente e constará no campo número do documento do aviso de crédito ao Fornecedor, obrigatório quando o Tipo do documento for igual a 1 ou 3.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 28, Regex = @"(?<NUMERO_NOTA_FISCAL>.{10})")]
                    public string NUMERO_NOTA_FISCAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_NOTA_FISCAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_NOTA_FISCAL)] = "".PadRight(10, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_NOTA_FISCAL)].PadRight(10, ' ').Substring(0, 10);
                        }
                        set
                        {
                            if (value.Length > 10)
                                throw new ArgumentException("Número da Nota Fiscal deve ter até 10 digitos.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_NOTA_FISCAL)] = value.PadRight(15, ' ').Substring(0, 10);
                        }
                    }

                    /// <summary>
                    /// Série Documento. Opcional.
                    /// </summary>
                    [CNABAtributo(Sequencia = 29, Regex = @"(?<SERIE_DOCUMENTO>.{2})")]
                    public string SERIE_DOCUMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SERIE_DOCUMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SERIE_DOCUMENTO)] = "".PadRight(2, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SERIE_DOCUMENTO)].ToString().PadRight(2, ' ').Substring(0, 2).Trim();
                        }
                        set
                        {
                            if (value.Length > 2)
                                throw new ArgumentException("Série do Documento deve ter até 2 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SERIE_DOCUMENTO)] = value.PadRight(2, ' ').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// Modalidade de Pagamento. Identifica o modo pelo qual o repasse será feito ao Favorecido.
                    /// <para>01 = Crédito em conta, 02 = Cheque OP (Ordem Pagamento), 03 = DOC COMPE, 05 = Crédito em Conta Real Time, 08 = TED, 30 = Rastreamento de Títulos (Exclusivo para o arquivo de rastreamento, caso contrário deverá ser agendado como título terceiro) e 31 = Títulos Terceiros.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 30, Regex = @"(?<MODALIDADE_PAGAMENTO>01|02|03|05|08|30|31)")]
                    public MODALIDADE_PAGAMENTO MODALIDADE_PAGAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)] = ((int)CNAB.MODALIDADE_PAGAMENTO.CREDITO_CONTA_CORRENTE).ToString().PadLeft(2, '0').Substring(0, 2);

                            return Enum.GetValues(typeof(CNAB.MODALIDADE_PAGAMENTO))
                                .Cast<CNAB.MODALIDADE_PAGAMENTO>()
                                .Where(x => ((int)x) == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)]))
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MODALIDADE_PAGAMENTO)] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// <para>Data para efetivação do pagamento no formato AAAAMMDD (opcional). Quando não informada, o sistema assume a data constante do campo Vencimento.</para>
                    /// <para>Quando no campo informação de retorno contiver o código “BW” – pagamento efetuado, esta data será a de pagamento (quitação).</para>
                    /// <remarks>Este campo deverá ser igual a data de vencimento (posições 166 a 173), não podendo ser inferior a data do processamento, para as modalidades 1, 2 e 3. Campo obrigatório para Lista de Débito.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 31, Regex = @"(?<DATA_PAGAMENTO>\d{8})")]
                    public DateTime DATA_PAGAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_PAGAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_PAGAMENTO)] = "".PadLeft(8, '0');

                            DateTime dt;

                            DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_PAGAMENTO)], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                            return dt;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.DATA_PAGAMENTO)] = value.ToString("yyyyMMdd");
                        }
                    }

                    /// <summary>
                    /// Moeda (CÓDIGO CNAB). Obrigatório – Fixo branco.
                    /// </summary>
                    [CNABAtributo(Sequencia = 32, Regex = @"(?<MOEDA>.{3})")]
                    public string MOEDA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MOEDA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MOEDA)] = "".PadRight(3, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MOEDA)].ToString().PadRight(3, ' ').Substring(0, 3).Trim();
                        }
                        set
                        {
                            if (value.Length > 3)
                                throw new ArgumentException("Moeda deve ter até 3 caracteres.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.MOEDA)] = value.PadRight(3, ' ').Substring(0, 3);
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
                    [CNABAtributo(Sequencia = 33, Regex = @"(?<SITUACAO_AGENDAMENTO>01|02|05|06|07|08|09|11|22)")]
                    public CNAB.SITUACAO_AGENDAMENTO SITUACAO_AGENDAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SITUACAO_AGENDAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SITUACAO_AGENDAMENTO)] = ((int)CNAB.SITUACAO_AGENDAMENTO.NAO_PAGO).ToString().PadLeft(2).Substring(0, 2);

                            // return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SITUACAO_AGENDAMENTO)].ToString().PadLeft(2, '0').Substring(0, 2);
                            return Enum.GetValues(typeof(CNAB.SITUACAO_AGENDAMENTO))
                                .Cast<CNAB.SITUACAO_AGENDAMENTO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SITUACAO_AGENDAMENTO)]))
                                .First();
                        }
                        set
                        {
                            //if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                            //    throw new ArgumentException("Situação do Agendamento deve ser 2 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SITUACAO_AGENDAMENTO)] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// <para>Informação de Retorno 1. Campo válido somente para o arquivo retorno.</para>
                    /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                    /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                    /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 34, Regex = @"(?<INFO_RETORNO_1>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                    public CNAB.Ocorrencia? INFO_RETORNO_1
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)].Trim().Length == 0)
                                return null;

                            return CNAB.Ocorrencias[Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)]];
                        }
                        set
                        {
                            if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                            else if (value.HasValue)
                                throw new ArgumentException("O valor para INFO_RETORNO_1 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_1)] = "".PadLeft(2, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Informação de Retorno 2. Campo válido somente para o arquivo retorno.</para>
                    /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                    /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                    /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 35, Regex = @"(?<INFO_RETORNO_2>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                    public CNAB.Ocorrencia? INFO_RETORNO_2
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)].Trim().Length == 0)
                                return null;

                            return CNAB.Ocorrencias[Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)]];
                        }
                        set
                        {
                            if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                            else if (value.HasValue)
                                throw new ArgumentException("O valor para INFO_RETORNO_2 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_2)] = "".PadLeft(2, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Informação de Retorno 3. Campo válido somente para o arquivo retorno.</para>
                    /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                    /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                    /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 36, Regex = @"(?<INFO_RETORNO_3>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                    public CNAB.Ocorrencia? INFO_RETORNO_3
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)].Trim().Length == 0)
                                return null;

                            return CNAB.Ocorrencias[Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)]];
                        }
                        set
                        {
                            if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                            else if (value.HasValue)
                                throw new ArgumentException("O valor para INFO_RETORNO_3 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_3)] = "".PadLeft(2, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Informação de Retorno 4. Campo válido somente para o arquivo retorno.</para>
                    /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                    /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                    /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 37, Regex = @"(?<INFO_RETORNO_4>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                    public CNAB.Ocorrencia? INFO_RETORNO_4
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)].Trim().Length == 0)
                                return null;

                            return CNAB.Ocorrencias[Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)]];
                        }
                        set
                        {
                            if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                            else if (value.HasValue)
                                throw new ArgumentException("O valor para INFO_RETORNO_4 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_4)] = "".PadLeft(2, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Informação de Retorno 5. Campo válido somente para o arquivo retorno.</para>
                    /// <para>No arquivo de rastreamento, quando “01” no campo anterior “FS” – entrada do título no cadastro da cobrança (BRANCO) – Quando o pagamento sofrer alguma alteração no cadastro da cobrança</para>
                    /// <para>No arquivo de agendamento. Até cinco ocorrências – vide tabelas de códigos.</para>
                    /// <para>No arquivo de confirmação de pagamentos “BW” – confirmação de pagamentos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 38, Regex = @"(?<INFO_RETORNO_5>\s\s|AA|AB|AC|AD|AE|AF|AG|AJ|AL|AM|AN|AO|AQ|AT|AU|AX|AY|AZ|BD|BE|BF|BG|BH|BI|BJ|BK|BL|BM|BN|BO|BP|BQ|BT|BU|BV|BW|FA|FB|FC|FE|FF|FG|FH|FI|FJ|FK|FL|FM|FN|FO|FP|FQ|FR|FS|FT|FU|FV|FW|FX|FZ|F0|F1|F3|F4|F5|F6|F7|F8|F9|GA|GB|GC|GD|GE|GF|GG|GH|GI|GJ|GK|GL|GM|GN|GO|GP|GQ|GR|GS|GT|GU|GV|GW|GX|GY|GZ|HA|HB|HC|HD|HE|HF|HG|HI|JA|JB|JC|JD|JE|JF|JG|JH|JI|JJ|JK|JL|JM|JN|JO|JP|KO|KP|KQ|KR|KS|KT|KV|KW|KX|KZ|LA|LB|LC|LD|LE|LF|LG|LH|LI|LJ|LK|LL|LM|MA|MB|MC|MD|ME|MF|MG|MH|NC|TR)")]
                    public CNAB.Ocorrencia? INFO_RETORNO_5
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)].Trim().Length == 0)
                                return null;

                            return CNAB.Ocorrencias[Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)]];
                        }
                        set
                        {
                            if (value.HasValue && CNAB.Ocorrencias.ContainsKey(value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)] = value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2);
                            else if (value.HasValue)
                                throw new ArgumentException("O valor para INFO_RETORNO_5 é desconhecido: '" + value.Value.Codigo.Trim().PadLeft(2, ' ').Substring(0, 2) + "'");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFO_RETORNO_5)] = "".PadLeft(2, ' ');
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
                    [CNABAtributo(Sequencia = 39, Regex = @"(?<TIPO_MOVIMENTO>0|1|2|3|5|9)")]
                    public CNAB.TIPO_MOVIMENTO TIPO_MOVIMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_MOVIMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_MOVIMENTO)] = ((int)CNAB.TIPO_MOVIMENTO.NAO_ESPECIFICADO).ToString().Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.TIPO_MOVIMENTO))
                                .Cast<CNAB.TIPO_MOVIMENTO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_MOVIMENTO)]))
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_MOVIMENTO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// <para>Código do Movimento. Válido somente para arquivo de Remessa. 00 – Autoriza Agendamento, 25 – Desautoriza Agendamento ou 50 – Efetuar Alegação. Obrigatório – variável.</para>
                    /// <remarks>Quando na posição 289 a 289, campo Tipo de Movimento = “9” - exclusão, este campo ( 290 a 291) será desconsiderado, podendo ser igual a brancos.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 40, Regex = @"(?<CODIGO_MOVIMENTO>\s\s|00|25|50)")]
                    public CNAB.CODIGO_MOVIMENTO? CODIGO_MOVIMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)] = "".PadLeft(2, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)] == "".PadLeft(2, ' '))
                                return null;

                            return Enum.GetValues(typeof(CNAB.CODIGO_MOVIMENTO))
                                .Cast<CNAB.CODIGO_MOVIMENTO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)]))
                                .First();
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)] = ((int)value.Value).ToString().PadLeft(2, '0').Substring(0, 2);
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_MOVIMENTO)] = "".PadLeft(2, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Endereço do Sacador/avalista. Somente para títulos Bradesco Rastreados, demais modalidades será desconsiderado – fixo brancos.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 41, Regex = @"(?<ENDERECO_SACADO>.{40})", DDA = true)]
                    public string ENDERECO_SACADO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_SACADO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_SACADO)] = "".PadRight(40, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_SACADO)];
                        }
                        set
                        {
                            if (value.Length > 40)
                                throw new ArgumentException("Endereço do Sacado deve ter até 40 caracteres.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.ENDERECO_SACADO)] = value.PadLeft(40, ' ').Substring(0, 40);
                        }
                    }

                    /// <summary>
                    /// Horário para consulta de saldo para as modalidades real time. 02 – Cheque OP, 05 – Credito em conta real time ou 08 – TED. Opcional, quando não informado, o Sistema consultará em todos os processamentos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 42, Regex = @"(?<HORARIO_CONSULTA_SALDO>.{4})", Escritural = true)]
                    public DateTime? HORARIO_CONSULTA_SALDO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)] = "".PadRight(4, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)] == "".PadRight(4, ' '))
                                return null;

                            DateTime dt;

                            if (!DateTime.TryParseExact(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)], "HHmm", null, System.Globalization.DateTimeStyles.None, out dt))
                                return null;

                            return dt;
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)] = value.Value.ToString("HHmm");
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.HORARIO_CONSULTA_SALDO)] = "".PadLeft(4, ' ');
                        }
                    }

                    /// <summary>
                    /// <para>Saldo disponível no momento da consulta. Válido somente para o arquivo retorno.</para>
                    /// </summary>
                    /// <remarks>Saldo disponível esta definido na documentação como alfanumérico !?!?. Não ha explicação sobre o formato dos dados deste campo no arquivo de Retorno.</remarks>
                    [CNABAtributo(Sequencia = 43, Regex = @"(?<SALDO_DISPONIVEL>.{15})", Escritural = true)]
                    public decimal? SALDO_DISPONIVEL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)] = "".PadLeft(15, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)] == "".PadLeft(15, ' '))
                                return null;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)], out d))
                                return null;

                            return d / 100;
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)] = value.Value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.SALDO_DISPONIVEL)] = "".PadLeft(15, ' ');

                        }
                    }

                    /// <summary>
                    /// Valor da taxa pré funding. Válido somente para o arquivo retorno.
                    /// </summary>
                    [CNABAtributo(Sequencia = 44, Regex = @"(?<VALOR_TAXA_PREFUNDING>.{15})", Escritural = true)]
                    public decimal? VALOR_TAXA_PREFUNDING
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)] = "".PadLeft(15, ' ');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)]))
                                return null;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)], out d))
                                return null;

                            return d / 100;
                        }
                        set
                        {
                            if (!value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)] = "".PadLeft(15, ' ');
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TAXA_PREFUNDING)] = value.Value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(15, '0');
                        }
                    }

                    /// <summary>
                    /// Posição 326 A 331. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 45, Regex = @"(?<RESERVADO_USO_BANCO_1>.{6})", Escritural = true)]
                    public string RESERVADO_USO_BANCO_1
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)] = "".PadRight(6, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)].PadRight(6, ' ').Substring(0, 6);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_1)] = value.PadRight(6, ' ').Substring(0, 6);
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
                    [CNABAtributo(Sequencia = 46, Regex = @"(?<NOME_SACADO>.{40})")]
                    public string NOME_SACADO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_SACADO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_SACADO)] = "".PadRight(40, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_SACADO)].PadRight(40, ' ').Substring(0, 40);
                        }
                        set
                        {
                            if (value.Trim().Length > 40)
                                throw new ArgumentException("Nome do Sacado deve ter até 40 caracteres.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_SACADO)] = value.PadRight(40, ' ').Substring(0, 40);
                        }
                    }

                    /// <summary>
                    /// Posição 372 A 372. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 47, Regex = @"(?<RESERVADO_USO_BANCO_2>.)")]
                    public string RESERVADO_USO_BANCO_2
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)] = "".PadRight(1, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)].PadRight(1, ' ').Substring(0, 1);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_2)] = value.PadRight(1, ' ').Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// <para>Nível da Informação de Retorno. Campo válido somente para arquivo retorno.</para>
                    /// <para>1 = Invalida o arquivo</para>
                    /// <para>2 = Invalida o registro</para>
                    /// <para>3 = A tarefa foi executada</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 48, Regex = @"(?<NIVEL_INFORMACAO_RETORNO>.)")]
                    public CNAB.NIVEL_INFORMACAO_RETORNO? NIVEL_INFORMACAO_RETORNO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)] = "".PadLeft(1, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)].Trim().Length == 0)
                                return null;

                            return Enum.GetValues(typeof(CNAB.NIVEL_INFORMACAO_RETORNO))
                                .Cast<CNAB.NIVEL_INFORMACAO_RETORNO>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)].Replace(' ', '0')))
                                .First();
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)] = ((int)value.Value).ToString().Substring(0, 1);
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NIVEL_INFORMACAO_RETORNO)] = "".PadLeft(1, ' ');
                        }
                    }

                    /// <summary>
                    /// Informações complementares. Decomposição das informações em função da modalidade de pagamento.
                    /// </summary>
                    [CNABAtributo(Sequencia = 49, Regex = @"(?<INFORMACAO_COMPLEMENTAR>.{40})")]
                    public string INFORMACAO_COMPLEMENTAR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFORMACAO_COMPLEMENTAR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFORMACAO_COMPLEMENTAR)] = "".PadRight(40, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFORMACAO_COMPLEMENTAR)].ToString().PadRight(40, ' ').Substring(0, 40);
                        }
                        set
                        {
                            if (value.Length > 40)
                                throw new ArgumentException("Informação Complementar deve ter até 40 caracteres.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.INFORMACAO_COMPLEMENTAR)] = value.PadRight(40, ' ').Substring(0, 40);
                        }
                    }

                    /// <summary>
                    /// <para>Código de área na empresa. Uso da empresa – para identificar a origem do pagamento. Opcional.</para>
                    /// <para>Quando Tipo de Processamento = “1”, ( posição 106 a 106 do Registro header ) o conteúdo deste campo será branco.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 50, Regex = @"(?<CODIGO_AREA_EMPRESA>.{2})")]
                    public string CODIGO_AREA_EMPRESA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_AREA_EMPRESA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_AREA_EMPRESA)] = "".PadRight(2, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_AREA_EMPRESA)].PadRight(2, ' ').Substring(0, 2);
                        }
                        set
                        {
                            if (value.Length > 2)
                                throw new ArgumentException("Código de Área da Empresa deve ser 2 digitos.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_AREA_EMPRESA)] = value.PadRight(2, ' ').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// <para>Uso da empresa – Para que seja devolvido no arquivo retorno, depende de cadastramento no Banco. Opcional.</para>
                    /// <para>Será confirmado o conteúdo da remessa.</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 51, Regex = @"(?<RESERVADO_USO_EMPRESA>.{35})")]
                    public string RESERVADO_USO_EMPRESA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)] = "".PadRight(35, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)].PadRight(35, ' ').Substring(0, 35);
                        }
                        set
                        {
                            if (value.Length > 35)
                                throw new ArgumentException("Informação de Uso da Empresa deve ter até 35 caracteres.");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_EMPRESA)] = value.PadRight(35, ' ').Substring(0, 35);
                        }
                    }

                    /// <summary>
                    /// Posição 451 A 472. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 52, Regex = @"(?<RESERVADO_USO_BANCO_3>.{22})")]
                    public string RESERVADO_USO_BANCO_3
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)] = "".PadRight(22, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)].PadRight(22, ' ').Substring(0, 22);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_3)] = value.PadRight(22, ' ').Substring(0, 22);
                        }
                    }

                    /// <summary>
                    /// Código de lançamento. Exclusivo para as modalidades 01, 02, 03, 05 e 08. Indica o código de lançamento no extrato de conta corrente.
                    /// <remarks>A Empresa pagadora terá que informar ao Banco os códigos de lançamento para débito/crédito (modalidades 01,02, 03, 05 e 08) a serem utilizados, para que sejam previamente cadastrados. Código de lançamento esta definido com string por que os códigos variam pois são cadastrados pela agencia detentora da conta.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 53, Regex = @"(?<CODIGO_LANCAMENTO>\d{5})")]
                    public string CODIGO_LANCAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_LANCAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_LANCAMENTO)] = "".PadLeft(5, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_LANCAMENTO)];
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_LANCAMENTO)] = value.PadLeft(5, '0').Substring(0, 5);
                        }
                    }
                    /// <summary>
                    /// Posição 478 A 478. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 54, Regex = @"(?<RESERVADO_USO_BANCO_4>.)")]
                    public string RESERVADO_USO_BANCO_4
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_4)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_4)] = "".PadRight(1, ' ').Substring(0, 1);

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_4)].PadRight(1, ' ').Substring(0, 1);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_4)] = value.PadRight(1, ' ').Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// <para>Tipo de conta do fornecedor. Exclusivo para as modalidades 01 e 05. Obrigatória - variável.</para>
                    /// <para>Exclusivo para as modalidades 01 e 05</para>
                    /// <para>1 = Indica que o credito ao fornecedor será realizado em conta corrente</para>
                    /// <para>2 = Indica que o credito ao fornecedor será realizado em conta de poupança</para>
                    /// </summary>
                    [CNABAtributo(Sequencia = 55, Regex = @"(?<TIPO_CONTA_FORNECEDOR>\s|1|2)")]
                    public TIPO_CONTA_FORNECEDOR? TIPO_CONTA_FORNECEDOR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)] = "".PadLeft(1, ' ');

                            if (Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)] == "".PadLeft(1, ' '))
                                return null;

                            return Enum.GetValues(typeof(CNAB.TIPO_CONTA_FORNECEDOR))
                                .Cast<CNAB.TIPO_CONTA_FORNECEDOR>()
                                .Where(x => (int)x == int.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)]))
                                .First();
                        }
                        set
                        {
                            if (value.HasValue)
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)] = ((int)value).ToString().PadLeft(1, ' ').Substring(0, 1);
                            else
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_CONTA_FORNECEDOR)] = "".PadLeft(1, ' ');
                        }
                    }

                    /// <summary>
                    /// Conta complementar. Obrigatório quando o cliente pagador possuir mais de uma Conta para débito dos pagamentos. Deverá ser solicitado ao Banco.
                    /// <para>Se a empresa pagadora tiver várias contas abertas com o mesmo CNPJ, todas as contas poderão ser previamente cadastradas e indicadas para débito, bastando indicar neste campo o código correspondente à conta de débito cadastrado no Banco.</para>
                    /// <remarks>Obrigatório quando o cliente pagador for optante pelo pagamento diferenciado, ou seja contas de débito diferenciadas.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 56, Regex = @"(?<CONTA_COMPLEMENTAR>\d{7})")]
                    public string CONTA_COMPLEMENTAR
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_COMPLEMENTAR)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_COMPLEMENTAR)] = "".PadLeft(7, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_COMPLEMENTAR)].ToString().PadLeft(7, '0').Substring(0, 7);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(7, '0').IsNumericArray(7))
                                throw new ArgumentException("Conta Complementar deve ter até 7 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CONTA_COMPLEMENTAR)] = value.Trim().PadLeft(7, '0').Substring(0, 7);
                        }
                    }

                    /// <summary>
                    /// Posição 487 A 494. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 57, Regex = @"(?<RESERVADO_USO_BANCO_5>.{8})")]
                    public string RESERVADO_USO_BANCO_5
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_5)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_5)] = "".PadRight(8, ' ').Substring(0, 8);

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_5)].PadRight(8, ' ').Substring(0, 8);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO_USO_BANCO_5)] = value.PadRight(8, ' ').Substring(0, 8);
                        }
                    }

                    /// <summary>
                    /// Número sequencial do registro. Número sequencial – O Primeiro registro de operação sempre será o registro “000002”, e assim sucessivamente. Obrigatório – variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 58, Regex = @"(?<NUMERO_SEQUENCIAL>\d{6})")]
                    public UInt32 NUMERO_SEQUENCIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = "".PadRight(6, '0');

                            return UInt32.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)]);
                        }
                        set
                        {
                            //if (!value.Trim().PadLeft(6, '0').IsNumericArray(6))
                            //    throw new ArgumentException("Número Sequencial deve ter até 6 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = ((int)value).ToString().PadLeft(6, '0').Substring(0, 6);
                        }
                    }

                    #endregion

                    #region Construtores

                    /// <summary>
                    /// Construtor da classe Instrução
                    /// </summary>
                    public Instrucao()
                    {
                        Reset();
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
                    /// Gera uma lista de propriedades representando cada campo do registro
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
                                        Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
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
                                        Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
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
                                        Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
                                    })
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
                                        Attribute = (CNAB.CNABAtributo)Attribute.GetCustomAttribute(x, typeof(CNAB.CNABAtributo), true)
                                    })
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

                /// <summary>
                /// Representa o Rodape do Arquivo padrão CNAB do Bradesco
                /// </summary>
                public partial class Rodape : Registro
                {
                    #region Variaveis

                    #endregion

                    #region Propriedades

                    /// <summary>
                    /// Identificação do Registro. Constante “9”. Obrigatório.
                    /// </summary>
                    [CNABAtributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>9)")]
                    public CNAB.TIPO_REGISTRO TIPO_REGISTRO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)CNAB.TIPO_REGISTRO.RODAPE).ToString().Substring(0, 1);

                            return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                                .Cast<CNAB.TIPO_REGISTRO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)])
                                .First();
                        }
                        protected set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_REGISTRO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// <para>Quantidade de registros. Total de registros do arquivo, incluindo todos os headers, transações e o próprio trailler. Obrigatório.</para>
                    /// <remarks>No arquivo retorno referente à confirmação dos agendamentos efetuados, a quantidade de registros e/ou o total dos valores de pagamentos serão sempre os valores de origem no cliente mesmo que eventualmente, divergentes.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 1, Regex = @"(?<QUANTIDADE_REGISTROS>\d{6})")]
                    public UInt32 QUANTIDADE_REGISTROS
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.QUANTIDADE_REGISTROS)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.QUANTIDADE_REGISTROS)] = "".PadRight(6, '0');

                            return UInt32.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.QUANTIDADE_REGISTROS)]);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.QUANTIDADE_REGISTROS)] = value.ToString().PadLeft(6, '0').Substring(0, 6);
                        }
                    }

                    /// <summary>
                    /// <para>Total dos valores de pagamento. Somatória do conteúdo do campo valor de pagamento dos registros transações Obrigatório.</para>
                    /// <remarks>No arquivo retorno referente à confirmação dos agendamentos efetuados, a quantidade de registros e/ou o total dos valores de pagamentos serão sempre os valores de origem no cliente mesmo que eventualmente, divergentes.</remarks>
                    /// </summary>
                    [CNABAtributo(Sequencia = 2, Regex = @"(?<VALOR_TOTAL_PAGAMENTO>\d{17})")]
                    public decimal VALOR_TOTAL_PAGAMENTO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TOTAL_PAGAMENTO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TOTAL_PAGAMENTO)] = "".PadLeft(17, '0');

                            if (string.IsNullOrEmpty(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TOTAL_PAGAMENTO)]))
                                return 0;

                            Decimal d;

                            if (!Decimal.TryParse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TOTAL_PAGAMENTO)], out d))
                                return 0;

                            return d / 100;
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.VALOR_TOTAL_PAGAMENTO)] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(17, '0');
                        }
                    }

                    /// <summary>
                    /// Posição 025 A 494. Reservado para uso futuro. Fixo Brancos.
                    /// </summary>
                    [CNABAtributo(Sequencia = 3, Regex = @"(?<RESERVADO>.{470})")]
                    public string RESERVADO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO)] = "".PadRight(470, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO)].PadRight(470, ' ').Substring(0, 470);
                        }
                        protected set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.RESERVADO)] = value.PadRight(470, ' ').Substring(0, 470);
                        }
                    }

                    /// <summary>
                    /// Número sequencial. Sequencial crescente no arquivo.
                    /// </summary>
                    [CNABAtributo(Sequencia = 4, Regex = @"(?<NUMERO_SEQUENCIAL>\d{6})")]
                    public UInt32 NUMERO_SEQUENCIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = "".PadRight(6, '0');

                            return UInt32.Parse(Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)]);
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NUMERO_SEQUENCIAL)] = value.ToString().PadLeft(6, '0').Substring(0, 6);
                        }
                    }

                    #endregion

                    #region Contrutores

                    public Rodape()
                    {
                        Reset();
                    }

                    public Rodape(string Registro)
                    {
                        this._Registro = Registro;

                        Parse();
                    }

                    #endregion

                    #region Metodos


                    #endregion
                }

                #endregion

                #region SubClasses para Arquivo, Remessa e Retorno

                /// <summary>
                /// Representa um bloco de instruções de uma mesma conta corrente. Este bloco é composto de Cabeçalho, Instrucao e Rodape
                /// </summary>
                //public abstract partial class Instrucoes /*: Stream*/
                //{
                //    #region Variaveis


                //    /// <summary>
                //    /// Representa uma coleção dos registros de Instrução do arquivo CNAB do Bradesco.
                //    /// </summary>
                //    public Collection<SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Instrucao> Instrucao { get; protected set; }

                //    #endregion

                //    #region Construtores

                //    /// <summary>
                //    /// Construtor padrão para a classe Arquivo.
                //    /// </summary>
                //    public Instrucoes()
                //    {
                //        Cabecalho = null;
                //        Instrucao = new Collection<Instrucao>();
                //        Rodape = null;
                //    }

                //    #endregion

                //    #region Metodos

                //    /// <summary>
                //    /// Gera o arquivo de Remessa padrão CNAB do Bradesco.
                //    /// </summary>
                //    /// <param name="Arquivo">O arquivo a ser gerado.</param>
                //    /// <returns>Retorna verdadeiro se o arquivo for gerado com sucesso.</returns>
                //    public bool Write(StreamWriter Arquivo)
                //    {
                //        this.Cabecalho.Write(Arquivo);

                //        foreach (Instrucao t in this.Instrucao)
                //        {
                //            t.Write(Arquivo);
                //        }

                //        this.Rodape.Write(Arquivo);

                //        //Arquivo.Flush();
                //        //Arquivo.Close();

                //        return true;
                //    }

                //    /// <summary>
                //    /// Processa a linha do arquivo de Retorno.
                //    /// </summary>
                //    /// <param name="Registro">A linha a ser processada.</param>
                //    /// <returns>Retorna um objeto do tipo Cabecalho, Instrução ou Rodape conforme o Tipo do Registro.</returns>
                //    private object Parse(string Registro)
                //    {
                //        switch (Registro.First())
                //        {
                //            case '0': // Cabecalho
                //                return new Cabecalho(Registro);
                //            case '1': // Instrucao
                //                return new Instrucao(Registro);
                //            case '9': // Rodape
                //                return new Rodape(Registro);
                //            default:
                //                throw new Exception("Registro CNAB inválido. O primeiro dígito do registro deve ser 0, 1, ou 9 !");
                //        }
                //    }

                //    /// <summary>
                //    /// Processa o arquivo de Retorno.
                //    /// </summary>
                //    /// <param name="Arquivo">Arquivo a ser processado.</param>
                //    /// <returns>Retorna verdadeiro se o arquivo for processado com sucesso.</returns>
                //    public bool Parse(StreamReader Arquivo)
                //    {
                //        IEnumerable<object> c = Arquivo.GetLines().Select(Parse);

                //        foreach (object o in c)
                //        {
                //            string type = o.GetType().ToString();

                //            switch (type)
                //            {
                //                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Cabecalho":
                //                    Cabecalho = o as Cabecalho;
                //                    break;
                //                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Instrucao":
                //                    Instrucao.Add(o as Instrucao);
                //                    break;
                //                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Rodape":
                //                    Rodape = o as Rodape;
                //                    break;
                //                default:
                //                    throw new Exception("Tipo de Registro de Retorno desconhecido !");
                //            }
                //        }

                //        if (Cabecalho == null || Rodape == null || Instrucao.Count == 0)
                //            throw new Exception("Registro CNAB inválido. Erro interno, não é esperado que o resultado do processamento do registro seja nulo !");

                //        return true;
                //    }

                //    #endregion

                //}

                /// <summary>
                /// Representa a empresa conveniada para o envio e recebimento de arquivos CNAB
                /// </summary>
                public class Empresa
                {
                    #region Variaveis

                    private Dictionary<string, string> Dicionario = new Dictionary<string, string>();

                    /// <summary>
                    /// Representa o registro de Cabeçalho do arquivo CNAB do Bradesco.
                    /// </summary>
                    public SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Cabecalho Cabecalho { get; protected set; }
                    
                    public Collection<Instrucao> Instrucoes = new Collection<Instrucao>();

                    #endregion

                    #region Propriedades

                    /// <summary>
                    /// Tipo de Inscrição da Empresa Pagadora. 1 = CPF / 2 = CNPJ / 3= OUTROS. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 2, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                    public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                            //return Dicionario[SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.DADOS.TIPO_INSCRICAO.ToString()].ToString().Substring(0, 1);
                            return Enum.GetValues(typeof(CNAB.TIPO_INSCRICAO))
                                .Cast<CNAB.TIPO_INSCRICAO>()
                                .Where(x => ((int)x).ToString() == Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)])
                                .First();
                        }
                        set
                        {
                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_INSCRICAO)] = ((int)value).ToString().Substring(0, 1);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 3, Regex = @"(?<CNPJ>\d{9})")]
                    public string CNPJ
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = "".PadLeft(9, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)].ToString().PadLeft(9, '0').Substring(0, 9);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(9, '0').IsNumericArray(9))
                                throw new ArgumentException("CNPJ deve ter 9 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ)] = value.Trim().PadLeft(9, '0').Substring(0, 9);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Filial. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 4, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
                    public string CNPJ_FILIAL
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = "".PadLeft(4, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)].ToString().PadLeft(4, '0').Substring(0, 4);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                                throw new ArgumentException("Filial deve ter 4 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_FILIAL)] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                        }
                    }

                    /// <summary>
                    /// CNPJ/CPF - Digito de Verificação. Obrigatório - variável.
                    /// </summary>
                    [CNABAtributo(Sequencia = 5, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
                    public string CNPJ_DIGITO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = "".PadLeft(2, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)].ToString().PadLeft(2, '0').Substring(0, 2);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                                throw new ArgumentException("Controle deve ter 2 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CNPJ_DIGITO)] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                        }
                    }

                    /// <summary>
                    /// Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo.
                    /// </summary>
                    [CNABAtributo(Sequencia = 6, Regex = @"(?<NOME_EMPRESA>.{40})")]
                    public string NOME_EMPRESA
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)] = "".PadRight(40, ' ');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)].ToString().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                        }
                        set
                        {
                            if (value.Trim().Length < 5 || value.Trim().Length > 40)
                                throw new ArgumentException("Nome da Empresa deve ter no mínimo 5 e no máximo 40 caracteres;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.NOME_EMPRESA)] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                        }
                    }

                    #endregion

                    #region Contrutores

                    public Empresa(Cabecalho Cabecalho)
                    {
                        TIPO_INSCRICAO = Cabecalho.TIPO_INSCRICAO;
                        CNPJ = Cabecalho.CNPJ;
                        CNPJ_FILIAL = Cabecalho.CNPJ_FILIAL;
                        CNPJ_DIGITO = Cabecalho.CNPJ_DIGITO;
                        NOME_EMPRESA = Cabecalho.NOME_EMPRESA;

                        this.Cabecalho = Cabecalho;
                    }

                    public bool Parse(Instrucao Instrucao)
                    {
                        Instrucoes.Add(Instrucao);

                        return true;
                    }

                    #endregion

                }

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
                    public SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Rodape Rodape { get; set; }

                    #endregion

                    #region Propriedades

                    /// <summary>
                    /// Identificação da empresa no Banco - Será fornecido pelo Banco previamente à implantação. É único e constante para todas as empresas do Grupo, quando o processamento for centralizado. Se o processamento for descentralizado, por exemplo, por região, poderá ser fornecido um código para cada centro processador, desde que possuam CNPJ’s diferentes. Obrigatório – fixo.
                    /// </summary>
                    [CNABAtributo(Sequencia = 1, Regex = @"(?<CODIGO_COMUNICACAO>\d{8})")]
                    public string CODIGO_COMUNICACAO
                    {
                        get
                        {
                            if (!Dicionario.ContainsKey(Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)))
                                Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)] = "".PadLeft(8, '0');

                            return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)].ToString().PadLeft(8, '0').Substring(0, 8);
                        }
                        set
                        {
                            if (!value.Trim().PadLeft(8, '0').IsNumericArray(8))
                                throw new ArgumentException("Codigo de Comunicação deve ter 8 digitos numéricos;");

                            Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.CODIGO_COMUNICACAO)] = value.Trim().PadLeft(8, '0').Substring(0, 8);
                        }
                    }

                    #endregion

                    #region Construtores

                    public Convenio(Cabecalho Cabecalho)
                    {
                        CODIGO_COMUNICACAO = Cabecalho.CODIGO_COMUNICACAO;

                        Empresas.Add(new Empresa(Cabecalho));
                    }

                    #endregion

                    #region Metodos

                    #endregion

                }

                /// <summary>
                /// Representa um arquivo no formato CNAB
                /// </summary>
                public abstract partial class Arquivo /*: Stream*/
                {
                    #region Variaveis

                    /// <summary>
                    /// Nome do arquivo
                    /// </summary>
                    private string nome;

                    /// <summary>
                    /// Representa uma relação dos convenios firmados com o banco para envio e recebimento de arquivos presentes no arquivo de remessa/retorno
                    /// </summary>
                    public Collection<Convenio> Convenios = new Collection<Convenio>();

                    #endregion

                    #region Propriedades

                    /// <summary>
                    /// Nome do arquivo
                    /// </summary>
                    /// <remarks>
                    /// O arquivo-remessa deverá ter a seguinte formatação:
                    /// PGDDMMX.REM OU PGDDMMXX.REM
                    /// 1 ou 2 variáveis alfanuméricas: 0, 01, AB, A1, etc.
                    /// Exemplo: PG250601.REM , PG2506AB.REM , PG2506A1.REM , etc.
                    /// Quanto ao arquivo-retorno terá a mesma formatação, porém, com a extensão RET.
                    /// Exemplo: PG250600.RET , PG250601.RET , PG2506AB.RET , ETC.
                    /// </remarks>
                    public string Nome
                    {
                        get
                        {
                            if (string.IsNullOrEmpty(nome))
                                nome = string.Format("PG{0, -2}{1, -2}{2, -2}", DateTime.Now.Day.ToString(), DateTime.Now.Month.ToString(), "01");

                            return nome;
                        }
                        set
                        {
                            nome = value;
                        }
                    }

                    #endregion

                    #region Enum

                    /// <summary>
                    /// Representa o conteudo do arquivo.
                    /// </summary>
                    /// <remarks>
                    /// O banco recebe um tipo de arquivo de remessa e disponibiliza 7 tipos de arquivo de retorno (todos com mesmo layout):
                    /// 1. Rastreamento Bradesco: arquivo com os títulos registrados na Cobrança Online Bradesco de responsabilidade da sua empresa;
                    /// 2. Rastreamento DDA: arquivo com os títulos registrados no sistema DDA, de responsabilidade da sua empresa;
                    /// 3. Confirmação de Agendamento: disponível imediatamente após cada processamento apresenta as consistências e inconsistências, inclusive para pagamentos do próprio dia;
                    /// 4. Confirmação de Pagamento: apresenta a descrição dos pagamentos efetuados, independente da data de agendamento.
                    /// 5. Confirmação de Pagamento Não Efetuado – apresenta a descrição dos pagamentos não efetuados, por saldo insuficiente.
                    /// 6. DOC COMPE Devolvido: apresenta a descrição dos DOC’s COMPE devolvidos.
                    /// 7. Cheque OP Estornado: apresenta a descrição do Cheque OP (Ordem de Pagamento) estornado, quando a pedido do cliente pagador ou não retirado pelo fornecedor.
                    /// </remarks>
                    public enum TIPO_ARQUVO
                    {
                        REMESSA = 0,
                        RETORNO_RASTREAMENTO_TITULOS_ESCRITURADOS,
                        RETORNO_RASTREAMENTO_TITULOS_DDA,
                        RETORNO_CONFIRMACAO_AGENDAMENTO,
                        RETORNO_CONFIRMACAO_PAGAMENTO,
                        RETORNO_CONFIRMACAO_PAGAMENTO_NAO_EFETUADO,
                        RETORNO_CHEQUE_ORDEM_PAGAMENTO_ESTORNADO
                    }

                    #endregion

                    #region Construtores

                    /// <summary>
                    /// Construtor padrão para a classe Arquivo.
                    /// </summary>
                    public Arquivo()
                    {
                    }

                    #endregion

                    #region Metodos

                    /// <summary>
                    /// Gera o arquivo de Remessa padrão CNAB do Bradesco.
                    /// </summary>
                    /// <param name="Arquivo">O arquivo a ser gerado.</param>
                    /// <returns>Retorna verdadeiro se o arquivo for gerado com sucesso.</returns>
                    public bool Write(StreamWriter Arquivo)
                    {
                        foreach (Convenio convenio in Convenios)
                        {
                            foreach (Empresa empresa in convenio.Empresas)
                            {
                                empresa.Cabecalho.Write(Arquivo);

                                foreach (Instrucao instrucao in empresa.Instrucoes)
                                {
                                    instrucao.Write(Arquivo);
                                }
                            }

                            convenio.Rodape.Write(Arquivo);
                        }

                        //Arquivo.Flush();
                        //Arquivo.Close();

                        return true;
                    }

                    /// <summary>
                    /// Processa a linha do arquivo de Retorno.
                    /// </summary>
                    /// <param name="Registro">A linha a ser processada.</param>
                    /// <returns>Retorna um objeto do tipo Cabecalho, Instrução ou Rodape conforme o Tipo do Registro.</returns>
                    private object Parse(string Registro)
                    {
                        switch (Registro.First())
                        {
                            case '0': // Cabecalho
                                return new Cabecalho(Registro);
                            case '1': // Instrucao
                                return new Instrucao(Registro);
                            case '9': // Rodape
                                return new Rodape(Registro);
                            default:
                                throw new Exception("Registro CNAB inválido. O primeiro dígito do registro deve ser 0, 1, ou 9 !");
                        }
                    }

                    /// <summary>
                    /// Processa o arquivo de Retorno.
                    /// </summary>
                    /// <param name="Arquivo">Arquivo a ser processado.</param>
                    /// <returns>Retorna verdadeiro se o arquivo for processado com sucesso.</returns>
                    public bool Parse(StreamReader Arquivo)
                    {
                        Convenio convenio = null;

                        IEnumerable<object> c = Arquivo.GetLines().Select(Parse);

                        foreach (object o in c)
                        {
                            string type = o.GetType().ToString();

                            switch (type)
                            {
                                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Cabecalho":
                                    convenio = new Convenio(o as Cabecalho);
                                    Convenios.Add(convenio);
                                    //Cabecalho = o as Cabecalho;
                                    break;
                                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Instrucao":
                                    convenio.Empresas.Last().Parse(o as Instrucao);
                                    break;
                                case "SA.Data.Models.Financeiro.Bancos.Banco+Bradesco+CNAB+Rodape":
                                    convenio.Rodape = o as Rodape;
                                    break;
                                default:
                                    throw new Exception("Tipo de Registro de Retorno desconhecido !");
                            }
                        }

                        //if (Cabecalho == null || Rodape == null || Instrucao.Count == 0)
                        //    throw new Exception("Registro CNAB inválido. Erro interno, não é esperado que o resultado do processamento do registro seja nulo !");

                        return true;
                    }

                    public virtual IEnumerable<Exception> Validar()
                    {
                        yield return null;
                    }

                    #endregion

                }

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
                    /// Contrutor da classe que representa o arquivo de Remessa no padrão CNAB do Bradesco.
                    /// </summary>
                    /// <param name="Codigo_Comunicacao">Código de Comunicação – Identificação da Empresa no Banco. Será fornecido pelo Bradesco. Obrigatório – fixo</param>
                    /// <param name="Tipo_Inscricao">Tipo de Inscrição da Empresa Pagadora. 1 = CPF, 2 = CNPJ, 3 = OUTROS. Obrigatório - variável</param>
                    /// <param name="CNPJ">CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição.</param>
                    /// <param name="Filial">CNPJ - Filial.</param>
                    /// <param name="Controle">CNPJ - Controle</param>
                    /// <param name="Nome_Empresa">Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo</param>
                    /// <param name="Numero_Remessa">Número da Remessa. Sequencial Crescente. Obrigatório - variável</param>
                    //public Remessa(
                    //    string CODIGO_COMUNICACAO,
                    //    TIPO_INSCRICAO TIPO_INSCRICAO,
                    //    string CNPJ, 
                    //    string CNPJ_FILIAL, 
                    //    string CNPJ_DIGITO, 
                    //    string NOME_EMPRESA, 
                    //    string NUMERO_REMESSA) : base()
                    //{
                    //    this.Cabecalho = new SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Cabecalho(
                    //        CODIGO_COMUNICACAO, 
                    //        TIPO_INSCRICAO, 
                    //        CNPJ, 
                    //        CNPJ_FILIAL, 
                    //        CNPJ_DIGITO, 
                    //        NOME_EMPRESA, 
                    //        NUMERO_REMESSA);

                    //    this.Instrucao = new Collection<SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Instrucao>();

                    //    this.Rodape = new SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Rodape();
                    //}

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
                                    if (i.TIPO_DOCUMENTO == null)
                                        yield return new Exception("O Tipo de Documento é obrigatório.");

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
                                                uint.Parse(i.AGENCIA_FORNECEDOR_DIGITO) != Bradesco.Modulo11(i.AGENCIA_FORNECEDOR.ToCharArray().Select(x => uint.Parse(x.ToString())).ToArray()))
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

                /// <summary>
                /// Calcula o digito verificador da Agência e Conta Corrente
                /// </summary>
                /// <returns></returns>
                private uint CalculoDigitoAgenciaConta()
                {
                    return 0;
                }

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
                    public Retorno() : base()
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
                #endregion
            }

            #endregion
        }
    }
}
