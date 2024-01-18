import 'package:e_commerce_app/view/cartpage.dart';
import 'package:e_commerce_app/view/productdetailspage.dart';
import 'package:e_commerce_app/view/widgetsCollection.dart';
import 'package:e_commerce_app/viewmodel/provider/APIfetchingprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  WidgetsCollection Obj = WidgetsCollection();
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    Provider.of<APIfetchingProvider>(context, listen: false).fetchDataFromApi();
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final providerobj = Provider.of<APIfetchingProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.purple,
      //   title: Image.asset('assets/images/easybuy-.png',
      //       fit: BoxFit.fill, height: 130),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart_rounded)),
      //   ],
      // ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Image.asset('assets/images/easybuy-.png',
            fit: BoxFit.fill, height: 130),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartPage(
                              transferedProducts:
                                  providerobj.fetchData.products,
                            )));
              },
              icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obj.searchField(context),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: providerobj.fetchData.products.length,
                itemBuilder: (context, index) {
                  final products =
                      Provider.of<APIfetchingProvider>(context, listen: false)
                          .fetchData
                          .products[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                    product: products,
                                  )));
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 130,
                                child: Image.network('${products.thumbnail}'),
                              )),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              title: Obj.title(products),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [Obj.rating(products)]),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Obj.discountPercentage(products),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Obj.price(products),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    products.isClick = !products.isClick;
                                  });
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: products.isClick
                                      ? Colors.red
                                      : Colors.grey,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({
    super.key,
  });

  var size, height, width;

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<APIfetchingProvider>(context);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: height / 17,
            width: width / .5,
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (value) {
                providerObj.searching(value);
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_rounded)),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: providerObj.myList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                              product: providerObj.myList[index])));
                },
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.network(
                            '${providerObj.myList[index].thumbnail}'),
                      ),
                      Expanded(
                        flex: 6,
                        child: ListTile(
                          title: Text('${providerObj.myList[index].title}'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
