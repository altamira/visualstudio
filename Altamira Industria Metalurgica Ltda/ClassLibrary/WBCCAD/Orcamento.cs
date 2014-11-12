using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace SA.Data.Models.WBCCAD
{
    [ORM.PetaPoco.TableName("[WBCCAD].[Orcamento]")]
    [ORM.PetaPoco.PrimaryKey("[Numero]")]
    public class Orcamento
    {
        //private int numero;
        //private DateTime dataCriacao;
        //private string cliente;

        [ORM.PetaPoco.Column("Numero")]                 
        public int Numero { get; set; }
        
        [ORM.PetaPoco.Column("Comissao")]
        public float Comissao { get; set; }
        
        [ORM.PetaPoco.Column("Data do Cadastro")]       
        public DateTime Criacao { get; set; }

        [ORM.PetaPoco.Column("Data da Emissao")]
        public DateTime Emissao { get; set; }

        [ORM.PetaPoco.Column("Nome")]                   
        public string Cliente { get; set; }
            
        public static IEnumerable<Orcamento> ListAll()
        {
            var db = new ORM.PetaPoco.Database("SA");

            return db.Query<Orcamento>("SELECT [Numero],[Comissao],[Data do Cadastro],[Data da Emissao],[Nome] FROM [WBCCAD].[Orcamento]");

        }
    
    }
}
