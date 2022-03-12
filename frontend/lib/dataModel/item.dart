import 'dart:math';

import 'package:faker/faker.dart';

class Item {
  late String name;
  late double price;
  late String category;
  late String description;
  late String imageUrl;
  late int id;

  Item(
      {required this.category,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.id});
  static _generateRandomDecimal(int scale) {
    return double.parse(random.decimal(scale: scale).toStringAsFixed(2));
  }

  static getDefaultFakeData() {
    var faker = Faker();
    return List<Item>.generate(
            10,
            (i) => Item(
                  imageUrl: 'https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8',
                name: faker.food.dish(),
                price: _generateRandomDecimal(10),
                category: "Food",
                id: 1,
                description: faker.lorem.sentence())) +
        List<Item>.generate(
            10,
            (i) => Item(
                  imageUrl: 'https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8',
                name: faker.vehicle.model(),
                price: _generateRandomDecimal(100),
                category: "Vehicle",
                id: 2,
                description: faker.lorem.sentence())) +
        List<Item>.generate(
            10,
            (i) => Item(
                  imageUrl: 'https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8',
                name: faker.sport.name() + " equipment",
                price: _generateRandomDecimal(20),
                category: "Sport equipment",
                id: 3,
                description: faker.lorem.sentence()));
  }

  Item.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    price = json['price'];
    description = json['description'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    id = json['id'];
  }
}
