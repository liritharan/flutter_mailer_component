class DatabaseModel {
  int? id;
  String? transDes;
  String? transStatus;
  String? date;

  DatabaseModel({this.id, this.transDes, this.transStatus, this.date});

  DatabaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transDes = json['transDes'];
    transStatus = json['transStatus'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transDes'] = this.transDes;
    data['transStatus'] = this.transStatus;
    data['date'] = this.date;
    return data;
  }
}
