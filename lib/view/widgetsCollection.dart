import 'package:e_commerce_app/view/dashbord.dart';
import 'package:flutter/material.dart';

class WidgetsCollection {
  Widget title(product) {
    return Text('${product?.title}',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black));
  }

  Widget discountPercentage(product) {
    return Text(
      '\n${product?.discountPercentage} % off ',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  Widget price(product) {
    return Text('\$${product?.price}',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black));
  }

  Widget rating(product) {
    return Text('⭐ ${product?.rating}',
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 17, color: Colors.black));
  }

  Widget description(product) {
    return Text('${product?.description}',
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 17, color: Colors.black));
  }

  InkWell searchField(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage()));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
        child: Container(
          height: height / 17,
          width: width / .5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.white,
              border: Border.all(color: Colors.black26)),
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Icon(Icons.search_rounded),
              SizedBox(
                width: 5,
              ),
              Text('search')
            ],
          ),
        ),
      ),
    );
  }
}
