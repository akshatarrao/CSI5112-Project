using System.Net.Http;
using System.Net;
using System;
using backend.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;
using System.Text.Json;
using backend.Views;
using System.Text;
using System.Collections.Generic;


public class AnswerIntegrationtests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public AnswerIntegrationtests(WebApplicationFactory<Program> application)
    {
        client = application.CreateClient();
        
    }
    

    [Fact]
    public async void GetAnswer()
    {
        var response = await client.GetAsync("/api/answer?page=0&per_page=2");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Answer.GetFakeData().GetRange(0,2)));
    }

    
    [Fact]
    public async void GetAllAnswer()
    {
        var response = await client.GetAsync("/api/answer?page=0&per_page=1000");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Answer.GetFakeData()));
    }

       [Fact]
    public async void GetExactAllAnswer()
    {
        var response = await client.GetAsync("/api/answer?page=0&per_page=5");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Answer.GetFakeData()));
    }



    
    [Fact]
    public async void GetAnswerByID()
    {
        var response = await client.GetAsync("/api/answer/1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Answer.GetFakeData()[1]));
    }

        [Fact]
    public async void GetAnswerByQuestionID()
    {
        var response = await client.GetAsync("/api/answer/__question__?question_id=0");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Answer.GetFakeData().GetRange(0,1)));
    }

        [Fact]
    public async void GetFail()
    {
        var response = await client.GetAsync("/api/answer/999");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

            [Fact]
    public async void Post()
    {
        Answer newAnswer = new Answer("a", User.GetFakeData()[0], DateTime.MinValue, 0,6);
        var body = new StringContent(JsonSerializer.Serialize(newAnswer), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PostAsync("/api/answer",body);
         response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Content.ReadAsStringAsync().Result.Should().Contain( JsonSerializer.Serialize(newAnswer));

        }


                [Fact]
    public async void Put()
    {
        Answer updateAnswer =new Answer("a", User.GetFakeData()[0], DateTime.MinValue, 0,1);
        var body = new StringContent(JsonSerializer.Serialize(updateAnswer), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/answer/1",body);
         response.StatusCode.Should().Be(HttpStatusCode.NoContent);


        }

  [Fact]
        public async void PutFail()
    {
        var body = new StringContent(JsonSerializer.Serialize(Answer.GetFakeData()[0]), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/answer/1111",body);
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    
  [Fact]
       public async void DeleteFail()
    {
        var response = await client.DeleteAsync("/api/answer/1111");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

          [Fact]
       public async void Delete()
    {
        var response = await client.DeleteAsync("/api/answer/3");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);
        }
}