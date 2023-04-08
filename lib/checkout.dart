import 'package:flutter/material.dart';
import 'package:okfoodd/Success.dart';
import 'package:okfoodd/transaksi.dart';

class CheckOut extends StatefulWidget {
  final total;
  const CheckOut({Key? key, required this.total}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState(total);
}

class _CheckOutState extends State<CheckOut> {

  final total;
  _CheckOutState(this.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text("Metode Pembayaran"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Transaksi(total: total,)));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(204, 255, 1, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "Bayar Online",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPayment(total: total, pembayaran: "COD",)));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(204, 255, 1, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                    "Bayar di Tempat",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
