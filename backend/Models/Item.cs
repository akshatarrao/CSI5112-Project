namespace backend.Models;


public class Item
{
    public String name { get; set; }
    public String category { get; set; }
     public String description { get; set; }
      public String imageUrl { get; set; }
    public double price {get; set; }
    
    public Int64 id { get; set; }
    
    public Item(Int64 id,string name, string category, string description, string imageUrl, double price) {
        this.name = name;
        this.category = category;
        this.description = description;
        this.imageUrl = imageUrl;
        this.id = id;
        this.price = price;
    }
    public static readonly  Item NoItem = new Item(-1,"", "", "","",0.0);
    public static List<Item> GetFakeData()
    {
            string description = "Deserunt earum atque maxime assumenda quisquam aspernatur magni vitae neque itaque dolor.";
            string imageUrl = "https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8";
            double price = 5.99;
        return new List<Item> () {
            new Item(0,"Apple", "Fruit",description, imageUrl, price),
            new Item(1,"Banana", "Fruit",description, imageUrl, price),
            new Item(2,"Pear", "Fruit",description, imageUrl, price),
            new Item(3,"Shirt", "Clothes",description, imageUrl, price),
            new Item(4,"Pants", "Clothes",description, imageUrl, price),
            new Item(5,"T-shirt", "Clothes",description, imageUrl, price),
            new Item(6,"Jacket", "Clothes",description, imageUrl, price),
            new Item(7,"Honda", "Car",description, imageUrl, price),
            new Item(8,"BMW", "Car",description, imageUrl, price),
            new Item(9,"Tesla", "Car",description, imageUrl, price),
            new Item(10,"Truck", "Car",description, imageUrl, price),
            new Item(11,"GTA", "Game",description, imageUrl, price),
            new Item(12,"NFS", "Game",description, imageUrl, price),
            new Item(13,"AC", "Game",description, imageUrl, price),
            new Item(14,"Fortnite", "Game",description, imageUrl, price),
            new Item(15,"Book A", "Book",description, imageUrl, price),
            new Item(16,"Book B", "Book",description, imageUrl, price)
        };

    }

}
