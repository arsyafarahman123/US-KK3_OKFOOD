import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/Detail_Product.dart';

import 'keranjang.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {

  final fDatabaseCart = FirebaseDatabase.instance.ref().child('product');

  List<dynamic> productList = [];
  List<dynamic> productKeys = [];



  Future<void> getData() async {
    fDatabaseCart.onValue.listen((event) {
      productList.clear();
      productKeys.clear();
      setState(() {
        List<dynamic>? _foodMap = event.snapshot.value as List?;
        if (_foodMap != null) {
          _foodMap.asMap().forEach((index, value) {
            if (value != null) {
              productKeys.add(index.toString());
              productList.add(value);
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            text: "OK-Food",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Shop();
                  },
                ),
              ),
            },
            child: Container(
              width: 7,
              height: 17,
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.shopping_basket,
                color: Colors.lightGreenAccent,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(25),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 150,
          ),
          itemCount: productList.length,
          itemBuilder: (context, index){
            return  Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () => {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return ProductDetail(keys: productKeys[index]);
                    },
                    ),
                  ),
                },
                splashColor: Colors.lightGreenAccent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                        productList[index]['images']
                    ),
                    Text(productList[index]['nama_product'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            );
          }

      ),
    );
  }
}
