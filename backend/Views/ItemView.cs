using backend.Models;
using backend.Utils;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using MongoDB.Bson;


namespace backend.Views;

public class ItemView
{
    // private readonly List<Item> items = Item.GetFakeData();

    private readonly IMongoCollection<Item> _items;
    
    public ItemView(IOptions<DatabaseSettings> DatabaseSettings, IConfiguration configuration) {
        //var settings = MongoClientSettings.FromConnectionString(DatabaseSettings.Value.ConnectionString);
        //settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        //var client = new MongoClient(settings);
        //var database = client.GetDatabase(DatabaseSettings.Value.DatabaseName);
        
        // NOTE: Connection code from MongoDB webstite (As method shown in lecture was not working)
        string connection_string = configuration.GetValue<string>("CONNECTION_STRING");
        if (string.IsNullOrEmpty(connection_string)) {
            // default - should not be used
            connection_string = "mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority";
        }

        // TODO: Remove the below code later
        var settings = MongoClientSettings.FromConnectionString(connection_string);
        //var settings = MongoClientSettings.FromConnectionString("mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority");
        var client = new MongoClient(settings);
        var database = client.GetDatabase("egroDB");
        _items = database.GetCollection<Item>("item");
    }
    public async Task CreateAsync(Item item)
    {
        // _items.Add(item);
         // TODO: May need to do something about ID
        item.mongoId = null;
        await _items.InsertOneAsync(item);
    }

    public async Task<List<Item>> GetAsync(int page,int per_page)
    {
        // if (per_page*(page+1)>= items.Count){
        //     return new List<Item>(items.Skip(per_page*page));
        // }
        // return items.GetRange(per_page*page,per_page);
        var filteredItems = await _items.Find(_ => true).ToListAsync();

           if (per_page*(page+1)>= filteredItems.Count){
            return new List<Item>(filteredItems.Skip(per_page*page));
        }
        return filteredItems.GetRange(per_page*page,per_page);
        
    }

    public async Task<Item> GetByIdAsync(long id)
    {
        // var filteredItems = items.Where(x => x.id == id);
        // return filteredItems.Count() > 0 ? filteredItems.First() : Item.NoItem;
            return await _items.Find(item => item.id == id).FirstOrDefaultAsync();

    }


    public async Task<Status> UpdateAsync(long id, Item newItem)
    {
        // var index = items.FindIndex(x => x.id == id);
        // if (index != -1)
        // {
        //     newItem.id = id;
        //     items[index] = newItem;
        //     return Status.SUCCESS;
        // }

        // return Status.NOT_FOUND;
        Item oldItem=await _items.Find(item => item.id == id).FirstOrDefaultAsync();
        String savedMongoId=oldItem.mongoId;
        newItem.mongoId=savedMongoId;
        ReplaceOneResult r = await _items.ReplaceOneAsync(item => item.id == newItem.id, newItem);
        bool v = (r.IsModifiedCountAvailable) && (r.ModifiedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }

    public async Task<Status> DeleteAsync(long id)
    {
        // var index = items.FindIndex(x => x.id == id);
        // if (index != -1)
        // {
        //     items.RemoveAt(index);
        //     return Status.SUCCESS;
        // }

        // return Status.NOT_FOUND;
        DeleteResult r = await _items.DeleteOneAsync(item => item.id == id);
        bool v = (r.DeletedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }
}