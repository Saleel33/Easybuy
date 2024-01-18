import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_app/model/model.dart';
import 'package:e_commerce_app/view/cartpage.dart';
import 'package:e_commerce_app/view/dashbord.dart';
import 'package:e_commerce_app/view/widgetsCollection.dart';
import 'package:e_commerce_app/viewmodel/provider/APIfetchingprovider.dart';
import 'package:e_commerce_app/viewmodel/provider/cartprovider.dart';
import 'package:e_commerce_app/viewmodel/razorpay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int totalPrize = 0;
  RazorPayIntegration razorPayIntegration = RazorPayIntegration();
  final _razorpay = Razorpay();

  @override
  void initState() {
    Provider.of<CartProvider>(context, listen: false)
        .wishListColor(widget.product);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  var size, height, width;
  int currentIndex = 0;
  WidgetsCollection Obj = WidgetsCollection();

  final cart = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    totalPrize = Provider.of<CartProvider>(context).totalPrice;
    final providerObj = Provider.of<CartProvider>(context, listen: false);
    final providerObject =
        Provider.of<APIfetchingProvider>(context, listen: false);

    //size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          },
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'search',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
            height: height / 17,
            width: width / .5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Colors.white,
                border: Border.all(color: Colors.black26)),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartPage(
                              transferedProducts: widget.product,
                            )));
              },
              icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                CarouselSlider(
                  options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: height / 1.9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      }),
                  items: widget.product.images.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.network(imageUrl),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          providerObj.colourBlink = !providerObj.colourBlink;
                          if (providerObj.colourBlink) {
                            providerObj.addtoWishList(widget.product);
                          } else {
                            providerObj.wishlistDelete(widget.product);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.favorite,
                        color:
                            widget.product.isClick ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
              new DotsIndicator(
                dotsCount: widget.product.images.length,
                position: currentIndex,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [
                      Obj.title(widget.product),
                    ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obj.discountPercentage(widget.product),
                        SizedBox(
                          width: 10,
                        ),
                        Obj.price(widget.product)
                      ],
                    ),
                    Row(children: [
                      Obj.rating(widget.product),
                    ]),
                    Obj.description(widget.product)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
                onPressed: () {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    providerObj.addtoCart(widget.product);
                  }
                },
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width /
                        2, // Set width based on screen width
                    50, // Set a fixed height
                  ),

                  // Set a minimum size for the button

                  backgroundColor: (Colors.blueGrey),
                )),
            ElevatedButton(
              onPressed: () {
                providerObj.placeOrderFromProductPage(widget.product);
                razorPayIntegration.paymentResponse(context);
                razorPayIntegration.razorPayFunction(providerObj.totalPrice);
              },
              child: Text('Buy Now'),
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
            )
          ],
        ),
      ),
    );
  }
}
