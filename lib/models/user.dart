class User {

  final String username;
  final int conductivity;
  final int oxygen;
  final int ph;
  final int temperature;

  User({
    required this.username,
    required this.conductivity,
    required this.oxygen,
    required this.ph,
    required this.temperature,
  });


  static User fromJson(Map<String, dynamic> json) =>
      User(username: json['username'],
          conductivity: json['conductivity'],
          oxygen: json['oxygen'],
          ph: json['ph'],
          temperature: json['temperature']);
}