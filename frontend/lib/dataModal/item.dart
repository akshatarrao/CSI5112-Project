import 'package:faker/faker.dart';

class Item {
  final String name;
  final double price;
  final String category;
  final String description;

  Item(
      {required this.category,
      required this.name,
      required this.description,
      required this.price});

  static _generateRandomDecimal(int scale) {
    return double.parse(random.decimal(scale: scale).toStringAsFixed(2));
  }

  static getDefaultFakeData() {
    var faker = Faker();
    return List<Item>.generate(
            10,
            (i) => Item(
                name: faker.food.dish(),
                price: _generateRandomDecimal(10),
                category: "Food",
                description: faker.lorem.sentence())) +
        List<Item>.generate(
            10,
            (i) => Item(
                name: faker.vehicle.model(),
                price: _generateRandomDecimal(100),
                category: "Vehicle",
                description: faker.lorem.sentence())) +
        List<Item>.generate(
            10,
            (i) => Item(
                name: faker.sport.name() + " equipment",
                price: _generateRandomDecimal(20),
                category: "Sport equipment",
                description: faker.lorem.sentence()));
  }
}
