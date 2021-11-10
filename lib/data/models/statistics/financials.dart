class Financials {
  int totalSales;

  Financials.fromJson(Map<String, dynamic> json)
      : totalSales = json["totalSales"];

  Map<String, dynamic> toJson() {
    return {
      "totalSales": totalSales,
    };
  }
}
