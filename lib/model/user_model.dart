class UserModel {
  String name;
  String email;
  String bio;
  String phoneNumber;
  String profilePic;
  String createdAt;
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.phoneNumber,
    required this.profilePic,
    required this.createdAt,
    required this.uid,
  });

  // -- From Map(This means we are getting the data from server)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  // -- To Map(This means we are send the data to server)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'createdAt': createdAt,
      'uid': uid,
    };
  }
}
