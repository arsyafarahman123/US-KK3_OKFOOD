import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/keranjang.dart';
import 'package:okfoodd/pesan_sekarang_sandwich.dart';
import 'package:okfoodd/Detail_Kategori.dart';


class ProductDetail extends StatefulWidget {

  final keys;

  const ProductDetail({Key? key, required this.keys}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState(keys);
}

class _ProductDetailState extends State<ProductDetail> {

  final keys;
  _ProductDetailState(this.keys);

  final fDatabaseKategori = FirebaseDatabase.instance.ref().child('kategori');
  final fDatabaseProduct = FirebaseDatabase.instance.ref().child('product');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  String? images;
  String? nama_product;
  String? bahan;
  String? harga;
  var nutrisi;

  bool isLoading = false;

  Future<void> getData() async {

    setState(() {
      isLoading = true;
    });

    var imagesSnapshot = await fDatabaseProduct.child(keys).child('images').once();
    var nama_productSnapshot = await fDatabaseProduct.child(keys).child('nama_product').once();
    var bahanSnapshot = await fDatabaseProduct.child(keys).child('bahan').once();
    var nutrisiSnapshot = await fDatabaseProduct.child(keys).child('nutrisi').once();
    var hargaSnapshot = await fDatabaseProduct.child(keys).child('harga').once();

    setState(() {
      images = imagesSnapshot.snapshot.value.toString();
      nama_product = nama_productSnapshot.snapshot.value.toString();
      bahan = bahanSnapshot.snapshot.value.toString();
      nutrisi = nutrisiSnapshot.snapshot.value;
      harga = hargaSnapshot.snapshot.value.toString();
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveCart() async {
    await FirebaseDatabase.instance.ref().child("user").child(userId).child('cart').child(keys).set({
      "nama_product" : nama_product,
      "harga" : int.parse(harga!),
      "images" : images,
      "jumlah" : 1
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil Menyimpan ke Keranjang"))
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
      body: ListView(
        children: [
          Image.network(images!),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: nama_product!,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
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
                margin: EdgeInsets.only(top: 0),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Nutrional value per 100 g",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          margin: const EdgeInsets.all(7),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: 75.0,
                            // height: 57.0,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  nutrisi['kcal'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Kcal",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.all(7),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: 75.0,
                        // height: 57.0,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              nutrisi['proteins'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Proteins",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(7),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: 75.0,
                        // height: 57.0,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              nutrisi['lemak'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Lemak",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(7),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: 75.0,
                        // height: 57.0,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "35",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              nutrisi['karbo'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  RichText(
                    text: TextSpan(
                      text: "Bahan",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  RichText(
                    text: TextSpan(
                      text:
                      bahan!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Row(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                saveCart();
                                return Shop();
                              },
                              ),
                            ),
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                margin: const EdgeInsets.all(20),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: 150.0,
                                  // height: 57.0,
                                  color: Colors.lightGreenAccent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Tambahkan Keranjang",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return Pesan();
                              },
                              ),
                            ),
                          },
                          child: Card(
                            margin: const EdgeInsets.all(7),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              width: 150.0,
                              // height: 57.0,
                              color: Colors.lightGreenAccent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pesan Sekarang",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          ),
                        ),
                      ]),
                ],
                ),
              ),
            ],
          )
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
