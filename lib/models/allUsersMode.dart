 class AllUsersModel{
  String? username;
  String? email;
  String? phone;
  String? uid;
  String? image;
  String? bio;
  String? token;
  String? status;

  AllUsersModel({
    this.username,
    this.email,
    this.phone,
    this.uid,
    this.image,
    this.bio,
    this.token,
    this.status,

  });
  AllUsersModel.fromJson(Map<String,dynamic> json){
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    uid = json['uid'];
    image = json['image'];
    bio = json['bio'];
    token = json['token'];
    status = json['status'];

  }

  Map<String,dynamic> toJson() {
    return {
      'username':username,
      'email':email,
      'phone':phone,
      'uid':uid,
      'image':image,
      'bio':bio,
      'token':token,
      'status':status,
    };
  }

}