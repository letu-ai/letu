namespace Fancyx.Core.AutoInject
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = true, Inherited = false)]
    public abstract class AsyncAopAttributeBase : Attribute
    {
        private readonly bool _throwException;

        protected AsyncAopAttributeBase(bool throwException)
        {
            _throwException = throwException;
        }

        public bool ThrowException => _throwException;

        public abstract Task OnBeforeAsync();

        public abstract Task OnAfterAsync();

        public virtual Task OnExceptionAsync()
        {
            return Task.CompletedTask;
        }

        protected IServiceProvider ServiceProvider { get; private set; } = null!;

        public void SetServiceProvider(IServiceProvider serviceProvider)
        {
            if (ServiceProvider != null)
            {
                throw new InvalidOperationException("ServiceProvider has already been set.");
            }
            ServiceProvider = serviceProvider ?? throw new ArgumentNullException(nameof(serviceProvider));
        }
    }
}