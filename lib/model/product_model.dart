import 'dart:convert';

// SMALL SAMPLE OF THE PRODUCT DATASET


class Product {
  int id;
  String name;
  int imageFileID;
  int type;
  String description;
  int statusCode;
  String partName;
  double priceExVat;
  double priceIncVat;
  String unit;
  double averageCost;
  double listPrice;

  Product(
      {this.id = 0,
      this.name,
      this.imageFileID = 0,
      this.type = 0,
      this.description = "",
      this.statusCode = 0,
      this.partName = "",
      this.priceExVat = 0.0,
      this.priceIncVat = 0.0,
      this.unit = "",
      this.averageCost = 0.0,
      this.listPrice = 0.0});

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["ID"],
        name: map["Name"],
        imageFileID: map["ImageFileID"],
        type: map["Type"],
        description: map["Description"],
        statusCode: map["StatusCode"],
        partName: map["PartName"],
        priceExVat: map["PriceExVat"],
        priceIncVat: map["PriceIncVat"],
        averageCost: map["AverageCost"],
        listPrice: map["ListPrice"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Name": name,
      "ImageFileID": imageFileID,
      "Type": type,
      "Description": description,
      "StatusCode": statusCode,
      "PartName": partName,
      "PriceExVat": priceExVat,
      "PriceIncVat": priceIncVat,
      "AverageCost": averageCost,
      "ListPrice": listPrice
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, name: $name, listPrice: $listPrice}';
  }
}

List<Product> productFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Product>.from(data.map((item) => Product.fromJson(item)));
}

String productToJson(Product data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
