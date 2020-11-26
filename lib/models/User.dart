

class User {
   int id;
   String username;
   String birthDate;
   int phoneNumber;
   String address;

   String picture;
   String email;
   String password;
   String createdAt;
 User({this.address, this.picture, this.id,this.username,this.birthDate,this.phoneNumber,this.email,this.password,this.createdAt});

  User.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    email = map['email'];
    address = map['address'];
    password =map['password'];
    phoneNumber = map['phoneNumber']  as int;
    birthDate = map['birthDate']  ;
    picture = map['picture'];
  }
   DateTime fromTimestampToDateTime(int date) {
     DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
     return dateTime;
   }
factory User.fromJson(Map<String,dynamic> json){
  return User(
    id: json['id'],
    username: json['username'],
    phoneNumber: json['phoneNumber'],
    birthDate: json['birthDate'],
    picture: json['picture'],
    email: json['email'],
    password: json['password'],
    address: json['address'],
    createdAt:json['createdAt'] ,

  );
}
}