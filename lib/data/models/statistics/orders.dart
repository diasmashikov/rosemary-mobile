class Orders {
  int totalOrders;

  Orders.fromJson(Map<String, dynamic> json)
      : totalOrders = json["totalOrders"];

  Map<String, dynamic> toJson() {
    return {
      "totalOrders": totalOrders,
    };
  }
}
