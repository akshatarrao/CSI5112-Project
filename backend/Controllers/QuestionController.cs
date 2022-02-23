using backend.Models;
using backend.Views;
using Microsoft.AspNetCore.Mvc;

using backend.Utils;

[ApiController]
[Route("api/[controller]")]
public class QuestionController : ControllerBase
{
    private readonly QuestionView _questionView;

    public QuestionController(QuestionView questionView) {
        _questionView = questionView;
    }

    [HttpGet]
    public async Task<List<Question>> Get( [FromQuery] int page = 0,int per_page=50) {
        return await _questionView.GetAsync(page,per_page,null);
    }

        [HttpGet("__search__/{search_key}")]
    public async Task<List<Question>> Get(string search_key, [FromQuery] int page = 0,int per_page=50) {
        return await _questionView.GetAsync(page,per_page,search_key);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Question>> GetById(Int64 id) {
        var question = await _questionView.GetByIdAsync(id);
        return question.id == Question.NoQuestion.id ? NotFound() : question;
    }
    

    [HttpPost]
    public async Task<ActionResult> Post(Question newQuestion) {
        await _questionView.CreateAsync(newQuestion);
        return CreatedAtAction(nameof(Get), new {id = newQuestion.id}, newQuestion);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> Update(Int64 id, Question questionToUpdate) {
        Status status = await _questionView.UpdateAsync(id, questionToUpdate);
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
        Status status = await this._questionView.DeleteAsync(id);
        if (status is Status.SUCCESS){
            return NoContent();}
        if (status is Status.NOT_FOUND) {
            return NotFound();
        }
        return BadRequest();
    }
}
