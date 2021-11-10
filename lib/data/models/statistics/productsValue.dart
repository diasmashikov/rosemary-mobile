class ProductsValue {
  int totalProductsValue;

  ProductsValue.fromJson(Map<String, dynamic> json)
      : totalProductsValue = json["totalProductsValue"];

  Map<String, dynamic> toJson() {
    return {
      "totalProductsValue": totalProductsValue,
    };
  }
}
