import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/keranjang.dart';
import 'package:okfoodd/Detail_Product.dart';
import 'package:okfoodd/Detail_Kategori.dart';
import 'package:okfoodd/view_all.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final fDatabaseKategori = FirebaseDatabase.instance.ref().child('kategori');
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
        automaticallyImplyLeading: false,
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
              Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return Shop();
                },
                ),
              ),
            },
            child: Container(
              width: 12,
              height: 25,
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.shopping_basket,
                color: Colors.lightGreenAccent,
                size: 32,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: ClipPathClass(),
            child: Container(
              height: 100.0,
              width: 1000.0,
              color: Colors.black,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Top Categories",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 150,
                  child: FirebaseAnimatedList(
                    scrollDirection: Axis.horizontal,
                    query: fDatabaseKategori,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      Map kategori = snapshot.value as Map;
                      kategori['key'] = snapshot.key;

                      return InkWell(
                        onTap: () => {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return KategoriDetail(keys: kategori['key'],);
                            },
                            ),
                          ),
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              margin: const EdgeInsets.all(12),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                width: 100.0,
                                // height: 57.0,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        kategori['images'],
                                      fit: BoxFit.cover,
                                      height: 58,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      kategori['nama_kategori'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                  },
                  ),
                ),
                Container(
                  height: 30.0,
                  color: Colors.white,
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    height: 500,
                    width: 1000,
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          onPressed: () => {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return All();
                              },
                              ),
                            ),
                          },
                          child: Text(
                            "View All ->",
                            style: TextStyle(
                                color: Colors.blue
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Recomended For You",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 320,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 170,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0
                              ), 
                              itemBuilder: (context, index){
                                if(productList.length == 0){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GestureDetector(
                                          onTap: () => {
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context){
                                                return ProductDetail(keys: productKeys[index]);
                                              },
                                              ),
                                            ),
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Card(
                                                margin: const EdgeInsets.all(20),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  width: 120.0,
                                                  // height: 7.0,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network(
                                                        productList[index]['images'],
                                                        height: 70,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 10),
                                                        child:
                                                        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: productList[index]['nama_product'],
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ]
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
