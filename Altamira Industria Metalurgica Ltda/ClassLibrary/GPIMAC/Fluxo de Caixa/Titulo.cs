using System;
using System.Collections.Generic;

namespace SA.Data.Models.GPIMAC.FluxoCaixa
{
    //[ORM.PetaPoco.TableName("[GPIMAC].[Lançamentos do Fluxo de Caixa]")]
    //[ORM.PetaPoco.PrimaryKey("[Título]")]
    public class Titulo
    {
        #region Properties

        [ORM.PetaPoco.Column("[Empresa]")]
        public int Empresa { get; set; }

        [ORM.PetaPoco.Column("[Titulo]")]
        private int Numero { get; set; }
        
        [ORM.PetaPoco.Column("[Documento]")]
        private string Documento { get; set; }
        
        [ORM.PetaPoco.Column("[Pedido]")]
        private int Pedido { get; set; }
        
        [ORM.PetaPoco.Column("[Titular]")]
        private string Titular { get; set; }
        
        [ORM.PetaPoco.Column("[Tipo]")]
        private string Tipo { get; set; }
        
        [ORM.PetaPoco.Column("[Emissao]")]
        private DateTime Emissao { get; set; }
        
        [ORM.PetaPoco.Column("[Vencimento]")]
        private DateTime Vencimento { get; set; }
        
        [ORM.PetaPoco.Column("[Pagamento]")]
        private DateTime Pagamento { get; set; }
        
        [ORM.PetaPoco.Column("[Valor do Titulo]")]
        private float Valor { get; set; }
        
        [ORM.PetaPoco.Column("[Total Baixado]")]
        private float Baixado { get; set; }
        
        [ORM.PetaPoco.Column("[Valor do Saldo]")]
        private float Saldo { get; set; }
        
        [ORM.PetaPoco.Column("[Conta]")]
        private string Conta { get; set; }
        
        [ORM.PetaPoco.Column("[Grupo]")]
        private string Grupo { get; set; }
        
        [ORM.PetaPoco.Column("[Sub Grupo]")]
        private string SubGrupo { get; set; }
        
        [ORM.PetaPoco.Column("[Plano de Contas]")]
        private string PlanoConta { get; set; }

        #endregion

        public static IEnumerable<Titulo> ListAll()
        {
            try
            {
                var db = new ORM.PetaPoco.Database("SA");

                return db.Query<Titulo>("SELECT [Empresa], [Titular] FROM [GPIMAC].[Lançamentos do Fluxo de Caixa]");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
