// import 'dart:convert';

// import 'package:e_commerce_app/model/model.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// dynamic body;
// Future<ProductClass> fetchProducts() async {
//   final response = await http.get(Uri.parse('https://dummyjson.com/products'));
//   print('////\\\\\\\[[[[[[$response');
//   if (response.statusCode == 200) {
//     return ProductClass.fromJson(
//         jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

// // ignore: must_be_immutable
// class ProductPage extends StatefulWidget {
//   ProductPage({super.key});
//   late Future<ProductClass> fetchProducts;

//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   TextEditingController editingController = TextEditingController();
//   // final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
//   // var items = <String>[];

//   // void initState() {
//   //   items = duplicateItems;
//   //   super.initState();
//   // }

//   // void filterSearchResults(String query) {
//   //   setState(() {
//   //     items = duplicateItems
//   //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//   //         .toList();
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Products'), actions: [
//         IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart_rounded))
//       ]),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//               child: TextField(
//                 onChanged: (value) {
//                   // filterSearchResults(value);
//                 },
//                 controller: editingController,
//                 decoration: InputDecoration(
//                   suffixIcon: Icon(Icons.search),
//                   hintText: 'search',
//                   hintStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(color: Colors.white70)),
//                 ),
//               ),
//             ),
//             FutureBuilder<ProductClass>(
//                 future: fetchProducts(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   }
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 800,
//                       child: ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemCount: snapshot.data?.products.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     flex: 1,
//                                     child: Image.network(
//                                         '${snapshot.data?.products[index].thumbnail}')),
//                                 Expanded(
//                                   flex: 2,
//                                   child: ListTile(
//                                     title: Text(
//                                         '${snapshot.data?.products[index].title}'),
//                                     subtitle: Text(
//                                         '${snapshot.data?.products[index].description}' +
//                                             '\n\$' +
//                                             '${snapshot.data?.products[index].price}'),
//                                     trailing: IconButton(
//                                         onPressed: () {},
//                                         icon: Icon(Icons.favorite)),
//                                     isThreeLine: true,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                           // return ListTile(
//                           //   leading: Image.network(
//                           //       '${snapshot.data?.products[index].thumbnail}'),
//                           //   title:
//                           //       Text("${snapshot.data?.products[index].title}"),
//                           // );
//                           // return Container(
//                           //   child: Column(children: [
//                           //     Text("${snapshot.data?.products[index].title}")
//                           //   ],),
//                           // );
//                         },
//                       ),
//                     ),
//                   );
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
