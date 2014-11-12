using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;
using System.Windows.Threading;

namespace GestaoApp.Behaviors.OverlappingTabs
{
    public class SetTabItemZIndexOnSelectionChangedBehavior : Behavior<DependencyObject>
    {
        private static readonly Type DependencyObjectType = typeof(SetTabItemZIndexOnSelectionChangedBehavior);

        private TabControl _tabControl;
        private readonly DispatcherTimer _refreshTimer = new DispatcherTimer();

        public SetTabItemZIndexOnSelectionChangedBehavior()
        {
            _refreshTimer.Interval = TimeSpan.FromSeconds(0);
        }

        #region SourceObject Dependency Property
        public static readonly DependencyProperty SourceObjectProperty =
                               DependencyProperty.Register("SourceObject", typeof(TabControl), DependencyObjectType, new PropertyMetadata(null,
                                   (sender, args) => ((SetTabItemZIndexOnSelectionChangedBehavior)sender).OnSourceObjectPropertyChanged(args)));


        protected virtual void OnSourceObjectPropertyChanged(DependencyPropertyChangedEventArgs e)
        {
            if (e.OldValue != null)
            {
                var tabControl = e.OldValue as TabControl;

                if (tabControl != null)
                {
                    tabControl.SelectionChanged -= TabControlSelectionChanged;
                    tabControl.Loaded -= TabControlLoaded;
                }                
            }

            if (e.NewValue != null)
            {
                var tabControl = e.NewValue as TabControl;

                if (tabControl != null)
                {
                    _tabControl = tabControl;
                    tabControl.SelectionChanged += TabControlSelectionChanged;
                    tabControl.Loaded += TabControlLoaded;
                    StartRefreshTabs();
                }
            }
        }

        public TabControl SourceObject
        {
            get { return (TabControl)GetValue(SourceObjectProperty); }
            set { SetValue(SourceObjectProperty, value); }
        }
        #endregion SourceObject Dependency Property       

        protected override void OnAttached()
        {
            base.OnAttached();

            if (SourceObject != null && _tabControl == null)
            {
                _tabControl = SourceObject;
                _tabControl.SelectionChanged += TabControlSelectionChanged;
                _tabControl.Loaded += TabControlLoaded;
                StartRefreshTabs();
            }
            else if (_tabControl == null && AssociatedObject != null && AssociatedObject is TabControl)
            {
                _tabControl = AssociatedObject as TabControl;                

                _tabControl.SelectionChanged += TabControlSelectionChanged;
                _tabControl.Loaded += TabControlLoaded;
                StartRefreshTabs();
            }            
        }

        private void TabControlLoaded(object sender, RoutedEventArgs e)
        {
            StartRefreshTabs();
        }       
                

        private void TabControlSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            StartRefreshTabs();
        }

        private  void StartRefreshTabs()
        {
            _refreshTimer.Tick += RefreshTimerTick;
            _refreshTimer.Start();
        }

        private void RefreshTimerTick(object sender, EventArgs e)
        {
            _refreshTimer.Stop();            
            _refreshTimer.Tick -= RefreshTimerTick;                        
            RefreshTabs();
        }

        private void RefreshTabs()
        {                       
            if (_tabControl != null)
            {
                var tabControl = _tabControl;              
                                
                for (int i = 0; i < tabControl.Items.Count; i++)                
                {
                    var tabItem = tabControl.Items[i] as TabItem;

                    if (tabItem != null)
                    {                        
                        var zIndex = (tabItem == tabControl.SelectedItem
                                          ? tabControl.Items.Count + 1
                                          : tabControl.Items.Count - i);

                        tabItem.SetValue(Canvas.ZIndexProperty, zIndex);                        
                    }
                }
            }
        }
        
        protected override void OnDetaching()
        {
            _refreshTimer.Stop();
            _refreshTimer.Tick -= RefreshTimerTick;                        

            if (AssociatedObject != null && AssociatedObject is TabControl)
            {
                ((TabControl)AssociatedObject).SelectionChanged -= TabControlSelectionChanged;
                ((TabControl)AssociatedObject).Loaded -= TabControlLoaded;
            }

            if (SourceObject != null)
            {
                SourceObject.SelectionChanged -= TabControlSelectionChanged;
                SourceObject.Loaded -= TabControlLoaded;
            }   

            base.OnDetaching();
        }
    }
}
