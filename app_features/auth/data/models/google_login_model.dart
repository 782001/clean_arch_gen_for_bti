
class GoogleLoginResponseModel extends GoogleLoginResponseEntity {
  GoogleLoginResponseModel({super.message});

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginModel(
      message: json['message'],
    );
  }
}
