using backend.Models;
using backend.Utils;

namespace backend.Views;

public class AnswerView
{
    private readonly List<Answer> answers = Answer.GetFakeData();


    public async Task CreateAsync(Answer answer)
    {
        answers.Add(answer);
    }

    public async Task<List<Answer>> GetAsync(int page,int per_page)
    {
        if (per_page*(page+1)>= answers.Count){
            return new List<Answer>(answers.Skip(per_page*page));
        }
        return answers.GetRange(per_page*page,per_page);
    }

    public async Task<Answer> GetByIdAsync(long id)
    {
        var filteredAnswers = answers.Where(x => x.id == id);
        return filteredAnswers.Count() > 0 ? filteredAnswers.First() : Answer.NoAnswer;
    }


        public async Task<List<Answer>> GetByQuestionIdAsync(long id)
    {
        var filteredAnswers = answers.Where(x => x.questionId == id);
        return filteredAnswers.Count() > 0 ? new List<Answer>(filteredAnswers) : new List<Answer>();
    }


    public async Task<Status> UpdateAsync(long id, Answer newAnswer)
    {
        var index = answers.FindIndex(x => x.id == id);
        if (index != -1)
        {
            newAnswer.id = id;
            answers[index] = newAnswer;
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        var index = answers.FindIndex(x => x.id == id);
        if (index != -1)
        {
            answers.RemoveAt(index);
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }
}