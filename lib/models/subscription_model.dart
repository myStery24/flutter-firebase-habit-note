import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  String? amount;
  String? description;
  DateTime? firstPayDate;
  DateTime? nextPayDate;
  DateTime? dueDate;
  int? duration;
  String? durationUnit;
  String? name;
  String? paymentMethod;
  String? userId;
  String? id;
  DateTime? notificationDate;
  int? notificationId;
  String? color;

  SubscriptionModel({
    this.amount,
    this.description,
    this.dueDate,
    this.duration,
    this.durationUnit,
    this.name,
    this.paymentMethod,
    this.userId,
    this.firstPayDate,
    this.nextPayDate,
    this.id,
    this.notificationId,
    this.notificationDate,
    this.color,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      amount: json['amount'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? (json['dueDate'] as Timestamp).toDate() : null,
      firstPayDate: json['firstPayDate'] != null ? (json['firstPayDate'] as Timestamp).toDate() : null,
      nextPayDate: json['nextPayDate'] != null ? (json['nextPayDate'] as Timestamp).toDate() : null,
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      name: json['name'],
      paymentMethod: json['paymentMethod'],
      userId: json['userId'],
      id: json['id'],
      notificationId: json['notificationId'],
      notificationDate: json['notificationDate'] != null ? (json['notificationDate'] as Timestamp).toDate() : null,
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['dueDate'] = this.dueDate;
    data['firstPayDate'] = this.firstPayDate;
    data['nextPayDate'] = this.nextPayDate;
    data['duration'] = this.duration;
    data['durationUnit'] = this.durationUnit;
    data['name'] = this.name;
    data['paymentMethod'] = this.paymentMethod;
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['notificationDate'] = this.notificationDate;
    data['notificationId'] = this.notificationId;
    data['color'] = this.color;
    return data;
  }
}
