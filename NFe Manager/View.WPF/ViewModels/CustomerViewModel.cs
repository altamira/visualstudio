using System;
using System.Windows;
using System.Windows.Input;
using System.Threading;
using System.Collections.ObjectModel;

// Toolkit namespace
using SimpleMvvmToolkit;

namespace View.WPF
{
    /// <summary>
    /// This class extends ViewModelDetailBase which implements IEditableDataObject.
    /// <para>
    /// Specify type being edited <strong>DetailType</strong> as the second type argument
    /// and as a parameter to the seccond ctor.
    /// </para>
    /// <para>
    /// Use the <strong>mvvmprop</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// </summary>
    public class CustomerViewModel : ViewModelDetailBase<CustomerViewModel, Customer>
    {
        // Add a member for ICustomerServiceAgent
        private ICustomerServiceAgent serviceAgent;

        // Default ctor
        public CustomerViewModel() { }

        // Ctor that accepts ICustomerServiceAgent
        public CustomerViewModel(ICustomerServiceAgent serviceAgent)
        {
            this.serviceAgent = serviceAgent;
        }

        // TODO: Add events to notify the view or obtain data from the view
        public event EventHandler<NotificationEventArgs<Exception>> ErrorNotice;

        // TODO: Add properties using the mvvmprop code snippet

        // Set the model to a new customer
        public void NewCustomer()
        {
            base.Model = serviceAgent.CreateCustomer();
        }

        public ICommand NewCustomerCommand
        {
            get
            {
                return new DelegateCommand(NewCustomer);
            }
        }

        // TODO: Optionally add callback methods for async calls to the service agent

        // Helper method to notify View of an error
        private void NotifyError(string message, Exception error)
        {
            // Notify view of an error
            Notify(ErrorNotice, new NotificationEventArgs<Exception>(message, error));
        }
    }
}