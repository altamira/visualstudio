using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web.Services.Protocols;

namespace Webservice
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IPlanoContas
    {
        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/PlanoContasList", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        List<ContaContabil> PlanoContasList(/*string Token, DateTime RequestDateTime*/);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/ContaContabilUpdate", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        bool ContaContabilUpdate(/*string Token, DateTime RequestDateTime,*/ string Conta);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/ParticipantesList", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        List<Participante> ParticipantesList(/*string Token, DateTime RequestDateTime*/);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/GetCurrentVersion", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        float GetCurrentVersion(string Token, DateTime RequestDateTime);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/GetToken", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        string GetToken(DateTime RequestDateTime);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/LancamentosFluxoCaixaList", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        List<LancamentoFluxoCaixa> LancamentosFluxoCaixaList(/*string Token, DateTime RequestDateTime,*/ int Data, DateTime DataInicial, DateTime DataFinal, string Tipo, string Origem, string Banco, string Nome);

        [OperationContract]
        [WebInvoke(Method = "GET", UriTemplate = "/LancamentosFluxoCaixaConciliado", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json)]
        bool LancamentosFluxoCaixaConciliado(/*string Token, DateTime RequestDateTime,*/ int Titulo, int Lancamento, int Sequencia, string Debito, string Credito);

    }

    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    [DataContract]
    public class ContaContabil
    {
        private string conta;

        [DataMember]
        public string Conta
        {
            get { return conta; }
            set { conta = value; }
        }

        private string contaantiga;

        [DataMember]
        public string ContaAntiga
        {
            get { return contaantiga; }
            set { contaantiga = value; }
        }

        private string cnpj;

        [DataMember]
        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }
        
        private string nome;

        [DataMember]
        public string Nome
        {
            get { return nome; }
            set { nome = value; }
        }

        private string tipo;

        [DataMember]
        public string Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }
        
        private int reduzida;

        [DataMember]
        public int Reduzida
        {
            get { return reduzida; }
            set { reduzida = value; }
        }

        private int reduzidaantiga;

        [DataMember]
        public int ReduzidaAntiga
        {
            get { return reduzidaantiga; }
            set { reduzidaantiga = value; }
        }

        private string pessoa;

        [DataMember]
        public string Pessoa
        {
            get { return pessoa; }
            set { pessoa = value; }
        }
    }

    [DataContract]
    public class Participante
    {
        private string cnpj;

        [DataMember]
        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }

        private string nome;

        [DataMember]
        public string Nome
        {
            get { return nome; }
            set { nome = value; }
        }

        private string tipo;

        [DataMember]
        public string Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }

        private string pessoa;

        [DataMember]
        public string Pessoa
        {
            get { return pessoa; }
            set { pessoa = value; }
        }

        private string cccliente;

        [DataMember]
        public string CCCliente
        {
            get { return cccliente; }
            set { cccliente = value; }
        }

        private string ccfornecedor;

        [DataMember]
        public string CCFornecedor
        {
            get { return ccfornecedor; }
            set { ccfornecedor = value; }
        }

    }

    [DataContract]
    public class LancamentoFluxoCaixa
    {
        private int titulo;

        [DataMember]
        public int Titulo
        {
            get { return titulo; }
            set { titulo = value; }
        }

        private string documento;

        [DataMember]
        public string Documento
        {
            get { return documento; }
            set { documento = value; }
        }

        private string pedido;

        [DataMember]
        public string Pedido
        {
            get { return pedido; }
            set { pedido = value; }
        }

        private string origem;

        [DataMember]
        public string Origem
        {
            get { return origem; }
            set { origem = value; }
        }
        
        private DateTime? emissao;

        [DataMember]
        public DateTime? Emissao
        {
            get { return emissao; }
            set { emissao = value; }
        }

        private DateTime? vencimento;

        [DataMember]
        public DateTime? Vencimento
        {
            get { return vencimento; }
            set { vencimento = value; }
        }

        private DateTime? pagamento;

        [DataMember]
        public DateTime? Pagamento
        {
            get { return pagamento; }
            set { pagamento = value; }
        }

        private DateTime? faturamento;

        [DataMember]
        public DateTime? Faturamento
        {
            get { return faturamento; }
            set { faturamento = value; }
        }
        
        private string cnpj;

        [DataMember]
        public string CNPJ
        {
            get { return cnpj; }
            set { cnpj = value; }
        }

        private string titular;

        [DataMember]
        public string Titular
        {
            get { return titular; }
            set { titular = value; }
        }

        private string tipo;

        [DataMember]
        public string Tipo
        {
            get { return tipo; }
            set { tipo = value; }
        }

        private string banco;

        [DataMember]
        public string Banco
        {
            get { return banco; }
            set { banco = value; }
        }
        
        private string parcela;

        [DataMember]
        public string Parcela
        {
            get { return parcela; }
            set { parcela = value; }
        }

        private string parcelas;

        [DataMember]
        public string Parcelas
        {
            get { return parcelas; }
            set { parcelas = value; }
        }

        private decimal valor;

        [DataMember]
        public decimal Valor
        {
            get { return valor; }
            set { valor = value; }
        }

        private decimal valorbaixa;

        [DataMember]
        public decimal ValorBaixa
        {
            get { return valorbaixa; }
            set { valorbaixa = value; }
        }

        private string situacao;

        [DataMember]
        public string Situacao
        {
            get { return situacao; }
            set { situacao = value; }
        }

        private string observacao;

        [DataMember]
        public string Observacao
        {
            get { return observacao; }
            set { observacao = value; }
        }

        private DateTime? conciliacao;

        [DataMember]
        public DateTime? Conciliacao
        {
            get { return conciliacao; }
            set { conciliacao = value; }
        }

        private int idlancamento;

        [DataMember]
        public int IDLancamento
        {
            get { return idlancamento; }
            set { idlancamento = value; }
        }

        private int lancamento;

        [DataMember]
        public int Lancamento
        {
            get { return lancamento; }
            set { lancamento = value; }
        }

        private int sequencia;

        [DataMember]
        public int Sequencia
        {
            get { return sequencia; }
            set { sequencia = value; }
        }

        private string ccdebito;

        [DataMember]
        public string CCDebito
        {
            get { return ccdebito; }
            set { ccdebito = value; }
        }

        private string cccredito;

        [DataMember]
        public string CCCredito
        {
            get { return cccredito; }
            set { cccredito = value; }
        }
    }
}
