using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.WPF.Financial.Model.Filters
{
    public interface IFilter<T> where T : DbContext
    {
        T DbContext { get; set; }

        void Apply();
    }
}
