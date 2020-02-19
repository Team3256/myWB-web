class Cart {
  String productID;
  String userID;
  String productName;
  String size;
  String variant;
  int quantity;
  int price;

  Cart(Map<String, dynamic> json) {
    productID = json["productID"];
    userID = json["userID"];
    productName = json["productName"];
    size = json["size"];
    variant = json["variant"];
    quantity = json["quantity"];
    price = json["price"];
  }
}