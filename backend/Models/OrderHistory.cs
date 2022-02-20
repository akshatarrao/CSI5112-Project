namespace backend.Models;
using System.Text.Json;

public class OrderHistory
{
    public Boolean isPaid { get; set; }
    public double amount {get; set; }

    public User user {get;set;}

    public string items {get;set;}

    public DateTime time {get;set;}

    public Int64 id { get; set; }

    
    public OrderHistory(Boolean isPaid, double amount,DateTime time , string items, Int64 id, User user) {
        this.isPaid = isPaid;
        this.amount = amount;
        this.id = id;
        this.time = time;
        this.items =items;
        this.user=user;
    }

    public static readonly  OrderHistory NoOrderHistory = new OrderHistory(false, 0, DateTime.MinValue,"",-1, User.NoUser);
    public static List<OrderHistory> GetFakeData()
    {
        Dictionary<string,int> items = new Dictionary<string,int>();
        items.Add("apple with info",2);
        items.Add("banana with info",5);
        string itemSnapShot = JsonSerializer.Serialize(items);
        return new List<OrderHistory> () {
            new OrderHistory(true, 20.5, DateTime.Parse("2017-05-02T07:34:42-5:00"), itemSnapShot,0, User.GetFakeData()[0]),
            new OrderHistory(true, 40, DateTime.Parse("2018-05-02T07:34:42-5:00"), itemSnapShot,1,User.GetFakeData()[0]),
            new OrderHistory(true, 55.2, DateTime.Parse("2019-05-02T07:34:42-5:00"), itemSnapShot,2,User.GetFakeData()[1])
        };

    }

}
