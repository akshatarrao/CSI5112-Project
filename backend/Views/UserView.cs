using backend.Models;
using backend.Utils;

namespace backend.Views;

public class UserView
{
    private readonly List<User> users = User.GetFakeData();


    public async Task CreateAsync(User user)
    {
        users.Add(user);
    }

    public async Task<List<User>> GetAsync()
    {
        return users;
    }

    public async Task<User> GetByIdAsync(long id)
    {
        var filteredUsers = users.Where(x => x.id == id);
        return filteredUsers.Count() > 0 ? filteredUsers.First() : User.NoUser;
    }


    public async Task<Status> UpdateAsync(long id, User newUser)
    {
        var index = users.FindIndex(x => x.id == id);
        if (index != -1)
        {
            newUser.id = id;
            users[index] = newUser;
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        var index = users.FindIndex(x => x.id == id);
        if (index != -1)
        {
            users.RemoveAt(index);
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }
}