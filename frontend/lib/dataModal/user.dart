import 'package:faker/faker.dart';

class User {
  final String name;

  User({required this.name});

  static getRandomUser() {
    Faker faker = Faker();
    return User(name: faker.internet.userName());
  }
}
