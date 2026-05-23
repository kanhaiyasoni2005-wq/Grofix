

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grofix/data/cartModel.dart';
class CartRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addToCart(CartModel cartItem) async {
    final user = FirebaseAuth.instance.currentUser;

    var docRef =  _db
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(cartItem.productId);

        var doc = await docRef.get();
        if(doc.exists){
          await docRef.update({
            "quantity": FieldValue.increment(1),

          });
        }
        else{
          await docRef.set(cartItem.toMap(),);
        }
        
  }

  Stream<List<CartModel>> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;

    return _db
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> removeItem(String productId) async {
    final user = FirebaseAuth.instance.currentUser;

    await _db
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }
}


