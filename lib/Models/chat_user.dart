class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.email,
  });
  late final String image;
  late final String name;
  late final String about;
  late final String email;

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['email'] = email;
    return data;
  }
}