using System.Windows.Controls;
using System.Linq;
using System.Collections.Generic;
using System;

namespace SA.WPF.Application
{
    public class Grupos
    {
        public string Titular { get; set; }
        public DateTime? Vencimento { get; set; }
        public decimal? Valor { get; set; }
    }

    public class Pivot
    {
        public string Titular { get; set; }
        public IEnumerable<DateTime?> Vencimento { get; set; }
        public IEnumerable<decimal?> Valor { get; set; }
    }

    /// <summary>
    /// Interação lógica para FluxoCaixa.xam
    /// </summary>
    public partial class FluxoCaixa : UserControl
    {
        public FluxoCaixa()
        {
            InitializeComponent();

            System.Windows.Controls.DataGrid grid = LancamentosGridView;

            var query = SA.Data.Models.GPIMAC.FluxoCaixa.Titulo.ListAll();

            var groups = from item in query
                         orderby item.Titular ascending
                         group item by new { item.Titular, item.Vencimento } into grp
                         select new Grupos()
                               {
                                   Titular = grp.Key.Titular,
                                   Vencimento = grp.Key.Vencimento.HasValue ? grp.Key.Vencimento.Value : new Nullable<DateTime>(),
                                   Valor = grp.Select(v => v.Valor).Sum()
                               };

            var pivot = (from n in groups
                         group n by n.Titular into source
                         select new Pivot()
                         {
                             Titular = source.Key,
                             Vencimento = source.Select(s => s.Vencimento),
                             Valor = source.Select(s => s.Valor)
                         }).ToList();

            //LancamentosGridView.DataContext = pivot;


            grid.AutoGenerateColumns = false;

            grid.Columns.Add(new DataGridTextColumn() { Header = "Titular" });

            foreach (Pivot p in pivot)
            {
                grid.Items.Add(p);
            }

        }
    }
}
