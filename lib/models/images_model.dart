import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesModel {
  String? imageId;
  String? userId;
  String? title;
  String? description;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;

  /// Instantiates a [NoteModel]
  ImagesModel({
    this.imageId,
    this.userId,
    this.title,
    this.description,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      imageId: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Send data to Firebase
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = this.imageId;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    return data;
  }
}