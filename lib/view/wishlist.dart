import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/model.dart';
import 'package:e_commerce_app/view/productdetailspage.dart';
import 'package:e_commerce_app/viewmodel/provider/APIfetchingprovider.dart';
import 'package:e_commerce_app/viewmodel/provider/cartprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final cart = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  Product? product;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerOb = Provider.of<APIfetchingProvider>(context);
    final providerObj = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
        stream: cart.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> cartData = snapshot.data!.data();
            List<dynamic> document = cartData['wishList'];

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: document.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    int selectedIndex = document[index]['id'];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                                product: providerOb
                                    .fetchData.products[selectedIndex - 1])));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child:
                              Image.network('${document[index]['thumbnail']}'),
                        ),
                        Expanded(
                          flex: 2,
                          child: ListTile(
                            title: Text(document[index]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Colors.black)),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(
                                      '⭐${document[index]['rating'].toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.black))
                                ]),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${document[index]['discountPercentage'].toString()} % off',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        '\$${document[index]['price'].toString()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // providerObj
                                //     .deleteFieldFromDocument(widget.products??[]);
                                providerObj.wishlistDelete(product);
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
