using Castle.DynamicProxy;

namespace Letu.Core.AutoInject
{
    public class AsyncInterceptorAdaper : AsyncDeterminationInterceptor
    {
        private readonly IAsyncInterceptor asyncInterceptor;

        public AsyncInterceptorAdaper(IAsyncInterceptor asyncInterceptor) : base(asyncInterceptor)
        {
            this.asyncInterceptor = asyncInterceptor;
        }

        public override void Intercept(IInvocation invocation)
        {
            asyncInterceptor.ToInterceptor().Intercept(invocation);
        }
    }
}