using backend.Models;
using backend.Utils;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace backend.Views;

public class AnswerView
{
    //private readonly List<Answer> answers = Answer.GetFakeData();
    private readonly IMongoCollection<Answer> _answers;

    public AnswerView(IOptions<DatabaseSettings> DatabaseSettings) {
        //var settings = MongoClientSettings.FromConnectionString(DatabaseSettings.Value.ConnectionString);
        //settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        //var client = new MongoClient(settings);
        //var database = client.GetDatabase(DatabaseSettings.Value.DatabaseName);
        
        // NOTE: Connection code from MongoDB webstite (As method shown in lecture was not working)
        // TODO: Remove the below code later
        var settings = MongoClientSettings.FromConnectionString("mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority");
        var client = new MongoClient(settings);
        var database = client.GetDatabase("egroDB");
        _answers = database.GetCollection<Answer>("answer");
    }


    public async Task CreateAsync(Answer answer)
    {
        //answers.Add(answer);
        // TODO: May need to do something about ID
        answer.mongoId = null;
        await _answers.InsertOneAsync(answer);
    }

    public async Task<List<Answer>> GetAsync(int page,int per_page)
    {
        //if (per_page*(page+1)>= answers.Count){
        //      //        Handle out of range list error
        //    return new List<Answer>(answers.Skip(per_page*page));
        //}
        //return answers.GetRange(per_page*page,per_page);
        return await _answers.Find(_ => true).ToListAsync();
    }

    public async Task<Answer> GetByIdAsync(long id)
    {
        //var filteredAnswers = answers.Where(x => x.id == id);
        //return filteredAnswers.Count() > 0 ? filteredAnswers.First() : Answer.NoAnswer;
        return await _answers.Find(answer => answer.id == id).FirstOrDefaultAsync();
    }


    public async Task<List<Answer>> GetByQuestionIdAsync(long id)
    {
        //var filteredAnswers = answers.Where(x => x.questionId == id);
        //return filteredAnswers.Count() > 0 ? new List<Answer>(filteredAnswers) : new List<Answer>();
        return await _answers.Find(answer => answer.questionId == id).ToListAsync();
    }


    public async Task<Status> UpdateAsync(long id, Answer newAnswer)
    {
        //var index = answers.FindIndex(x => x.id == id);
        //if (index != -1)
        //{
        //    newAnswer.id = id;
        //    answers[index] = newAnswer;
        //    return Status.SUCCESS;
        //}
        //
        //return Status.NOT_FOUND;
        Answer oldAnswer=await _answers.Find(ans => ans.id == id).FirstOrDefaultAsync();
        String savedMongoId=oldAnswer.mongoId;
        newAnswer.mongoId=savedMongoId;
        ReplaceOneResult r = await _answers.ReplaceOneAsync(answer => answer.id == newAnswer.id, newAnswer);
        bool v = (r.IsModifiedCountAvailable) && (r.ModifiedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }

    public async Task<Status> DeleteAsync(long id)
    {
        //var index = answers.FindIndex(x => x.id == id);
        //if (index != -1)
        //{
        //    answers.RemoveAt(index);
        //    return Status.SUCCESS;
        //}
        //
        //return Status.NOT_FOUND;

        DeleteResult r = await _answers.DeleteOneAsync(answer => answer.id == id);
        bool v = (r.DeletedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }
    }
}