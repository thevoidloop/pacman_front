import 'dart:convert';

class GraphModel {
  List<int> nodoActual;
  List<List<int>> stack;

  GraphModel({
    required this.nodoActual,
    required this.stack,
  });

  factory GraphModel.fromRawJson(String str) => GraphModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphModel.fromJson(Map<String, dynamic> json) => GraphModel(
        nodoActual: List<int>.from(json["nodo_actual"].map((x) => x)),
        stack: List<List<int>>.from(json["stack"].map((x) => List<int>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "nodo_actual": List<dynamic>.from(nodoActual.map((x) => x)),
        "stack": List<dynamic>.from(stack.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
