import 'dart:convert';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String token;

  User({this.id, this.firstName, this.lastName, this.email, this.token});

  /**
   * Use when getting user from StorageService
   */
  factory User.fromJsonResponse(String json) {
    print(json);
    return new User(
        id: jsonDecode(json)['data']['id'],
        firstName: jsonDecode(json)['data']['firstName'],
        lastName: jsonDecode(json)['data']['lastName'],
        email: jsonDecode(json)['data']['email'],
        token: jsonDecode(json)['token']);
  }

  /**
   * Use when getting an user from the api.
   */
  factory User.fromJson(String json) {
    print(json);
    return new User(
        id: jsonDecode(json)['id'],
        firstName: jsonDecode(json)['firstName'],
        lastName: jsonDecode(json)['lastName'],
        email: jsonDecode(json)['email'],
        token: jsonDecode(json)['token']);
  }

  String toJson() {
    return "{\"id\":$id,\"firstName\":\"$firstName\",\"lastName\":\"$lastName\",\"email\":\"$email\",\"token\":\"$token\"}";
  }
}
