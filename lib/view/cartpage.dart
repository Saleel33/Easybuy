import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/view/productdetailspage.dart';
import 'package:e_commerce_app/viewmodel/provider/APIfetchingprovider.dart';
import 'package:e_commerce_app/viewmodel/provider/cartprovider.dart';
import 'package:e_commerce_app/viewmodel/razorpay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  int totalPrize = 0;
  RazorPayIntegration razorPayIntegration = RazorPayIntegration();
  final _razorpay = Razorpay();
  final razorPayIntegrationobj = RazorPayIntegration();
  @override
  void initState() {
    // razorPayIntegration.paymentHandling(context);

    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalPrize = Provider.of<CartProvider>(context).totalPrice;
    final providerOb = Provider.of<APIfetchingProvider>(context);
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
                            child: Container(
                              height: 130,
                              child: Image.network(
                                  '${document[index]['thumbnail']}'),
                            )),
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
              onPressed: () {
                razorPayIntegration.paymentResponse(context);
                razorPayIntegration.razorPayFunction(providerObj.totalPrice);
              },
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

  // void showAlertDialog(BuildContext context, String title, String message) {
  //   // set up the buttons
  //   Widget continueButton = ElevatedButton(
  //     child: const Text("Continue"),
  //     onPressed: () {
  //       // Navigator.push(
  //       //     context, MaterialPageRoute(builder: (context) => OrderPage(orderedItems: ,)));
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //     actions: [
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   /*
  //   * PaymentFailureResponse contains three values:
  //   * 1. Error Code
  //   * 2. Error Description
  //   * 3. Metadata
  //   * */
  //   showAlertDialog(context, "Payment Failed",
  //       "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   /*
  //   * Payment Success Response contains three values:
  //   * 1. Order ID
  //   * 2. Payment ID
  //   * 3. Signature
  //   * */
  //   showAlertDialog(
  //       context, "Payment Successful", "Payment ID: ${response.paymentId}");
  //   cartProvider?.placeOrder(context);
  //   cartProvider?.totalPrice = 0;
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   showAlertDialog(
  //       context, "External Wallet Selected", "${response.walletName}");
  // }
}
