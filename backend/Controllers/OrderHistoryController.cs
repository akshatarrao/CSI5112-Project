using backend.Models;
using backend.Views;
using Microsoft.AspNetCore.Mvc;
using backend.Utils;

[ApiController]
[Route("api/[controller]")]
public class OrderHistoryController : ControllerBase
{
    private readonly OrderHistoryView _orderHistoryView;

    public OrderHistoryController(OrderHistoryView orderHistoryView) {
        _orderHistoryView = orderHistoryView;
    }

    [HttpGet]
    public async Task<ActionResult<List<OrderHistory>>> Get([FromQuery] int page = 0, int per_page=50) {
        return await _orderHistoryView.GetAsync(page,per_page);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<OrderHistory>> GetById( Int64 id) {
        var orderHistory = await _orderHistoryView.GetByIdAsync(id);
        return orderHistory.id == OrderHistory.NoOrderHistory.id ? NotFound() : orderHistory;
    }


    [HttpPost]
    public async Task<ActionResult> Post(OrderHistory newOrderHistory) {
        await _orderHistoryView.CreateAsync(newOrderHistory);
        return CreatedAtAction(nameof(Get), new {id = newOrderHistory.id}, newOrderHistory);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> Update(Int64 id, OrderHistory orderHistoryToUpdate) {
        Status status = await _orderHistoryView.UpdateAsync(id, orderHistoryToUpdate);
        if (status is Status.SUCCESS){
        return NoContent();
        
        }
         if (status is Status.NOT_FOUND)  {
            return NotFound();
        } 
            return BadRequest();
        
        
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(Int64 id) {
        Status status = await this._orderHistoryView.DeleteAsync(id);
        if (status is Status.SUCCESS){
            return NoContent();}
        if (status is Status.NOT_FOUND) {
            return NotFound();
        }
        return BadRequest();
    }
}
