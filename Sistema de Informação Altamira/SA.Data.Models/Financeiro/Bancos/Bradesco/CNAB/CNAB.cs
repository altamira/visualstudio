using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
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
        [System.ComponentModel.Description("Nota Fiscal Fatura")]
        NOTA_FISCAL_FATURA = 1,
        [System.ComponentModel.Description("Fatura")]
        FATURA = 2,
        [System.ComponentModel.Description("Nota Fiscal")]
        NOTA_FISCAL = 3,
        [System.ComponentModel.Description("Duplicata")]
        DUPLICATA = 4,
        [System.ComponentModel.Description("Outros")]
        OUTROS = 5
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

    public partial class Bradesco : Banco
    {

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
                [System.ComponentModel.Description("Nota Fiscal Fatura")]
                NOTA_FISCAL_FATURA = 1,
                [System.ComponentModel.Description("Fatura")]
                FATURA = 2,
                [System.ComponentModel.Description("Nota Fiscal")]
                NOTA_FISCAL = 3,
                [System.ComponentModel.Description("Duplicata")]
                DUPLICATA = 4,
                [System.ComponentModel.Description("Outros")]
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
                [System.ComponentModel.Description("Não Especificado")]
                NAO_ESPECIFICADO = 0,
                [System.ComponentModel.Description("Inclusão")]
                INCLUSAO = 0,
                [System.ComponentModel.Description("Inclusão Título em Cartório")]
                INCLUSAO_TITULO_CARTORIO = 1,
                [System.ComponentModel.Description("Alteração de Título")]
                ALTERACAO_TITULO = 2,
                [System.ComponentModel.Description("Baixa de Título em Cartório")]
                BAIXA_TITULO_CARTORIO = 3,
                [System.ComponentModel.Description("Alteração")]
                ALTERACAO = 5,
                [System.ComponentModel.Description("Exclusão")]
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
            public class Atributo : Attribute
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

            /// <summary>
            /// Calcula o digito verificador da Agência e Conta Corrente
            /// </summary>
            /// <returns></returns>
            private uint CalculoDigitoAgenciaConta()
            {
                return 0;
            }

            #endregion
        }

    }
}
