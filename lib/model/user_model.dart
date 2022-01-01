import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? masterPwd;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.loginType,
    this.masterPwd,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      loginType: json['loginType'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : null,
      masterPwd: json['masterPwd'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['masterPwd'] = this.masterPwd;
    data['loginType'] = this.loginType;

    return data;
  }
}
