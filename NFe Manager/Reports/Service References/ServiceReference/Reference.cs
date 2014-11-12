﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18034
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Reports.ServiceReference {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="Invoice", Namespace="http://schemas.datacontract.org/2004/07/Model.Models")]
    [System.SerializableAttribute()]
    public partial class Invoice : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private System.DateTime DateField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string FromField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private byte[] HashField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int IdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string KeyField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int NumberField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private Reports.ServiceReference.STATUS StatusField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ToField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string XmlField;
        
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
        public System.DateTime Date {
            get {
                return this.DateField;
            }
            set {
                if ((this.DateField.Equals(value) != true)) {
                    this.DateField = value;
                    this.RaisePropertyChanged("Date");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string From {
            get {
                return this.FromField;
            }
            set {
                if ((object.ReferenceEquals(this.FromField, value) != true)) {
                    this.FromField = value;
                    this.RaisePropertyChanged("From");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public byte[] Hash {
            get {
                return this.HashField;
            }
            set {
                if ((object.ReferenceEquals(this.HashField, value) != true)) {
                    this.HashField = value;
                    this.RaisePropertyChanged("Hash");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Id {
            get {
                return this.IdField;
            }
            set {
                if ((this.IdField.Equals(value) != true)) {
                    this.IdField = value;
                    this.RaisePropertyChanged("Id");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Key {
            get {
                return this.KeyField;
            }
            set {
                if ((object.ReferenceEquals(this.KeyField, value) != true)) {
                    this.KeyField = value;
                    this.RaisePropertyChanged("Key");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int Number {
            get {
                return this.NumberField;
            }
            set {
                if ((this.NumberField.Equals(value) != true)) {
                    this.NumberField = value;
                    this.RaisePropertyChanged("Number");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public Reports.ServiceReference.STATUS Status {
            get {
                return this.StatusField;
            }
            set {
                if ((this.StatusField.Equals(value) != true)) {
                    this.StatusField = value;
                    this.RaisePropertyChanged("Status");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string To {
            get {
                return this.ToField;
            }
            set {
                if ((object.ReferenceEquals(this.ToField, value) != true)) {
                    this.ToField = value;
                    this.RaisePropertyChanged("To");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Xml {
            get {
                return this.XmlField;
            }
            set {
                if ((object.ReferenceEquals(this.XmlField, value) != true)) {
                    this.XmlField = value;
                    this.RaisePropertyChanged("Xml");
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
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="STATUS", Namespace="http://schemas.datacontract.org/2004/07/Model.Models")]
    public enum STATUS : short {
        
        [System.Runtime.Serialization.EnumMemberAttribute()]
        New = 0,
        
        [System.Runtime.Serialization.EnumMemberAttribute()]
        Accepted = 1,
        
        [System.Runtime.Serialization.EnumMemberAttribute()]
        Rejected = 2,
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="ServiceReference.IService")]
    public interface IService {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/GetInvoices", ReplyAction="http://tempuri.org/IService/GetInvoicesResponse")]
        Reports.ServiceReference.Invoice[] GetInvoices();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/GetInvoices", ReplyAction="http://tempuri.org/IService/GetInvoicesResponse")]
        System.Threading.Tasks.Task<Reports.ServiceReference.Invoice[]> GetInvoicesAsync();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/AcceptInvoice", ReplyAction="http://tempuri.org/IService/AcceptInvoiceResponse")]
        string AcceptInvoice(int Id);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/AcceptInvoice", ReplyAction="http://tempuri.org/IService/AcceptInvoiceResponse")]
        System.Threading.Tasks.Task<string> AcceptInvoiceAsync(int Id);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/RejectInvoice", ReplyAction="http://tempuri.org/IService/RejectInvoiceResponse")]
        string RejectInvoice(int Id);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IService/RejectInvoice", ReplyAction="http://tempuri.org/IService/RejectInvoiceResponse")]
        System.Threading.Tasks.Task<string> RejectInvoiceAsync(int Id);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IServiceChannel : Reports.ServiceReference.IService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class ServiceClient : System.ServiceModel.ClientBase<Reports.ServiceReference.IService>, Reports.ServiceReference.IService {
        
        public ServiceClient() {
        }
        
        public ServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public ServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public Reports.ServiceReference.Invoice[] GetInvoices() {
            return base.Channel.GetInvoices();
        }
        
        public System.Threading.Tasks.Task<Reports.ServiceReference.Invoice[]> GetInvoicesAsync() {
            return base.Channel.GetInvoicesAsync();
        }
        
        public string AcceptInvoice(int Id) {
            return base.Channel.AcceptInvoice(Id);
        }
        
        public System.Threading.Tasks.Task<string> AcceptInvoiceAsync(int Id) {
            return base.Channel.AcceptInvoiceAsync(Id);
        }
        
        public string RejectInvoice(int Id) {
            return base.Channel.RejectInvoice(Id);
        }
        
        public System.Threading.Tasks.Task<string> RejectInvoiceAsync(int Id) {
            return base.Channel.RejectInvoiceAsync(Id);
        }
    }
}