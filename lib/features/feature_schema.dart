class RequestSchema {
  final Map<String, String> pathParams;
  final Map<String, String> body;
  final Map<String, String> query;

  RequestSchema({
    required this.pathParams,
    required this.body,
    required this.query,
  });

  factory RequestSchema.fromJson(Map<String, dynamic> json) {
    return RequestSchema(
      pathParams: Map<String, String>.from(json['path_params'] ?? {}),
      body: Map<String, String>.from(json['body'] ?? {}),
      query: Map<String, String>.from(json['query'] ?? {}),
    );
  }
}
