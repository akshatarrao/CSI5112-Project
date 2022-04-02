namespace backend.Models;
using System.Text.Json;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;
public class OrderHistory
{
    [BsonId][BsonRepresentation(BsonType.ObjectId)][BsonElement("_id")][JsonPropertyName("mongoId")]

    public string? mongoId { get; set; }

    public Boolean isPaid { get; set; }
    public double amount {get; set; }

    public User user {get;set;}

    public string items {get;set;}

    public DateTime time {get;set;}

    public Int64 id { get; set; }

    
    public OrderHistory(string mongoId,Boolean isPaid, double amount,DateTime time , string items, Int64 id, User user) {
        this.mongoId = mongoId;
        this.isPaid = isPaid;
        this.amount = amount;
        this.id = id;
        this.time = time;
        this.items =items;
        this.user=user;
    }
//     Its just a fancy version of null which is easier for type checking
    public static readonly  OrderHistory NoOrderHistory = new OrderHistory("", false, 0, DateTime.MinValue,"",-1, User.NoUser);
    public static List<OrderHistory> GetFakeData()
    {
        Dictionary<string,int> items = new Dictionary<string,int>();
        items.Add("Apple;Fruit;Deserunt earum atque maxime assumenda quisquam aspernatur magni vitae neque itaque dolor.;https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8;5.99",2);
        items.Add("Banana;Fruit;Deserunt earum atque maxime assumenda quisquam aspernatur magni vitae neque itaque dolor.;https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8;5.99",5);
        string itemSnapShot = JsonSerializer.Serialize(items);
        return new List<OrderHistory> () {
            new OrderHistory("", true, 20.5, DateTime.Parse("2017-05-02T07:34:42-5:00"), itemSnapShot,0, User.GetFakeData()[0]),
            new OrderHistory("", true, 40, DateTime.Parse("2018-05-02T07:34:42-5:00"), itemSnapShot,1,User.GetFakeData()[0]),
            new OrderHistory("", true, 55.2, DateTime.Parse("2019-05-02T07:34:42-5:00"), itemSnapShot,2,User.GetFakeData()[1])
        };

    }

}
