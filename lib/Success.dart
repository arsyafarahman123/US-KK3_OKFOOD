import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:okfoodd/home_screen.dart';
import 'package:okfoodd/setting/DateFormat.dart';
import 'package:okfoodd/setting/format_rupiah.dart';
import 'dart:math';

class SuccessPayment extends StatefulWidget {

  final pembayaran;
  final total;
  const SuccessPayment({Key? key, required this.pembayaran, required this.total}) : super(key: key);

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState(pembayaran, total);
}

class _SuccessPaymentState extends State<SuccessPayment> {

  final pembayaran;
  final total;
  _SuccessPaymentState(this.pembayaran, this.total);

  bool loading = false;
  String? username;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> getData() async {

    setState(() {
      loading = true;
    });

    var usernameSnapshot = await FirebaseDatabase.instance.ref().child("user").child(userId).child('profile').child("username").once();

    setState(() {
      username = usernameSnapshot.snapshot.value.toString();
    });

    setState(() {
      loading = false;
    });
  }

  String chars = "0123456789";
  String kode = "";
  Random random = Random.secure();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 10; i++) {
      int index = random.nextInt(chars.length);
      kode += chars[index];
    }
    getData();
  }



  @override
  Widget build(BuildContext context) {

    if(loading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: ClipPathClass(),
            child: Container(
              height: 400.0,
              width: 1000.0,
              color: Color.fromRGBO(204, 255, 1, 1),
            ),
          ),
          Center(
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2,2),
                  blurRadius: 10,
                  spreadRadius: 3
                )
              ]
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Text("Payment Successfull", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 5,),
                  Text("Trans ID PA$kode", style: TextStyle(color: Colors.grey, fontSize: 12),),
                  SizedBox(height: 20,),
                  Divider(
                    thickness: 0.8,
                    indent: 20,
                    endIndent:20,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Date"),
                                SizedBox(height: 5,),
                                Text(DateFormatter.formatDate(DateTime.now()), style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Time"),
                                SizedBox(height: 5,),
                                Text(TimeFormatter.formatTime(DateTime.now()), style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text("To: $username", style: TextStyle(),),
                        SizedBox(height: 5,),
                        Text("Ok-Food", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text(pembayaran, style: TextStyle(),),
                        SizedBox(height: 50,),
                        Text("Total Paid Payment"),
                        SizedBox(height: 5,),
                        Text(CurrencyFormat.convertToIdr(total, 2), style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )
                ],
              )
          ),)
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        height: 80,
        child: InkWell(
          onTap: () async {
            await FirebaseDatabase.instance.ref().child("user").child(userId).child('cart').remove();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromRGBO(204, 255, 1, 1),
                borderRadius: BorderRadius.circular(50)
            ),
            child: Text(
              "Done",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
        )
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
