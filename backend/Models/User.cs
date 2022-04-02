using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;
using MongoDB.Bson;

namespace backend.Models;

// Enum support in C# is horrible. Fake Enum this way
public static class UserType
{
    public static readonly string buyer ="buyer";
    public static readonly  string merchant="merchant";

}

[BsonIgnoreExtraElements]
public class User
{
    [BsonId][BsonRepresentation(BsonType.ObjectId)][BsonElement("_id")][JsonPropertyName("mongoId")] //Actual name in mongoDB is "_id"
    public string? mongoId { get; set; }

    public String username { get; set; }
    public String password { get; set; }
    public string userType {get; set; }
    
    public Int64 id { get; set; }
    
    public User(string mongoId,string username, string password, string userType, Int64 id) {
                this.mongoId = mongoId;

        this.username = username;
//        horrible security practice, but since user auth is out of scope, plain text password will do.
        this.password = password;
        this.userType = userType;
        this.id = id;
    }
//     Its just a fancy version of null which is easier for type checking
    public static readonly  User NoUser = new User("", "", "", UserType.buyer, -1);
    public static List<User> GetFakeData()
    {
        return new List<User> () {
            new User("","admin@gmail.com", "admin", UserType.buyer, 0),
            new User("","merchant@gmail.com","merchant", UserType.merchant,1)
        };

    }

}
