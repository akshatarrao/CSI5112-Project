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
using System.Net.Http.Headers;


public class OrderHistoryIntegrationtests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public OrderHistoryIntegrationtests(WebApplicationFactory<Program> application)
    {
        client = application.CreateClient();
        
    }

    [Fact]
    public async void GetOrderHistory()
    {
        var response = await client.GetAsync("/api/orderHistory?page=0&per_page=1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        // Due to C#'s week abliablity to serialize nested objects, I cannot do a string comparsion because of extra "\""
        response.Content.ReadAsStringAsync().Result.Should().Contain("20.5").And.NotContain("55.2").And.NotContain("55.2");
    }




    
    [Fact]
    public async void GetAllOrderHistory()
    {
        var response = await client.GetAsync("/api/orderHistory?page=0&per_page=1000");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Contain("20.5").And.Contain("40").And.Contain("55.2");
    }

       [Fact]
    public async void GetExactAllOrderHistory()
    {
         var response = await client.GetAsync("/api/orderHistory?page=0&per_page=3");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Contain("20.5").And.Contain("40").And.Contain("55.2");
    }



    
    [Fact]
    public async void GetOrderHistoryByID()
    {
         var response = await client.GetAsync("/api/orderHistory/1");
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        response.Content.ReadAsStringAsync().Result.Should().Contain("40").And.NotContain("55.2").And.NotContain("20.5");
    }



    


        [Fact]
    public async void GetFail()
    {
        var response = await client.GetAsync("/api/orderHistory/999");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

            [Fact]
    public async void Post()
    {
        OrderHistory newOrderHistory = new OrderHistory(false,10.5, DateTime.MinValue, "",6,User.GetFakeData()[0]);
        var body = new StringContent(JsonSerializer.Serialize(newOrderHistory), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PostAsync("/api/orderHistory",body);
         response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Content.ReadAsStringAsync().Result.Should().Contain( JsonSerializer.Serialize(newOrderHistory));

        }


                [Fact]
    public async void Put()
    {
        OrderHistory updateOrderHistory =new OrderHistory(false,10.5, DateTime.MinValue, "",1,User.GetFakeData()[0]);
        var body = new StringContent(JsonSerializer.Serialize(updateOrderHistory), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/orderHistory/1",body);
         response.StatusCode.Should().Be(HttpStatusCode.NoContent);


        }

  [Fact]
        public async void PutFail()
    {
        var body = new StringContent(JsonSerializer.Serialize(OrderHistory.GetFakeData()[0]), UnicodeEncoding.UTF8, "application/json");
        var response = await client.PutAsync("/api/orderHistory/1111",body);
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    
  [Fact]
       public async void DeleteFail()
    {
        var response = await client.DeleteAsync("/api/orderHistory/1111");
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }

          [Fact]
       public async void Delete()
    {
        var response = await client.DeleteAsync("/api/orderHistory/1");
        response.StatusCode.Should().Be(HttpStatusCode.NoContent);
        }
}