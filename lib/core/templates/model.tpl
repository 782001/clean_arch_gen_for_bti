
class {{Feature}}ResponseModel extends {{entity}} {
  {{Feature}}ResponseModel({super.message});

  factory {{Feature}}Model.fromJson(Map<String, dynamic> json) {
    return {{Feature}}Model(
      message: json['message'],
    );
  }
}
