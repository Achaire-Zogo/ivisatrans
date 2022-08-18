import 'dart:convert';

DictionaryModel dictionaryModelFromJson(String str) =>
    DictionaryModel.fromJson(json.decode(str));

String dictionaryModelToJson(DictionaryModel data) =>
    json.encode(data.toJson());

class DictionaryModel {
  DictionaryModel({
    required this.word,
    required this.pronunciation,
    required this.definitions,
  });

  String word;
  String pronunciation;
  List<Definition> definitions;

  // factory HistoryModel.fromJson(Map<dynamic, dynamic> j) {
  //   return HistoryModel(
  //     record_type: j['record_type'] as String,
  //     date_record: j['date_record'] as String,
  //   );
  // }

  factory DictionaryModel.fromJson(Map<String, dynamic> json) {
    return DictionaryModel(
      word: json["word"] as String,
      pronunciation: json["pronunciation"] as String,
      definitions: List<Definition>.from(
          json["definitions"].map((x) => Definition.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "word": word,
        "pronunciation": pronunciation,
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
      };
}

class Definition {
  Definition({
    required this.type,
    required this.definition,
    required this.example,
    required this.imageUrl,
    required this.emoji,
  });

  String type;
  String definition;
  String example;
  String imageUrl;
  String emoji;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        type: json["type"],
        definition: json["definition"],
        example: json["example"],
        imageUrl: json["image_url"],
        emoji: json["emoji"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "definition": definition,
        "example": example,
        "image_url": imageUrl,
        "emoji": emoji,
      };
}
