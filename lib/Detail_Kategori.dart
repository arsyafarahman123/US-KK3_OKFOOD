import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/Detail_Product.dart';

import 'keranjang.dart';


class KategoriDetail extends StatefulWidget {

  final keys;

  const KategoriDetail({Key? key, required this.keys}) : super(key: key);

  @override
  State<KategoriDetail> createState() => _KategoriDetailState(keys);
}

class _KategoriDetailState extends State<KategoriDetail> {

  final keys;
  _KategoriDetailState(this.keys);

  final fDatabaseKategori = FirebaseDatabase.instance.ref().child('kategori');
  final fDatabaseProduct = FirebaseDatabase.instance.ref().child('product');

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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: FirebaseAnimatedList(
            defaultChild: Center(child: CircularProgressIndicator(),),
            query: fDatabaseProduct.orderByChild('id_kategori').equalTo(int.parse(keys)),
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

              Map product = snapshot.value as Map;
              product['key'] = snapshot.key;

              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return ProductDetail(keys: product['key'],);
                          },
                          ),
                        ),
                      },
                      splashColor: Colors.lightGreenAccent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                              product['images']
                          ),
                          SizedBox(height: 20,),
                          Text(product['nama_product'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              );
            },

          ),

        )
    );
  }
}

