import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/provider/cartprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  final transferedProducts;

  CartPage({super.key, this.transferedProducts});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<CartProvider>(context);
    if (providerObj.isAlreadyCalculated == false) {
      Provider.of<CartProvider>(context).getTotalPrice();
      providerObj.isAlreadyCalculated = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
        stream: cart.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> cartData = snapshot.data!.data();
            List<dynamic> document = cartData['cartList'];

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: document.length,
              itemBuilder: (context, index) {
                // totalPrice =
                //     totalPrice + int.parse(document[index]['price'].toString());

                return InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ProductDetailsPage(product: widget.product)));
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
                                providerObj.deleteFieldFromDocument(index);
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' Price: \$${providerObj.totalPrice}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Place Order'),
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                minimumSize: Size(
                  MediaQuery.of(context).size.width /
                      2, // Set width based on screen width
                  50, // Set a fixed height
                ),
                backgroundColor: (Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
