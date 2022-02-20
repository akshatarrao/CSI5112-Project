using backend.Models;
using backend.Views;
using Microsoft.AspNetCore.Mvc;
using backend.Utils;

[ApiController]
[Route("api/[controller]")]
public class AnswerController : ControllerBase
{
    private readonly AnswerView _answerView;

    public AnswerController(AnswerView answerView) {
        _answerView = answerView;
    }

    [HttpGet]
    public async Task<List<Answer>> Get( [FromQuery] int page = 0,int per_page=50) {
        return await _answerView.GetAsync(page,per_page);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Answer>> GetById(Int64 id) {
        var answer = await _answerView.GetByIdAsync(id);
        return answer.id == Answer.NoAnswer.id ? NotFound() : answer;
    }

        [HttpGet("__question__")]
    public async Task<ActionResult<List<Answer>>> GetByQuestionId([FromQuery] int question_id) {
        return await _answerView.GetByQuestionIdAsync(question_id);
        
    }
    

    [HttpPost]
    public async Task<ActionResult> Post(Answer newAnswer) {
        await _answerView.CreateAsync(newAnswer);
        return CreatedAtAction(nameof(Get), new {id = newAnswer.id}, newAnswer);
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> Update(Int64 id, Answer answerToUpdate) {
        Status status = await _answerView.UpdateAsync(id, answerToUpdate);
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
        Status status = await this._answerView.DeleteAsync(id);
        if (status is Status.SUCCESS){
            return NoContent();}
        if (status is Status.NOT_FOUND) {
            return NotFound();
        }
        return BadRequest();
    }
}
