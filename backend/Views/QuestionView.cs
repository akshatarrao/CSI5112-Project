using backend.Models;
using backend.Utils;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace backend.Views;

public class QuestionView
{
    //private readonly List<Question> questions = Question.GetFakeData();
    private readonly IMongoCollection<Question> _questions;

    public QuestionView(IOptions<DatabaseSettings> DatabaseSettings) {
        //var settings = MongoClientSettings.FromConnectionString(DatabaseSettings.Value.ConnectionString);
        //settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        //var client = new MongoClient(settings);
        //var database = client.GetDatabase(DatabaseSettings.Value.DatabaseName);
        
        // NOTE: Connection code from MongoDB webstite (As method shown in lecture was not working)
        // TODO: Remove the below code later
        var settings = MongoClientSettings.FromConnectionString("mongodb+srv://TempUser:3spipFz9vczf1QJP@cluster0.i2uat.mongodb.net/egroDB?retryWrites=true&w=majority");
        var client = new MongoClient(settings);
        var database = client.GetDatabase("egroDB");
        _questions = database.GetCollection<Question>("question");
    }

    public async Task CreateAsync(Question question)
    {
        //questions.Add(question);
        // TODO: May need to do something about ID
        question.mongoId = null;
        await _questions.InsertOneAsync(question);
    }

    public async Task<List<Question>> GetAsync(int page,int per_page, string? search)
    {
//     non-search call is just a empty string search
        //var filteredQuestions = new List<Question>(questions);
        var filteredQuestions = await _questions.Find(_ => true).ToListAsync();
        if(search!=null){
             //filteredQuestions = new List<Question>(_questions.Where(x => x.description.Contains(search)|| x.title.Contains(search)));
             filteredQuestions = new List<Question>(filteredQuestions.Where(x => x.description.Contains(search)|| x.title.Contains(search)));
        }
        
        if (per_page*(page+1)>= filteredQuestions.Count){
            return new List<Question>(filteredQuestions.Skip(per_page*page));
        }
        return filteredQuestions.GetRange(per_page*page,per_page);
    }

    public async Task<Question> GetByIdAsync(long id)
    {
        //var filteredQuestions = questions.Where(x => x.id == id);
        //return filteredQuestions.Count() > 0 ? filteredQuestions.First() : Question.NoQuestion;

        return await _questions.Find(question => question.id == id).FirstOrDefaultAsync();
    }


    public async Task<Status> UpdateAsync(long id, Question newQuestion)
    {
        //var index = questions.FindIndex(x => x.id == id);
        //if (index != -1)
        //{
        //    newQuestion.id = id;
        //    questions[index] = newQuestion;
        //    return Status.SUCCESS;
        //}
        //
        //return Status.NOT_FOUND;

        //ReplaceOneResult r = await _questions.ReplaceOneAsync(question => question.id == newQuestion.id, newQuestion);
        //bool v = (r.IsModifiedCountAvailable) && (r.ModifiedCount == 1);
        //if(v){
        //    return Status.SUCCESS;
        //} else {
        //    return Status.NOT_FOUND;
        //}

        // TODO: Need to fix this, current problem with not having the MongoDB _id when trying to replace document
        return Status.SUCCESS;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        //var index = questions.FindIndex(x => x.id == id);
        //if (index != -1)
        //{
        //    questions.RemoveAt(index);
        //    return Status.SUCCESS;
        //}
        //
        //return Status.NOT_FOUND;

        DeleteResult r = await _questions.DeleteOneAsync(question => question.id == id);
        bool v = (r.DeletedCount == 1);
        if(v){
            return Status.SUCCESS;
        } else {
            return Status.NOT_FOUND;
        }


    }
}