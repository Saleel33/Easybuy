import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/model.dart';
import 'package:e_commerce_app/view/cartpage.dart';
import 'package:e_commerce_app/view/ordrpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvider extends ChangeNotifier {
  Product? productsFromAPI;
  CartPage cartPage = CartPage();
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
      total.set({
        'cartList': [],
      });
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

  addtoWishList(Product? product) async {
    final total = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final users = await total.get();

    if (!users.exists) {
      total.set({
        'wishList': [],
      });
    }
    final data = {
      'wishList': FieldValue.arrayUnion([
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

      showToast("Product added");
    } else {
      showToast('Product already in Cart');
    }

    notifyListeners();
  }

  late bool colourBlink;
  wishListColor(Product? product) async {
    final newdata = await cart.get();
    final List cartList = newdata.data()?['cartList'];
    bool productAlreadyInCart =
        cartList.any((item) => item['id'] == product?.id);

    if (!productAlreadyInCart) {
      colourBlink = false;
      showToast("Product added");
    } else {
      colourBlink = true;
      showToast('Product already in Cart');
    }
  }

  wishlistDelete(Product? product) async {
    final cartGet = await cart.get();
    final wishlist = cartGet.data()?['wishList'];
    int index = wishlist.indexWhere((item) => item['id'] == product?.id);
    wishlist.removeAt(index);
    cart.update({'wishList': wishlist});
    print('Product removed from wishlist');
  }

  void deleteFieldFromDocument(index) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final docRef =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();
    List<dynamic> deleteList = docRef.get('cartList');

    int productPrice = deleteList[index]['price'];
    totalPrice = totalPrice - productPrice;

    deleteList.removeAt(index);
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
  }

  void placeOrder(context) async {
    // Move items from cart to orders in Firestore
    List<Map<String, dynamic>> orderedItemsList = [];
    totalPrice = 0;
    final newdata = await cart.get();
    final List cartList = newdata.data()?['cartList'];
    for (var item in cartList) {
      orderedItemsList.add({
        'title': item['title'],
        'price': item['price'],
        'thumbnail': item['thumbnail'],
        // Add other fields as needed
      });
    }

    await cart.update({
      'orderList': FieldValue.arrayUnion(orderedItemsList),
      'cartList': [],
    });

    // Navigate to the order page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(),
      ),
    );
    notifyListeners();
  }

  placeOrderFromProductPage(Product product) async {
    List<Map<String, dynamic>> orderedItemsList = [];
    orderedItemsList.add({
      'title': product.title,
      'price': product.price,
      'thumbnail': product.thumbnail,
      // Add other fields as needed
    });
    await cart.update({
      'orderList': FieldValue.arrayUnion(orderedItemsList),
    });
  }
}
