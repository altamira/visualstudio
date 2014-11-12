using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Interactivity;
using System.Linq;
using System.Collections.Generic;
using System.Windows.Media;
using Telerik.Windows.Controls;
using Telerik.Windows.Controls.GridView;
using System.Windows.Threading; 

namespace GestaoApp.Behaviors.Triggers
{
    public class RadGridViewRowMouseDoubleClickTrigger : TriggerBase<RadGridView>
    {
        private MouseButtonEventHandler _gridViewMouseLeftButtonDownHandler;
        private DateTime _lastMouseDownDateTime = DateTime.Now;
        private bool _hasFirstMouseDownOccured = false;
        private Point _firstMouseDownPosition;

        protected override void OnAttached()
        {
            if (AssociatedObject != null)
            {
                _gridViewMouseLeftButtonDownHandler = new MouseButtonEventHandler(OnGridViewMouseLeftButtonDown);
                AssociatedObject.AddHandler(UIElement.MouseLeftButtonDownEvent, _gridViewMouseLeftButtonDownHandler, true);
            }
        }

        protected override void OnDetaching()
        {
            if (AssociatedObject != null && _gridViewMouseLeftButtonDownHandler != null)
            {
                AssociatedObject.RemoveHandler(UIElement.MouseLeftButtonDownEvent, _gridViewMouseLeftButtonDownHandler);
            }
        }

        private static bool IsGridViewRow(RadGridView radGridView, Point mousePosition, ref object rowDataContext)
        {
            GeneralTransform gt = radGridView.TransformToVisual(Application.Current.RootVisual);
            Point mousePositionOffset = gt.Transform(mousePosition);

            IEnumerable<UIElement> hitElements = VisualTreeHelper.FindElementsInHostCoordinates(mousePositionOffset, radGridView);

            var gridViewRow = hitElements.OfType<GridViewRow>().FirstOrDefault();

            if (gridViewRow != null)
            {
                rowDataContext = gridViewRow.DataContext;
            }

            return gridViewRow != null;
        }

        private void OnGridViewMouseLeftButtonDown(object sender, MouseButtonEventArgs args)
        {
            DateTime currentMouseDownDateTime = DateTime.Now;
            TimeSpan timeSpanBetweenButtonDowns = currentMouseDownDateTime - _lastMouseDownDateTime;

            //First Mouse Down  
            if (timeSpanBetweenButtonDowns.TotalMilliseconds > 300 || _hasFirstMouseDownOccured == false)
            {
                _firstMouseDownPosition = args.GetPosition(AssociatedObject);
                _hasFirstMouseDownOccured = true;
                _lastMouseDownDateTime = DateTime.Now;
            }
            else
            {
                Point currentMousePosition = args.GetPosition(AssociatedObject);

                object rowDataContext = null;

                // Second Mouse Down within 300 miliseconds  
                // Mouse hasn't moved since previous left button down,   
                // and mouse pointer is within a GridViewRow  
                if ((Math.Abs(_firstMouseDownPosition.X - currentMousePosition.X) < 4 && Math.Abs(_firstMouseDownPosition.Y - currentMousePosition.Y) < 4)
                    && IsGridViewRow(AssociatedObject, currentMousePosition, ref rowDataContext)
                    )
                {
                    InvokeActions(rowDataContext);
                }

                _hasFirstMouseDownOccured = false;
            }
        }
    }

    public class DoubleClickTrigger : TriggerBase<UIElement>
    {
        private readonly DispatcherTimer _timer;
        private Point _clickPosition;

        public DoubleClickTrigger()
        {
            _timer = new DispatcherTimer
            {
                Interval = new TimeSpan(0, 0, 0, 0, 300)
            };

            _timer.Tick += OnTimerTick;
        }

        protected override void OnAttached()
        {
            base.OnAttached();

            AssociatedObject.MouseLeftButtonUp += new MouseButtonEventHandler(AssociatedObject_MouseLeftButtonUp);
        }

        void AssociatedObject_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            UIElement element = sender as UIElement;

            if (_timer.IsEnabled)
            {
                _timer.Stop();
                Point position = e.GetPosition(element);

                if (Math.Abs(_clickPosition.X - position.X) < 1 && Math.Abs(_clickPosition.Y - position.Y) < 1)
                {
                    InvokeActions(null);
                }
            }
            else
            {
                _timer.Start();
                _clickPosition = e.GetPosition(element);
            }
        }

        protected override void OnDetaching()
        {
            base.OnDetaching();

            AssociatedObject.MouseLeftButtonUp -= new MouseButtonEventHandler(AssociatedObject_MouseLeftButtonUp);
            if (_timer.IsEnabled)
                _timer.Stop();
        }

        private void OnTimerTick(object sender, EventArgs e)
        {
            _timer.Stop();
        }
    }

}
