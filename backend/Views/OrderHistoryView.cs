using backend.Models;
using backend.Utils;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
namespace backend.Views;

public class OrderHistoryView
{
    // private readonly List<OrderHistory> orderHistorys = OrderHistory.GetFakeData();
    private readonly IMongoCollection<OrderHistory> _orderHistorys;
    private readonly IMongoCollection<User> _usersOrderHistory;

 public OrderHistoryView(IOptions<DatabaseSettings> DatabaseSettings) {
        //var settings = MongoClientSettings.FromConnectionString(DatabaseSettings.Value.ConnectionString);
        //settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        //var client = new MongoClient(settings);
        //var database = client.GetDatabase(DatabaseSettings.Value.DatabaseName);
        
        // NOTE: Connection code from MongoDB webstite (As method shown in lecture was not working)
        // TODO: Remove the below code later
        var settings = MongoClientSettings.FromConnectionString("mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority");
        var client = new MongoClient(settings);
        var database = client.GetDatabase("egroDB");
        _orderHistorys = database.GetCollection<OrderHistory>("order");
        _usersOrderHistory=database.GetCollection<User>("user");
    }


    public async Task CreateAsync(OrderHistory orderHistory)
    {
        // _orderHistorys.Add(orderHistory);
        orderHistory.mongoId = null;
        await _orderHistorys.InsertOneAsync(orderHistory);
    }

    public async Task<List<OrderHistory>> GetAsync(int page,int per_page,long userId)
    {
//         List<OrderHistory> filteredOrderHistory;
//         complex logic due to user filter
//         User user = await new UserView().GetByIdAsync(userId);
//          if (user.userType == UserType.buyer){
//             filteredOrderHistory = new List<OrderHistory>(orderHistorys.Where(x => x.user.id==userId));
//         }else{
//             filteredOrderHistory = orderHistorys;
//         }

//         if (per_page*(page+1)>= orderHistorys.Count){
//              return new List<OrderHistory>(filteredOrderHistory.Skip(per_page*page));
//         }
//         return  filteredOrderHistory.GetRange(per_page*page,per_page);
       var filteredOrderHistory=await _orderHistorys.Find(_ => true).ToListAsync();
       User user = await _usersOrderHistory.Find(user => user.id == userId).FirstOrDefaultAsync();
       if (user.userType == UserType.buyer){
            filteredOrderHistory = await _orderHistorys.Find(x => x.user.id==userId).ToListAsync();
         }
         else{
             filteredOrderHistory = await _orderHistorys.Find(_ => true).ToListAsync();
         }
        return await _orderHistorys.Find(_ => true).ToListAsync();


    }

    public async Task<OrderHistory> GetByIdAsync(long id, long userId)
    {
            
        // var filteredOrderHistorys = _orderHistorys.Where(x => x.id == id);
        // return filteredOrderHistorys.Count() > 0 && (filteredOrderHistorys.First().user.id==userId || (await new UserView().GetByIdAsync(userId)).userType == UserType.merchant)? filteredOrderHistorys.First() : OrderHistory.NoOrderHistory;
            var filteredOrderHistorys = await _orderHistorys.Find(x => x.id == id).ToListAsync();
            User user = await _usersOrderHistory.Find(user => user.id == userId).FirstOrDefaultAsync();
        return filteredOrderHistorys.Count()> 0 && 
        (filteredOrderHistorys.First().user.id==userId ||
        user.userType==UserType.merchant)?filteredOrderHistorys.First():OrderHistory.NoOrderHistory;
        
    }


    public async Task<Status> UpdateAsync(long id, OrderHistory newOrderHistory)
    {
        // var index = orderHistorys.FindIndex(x => x.id == id);
        // if (index != -1)
        // {
        //     newOrderHistory.id = id;
        //     orderHistorys[index] = newOrderHistory;
        //     return Status.SUCCESS;
        // }

        // return Status.NOT_FOUND;

        OrderHistory oldOrder=await _orderHistorys.Find(order => order.id == id).FirstOrDefaultAsync();
        String savedMongoId=oldOrder.mongoId;
        newOrderHistory.mongoId=savedMongoId;
        ReplaceOneResult r = await _orderHistorys.ReplaceOneAsync(orderhistory => orderhistory.id == newOrderHistory.id, newOrderHistory);
        bool v = (r.IsModifiedCountAvailable) && (r.ModifiedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    
    }

    public async Task<Status> DeleteAsync(long id)
    {
        // var index = orderHistorys.FindIndex(x => x.id == id);
        // if (index != -1)
        // {
        //     orderHistorys.RemoveAt(index);
        //     return Status.SUCCESS;
        // }

        // return Status.NOT_FOUND;
    DeleteResult r = await _orderHistorys.DeleteOneAsync(orderhistory => orderhistory.id == id);
        bool v = (r.DeletedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    
    }
}