class User {
  final String name;
  final String password;
  final String userType;
  final int id;

  User({required this.name,required this.password,required this.userType,required this.id});

  static List<User> fromListJson(List<dynamic> json) {
    List<User> result = <User>[];
    for(Map<String, dynamic> d in json) {
      result.add(User.fromJson(d));
    }
    return result;
  }

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name:json['username'],
      password: json['password'],
      userType: json['userType'],
      id:json['id']
    );
  }

}
