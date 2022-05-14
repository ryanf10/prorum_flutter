class User{
  final int userId;
  final String username;
  final String? email;
  String? base64Avatar;

  User({
    required this.userId,
    required this.username,
    required this.email,
  });

  // set avatar(String base64data){
  //   base64Avatar = base64data;
  // }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      username: json['username'],
      email: json['email'] ?? null,
    );
  }
}