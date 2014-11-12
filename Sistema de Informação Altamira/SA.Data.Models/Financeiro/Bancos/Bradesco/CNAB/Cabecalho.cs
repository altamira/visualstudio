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
                [Atributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>0)")]
                public TIPO_REGISTRO TIPO_REGISTRO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_REGISTRO"))
                            Dicionario["TIPO_REGISTRO"] = ((int)CNAB.TIPO_REGISTRO.CABECALHO).ToString().Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                            .Cast<CNAB.TIPO_REGISTRO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_REGISTRO"])
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_REGISTRO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

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

                /// <summary>
                /// Tipo de Inscrição da Empresa Pagadora. 1 = CPF / 2 = CNPJ / 3= OUTROS. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 2, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_INSCRICAO"))
                            Dicionario["TIPO_INSCRICAO"] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                        //return Dicionario[SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.DADOS.TIPO_INSCRICAO.ToString()].ToString().Substring(0, 1);
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
                /// CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 3, Regex = @"(?<CNPJ>\d{9})")]
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
                [Atributo(Sequencia = 4, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
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
                /// CNPJ/CPF - Digito de Verificação. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 5, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
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
                /// Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo.
                /// </summary>
                [Atributo(Sequencia = 6, Regex = @"(?<NOME_EMPRESA>.{40})")]
                public string NOME_EMPRESA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NOME_EMPRESA"))
                            Dicionario["NOME_EMPRESA"] = "".PadRight(40, ' ');

                        return Dicionario["NOME_EMPRESA"].ToString().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                    }
                    set
                    {
                        if (value.Trim().Length < 5 || value.Trim().Length > 40)
                            throw new ArgumentException("Nome da Empresa deve ter no mínimo 5 e no máximo 40 caracteres;");

                        Dicionario["NOME_EMPRESA"] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                    }
                }

                /// <summary>
                /// Tipo de Serviço. Obrigatório - Fixo “20” = PAGTO FORNECEDORES
                /// </summary>
                [Atributo(Sequencia = 7, Regex = @"(?<TIPO_SERVICO>20)")]
                public CNAB.TIPO_SERVICO TIPO_SERVICO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_SERVICO"))
                            Dicionario["TIPO_SERVICO"] = ((int)CNAB.TIPO_SERVICO.PAGAMENTO_FORNECEDOR).ToString().PadLeft(2, '0').Substring(0, 2);

                        return Enum.GetValues(typeof(CNAB.TIPO_SERVICO))
                            .Cast<CNAB.TIPO_SERVICO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_SERVICO"])
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_SERVICO"] = ((int)value).ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// <para>Código de origem do arquivo. 1 – Origem no Cliente, 2 – Origem no Banco. Obrigatório - Fixo “1”.</para>
                /// <para>Código 1 - Constará do arquivo-retorno - Confirmação de agendamento</para>
                /// <para>Código 2 - Constará do arquivo-retorno - Rastreamento da Cobrança Bradesco e confirmação de pagamentos</para>
                /// </summary>
                [Atributo(Sequencia = 8, Regex = @"(?<ORIGEM_ARQUIVO>1|2)")]
                public CNAB.ORIGEM_ARQUIVO ORIGEM_ARQUIVO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("ORIGEM_ARQUIVO"))
                            Dicionario["ORIGEM_ARQUIVO"] = ((int)CNAB.ORIGEM_ARQUIVO.ORIGEM_NO_CLIENTE).ToString().PadLeft(1, '0').Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.ORIGEM_ARQUIVO))
                            .Cast<CNAB.ORIGEM_ARQUIVO>()
                            .Where(x => (int)x == int.Parse(Dicionario["ORIGEM_ARQUIVO"]))
                            .First();
                    }
                    set
                    {
                        Dicionario["ORIGEM_ARQUIVO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// Sequencial crescente para cada remessa no dia, que deverá ser controlado pelo cliente. Deve ser o mesmo para todos os header’s de um mesmo trailler. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 9, Regex = @"(?<NUMERO_REMESSA>\d{5})")]
                public string NUMERO_REMESSA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_REMESSA"))
                            Dicionario["NUMERO_REMESSA"] = "".PadLeft(5, '0');

                        return Dicionario["NUMERO_REMESSA"].ToString().PadLeft(5, '0').Substring(0, 5);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                            throw new ArgumentException("Numero Remessa deve ter 5 digitos numéricos;");

                        Dicionario["NUMERO_REMESSA"] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                    }
                }

                /// <summary>
                /// <para>Número do retorno. Controlado pelo Banco. Campo válido somente para o arquivo-retorno.</para> 
                /// <para>O número do retorno é gerado através de um número sequencial iniciado em 1 e incrementado de 1 a cada arquivo originado da rotina PFEB, ou seja, apenas no rastreamento da Cobrança Bradesco e na confirmação de pagamentos.</para>
                /// <para>No arquivo de confirmação de agendamentos é devolvido o mesmo conteúdo enviado pela empresa ou zeros quando o campo não for numérico.</para>
                /// <remarks>Este número não deverá ser utilizado pelo cliente para controles internos, haja vista ocorrer variações nesta numeração, temporariamente sem prévio aviso.</remarks>
                /// </summary>
                [Atributo(Sequencia = 10, Regex = @"(?<NUMERO_RETORNO>\d{5})")]
                public string NUMERO_RETORNO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_RETORNO"))
                            Dicionario["NUMERO_RETORNO"] = "".PadLeft(5, '0');

                        return Dicionario["NUMERO_RETORNO"].ToString().PadLeft(5, '0').Substring(0, 5);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(5, '0').IsNumericArray(5))
                            throw new ArgumentException("Numero Retorno deve ter 5 digitos numéricos;");

                        Dicionario["NUMERO_RETORNO"] = value.Trim().PadLeft(5, '0').Substring(0, 5);
                    }
                }

                /// <summary>
                /// Data da gravação do arquivo no formato AAAAMMDD. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 11, Regex = @"(?<DATA_ARQUIVO>\d{8})")]
                public DateTime DATA_ARQUIVO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DATA_ARQUIVO"))
                            Dicionario["DATA_ARQUIVO"] = DateTime.Now.ToString("yyyyMMdd");

                        DateTime dt;

                        DateTime.TryParseExact(Dicionario["DATA_ARQUIVO"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dt);

                        return dt;
                    }
                    set
                    {
                        Dicionario["DATA_ARQUIVO"] = value.ToString("yyyyMMdd");
                    }
                }

                /// <summary>
                /// Hora da gravação do arquivo no formato HHMMSS. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 12, Regex = @"(?<HORA_ARQUIVO>\d{6})")]
                public DateTime HORA_ARQUIVO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("HORA_ARQUIVO"))
                            Dicionario["HORA_ARQUIVO"] = DateTime.Now.ToString("HHmmss");

                        DateTime h;

                        DateTime.TryParseExact(Dicionario["HORA_ARQUIVO"], "HHmmss", null, System.Globalization.DateTimeStyles.None, out h);

                        return h;
                    }
                    set
                    {
                        Dicionario["HORA_ARQUIVO"] = value.ToString("HHmmss");
                    }
                }

                /// <summary>
                /// Densidade de gravação do arquivo/fita. Brancos.
                /// </summary>
                [Atributo(Sequencia = 13, Regex = @"(?<DENSIDADE_GRAVACAO>.{5})")]
                public string DENSIDADE_GRAVACAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("DENSIDADE_GRAVACAO"))
                            Dicionario["DENSIDADE_GRAVACAO"] = "".PadRight(5, ' ');

                        return Dicionario["DENSIDADE_GRAVACAO"].PadRight(5, ' ').Substring(0, 5);
                    }
                    set
                    {
                        if (value.Trim().Length > 5)
                            throw new ArgumentException("Densidade de Gravacao deve ter até 5 caracteres;");

                        Dicionario["DENSIDADE_GRAVACAO"] = value.Trim().PadRight(5, ' ').Substring(0, 5);
                    }
                }

                /// <summary>
                /// Unidade de densidade da gravação do arquivo/fita. Brancos.
                /// </summary>
                [Atributo(Sequencia = 14, Regex = @"(?<UNIDADE_DENSIDADE>.{3})")]
                public string UNIDADE_DENSIDADE
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("UNIDADE_DENSIDADE"))
                            Dicionario["UNIDADE_DENSIDADE"] = "".PadRight(3, ' ');

                        return Dicionario["UNIDADE_DENSIDADE"].PadRight(3, ' ').Substring(0, 3).Trim();
                    }
                    set
                    {
                        if (value.Trim().Length > 3)
                            throw new ArgumentException("Unidade de Densidade de Gravacao deve ter até 3 caracteres;");

                        Dicionario["UNIDADE_DENSIDADE"] = value.Trim().PadRight(3, ' ').Substring(0, 3);
                    }
                }

                /// <summary>
                /// Identificação Módulo Micro. Brancos.
                /// </summary>
                [Atributo(Sequencia = 15, Regex = @"(?<IDENTIFICACAO_MODULO>.{5})")]
                public string IDENTIFICACAO_MODULO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("IDENTIFICACAO_MODULO"))
                            Dicionario["IDENTIFICACAO_MODULO"] = "".PadRight(5, ' ');

                        return Dicionario["IDENTIFICACAO_MODULO"].PadRight(5, ' ').Substring(0, 5);
                    }
                    set
                    {
                        if (value.Length > 5)
                            throw new ArgumentException("Identificação do Modulo deve ter até 5 caracteres;");

                        Dicionario["IDENTIFICACAO_MODULO"] = value.PadRight(5, ' ').Substring(0, 5);
                    }
                }

                /// <summary>
                /// <para>Tipo de Processamento. Campo válido somente para o arquivo-retorno. Para todas as modalidades, o sistema gera diariamente 2 (dois) tipos de arquivos-retorno, exceto para a modalidade 30 - Cobrança Bradesco, na qual são gerados 3 (três) tipos, ou seja:</para>
                /// <para>1 = Rastreamento da Cobrança Bradesco/Rastreamento DDA / Cheque estornado e DOC COMPE devolvido</para>
                /// <para>2 = Confirmação de Agendamento/Inconsistência</para>
                /// <para>3 = Confirmação de Pagamento/Pagamento não efetuado</para>
                /// </summary>
                [Atributo(Sequencia = 16, Regex = @"(?<TIPO_PROCESSAMENTO>0|1|2|3)")]
                public CNAB.TIPO_PROCESSAMENTO TIPO_PROCESSAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_PROCESSAMENTO"))
                            Dicionario["TIPO_PROCESSAMENTO"] = ((int)CNAB.TIPO_PROCESSAMENTO.DESCONSIDERADO).ToString();

                        //return Dicionario[Enum.GetName(typeof(CNAB.DADOS), CNAB.DADOS.TIPO_PROCESSAMENTO)].ToString().Substring(0, 1);
                        return Enum.GetValues(typeof(CNAB.TIPO_PROCESSAMENTO))
                            .Cast<CNAB.TIPO_PROCESSAMENTO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_PROCESSAMENTO"])
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_PROCESSAMENTO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// Reservado para uso da empresa. Variavel - Opcional.
                /// </summary>
                [Atributo(Sequencia = 17, Regex = @"(?<RESERVADO_USO_EMPRESA>.{74})")]
                public string RESERVADO_USO_EMPRESA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_EMPRESA"))
                            Dicionario["RESERVADO_USO_EMPRESA"] = "".PadRight(74, ' ');

                        return Dicionario["RESERVADO_USO_EMPRESA"].PadRight(74, ' ').Substring(0, 74);
                    }
                    set
                    {
                        if (value.Length > 74)
                            throw new ArgumentException("Uso Empresa deve ter até 74 caracteres;");

                        Dicionario["RESERVADO_USO_EMPRESA"] = value.PadRight(74, ' ').Substring(0, 74);
                    }
                }

                /// <summary>
                /// Posição 181 A 260. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 18, Regex = @"(?<RESERVADO_USO_BANCO_1>.{80})")]
                public string RESERVADO_USO_BANCO_1
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_1"))
                            Dicionario["RESERVADO_USO_BANCO_1"] = "".PadRight(80, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_1"].PadRight(80, ' ').Substring(0, 80);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_1"] = value.PadRight(80, ' ').Substring(0, 80);
                    }
                }

                /// <summary>
                /// Posição 261 A 477. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 19, Regex = @"(?<RESERVADO_USO_BANCO_2>.{217})")]
                public string RESERVADO_USO_BANCO_2
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_2"))
                            Dicionario["RESERVADO_USO_BANCO_2"] = "".PadRight(217, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_2"].PadRight(217, ' ').Substring(0, 217);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_2"] = value.PadRight(217, ' ').Substring(0, 217);
                    }
                }

                /// <summary>
                /// Número da Lista de Débito. O número da Lista de Débito deve ser Sequencial crescente e em hipótese alguma pode ser repetido. 
                /// </summary>
                /// <remarks>No documento de especificação fornecido pelo Banco este campo é numérico portanto deveria ser preenchido com zeros a esquerda, mas conforme arquivo de remessa do PagFor este campo é preechido com espaços. Segundo orientação do suporte este campo deve ter espaços contradizendo o documento de especificação do layout do arquivo CNAB.</remarks>
                [Atributo(Sequencia = 20, Regex = @"(?<NUMERO_LISTA_DEBITO>.{9})")]
                public string NUMERO_LISTA_DEBITO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_LISTA_DEBITO"))
                            Dicionario["NUMERO_LISTA_DEBITO"] = "".PadRight(9, ' ');

                        return Dicionario["NUMERO_LISTA_DEBITO"].PadRight(9, ' ').Substring(0, 9);
                    }
                    set
                    {
                        if (value.Length > 9)
                            throw new ArgumentException("Número da Lista de Débito deve ter no máximo 9 caracteres;");

                        Dicionario["NUMERO_LISTA_DEBITO"] = value.PadRight(9, ' ').Substring(0, 9);
                    }
                }

                /// <summary>
                /// Posição 487 A 494. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 21, Regex = @"(?<RESERVADO_USO_BANCO_3>.{8})")]
                public string RESERVADO_USO_BANCO_3
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO_USO_BANCO_3"))
                            Dicionario["RESERVADO_USO_BANCO_3"] = "".PadRight(8, ' ');

                        return Dicionario["RESERVADO_USO_BANCO_3"].PadRight(8, ' ').Substring(0, 8);
                    }
                    set
                    {
                        Dicionario["RESERVADO_USO_BANCO_3"] = value.PadRight(8, ' ').Substring(0, 8);
                    }
                }

                /// <summary>
                /// Número Sequencial do Registro. Sequencial crescente de 1 a 1 no arquivo. O primeiro header será sempre 000001. Obrigatório.
                /// </summary>
                [Atributo(Sequencia = 22, Regex = @"(?<NUMERO_SEQUENCIAL>000001)")]
                public UInt32 NUMERO_SEQUENCIAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_SEQUENCIAL"))
                            Dicionario["NUMERO_SEQUENCIAL"] = "1".PadLeft(6, '0');

                        return UInt32.Parse(Dicionario["NUMERO_SEQUENCIAL"]);
                    }
                    set
                    {
                        Dicionario["NUMERO_SEQUENCIAL"] = ((int)value).ToString().PadLeft(6, '0').Substring(0, 6);
                    }
                }

                #endregion

                #region Construtores

                /// <summary>
                /// Construtor da classe
                /// </summary>
                public Cabecalho()
                {
                    base.Reset();
                }

                /// <summary>
                /// Construtor da classe
                /// </summary>
                /// <param name="Registro"></param>
                public Cabecalho(string Registro)
                {
                    base.Reset();

                    base._Registro = Registro;

                    base.Parse();
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
                    char[] CODIGO_COMUNICACAO,
                    CNAB.TIPO_INSCRICAO TIPO_INSCRICAO,
                    string CNPJ,
                    string CNPJ_FILIAL,
                    string CNPJ_DIGITO,
                    string NOME_EMPRESA,
                    string NUMERO_REMESSA)
                {
                    base.Reset();

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
        }
    }
}
