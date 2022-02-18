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


public class ItemIntegrationtests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public ItemIntegrationtests(WebApplicationFactory<Program> application)
    {
        client = application.CreateClient();
        
    }
    

    [Fact]
    public async void GetItem()
    {
        var response = await client.GetAsync("/api/item?page=0&per_page=10");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Item.GetFakeData().GetRange(0,10)));
    }

    
    [Fact]
    public async void GetAllItem()
    {
        var response = await client.GetAsync("/api/item?page=0&per_page=1000");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Item.GetFakeData()));
    }

       [Fact]
    public async void GetExactAllItem()
    {
        var response = await client.GetAsync("/api/item?page=0&per_page=17");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Item.GetFakeData()));
    }



    
    [Fact]
    public async void GetItemByID()
    {
        var response = await client.GetAsync("/api/item/1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Be( JsonSerializer.Serialize(Item.GetFakeData()[1]));
    }

        [Fact]
    public async void GetFail()
    {
        var response = await client.GetAsync("/api/item/999");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

            [Fact]
    public async void Post()
    {
        Item newItem = new Item(2000,"a","a","a","a",20.0);
        var body = new StringContent(JsonSerializer.Serialize(newItem), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PostAsync("/api/item",body);
         response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Content.ReadAsStringAsync().Result.Should().Contain( JsonSerializer.Serialize(newItem));

        }


                [Fact]
    public async void Put()
    {
        Item updateItem =new Item(2000,"a","a","a","a",20.0);
        var body = new StringContent(JsonSerializer.Serialize(updateItem), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/item/1",body);
         response.StatusCode.Should().Be(HttpStatusCode.NoContent);


        }

  [Fact]
        public async void PutFail()
    {
        var body = new StringContent(JsonSerializer.Serialize(Item.GetFakeData()[0]), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/item/1111",body);
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    
  [Fact]
       public async void DeleteFail()
    {
        var response = await client.DeleteAsync("/api/item/1111");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

          [Fact]
       public async void Delete()
    {
        var response = await client.DeleteAsync("/api/item/5");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);
        }
}