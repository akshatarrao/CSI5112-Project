using backend.Models;
using backend.Utils;

namespace backend.Views;

public class QuestionView
{
    private readonly List<Question> questions = Question.GetFakeData();


    public async Task CreateAsync(Question question)
    {
        questions.Add(question);
    }

    public async Task<List<Question>> GetAsync(int page,int per_page)
    {
        if (per_page*(page+1)>= questions.Count){
            return new List<Question>(questions.Skip(per_page*page));
        }
        return questions.GetRange(per_page*page,per_page);
    }

    public async Task<Question> GetByIdAsync(long id)
    {
        var filteredQuestions = questions.Where(x => x.id == id);
        return filteredQuestions.Count() > 0 ? filteredQuestions.First() : Question.NoQuestion;
    }


    public async Task<Status> UpdateAsync(long id, Question newQuestion)
    {
        var index = questions.FindIndex(x => x.id == id);
        if (index != -1)
        {
            newQuestion.id = id;
            questions[index] = newQuestion;
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        var index = questions.FindIndex(x => x.id == id);
        if (index != -1)
        {
            questions.RemoveAt(index);
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }
}