namespace backend.Models;

public static class UserType
{
    public static readonly string buyer ="buyer";
    public static readonly  string merchant="merchant";

}

public class User
{
    public String username { get; set; }
    public String password { get; set; }
    public string userType {get; set; }
    
    public Int64 id { get; set; }
    
    public User(string username, string password, string userType, Int64 id) {
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.id = id;
    }

    public static readonly  User NoUser = new User("", "", UserType.buyer, -1);
    public static List<User> GetFakeData()
    {
        return new List<User> () {
            new User("admin@gmail.com", "admin", UserType.buyer, 0),
            new User("merchant@gmail.com","merchant", UserType.merchant,1)
        };

    }

}
