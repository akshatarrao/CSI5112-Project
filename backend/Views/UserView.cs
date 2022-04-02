using backend.Models;
using backend.Utils;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using MongoDB.Bson;

namespace backend.Views;

public class UserView
{
    // private readonly List<User> users = User.GetFakeData();
    private readonly IMongoCollection<User> _users;
    public UserView(IOptions<DatabaseSettings> DatabaseSettings) {
        //var settings = MongoClientSettings.FromConnectionString(DatabaseSettings.Value.ConnectionString);
        //settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        //var client = new MongoClient(settings);
        //var database = client.GetDatabase(DatabaseSettings.Value.DatabaseName);
        
        // NOTE: Connection code from MongoDB webstite (As method shown in lecture was not working)
        // TODO: Remove the below code later
        var settings = MongoClientSettings.FromConnectionString("mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority");
        var client = new MongoClient(settings);
        var database = client.GetDatabase("egroDB");
        _users = database.GetCollection<User>("user");
    }

    public async Task CreateAsync(User user)
    {
        // _users.Add(user);
        user.mongoId = null;
        await _users.InsertOneAsync(user);
    
    }

    public async Task<List<User>> GetAsync()
    {
        // return users;
        return await _users.Find(_ => true).ToListAsync();

    }

    public async Task<User> GetByIdAsync(long id)
    {
        // var filteredUsers = users.Where(x => x.id == id);
        // return filteredUsers.Count() > 0 ? filteredUsers.First() : User.NoUser;
        var filteredUsers = await _users.Find(_ => true).ToListAsync();
        return filteredUsers.Count() > 0 ? filteredUsers.First() : User.NoUser;

    }


    public async Task<Status> UpdateAsync(long id, User newUser)
    {
        // var index = users.FindIndex(x => x.id == id);
        // if (index != -1)
        // {
        //     newUser.id = id;
        //     users[index] = newUser;
        //     return Status.SUCCESS;
        // }

        // return Status.NOT_FOUND;
        ReplaceOneResult r = await _users.ReplaceOneAsync(orderhistory => orderhistory.id == newUser.id, newUser);
        bool v = (r.IsModifiedCountAvailable) && (r.ModifiedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }

    public async Task<Status> DeleteAsync(long id)
    {
DeleteResult r = await _users.DeleteOneAsync(user => user.id == id);
        bool v = (r.DeletedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }
}