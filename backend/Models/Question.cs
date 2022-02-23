namespace backend.Models;


public class Question
{
    public String title { get; set; }
    public String description { get; set; }
    public User user {get; set; }

    public DateTime time {get;set;}

    public int replies {get;set;}
    
    public Int64 id { get; set; }
    
    public Question(string title, string description, User user,DateTime time , int replies, Int64 id) {
        this.title = title;
        this.description = description;
        this.user = user;
        this.id = id;
        this.time = time;
        this.replies =replies;
    }

    public static readonly  Question NoQuestion = new Question("", "", User.NoUser, DateTime.MinValue, 0,-1);
    public static List<Question> GetFakeData()
    {
        string description = "Deserunt earum atque maxime assumenda quisquam aspernatur magni vitae neque itaque dolor.";
        return new List<Question> () {
            new Question("Question 1", description, User.GetFakeData()[0], DateTime.Parse("2018-05-01T07:34:42-5:00"), 1,0),
            new Question("Question 2", description, User.GetFakeData()[0], DateTime.Parse("2028-05-01T07:34:42-5:00"), 2,1),
            new Question("Question 3", description, User.GetFakeData()[0], DateTime.Parse("2038-05-01T07:34:42-5:00"), 2,2),
            new Question("Question 4", description, User.GetFakeData()[0], DateTime.Parse("2048-05-01T07:34:42-5:00"), 0,3),
            new Question("Question 5 ImAQuestion", description, User.GetFakeData()[0], DateTime.Parse("2058-05-01T07:34:42-5:00"), 0,4),
        };

    }

}
