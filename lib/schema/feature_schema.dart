class FeatureSchema {
  final String feature;
  final String? basePath;
  final String layerPath;
  final EndpointSchema endpoint;
  final ResponseSchema response;
  final PresentationSchema presentation;
  final RequestSchema request;

  FeatureSchema({
    required this.feature,
    this.basePath,
    required this.layerPath,
    required this.endpoint,
    required this.response,
    required this.presentation,
    required this.request,
  });

  factory FeatureSchema.fromJson(Map<String, dynamic> json) {
    return FeatureSchema(
      feature: json['feature'],
      basePath: json['base_path'],
      layerPath: json['layer_path'],
      endpoint: EndpointSchema.fromJson(json['endpoint']),
      response: ResponseSchema.fromJson(json['response']),
      presentation: PresentationSchema.fromJson(json['presentation']),
      request: RequestSchema.fromJson(json['request']),
    );
  }
}

class EndpointSchema {
  final String url;
  final String method;

  EndpointSchema({required this.url, required this.method});

  factory EndpointSchema.fromJson(Map<String, dynamic> json) {
    return EndpointSchema(
      url: json['url'],
      method: json['method'],
    );
  }
}

class ResponseSchema {
  final String entity;
  final Map<String, dynamic> data;

  ResponseSchema({required this.entity, required this.data});

  factory ResponseSchema.fromJson(Map<String, dynamic> json) {
    return ResponseSchema(
      entity: json['entity'] ?? 'APIResponseEntity',
      data: json['data'] ?? json['fields'] ?? json['api_response'] ?? {},
    );
  }
}

class PresentationSchema {
  final bool cubit;
  final bool injectionContainer;
  final String? injectionContainerPath;
  PresentationSchema({
    required this.cubit,
    required this.injectionContainer,
    this.injectionContainerPath,
  });

  factory PresentationSchema.fromJson(Map<String, dynamic> json) {
    return PresentationSchema(
      cubit: json['cubit'] ?? false,
      injectionContainer: json['injection_container'] ?? false,
      injectionContainerPath: json['injection_container_path'],
    );
  }
}
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
