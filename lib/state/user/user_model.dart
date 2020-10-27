class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String token;

  User({this.id, this.firstName, this.lastName, this.email, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['data']['id'],
        firstName: json['data']['firstName'],
        lastName: json['data']['lastName'],
        email: json['data']['email'],
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
