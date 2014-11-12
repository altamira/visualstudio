using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using SA.ORM.PetaPoco;

namespace SA.Data.Models.WBCCAD
{
    [TableName("[WBCCAD].[Orcamento]")]
    [PrimaryKey("[Numero]")]
    public class Orcamento
    {
        //private int numero;
        //private DateTime dataCriacao;
        //private string cliente;

        [Column("Numero")]                 
        public int Numero { get; set; }
        
        [Column("Comissao")]
        public float Comissao { get; set; }
        
        [Column("Data do Cadastro")]       
        public DateTime Criacao { get; set; }

        [Column("Data da Emissao")]
        public DateTime Emissao { get; set; }

        [Column("Nome")]                   
        public string Cliente { get; set; }
            
        public static IEnumerable<Orcamento> ListAll()
        {
            var db = new Database("SA");

            return db.Query<Orcamento>("SELECT [Numero],[Comissao],[Data do Cadastro],[Data da Emissao],[Nome] FROM [WBCCAD].[Orcamento]");

        }
    
    }
}
