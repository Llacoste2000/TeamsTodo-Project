class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  User({this.id, this.firstName, this.lastName, this.email, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['username'],
        token: json['token']);
  }

  Map toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'token': token
    };
  }
}