import 'package:flutter/material.dart';
import 'package:okfoodd/Success.dart';

class Transaksi extends StatefulWidget {

  final total;

  const Transaksi({Key? key, required this.total}) : super(key: key);

  @override
  State<Transaksi> createState() => _TransaksiState(total);
}

class _TransaksiState extends State<Transaksi> {

  final total;
  _TransaksiState(this.total);

  List pembayaran = [
    "Gopay",
    "Livin Mandiri",
    "Dana",
    "LinkAja",
    "Flip",
    "Ovo",
  ];

  List pembayaranImages = [
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Fgopay.png?alt=media&token=fa5ba9b7-8d70-438c-bb63-f94d94100b84",
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Fmandiri.png?alt=media&token=3a04cc33-4c71-44c7-afbd-2ee1aa0c67be",
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Fdana.png?alt=media&token=6fb38c6a-ed99-4a66-aab6-cab96ce59b10",
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Flinkaja.png?alt=media&token=37143d59-7f8a-4772-b12b-1805f19ee3e0",
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Fflip.png?alt=media&token=28b655f5-0f12-4ed0-a7a0-88f71bf475ff",
    "https://firebasestorage.googleapis.com/v0/b/flutter-483e8.appspot.com/o/pembayaran%2Fovo.png?alt=media&token=ee31b84b-3747-4dcf-b53e-11f31bbbbdf3"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text("Transaksi"),
      ),
      body: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: pembayaran.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 180,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20
          ),
          itemBuilder:(context, index){
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPayment(pembayaran: pembayaran[index], total: total,)));
              },
              child: Card(
                elevation: 2,
                child: Image.network(pembayaranImages[index]),
              ),
            );
          }
      ),
    );
  }
}
