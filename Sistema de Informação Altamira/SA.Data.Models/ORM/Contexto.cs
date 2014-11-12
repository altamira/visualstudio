using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.Data.Models.ORM
{
    class Contexto : DbContext
    {
        public DbSet<SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Instrucao> Instrucao { get; set; }
        public DbSet<SA.Data.Models.Financeiro.Bancos.Banco> Banco { get; set; }
    }
}
