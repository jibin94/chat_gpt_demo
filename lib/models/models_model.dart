class OpenAIModels {
  final String id;
  final int created;
  final String root;

  OpenAIModels({
    required this.id,
    required this.root,
    required this.created,
  });
  factory OpenAIModels.fromJson(Map<String, dynamic> json) => OpenAIModels(
        id: json["id"],
        root: json["root"],
        created: json["created"],
      );
  static List<OpenAIModels> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => OpenAIModels.fromJson(data)).toList();
  }
}
