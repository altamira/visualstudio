using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
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
            /// Representa um arquivo no formato CNAB
            /// </summary>
            public abstract partial class Arquivo /*: Stream*/
            {
                #region Variaveis

                /// <summary>
                /// Nome do arquivo
                /// </summary>
                private string nome;

                private uint registros = 0;

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

                /// <summary>
                /// Construtor padrão
                /// </summary>
                /// <param name="Convenio"></param>
                public Arquivo(Convenio Convenio)
                {
                    this.Convenios.Add(Convenio);
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
                    uint sequencial = 0;

                    foreach (Convenio convenio in Convenios)
                    {
                        decimal soma = 0;
                        registros = 1;
                        sequencial = 0;

                        foreach (Empresa empresa in convenio.Empresas)
                        {
                            empresa.Cabecalho.Write(Arquivo);

                            sequencial++;

                            foreach (Instrucao instrucao in empresa.Instrucoes)
                            {
                                instrucao.Write(Arquivo);

                                soma += instrucao.VALOR_PAGAMENTO;

                                registros++;
                                sequencial++;
                            }
                        }

                        convenio.Rodape.QUANTIDADE_REGISTROS = ++registros;
                        convenio.Rodape.NUMERO_SEQUENCIAL = ++sequencial;
                        convenio.Rodape.VALOR_TOTAL_PAGAMENTO = soma;

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
                            case "SA.Data.Models.Financeiro.Bancos.Bradesco+CNAB+Cabecalho":
                                convenio = new Convenio(o as Cabecalho);
                                Convenios.Add(convenio);
                                //Cabecalho = o as Cabecalho;
                                break;
                            case "SA.Data.Models.Financeiro.Bancos.Bradesco+CNAB+Instrucao":
                                convenio.Empresas.Last().Parse(o as Instrucao);
                                break;
                            case "SA.Data.Models.Financeiro.Bancos.Bradesco+CNAB+Rodape":
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
        }
    }
}
