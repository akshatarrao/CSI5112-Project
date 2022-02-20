
using backend.Views;
using Microsoft.AspNetCore.Mvc;
using backend.Models;

using backend.Utils;


[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly UserView _userView;

    public UserController(UserView userView) {
        _userView = userView;
    }

    [HttpGet]
    public async Task<List<User>> Get() {
        return await _userView.GetAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<User>> GetById(Int64 id) {
        var user = await _userView.GetByIdAsync(id);
        return user.id == backend.Models.User.NoUser.id ? NotFound() : user;
    }
    

    [HttpPost]
    public async Task<ActionResult> Post(User newUser) {
        await _userView.CreateAsync(newUser);
        return CreatedAtAction(nameof(Get), new {id = newUser.id}, newUser);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> Update(Int64 id, User userToUpdate) {
        Status status = await _userView.UpdateAsync(id, userToUpdate);
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
        Status status = await _userView.DeleteAsync(id);
        if (status is Status.SUCCESS){
            return NoContent();}
        if (status is Status.NOT_FOUND) {
            return NotFound();
        }
        return BadRequest();
    }
}
