import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/checkout.dart';
import 'package:okfoodd/service/cart.dart';
import 'package:okfoodd/setting/format_rupiah.dart';


class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final fDatabaseCart = FirebaseDatabase.instance.ref().child("user");
    int totall = 0;

    List<CartItem> cartList = [];
    List<String> cartKeys = [];

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getData();
    }


    Future<void> getData() async {
      fDatabaseCart.child(userId).child('cart').onValue.listen((event) {
        cartList.clear();
        cartKeys.clear();
        totall = 0;
        setState(() {
          var cartValue = event.snapshot.value;
          print(cartValue);
          if (cartValue != null && cartValue is Map) {
            cartValue.forEach((key, value) {
              var cartItem = CartItem.fromJson(value);
              cartKeys.add(key.toString());
              cartList.add(cartItem);
              totall += cartItem.harga! * cartItem.jumlah!;
            });
          }
          print(cartList);
        });
      });
    }











    @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text("Cart"),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: cartList.length,
            itemBuilder: (context, index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(cartList[index].images ?? ""),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartList[index].nama_product.toString()),
                            SizedBox(height: 5,),
                            Text(CurrencyFormat.convertToIdr(cartList[index].harga, 2)),
                          ],
                        )
                    ),
                    IconButton(
                        onPressed: () async {
                          await fDatabaseCart.child(userId).child('cart').child(cartKeys[index]).remove();
                        },
                        icon: Icon(Icons.delete)
                    )
                  ],
                ),
                SizedBox(height: 10,)
              ],
            );
        })
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          height: 60,
          child: Row(
            children: [
              Text("Total : ${CurrencyFormat.convertToIdr(totall, 2)}"),
              SizedBox(width: 10,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    if(totall != 0){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(total: totall)));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(204, 255, 1, 1),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                        "Check Out"
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
