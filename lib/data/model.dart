
class Product{
  String? Description;
  String id;
  String name;
  int stock;
  double  price;
  String image;
  String catagory;
  Product({required this.name,
   required this.price,
   required this.stock,
    required this.image,
     required this.id, 
     required this.Description,
     required this.catagory,

     });
   
   factory Product.fromMap(Map<String , dynamic> map, String id){
    return Product(
      id : id,
      Description: map["Description" ] ?? "",
      catagory: map["catagory"] ?? "",
      name: map["name"] ?? "",
      price: (map["price"] ?? 0).toDouble(),
      image: map["image"] ?? "",
      stock: map["stock"] ?? 0,
      
      
     );

   }

}

