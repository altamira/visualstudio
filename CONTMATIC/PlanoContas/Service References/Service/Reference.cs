﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18034
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CONTMATIC.Service {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="ContaContabil", Namespace="http://schemas.datacontract.org/2004/07/Webservice")]
    [System.SerializableAttribute()]
    public partial class ContaContabil : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CNPJField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ContaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ContaAntigaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NomeField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string PessoaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int ReduzidaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int ReduzidaAntigaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string TipoField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CNPJ {
            get {
                return this.CNPJField;
            }
            set {
                if ((object.ReferenceEquals(this.CNPJField, value) != true)) {
                    this.CNPJField = value;
                    this.RaisePropertyChanged("CNPJ");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Conta {
            get {
                return this.ContaField;
            }
            set {
                if ((object.ReferenceEquals(this.ContaField, value) != true)) {
                    this.ContaField = value;
                    this.RaisePropertyChanged("Conta");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string ContaAntiga {
            get {
                return this.ContaAntigaField;
            }
            set {
                if ((object.ReferenceEquals(this.ContaAntigaField, value) != true)) {
                    this.ContaAntigaField = value;
                    this.RaisePropertyChanged("ContaAntiga");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Nome {
            get {
                return this.NomeField;
            }
            set {
                if ((object.ReferenceEquals(this.NomeField, value) != true)) {
                    this.NomeField = value;
                    this.RaisePropertyChanged("Nome");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Pessoa {
            get {
                return this.PessoaField;
            }
            set {
                if ((object.ReferenceEquals(this.PessoaField, value) != true)) {
                    this.PessoaField = value;
                    this.RaisePropertyChanged("Pessoa");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Reduzida {
            get {
                return this.ReduzidaField;
            }
            set {
                if ((this.ReduzidaField.Equals(value) != true)) {
                    this.ReduzidaField = value;
                    this.RaisePropertyChanged("Reduzida");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int ReduzidaAntiga {
            get {
                return this.ReduzidaAntigaField;
            }
            set {
                if ((this.ReduzidaAntigaField.Equals(value) != true)) {
                    this.ReduzidaAntigaField = value;
                    this.RaisePropertyChanged("ReduzidaAntiga");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Tipo {
            get {
                return this.TipoField;
            }
            set {
                if ((object.ReferenceEquals(this.TipoField, value) != true)) {
                    this.TipoField = value;
                    this.RaisePropertyChanged("Tipo");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="Participante", Namespace="http://schemas.datacontract.org/2004/07/Webservice")]
    [System.SerializableAttribute()]
    public partial class Participante : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CCClienteField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CCFornecedorField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CNPJField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NomeField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string PessoaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string TipoField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CCCliente {
            get {
                return this.CCClienteField;
            }
            set {
                if ((object.ReferenceEquals(this.CCClienteField, value) != true)) {
                    this.CCClienteField = value;
                    this.RaisePropertyChanged("CCCliente");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CCFornecedor {
            get {
                return this.CCFornecedorField;
            }
            set {
                if ((object.ReferenceEquals(this.CCFornecedorField, value) != true)) {
                    this.CCFornecedorField = value;
                    this.RaisePropertyChanged("CCFornecedor");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CNPJ {
            get {
                return this.CNPJField;
            }
            set {
                if ((object.ReferenceEquals(this.CNPJField, value) != true)) {
                    this.CNPJField = value;
                    this.RaisePropertyChanged("CNPJ");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Nome {
            get {
                return this.NomeField;
            }
            set {
                if ((object.ReferenceEquals(this.NomeField, value) != true)) {
                    this.NomeField = value;
                    this.RaisePropertyChanged("Nome");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Pessoa {
            get {
                return this.PessoaField;
            }
            set {
                if ((object.ReferenceEquals(this.PessoaField, value) != true)) {
                    this.PessoaField = value;
                    this.RaisePropertyChanged("Pessoa");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Tipo {
            get {
                return this.TipoField;
            }
            set {
                if ((object.ReferenceEquals(this.TipoField, value) != true)) {
                    this.TipoField = value;
                    this.RaisePropertyChanged("Tipo");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="LancamentoFluxoCaixa", Namespace="http://schemas.datacontract.org/2004/07/Webservice")]
    [System.SerializableAttribute()]
    public partial class LancamentoFluxoCaixa : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string BancoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CCCreditoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CCDebitoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CNPJField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.Nullable<System.DateTime> ConciliacaoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string DocumentoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.Nullable<System.DateTime> EmissaoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.Nullable<System.DateTime> FaturamentoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int IDLancamentoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int LancamentoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ObservacaoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string OrigemField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.Nullable<System.DateTime> PagamentoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ParcelaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ParcelasField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string PedidoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int SequenciaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string SituacaoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string TipoField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string TitularField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int TituloField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private decimal ValorField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private float ValorBaixaField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.Nullable<System.DateTime> VencimentoField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Banco {
            get {
                return this.BancoField;
            }
            set {
                if ((object.ReferenceEquals(this.BancoField, value) != true)) {
                    this.BancoField = value;
                    this.RaisePropertyChanged("Banco");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CCCredito {
            get {
                return this.CCCreditoField;
            }
            set {
                if ((object.ReferenceEquals(this.CCCreditoField, value) != true)) {
                    this.CCCreditoField = value;
                    this.RaisePropertyChanged("CCCredito");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CCDebito {
            get {
                return this.CCDebitoField;
            }
            set {
                if ((object.ReferenceEquals(this.CCDebitoField, value) != true)) {
                    this.CCDebitoField = value;
                    this.RaisePropertyChanged("CCDebito");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string CNPJ {
            get {
                return this.CNPJField;
            }
            set {
                if ((object.ReferenceEquals(this.CNPJField, value) != true)) {
                    this.CNPJField = value;
                    this.RaisePropertyChanged("CNPJ");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.Nullable<System.DateTime> Conciliacao {
            get {
                return this.ConciliacaoField;
            }
            set {
                if ((this.ConciliacaoField.Equals(value) != true)) {
                    this.ConciliacaoField = value;
                    this.RaisePropertyChanged("Conciliacao");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Documento {
            get {
                return this.DocumentoField;
            }
            set {
                if ((object.ReferenceEquals(this.DocumentoField, value) != true)) {
                    this.DocumentoField = value;
                    this.RaisePropertyChanged("Documento");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.Nullable<System.DateTime> Emissao {
            get {
                return this.EmissaoField;
            }
            set {
                if ((this.EmissaoField.Equals(value) != true)) {
                    this.EmissaoField = value;
                    this.RaisePropertyChanged("Emissao");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.Nullable<System.DateTime> Faturamento {
            get {
                return this.FaturamentoField;
            }
            set {
                if ((this.FaturamentoField.Equals(value) != true)) {
                    this.FaturamentoField = value;
                    this.RaisePropertyChanged("Faturamento");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int IDLancamento {
            get {
                return this.IDLancamentoField;
            }
            set {
                if ((this.IDLancamentoField.Equals(value) != true)) {
                    this.IDLancamentoField = value;
                    this.RaisePropertyChanged("IDLancamento");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Lancamento {
            get {
                return this.LancamentoField;
            }
            set {
                if ((this.LancamentoField.Equals(value) != true)) {
                    this.LancamentoField = value;
                    this.RaisePropertyChanged("Lancamento");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Observacao {
            get {
                return this.ObservacaoField;
            }
            set {
                if ((object.ReferenceEquals(this.ObservacaoField, value) != true)) {
                    this.ObservacaoField = value;
                    this.RaisePropertyChanged("Observacao");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Origem {
            get {
                return this.OrigemField;
            }
            set {
                if ((object.ReferenceEquals(this.OrigemField, value) != true)) {
                    this.OrigemField = value;
                    this.RaisePropertyChanged("Origem");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.Nullable<System.DateTime> Pagamento {
            get {
                return this.PagamentoField;
            }
            set {
                if ((this.PagamentoField.Equals(value) != true)) {
                    this.PagamentoField = value;
                    this.RaisePropertyChanged("Pagamento");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Parcela {
            get {
                return this.ParcelaField;
            }
            set {
                if ((object.ReferenceEquals(this.ParcelaField, value) != true)) {
                    this.ParcelaField = value;
                    this.RaisePropertyChanged("Parcela");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Parcelas {
            get {
                return this.ParcelasField;
            }
            set {
                if ((object.ReferenceEquals(this.ParcelasField, value) != true)) {
                    this.ParcelasField = value;
                    this.RaisePropertyChanged("Parcelas");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Pedido {
            get {
                return this.PedidoField;
            }
            set {
                if ((object.ReferenceEquals(this.PedidoField, value) != true)) {
                    this.PedidoField = value;
                    this.RaisePropertyChanged("Pedido");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Sequencia {
            get {
                return this.SequenciaField;
            }
            set {
                if ((this.SequenciaField.Equals(value) != true)) {
                    this.SequenciaField = value;
                    this.RaisePropertyChanged("Sequencia");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Situacao {
            get {
                return this.SituacaoField;
            }
            set {
                if ((object.ReferenceEquals(this.SituacaoField, value) != true)) {
                    this.SituacaoField = value;
                    this.RaisePropertyChanged("Situacao");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Tipo {
            get {
                return this.TipoField;
            }
            set {
                if ((object.ReferenceEquals(this.TipoField, value) != true)) {
                    this.TipoField = value;
                    this.RaisePropertyChanged("Tipo");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Titular {
            get {
                return this.TitularField;
            }
            set {
                if ((object.ReferenceEquals(this.TitularField, value) != true)) {
                    this.TitularField = value;
                    this.RaisePropertyChanged("Titular");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Titulo {
            get {
                return this.TituloField;
            }
            set {
                if ((this.TituloField.Equals(value) != true)) {
                    this.TituloField = value;
                    this.RaisePropertyChanged("Titulo");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public decimal Valor {
            get {
                return this.ValorField;
            }
            set {
                if ((this.ValorField.Equals(value) != true)) {
                    this.ValorField = value;
                    this.RaisePropertyChanged("Valor");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public float ValorBaixa {
            get {
                return this.ValorBaixaField;
            }
            set {
                if ((this.ValorBaixaField.Equals(value) != true)) {
                    this.ValorBaixaField = value;
                    this.RaisePropertyChanged("ValorBaixa");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public System.Nullable<System.DateTime> Vencimento {
            get {
                return this.VencimentoField;
            }
            set {
                if ((this.VencimentoField.Equals(value) != true)) {
                    this.VencimentoField = value;
                    this.RaisePropertyChanged("Vencimento");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="Service.IPlanoContas")]
    public interface IPlanoContas {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/PlanoContasList", ReplyAction="http://tempuri.org/IPlanoContas/PlanoContasListResponse")]
        CONTMATIC.Service.ContaContabil[] PlanoContasList();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/ContaContabilUpdate", ReplyAction="http://tempuri.org/IPlanoContas/ContaContabilUpdateResponse")]
        bool ContaContabilUpdate(string Conta);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/ParticipantesList", ReplyAction="http://tempuri.org/IPlanoContas/ParticipantesListResponse")]
        CONTMATIC.Service.Participante[] ParticipantesList();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/GetCurrentVersion", ReplyAction="http://tempuri.org/IPlanoContas/GetCurrentVersionResponse")]
        float GetCurrentVersion(string Token, System.DateTime RequestDateTime);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/GetToken", ReplyAction="http://tempuri.org/IPlanoContas/GetTokenResponse")]
        string GetToken(System.DateTime RequestDateTime);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/LancamentosFluxoCaixaList", ReplyAction="http://tempuri.org/IPlanoContas/LancamentosFluxoCaixaListResponse")]
        CONTMATIC.Service.LancamentoFluxoCaixa[] LancamentosFluxoCaixaList(int Data, System.DateTime DataInicial, System.DateTime DataFinal, string Tipo, string Origem, string Banco, string Nome);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPlanoContas/LancamentosFluxoCaixaConciliado", ReplyAction="http://tempuri.org/IPlanoContas/LancamentosFluxoCaixaConciliadoResponse")]
        bool LancamentosFluxoCaixaConciliado(int Titulo, int Lancamento, int Sequencia, string Debito, string Credito);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IPlanoContasChannel : CONTMATIC.Service.IPlanoContas, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class PlanoContasClient : System.ServiceModel.ClientBase<CONTMATIC.Service.IPlanoContas>, CONTMATIC.Service.IPlanoContas {
        
        public PlanoContasClient() {
        }
        
        public PlanoContasClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public PlanoContasClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PlanoContasClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PlanoContasClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public CONTMATIC.Service.ContaContabil[] PlanoContasList() {
            return base.Channel.PlanoContasList();
        }
        
        public bool ContaContabilUpdate(string Conta) {
            return base.Channel.ContaContabilUpdate(Conta);
        }
        
        public CONTMATIC.Service.Participante[] ParticipantesList() {
            return base.Channel.ParticipantesList();
        }
        
        public float GetCurrentVersion(string Token, System.DateTime RequestDateTime) {
            return base.Channel.GetCurrentVersion(Token, RequestDateTime);
        }
        
        public string GetToken(System.DateTime RequestDateTime) {
            return base.Channel.GetToken(RequestDateTime);
        }
        
        public CONTMATIC.Service.LancamentoFluxoCaixa[] LancamentosFluxoCaixaList(int Data, System.DateTime DataInicial, System.DateTime DataFinal, string Tipo, string Origem, string Banco, string Nome) {
            return base.Channel.LancamentosFluxoCaixaList(Data, DataInicial, DataFinal, Tipo, Origem, Banco, Nome);
        }
        
        public bool LancamentosFluxoCaixaConciliado(int Titulo, int Lancamento, int Sequencia, string Debito, string Credito) {
            return base.Channel.LancamentosFluxoCaixaConciliado(Titulo, Lancamento, Sequencia, Debito, Credito);
        }
    }
}
