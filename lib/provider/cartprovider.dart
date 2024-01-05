import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvider extends ChangeNotifier {
  Product? productsFromAPI;
  //////////////////////////////////////////////////////////////////
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }

////////////////////////////////////////////////////////////////////
  int totalPrice = 0;
  bool isAlreadyCalculated = false;
  final cart = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  getTotalPrice() async {
    final data = await cart.get();
    for (var element in data.data()?['cartList']) {
      totalPrice = totalPrice + element['price'] as int;
    }
    notifyListeners();
  }

  addtoCart(Product? product) async {
    final total = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final users = await total.get();

    if (!users.exists) {
      total.set({'cartList': [], 'totalPrice': 0});
    }
    final data = {
      'cartList': FieldValue.arrayUnion([
        {
          'id': product?.id,
          'category': product?.category,
          'thumbnail': product?.thumbnail,
          'title': product?.title,
          'price': product?.price,
          'rating': product?.rating,
          'discountPercentage': product?.discountPercentage,
        }
      ]),
    };

    final newdata = await cart.get();
    final List cartList = newdata.data()?['cartList'];
    bool productAlreadyInCart =
        cartList.any((item) => item['id'] == product?.id);

    if (!productAlreadyInCart) {
      cart.update(data);

      totalPrice = totalPrice + (product?.price ?? 0);

      showToast("Product added");
    } else {
      showToast('Product already in Cart');
    }

    notifyListeners();
  }

  void deleteFieldFromDocument(index) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final docRef =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();
    List<dynamic> deleteList = docRef.get('cartList');

    int productPrice = deleteList[index]['price'];
    totalPrice = totalPrice - productPrice;

    print('/////////////////////////$totalPrice/////////////////////////////');
    deleteList.removeAt(index);

    print(
        '//////////////////////totalprice$totalPrice//////////////////////////');

    try {
      // Delete the 'cart' field from the document
      await FirebaseFirestore.instance.collection('cart').doc(userId).update({
        'cartList': deleteList,
        // 'totalPrice': totalPrices,
      });
      print('Field deleted successfully');
    } catch (e) {
      print('Error deleting field: $e');
    }
    notifyListeners();
    // Update total price
    // final total = FirebaseFirestore.instance.collection('cart').doc(userId);
    // final users = await total.get();
    // totalPrice =
    //     users['totalPrice'] - (productsFromAPI?.price ?? 0); // handle null
    // print('Total Price: $totalPrice');
  }
}
