namespace backend.Models;
public class DatabaseSettings {
    public string? ConnectionString { get; set; }
    public string? DatabaseName { get; set; }
    public string? ItemCollectionName { get; set; }
    public string? OrderHistoryCollectionName { get; set; }
    public string? UserCollectionName { get; set; }
    public string? QuestionCollectionName { get; set; }
    public string? AnswerCollectionName { get; set; }
}