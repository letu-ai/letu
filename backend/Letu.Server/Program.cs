using Letu.Basis;
using Letu.Core;
using Letu.Logger;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseLetuLogger();
builder.Host.UseAutofac();

builder.AddApplication<LetuBasisModule>();

var app = builder.Build();

app.InitializeApplication();

app.Run();