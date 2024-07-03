class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.email,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
  });
  late  String image;
  late  String name;
  late  String about;
  late  String email;
  late  String isOnline;
  late  String lastActive;
  late  String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    email = json['email'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['email'] = email;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    return data;
  }
}