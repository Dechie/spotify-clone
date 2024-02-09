class User {
  User({
    required this.name,
    required this.email,
    this.token,
    this.password,
  });

  final String name, email;
  String? password, token;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
    );
  }

  @override
  String toString() {
    return "{'name': $name, 'email': $email, 'token': $token}";
  }
  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  Map<String, dynamic> toMapAuth() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
