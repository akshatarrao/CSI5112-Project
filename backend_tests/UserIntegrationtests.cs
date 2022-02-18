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


public class UserIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public UserIntegrationTests(WebApplicationFactory<Program> application)
    {
        client = application.CreateClient();
        
    }

    

    [Fact]
    public async void GetUser()
    {
        var response = await client.GetAsync("/api/user");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(User.GetFakeData()));
    }


    
    [Fact]
    public async void GetUserByID()
    {
        var response = await client.GetAsync("/api/user/1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(User.GetFakeData()[1]));
    }

        [Fact]
    public async void GetFail()
    {
        var response = await client.GetAsync("/api/user/3");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

            [Fact]
    public async void Post()
    {
        User newUser = new User("a","a",UserType.buyer,5);
        var body = new StringContent(JsonSerializer.Serialize(newUser), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PostAsync("/api/user",body);
         response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Content.ReadAsStringAsync().Result.Should().Contain( JsonSerializer.Serialize(newUser));

        }
    
}