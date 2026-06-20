
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grofix/data/model.dart';

class Viewmodel extends ChangeNotifier {
  List<Product> products = [];
  final _fb = FirebaseFirestore.instance;

  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> orders = [];
  Map<String, dynamic>? selectedAddress;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // 🔥 PRODUCTS
  void fetchproduct() {
    _fb.collection("User").snapshots().listen((snapshot) {
      products = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
      notifyListeners();
    });
  }

  // 🔥 ADDRESS
  void fatchAdress() {
    final currentUserId = userId;
    if (currentUserId == null) {
      userData = [];
      selectedAddress = null;
      notifyListeners();
      return;
    }

    _fb
        .collection("users")
        .doc(currentUserId)
        .collection("Address")
        .snapshots()
        .listen((snapshot) {
      userData = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        };
      }).toList();

      if (userData.isNotEmpty && selectedAddress == null) {
        selectedAddress = userData[0];
      }

      notifyListeners();
    });
  }

 Future<void> addAddress({
  required String name,
  required String phone,
  required String email,
  required String address,
}) async {

  final currentUserId = userId;

  if (currentUserId == null) {
    throw Exception("User is not logged in");
  }

  await _fb
      .collection("users")
      .doc(currentUserId)
      .collection("Address")
      .add({

    "name": name,
    "phone": phone,
    "email": email,
    "Address": address,

  });
}

void selectAddress(Map<String, dynamic> address) {
  selectedAddress = address;
  notifyListeners();
}

  // 🔥 PLACE ORDER
  Future<String> placeOrder({
  required List cartItems,
  required Map<String, dynamic> address,
  required double totalPrice,
  required String paymentMethod,
  String status = "Order Placed",

  // 🔥 NEW (ADD THIS)
  required double lat,
  required double lng,

}) async {

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  // 🔥 1. STOCK UPDATE (Transaction)
  await firestore.runTransaction((transaction) async {

    final List<Map<String, dynamic>> productsData = [];

    for (var item in cartItems) {

      final productRef = firestore
          .collection('User')
          .doc(item.productId);

      final snapshot = await transaction.get(productRef);

      if (!snapshot.exists) {
        throw Exception("Product not found: ${item.name}");
      }

      productsData.add({
        "ref": productRef,
        "stock": snapshot.data()?['stock'] ?? 0,
        "item": item,
      });
    }

    for (var data in productsData) {

      var ref = data["ref"];
      var stock = data["stock"];
      var item = data["item"];

      if (stock >= item.quantity) {

        transaction.update(ref, {
          "stock": stock - item.quantity,
        });

      } else {
        throw Exception("${item.name} out of stock");
      }
    }
  });

  // 🔥 2. ORDER SAVE
  // 🔥 2. ORDER SAVE
List<Map<String, dynamic>> products = [];

for (var item in cartItems) {

  final doc = await firestore
      .collection("User")
      .doc(item.productId)
      .get();

  final data = doc.data();

  double price =
      (data?["price"] ?? 0).toDouble();

  products.add({
    "productId": item.productId,
    "name": item.name,
    "price": price,
    "quantity": item.quantity,
    "total": price * item.quantity,
    "image": item.image,
    "userId": userId,
  });
}

var doc = await firestore.collection("orders").add({

  "userId": userId,
  "products": products,
  "totalPrice": totalPrice,
  "totalItems": cartItems.length,
  "paymentMethod": paymentMethod,
  "address": address,
  "createdAt": FieldValue.serverTimestamp(),

  // ORDER STATUS
  "status": status,

  // ACCEPT SYSTEM
  "accepted": false,
  "acceptedBy": null,

  // LOCATION
  "latitude": lat,
  "longitude": lng,
});

  return doc.id;
}

  // 🔥 UPDATE ORDER STATUS
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
    await _fb.collection("orders").doc(orderId).update({ "status": status, });
    } catch (e) {
      print("Update status error: $e");
    }
  }

  // 🔥 FETCH ORDERS (LATEST FIRST)
  void fetchOrders() {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    _fb
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true) // 🔥 IMPORTANT
        .snapshots()
        .listen((snapshot) {
      orders = snapshot.docs.map((doc) {
  var data = doc.data();

  return {
    "id": doc.id,
    ...data,

    // 👇 Timestamp → DateTime convert
    "deliveredTime": data["deliveredTime"] != null
        ? (data["deliveredTime"] as Timestamp).toDate()
        : null,
  };
}).toList();

      notifyListeners();
    });
  }

  // 🔥 CANCEL ORDER
  Future<void> cancelOrder(String orderId) async {
    try {
      await _fb.collection("orders").doc(orderId).update({
        "status": "cancelled",
      });
    } catch (e) {
      print("Cancel error: $e");
    }
  }

  // 🔥 DELETE ADDRESS
  Future<void> deleteAddress(String id) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("User not logged in, cannot delete address");
      return;
    }
    try {
      await _fb
          .collection("users")
          .doc(currentUser.uid)
          .collection("Address")
          .doc(id)
          .delete();

      userData.removeWhere((element) => element["id"] == id);

      notifyListeners();
    } catch (e) {
      print("Delete error: $e");
    }
  }

  Future<void> returnOrder(String orderId) async {
  var doc = await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderId)
      .get();

  String status = (doc["status"] ?? "")
      .toString()
      .toLowerCase()
      .trim();

  if (status != "delivered") {
    throw Exception("Return allowed only for delivered orders");
  }

  await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderId)
      .update({
    "status": "return_requested"
  });

  notifyListeners();
}

List<String> bannerImages = [];

Future<void> fetchBanners() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("banners")
      .get();

  bannerImages = snapshot.docs
      .map((doc) => doc["image"].toString())
      .toList();

  notifyListeners();
}

}


