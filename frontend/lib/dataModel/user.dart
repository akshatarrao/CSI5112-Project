import 'package:faker/faker.dart';

// Mock users
class User {
  final String name;

  User({required this.name});

  static getRandomUser() {
    Faker faker = Faker();
    return User(name: faker.internet.userName());
  }

  static getDefaultUser(bool isMerchant) {
    return isMerchant
        ? {
            'merchant@gmail.com': 'merchant',
          }
        : {
            'admin@gmail.com': 'admin',
          };
  }
}
