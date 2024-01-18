import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});

  final cart = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.purple, title: Text('Orders')),
        body: StreamBuilder(
          stream: cart.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            Map<String, dynamic> cartData = snapshot.data!.data();
            List<dynamic> document = cartData['orderList'];
             if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
      return Text('No data');
    }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                                '${document[index]['thumbnail']}'),
                          ),
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              title: Text('${document[index]['title']}'),
                              subtitle: Text('Order On track'),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return Text('No data');
          },
        ));
  }
}
