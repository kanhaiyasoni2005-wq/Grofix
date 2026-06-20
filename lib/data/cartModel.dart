
class CartModel {
  String Description;
  String productId;
  String name;
  String image;

  int quantity;
  String catagory;

  CartModel({
    required this.catagory,
    required this.Description,
    required this.productId,
    required this.name,
    required this.image,

    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      "Description": Description,
      "productId": productId,
      "name": name,
      "image": image,
    
      "quantity": quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      catagory: map["catagory"] ?? "",
      Description: map["Description"] ?? "No description",
      productId: map["productId"] ?? "",
      name: map["name"] ?? "Unknown",
      image: map["image"] ?? "",
     
      quantity: (map["quantity"] as num?)?.toInt() ?? 1,
    );
  }
}

