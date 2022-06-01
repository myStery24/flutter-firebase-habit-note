class LabelsModel {
  String? labelId;
  String? labelName;
  String? userId;

  /// Instantiates a [LabelsModel]
  LabelsModel({
    this.labelId,
    this.labelName,
    this.userId,
  });

  factory LabelsModel.fromJson(Map<String, dynamic> json) {
    return LabelsModel(
      labelId: json['id'],
      labelName: json['labelName'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['labelId'] = this.labelId;
    data['labelName'] = this.labelName;
    data['userId'] = this.userId;

    return data;
  }
}
