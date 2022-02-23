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

builder.Services.AddScoped<UserView>();
builder.Services.AddScoped<ItemView>();
builder.Services.AddScoped<QuestionView>();
builder.Services.AddScoped<AnswerView>();
builder.Services.AddScoped<OrderHistoryView>();




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