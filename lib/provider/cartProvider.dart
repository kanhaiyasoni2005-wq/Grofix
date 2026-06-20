import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grofix/data/cartModel.dart';
import 'package:grofix/repository/cartRepository.dart';

class Cartprovider extends ChangeNotifier {

  final CartRepository _repo = CartRepository();
  final user = FirebaseAuth.instance.currentUser;

  List<CartModel> cartList = [];

  // 🔥 POPUP STATE
  bool _showPopup = false;
  bool get showPopup => _showPopup;

  Timer? _timer;

  // ================= ADD ITEM =================
  void addItem(CartModel item) async {
    await _repo.addToCart(item);
  }

  // ================= FETCH CART =================
  void fetchCart() {

  _repo.getCartItems().listen(
    (data) async {

      cartList = data;

      await calculateTotal();

      notifyListeners();

    },
  );

}

  // ================= REMOVE ITEM =================
  void removeItem(String productId) async {
    await _repo.removeItem(productId);
  }

  // ================= DECREASE ITEM =================
  void decreaseItem(CartModel item) async {
    
    final db = FirebaseFirestore.instance;

    if (item.quantity > 1) {
      item.quantity--;

      await db
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(item.productId)
          .update({
        "quantity": item.quantity,
      });
    } else {
      await db
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(item.productId)
          .delete();

      cartList.remove(item);
    }

    notifyListeners();
  }

  // ================= INCREASE ITEM =================
  void increaseItem(CartModel item) async {
    item.quantity++;

    final db = FirebaseFirestore.instance;

    await db
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(item.productId)
        .update({
      "quantity": item.quantity,
    });

    notifyListeners();
  }

  // ================= TOTAL PRICE =================
  double _totalPrice = 0;

double get totalPrice =>
    _totalPrice;

Future<void> calculateTotal() async {

 double total = 0;

 for (var item in cartList) {

   final doc =
   await FirebaseFirestore
       .instance
       .collection(
         "User",
       )
       .doc(
         item.productId,
       )
       .get();

   if (
   doc.exists
   ) {

     double price =
     (
       doc[
         "price"
       ] ??
       0
     )
     .toDouble();

     total +=
     (
       price *
       item.quantity
     );

   }

 }

 _totalPrice =
 total;

 notifyListeners();

}

  // ================= TOTAL ITEMS =================
  int get totalItems {
    int count = 0;
    for (var item in cartList) {
      count += item.quantity;
    }
    return count;
  }

  // ================= CLEAR CART =================
  void clearCart() {
    cartList.clear();
    notifyListeners();
  }

  // ================= SHOW POPUP =================
  void showCartPopupTemporarily() {
    _showPopup = true;
    notifyListeners();

    _timer?.cancel(); // 🔥 reset timer

    _timer = Timer(Duration(seconds: 3), () {
      _showPopup = false;
      notifyListeners();
    });
  }
}


