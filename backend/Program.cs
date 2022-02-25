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

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSingleton<UserView>();
builder.Services.AddSingleton<ItemView>();
builder.Services.AddSingleton<QuestionView>();
builder.Services.AddSingleton<AnswerView>();
builder.Services.AddSingleton<OrderHistoryView>();




var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseHttpsRedirection();

app.UseCors(corsName);

app.UseAuthorization();

app.MapControllers();

app.Run();

public partial class Program { }