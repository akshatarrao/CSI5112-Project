using backend.Models;
using backend.Views;

var builder = WebApplication.CreateBuilder(args);

var corsName = "GlobalAllowCORS";
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: corsName,
                      builder =>
                      {
                          builder.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin();
                      });
});

builder.Services.AddControllers().AddJsonOptions(options => options.JsonSerializerOptions.PropertyNamingPolicy = null); //Edited based on lecture
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Connecting to MongoDB as done in lecture
builder.Services.Configure<DatabaseSettings>(builder.Configuration.GetSection(nameof(DatabaseSettings)));
var options = builder.Configuration.GetSection(nameof(DatabaseSettings)).Get<DatabaseSettings>();
builder.Services.AddSingleton<DatabaseSettings>(); // TODO: Figure out why having "options" as parameter breaks the code, currently using a insecure work around


builder.Services.AddSingleton<UserView>();
builder.Services.AddSingleton<ItemView>();
builder.Services.AddSingleton<QuestionView>();
builder.Services.AddSingleton<AnswerView>();
builder.Services.AddSingleton<OrderHistoryView>();




var app = builder.Build();


app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseCors(corsName);

app.UseAuthorization();

app.MapControllers();

app.Run();

public partial class Program { }