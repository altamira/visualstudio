using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using SA.Data.Types.Metrica;
using SA.ORM.PetaPoco;

namespace SA.Data.Models
{
    [TableName("[Produto]")]
    [PrimaryKey("[Id]")]
    public class Produto
    {
        //private int id;
        //private string codigo;
        //private string descricao;
        //private SA.DataTypes.Metrica.Medida estoque;

        public Produto()
        {
        }

        public Produto(int Id, string Codigo, string Descricao, Medida Estoque)
        {
            this.Id = Id;
            this.Codigo = Codigo;
            this.Descricao = Descricao;
            this.Estoque = Estoque;
        }

        [Column("Id")]
        public int Id { get; set; }
        [Column("Codigo")]
        public string Codigo { get; set; }
        [Column("Descricao")]
        public string Descricao { get; set; }
        [Column("Estoque")]
        public Medida Estoque { get; set; }

        public static IEnumerable<Produto> ListAll()
        {
            var db = new Database("SA");

            return db.Query<Produto>("SELECT Id, Codigo, Descricao, Estoque FROM [Produto]");
        }

        public static Produto SingleOrDefault()
        {
            Produto p = null;

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.Text;

            Command.CommandText = "SELECT Id, Codigo, Descricao, Estoque FROM [Produto]";

            //Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            //Command.Parameters.Add(new SqlParameter("@Nome", SqlDbType.NVarChar, 50)).Value = NomeTextBox.Text.Trim();

            SqlDataReader dr = Command.ExecuteReader();

            if (dr.Read())
            {
                p = new Produto();
                p.Id = dr.GetInt32(0);
                p.Codigo = dr.GetString(1);
                p.Descricao = dr.GetString(2);

                Medida m = (Medida)dr[3];

                p.Estoque = m;
            }

            dr.Close();

            Connection.Close();

            return p;
        }

        public override string ToString()
        {
            return string.Format("{0} {1} {2}", Codigo, Descricao, Estoque);
        }

    }
}
