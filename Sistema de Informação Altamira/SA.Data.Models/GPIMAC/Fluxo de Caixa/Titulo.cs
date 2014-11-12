using System;
using System.Collections.Generic;
using SA.ORM.PetaPoco;
using SA.ORM.PetaPoco.GPIMAC;
using System.Linq;

namespace SA.Data.Models.GPIMAC.FluxoCaixa
{
    [TableName("Lançamentos do Fluxo de Caixa")]
    [ExplicitColumns]
    public class Titulo : Context.Record<Titulo> 
    {
        #region Properties

        [Column]
        public string Empresa
        {
            get
            {
                return _Empresa;
            }
            set
            {
                _Empresa = value;
                MarkColumnModified("Empresa");
            }
        }
        string _Empresa;

        [Column("Titulo")]
        public string Numero
        {
            get
            {
                return _Numero;
            }
            set
            {
                _Numero = value;
                MarkColumnModified("Numero");
            }
        }
        string _Numero;

        [Column]
        public string Documento
        {
            get
            {
                return _Documento;
            }
            set
            {
                _Documento = value;
                MarkColumnModified("Documento");
            }
        }
        string _Documento;

        [Column]
        public string Pedido
        {
            get
            {
                return _Pedido;
            }
            set
            {
                _Pedido = value;
                MarkColumnModified("Pedido");
            }
        }
        string _Pedido;

        [Column]
        public string Titular
        {
            get
            {
                return _Titular;
            }
            set
            {
                _Titular = value;
                MarkColumnModified("Titular");
            }
        }
        string _Titular;

        [Column]
        public string Tipo
        {
            get
            {
                return _Tipo;
            }
            set
            {
                _Tipo = value;
                MarkColumnModified("Tipo");
            }
        }
        string _Tipo;

        [Column]
        public DateTime? Emissao
        {
            get
            {
                return _Emissao;
            }
            set
            {
                _Emissao = value;
                MarkColumnModified("Emissao");
            }
        }
        DateTime? _Emissao;

        [Column]
        public DateTime? Vencimento
        {
            get
            {
                return _Vencimento;
            }
            set
            {
                _Vencimento = value;
                MarkColumnModified("Vencimento");
            }
        }
        DateTime? _Vencimento;

        [Column]
        public DateTime? Pagamento
        {
            get
            {
                return _Pagamento;
            }
            set
            {
                _Pagamento = value;
                MarkColumnModified("Pagamento");
            }
        }
        DateTime? _Pagamento;

        [Column("Valor do Titulo")]
        public decimal? Valor
        {
            get
            {
                return _Valor;
            }
            set
            {
                _Valor = value;
                MarkColumnModified("Valor");
            }
        }
        decimal? _Valor;

        [Column("Total Baixado")]
        public decimal? Baixado
        {
            get
            {
                return _Baixado;
            }
            set
            {
                _Baixado = value;
                MarkColumnModified("Baixado");
            }
        }
        decimal? _Baixado;

        [Column("Valor do Saldo")]
        public decimal? Saldo
        {
            get
            {
                return _Saldo;
            }
            set
            {
                _Saldo = value;
                MarkColumnModified("Saldo");
            }
        }
        decimal? _Saldo;

        [Column("Conta")]
        public string Origem
        {
            get
            {
                return _Origem;
            }
            set
            {
                _Origem = value;
                MarkColumnModified("Origem");
            }
        }
        string _Origem;

        [Column]
        public string Grupo
        {
            get
            {
                return _Grupo;
            }
            set
            {
                _Grupo = value;
                MarkColumnModified("Grupo");
            }
        }
        string _Grupo;

        [Column]
        public string SubGrupo
        {
            get
            {
                return _SubGrupo;
            }
            set
            {
                _SubGrupo = value;
                MarkColumnModified("SubGrupo");
            }
        }
        string _SubGrupo;

        [Column("Plano de Contas")]
        public string Conta
        {
            get
            {
                return _Conta;
            }
            set
            {
                _Conta = value;
                MarkColumnModified("Conta");
            }
        }
        string _Conta;

        #endregion

        public static IEnumerable<SA.Data.Models.GPIMAC.FluxoCaixa.Titulo> ListAll()
        //public static Dictionary<string, Dictionary<string, decimal?>> ListAll()
        {
            try
            {
                //var db = new ORM.PetaPoco.Database("ConnectionString");
                
                //return db.Query<Titulo>("SELECT * FROM [GPIMAC].[Lançamentos do Fluxo de Caixa]");

                return SA.Data.Models.GPIMAC.FluxoCaixa.Titulo.Query("SELECT * FROM [GPIMAC].[Lançamentos do Fluxo de Caixa] WHERE Pagamento IS NULL");

                //var query = from item in t
                //            let key = new { Category = item.Tipo, Type = item.Type }
                //            group new { Detail = item.Titular, Cost = item.Valor } by key;

                //return t.Pivot(titular => titular.Titular, vencto => vencto.Vencimento.ToString(), valor => valor.Sum(titular => titular.Valor));
 
            }
            catch
            {
                throw;
            }
        }
    }
}
