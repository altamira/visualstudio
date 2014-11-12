using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;

namespace SA.WPF.RibbonApplication
{
    /// <summary>
    /// Interação lógica para ContaCorrenteUserControl.xam
    /// </summary>
    public partial class PivotTest : UserControl
    {
        public PivotTest()
        {
            InitializeComponent();

            //DataGridView.DataContext = SA.ClassLibrary
            //Collection<ClassLibrary.ContaCorrente> c = new Collection<ClassLibrary.ContaCorrente>();

            //c.Add(new ClassLibrary.ContaCorrente("Nossa Caixa"));
            //c.Add(new ClassLibrary.ContaCorrente("Banco do Brasil"));
            //c.Add(new ClassLibrary.ContaCorrente("Bradesco"));

            //SaldoContasDataGrid.ItemsSource = c;

            //// DataGrid Pivot style
            //// http://csharperimage.jeremylikness.com/2011/02/pivot-style-data-grid-without-datagrid.html
            //// http://stackoverflow.com/questions/4251183/wpf-two-dimensional-datagrid-listview
            //Collection<ClassLibrary.SaldoContaCorrente> s = new Collection<ClassLibrary.SaldoContaCorrente>();

            //int day = 1;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 100.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 180.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 340.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 14.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 16.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 123.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 11.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 36.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 8.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 11.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 36.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 8.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 11.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 36.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 8.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 11.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 36.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 8.0f));

            //day++;

            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Nossa Caixa").First(), new DateTime(2012, 10, day), 11.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Banco do Brasil").First(), new DateTime(2012, 10, day), 36.0f));
            //s.Add(new ClassLibrary.SaldoContaCorrente(c.Select(i => i).Where(i => i.Banco == "Bradesco").First(), new DateTime(2012, 10, day), 8.0f));



            //var dict = s.Select(i => i.ContaCorrente.Banco).Distinct().ToDictionary(u => u, u => s.Where(i => i.ContaCorrente.Banco == u).ToDictionary(d => d.Data, d => d));

            //var rooms = dict.Values.First().Keys;
            //DataContext = Tuple.Create(dict, rooms);

            //PivotGridView.DataContext = DataContext;
        }
    }
}
