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


public class QuestionIntegrationtests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public QuestionIntegrationtests(WebApplicationFactory<Program> application)
    {
        client = application.CreateClient();
        
    }
    

    [Fact]
    public async void GetQuestion()
    {
        var response = await client.GetAsync("/api/question?page=0&per_page=2");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Question.GetFakeData().GetRange(0,2)));
    }

    
    [Fact]
    public async void GetAllQuestion()
    {
        var response = await client.GetAsync("/api/question?page=0&per_page=1000");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Question.GetFakeData()));
    }

       [Fact]
    public async void GetExactAllQuestion()
    {
        var response = await client.GetAsync("/api/question?page=0&per_page=5");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Question.GetFakeData()));
    }


       [Fact]
    public async void GetWithSearch()
    {
        var response = await client.GetAsync("/api/question/__search__/ImAQuestion?page=0&per_page=5");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Question.GetFakeData().GetRange(4,1)));
    }




    
    [Fact]
    public async void GetQuestionByID()
    {
        var response = await client.GetAsync("/api/question/1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Question.GetFakeData()[1]));
    }

        [Fact]
    public async void GetFail()
    {
        var response = await client.GetAsync("/api/question/999");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

            [Fact]
    public async void Post()
    {
        Question newQuestion = new Question("a", "a", User.GetFakeData()[0], DateTime.MinValue, 0,6);
        var body = new StringContent(JsonSerializer.Serialize(newQuestion), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PostAsync("/api/question",body);
         response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Content.ReadAsStringAsync().Result.Should().Contain( JsonSerializer.Serialize(newQuestion));

        }


                [Fact]
    public async void Put()
    {
        Question updateQuestion =new Question("a", "a", User.GetFakeData()[0], DateTime.MinValue, 0,1);
        var body = new StringContent(JsonSerializer.Serialize(updateQuestion), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/question/1",body);
         response.StatusCode.Should().Be(HttpStatusCode.NoContent);


        }

  [Fact]
        public async void PutFail()
    {
        var body = new StringContent(JsonSerializer.Serialize(Question.GetFakeData()[0]), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/question/1111",body);
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    
  [Fact]
       public async void DeleteFail()
    {
        var response = await client.DeleteAsync("/api/question/1111");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

          [Fact]
       public async void Delete()
    {
        var response = await client.DeleteAsync("/api/question/3");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);
        }
}