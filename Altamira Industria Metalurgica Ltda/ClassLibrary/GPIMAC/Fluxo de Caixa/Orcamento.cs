using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace SA.Data.Models.GPIMAC
{
    [ORM.PetaPoco.TableName("[GPIMAC].[Orcamento]")]
    [ORM.PetaPoco.PrimaryKey("[Numero]")]
    public class Orcamento
    {
        //private int numero;
        //private DateTime dataCriacao;
        //private string cliente;

        [ORM.PetaPoco.Column("[Numero]")]               public int Numero { get; set; }
        [ORM.PetaPoco.Column("[Data do Cadastro]")]     public DateTime DataCriacao { get; set; }
        [ORM.PetaPoco.Column("[Nome]")]                 public string Cliente { get; set; }
            
        public static IEnumerable<Orcamento> ListAll()
        {
            //SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            //Connection.Open();

            //SqlCommand Command = new SqlCommand();
            //Command.Connection = Connection;
            //Command.CommandType = CommandType.StoredProcedure;

            //Command.CommandText = "SELECT * FROM WBCCAD.Orcamento";

            ////Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            ////Command.Parameters.Add(new SqlParameter("@Nome", SqlDbType.NVarChar, 50)).Value = NomeTextBox.Text.Trim();

            //SqlDataReader DataReader = Command.ExecuteReader();
            
            //var qry = new Select().From(Product.Schema).Where(Product.CategoryIdColumn).IsEqualTo(x);

            //return qry.ExecuteReader();

            //if (DataReader.Read())
            //{
            //    DataReader.AsQueryable();
            //}

            //DataReader.Close();

            //Connection.Close();

            // Create a PetaPoco database object
            var db = new ORM.PetaPoco.Database("SA");

            return db.Query<Orcamento>("SELECT TOP 1000 [Numero],[Comissao],[Data do Cadastro],[Data da Emissao],[Nome] FROM [WBCCAD].[Orcamento]");

            //// Show all articles    
            //foreach (var o in q)
            //{
            //    Console.WriteLine("{0} - {1} - {2}", o.Numero, o.DataCriacao, o.Cliente);
            //}

            //return q.ToList();

        }
    
    }
}
