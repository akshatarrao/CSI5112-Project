using backend.Models;
using backend.Views;
using backend.Utils;
using Microsoft.AspNetCore.Mvc;


[ApiController]
[Route("api/[controller]")]
public class ItemController : ControllerBase
{
    private readonly ItemView _itemView;

    public ItemController(ItemView itemView) {
        _itemView = itemView;
    }

    [HttpGet]
    public async Task<List<Item>> Get( [FromQuery] int page = 0,int per_page=50) {
        return await _itemView.GetAsync(page,per_page);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Item>> GetById(Int64 id) {
        var item = await _itemView.GetByIdAsync(id);
        return item.id == Item.NoItem.id ? NotFound() : item;
    }
    

    [HttpPost]
    public async Task<ActionResult> Post(Item newItem) {
        await _itemView.CreateAsync(newItem);
        return CreatedAtAction(nameof(Get), new {id = newItem.id}, newItem);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> Update(Int64 id, Item itemToUpdate) {
        Status status = await _itemView.UpdateAsync(id, itemToUpdate);
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
        Status status = await this._itemView.DeleteAsync(id);
        if (status is Status.SUCCESS){
            return NoContent();}
        if (status is Status.NOT_FOUND) {
            return NotFound();
        }
        return BadRequest();
    }
}
