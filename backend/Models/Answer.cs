using System.Text.Json.Serialization;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace backend.Models;


public class Answer
{
    //[BsonId][BsonRepresentation(BsonType.ObjectId)]//[BsonElement("_id")] //Actual name in mongoDB is "_id"
    //public string? mongoId { get; set; }
    
    [BsonId][BsonRepresentation(BsonType.ObjectId)][JsonPropertyName("mongoID")]
    public string? mongoId { get; set; }

    public String answer { get; set; }
    
    [JsonPropertyName("user")]
    public User user {get; set; }

    public DateTime time {get;set;}

    public int questionId {get;set;}
    
    [BsonElement("id")]
    public Int64 id { get; set; }
    
    public Answer(string mongoId, string answer, User user,DateTime time , int questionId, Int64 id) {
        this.mongoId = mongoId;
        this.answer = answer;
        this.user = user;
        this.id = id;
        this.time = time;
        this.questionId =questionId;
    }
//     Its just a fancy version of null which is easier for type checking
    public static readonly  Answer NoAnswer = new Answer("", "", User.NoUser, DateTime.MinValue, -1,-1);
    public static List<Answer> GetFakeData()
    {
        string answer = "Deserunt earum atque maxime assumenda quisquam aspernatur magni vitae neque itaque dolor.";
        return new List<Answer> () {
            new Answer("",  answer, User.GetFakeData()[1], DateTime.Parse("2018-05-02T07:34:42-5:00"), 0,0),
            new Answer("", answer, User.GetFakeData()[1], DateTime.Parse("2028-05-02T07:34:42-5:00"), 1,1),
            new Answer("", answer, User.GetFakeData()[1], DateTime.Parse("2038-05-02T07:34:42-5:00"), 1,2),
            new Answer("", answer, User.GetFakeData()[1], DateTime.Parse("2048-05-02T07:34:42-5:00"), 2,3),
            new Answer("", answer, User.GetFakeData()[1], DateTime.Parse("2058-05-02T07:34:42-5:00"), 2,4),
        };

    }

}
