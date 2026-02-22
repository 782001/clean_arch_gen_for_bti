class EndpointSchema {
  final String feature;        // cart, home, auth
  final String name;           // increase_item_quantity
  final String method;         // GET, POST, PATCH, DELETE
  final String endpoint;       // cart/increase
  final bool hasIdInPath;       // true لو فيه productId
  final List<ParameterSchema> parameters;
  final ResponseSchema response;

  EndpointSchema({
    required this.feature,
    required this.name,
    required this.method,
    required this.endpoint,
    required this.hasIdInPath,
    required this.parameters,
    required this.response,
  });

  factory EndpointSchema.fromJson(Map<String, dynamic> json) {
    return EndpointSchema(
      feature: json['feature'],
      name: json['name'],
      method: json['method'],
      endpoint: json['endpoint'],
      hasIdInPath: json['hasIdInPath'] ?? false,
      parameters: (json['parameters'] as List)
          .map((e) => ParameterSchema.fromJson(e))
          .toList(),
      response: ResponseSchema.fromJson(json['response']),
    );
  }
}
class ParameterSchema {
  final String name;
  final String type; // int, String, File
  final String location; // body, path, query

  ParameterSchema({
    required this.name,
    required this.type,
    required this.location,
  });

  factory ParameterSchema.fromJson(Map<String, dynamic> json) {
    return ParameterSchema(
      name: json['name'],
      type: json['type'],
      location: json['location'],
    );
  }
}
class ResponseSchema {
  final Map<String, String> fields; // message:int, data:String

  ResponseSchema({required this.fields});

  factory ResponseSchema.fromJson(Map<String, dynamic> json) {
    return ResponseSchema(
      fields: Map<String, String>.from(json),
    );
  }
}
