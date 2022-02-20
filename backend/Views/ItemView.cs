using backend.Models;
using backend.Utils;

namespace backend.Views;

public class ItemView
{
    private readonly List<Item> items = Item.GetFakeData();


    public async Task CreateAsync(Item item)
    {
        items.Add(item);
    }

    public async Task<List<Item>> GetAsync(int page,int per_page)
    {
        if (per_page*(page+1)>= items.Count){
            return new List<Item>(items.Skip(per_page*page));
        }
        return items.GetRange(per_page*page,per_page);
    }

    public async Task<Item> GetByIdAsync(long id)
    {
        var filteredItems = items.Where(x => x.id == id);
        return filteredItems.Count() > 0 ? filteredItems.First() : Item.NoItem;
    }


    public async Task<Status> UpdateAsync(long id, Item newItem)
    {
        var index = items.FindIndex(x => x.id == id);
        if (index != -1)
        {
            newItem.id = id;
            items[index] = newItem;
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        var index = items.FindIndex(x => x.id == id);
        if (index != -1)
        {
            items.RemoveAt(index);
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }
}