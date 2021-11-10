class ModelCharacteristics {
  int modelHeight;
  int modelWeight;
  String modelSize;

  ModelCharacteristics(
      {required this.modelHeight, required this.modelWeight, required this.modelSize});

  ModelCharacteristics.fromJson(Map<String, dynamic> json)
      : modelHeight= json["modelHeight"],
        modelWeight = json["modelWeight"],
        modelSize = json["modelSize"];

  Map<String, dynamic> toJson() {
    return {
      "modelHeight":  modelHeight,
      "modelWeight": modelWeight,
      "modelSize": modelSize,
          };
  }
}
