using backend.Models;
using backend.Utils;

namespace backend.Views;

public class OrderHistoryView
{
    private readonly List<OrderHistory> orderHistorys = OrderHistory.GetFakeData();


    public async Task CreateAsync(OrderHistory orderHistory)
    {
        orderHistorys.Add(orderHistory);
    }

    public async Task<List<OrderHistory>> GetAsync(int page,int per_page)
    {

        if (per_page*(page+1)>= orderHistorys.Count){
            return new List<OrderHistory>(orderHistorys.Skip(per_page*page));
        }
        return orderHistorys.GetRange(per_page*page,per_page);
    }

    public async Task<OrderHistory> GetByIdAsync(long id)
    {
            
        var filteredOrderHistorys = orderHistorys.Where(x => x.id == id);
        return filteredOrderHistorys.Count() > 0 ? filteredOrderHistorys.First() : OrderHistory.NoOrderHistory;
    }


    public async Task<Status> UpdateAsync(long id, OrderHistory newOrderHistory)
    {
        var index = orderHistorys.FindIndex(x => x.id == id);
        if (index != -1)
        {
            newOrderHistory.id = id;
            orderHistorys[index] = newOrderHistory;
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }

    public async Task<Status> DeleteAsync(long id)
    {
        var index = orderHistorys.FindIndex(x => x.id == id);
        if (index != -1)
        {
            orderHistorys.RemoveAt(index);
            return Status.SUCCESS;
        }

        return Status.NOT_FOUND;
    }
}