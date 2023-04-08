import 'dart:convert';

class CartItem {
  String? nama_product;
  String? images;
  int? jumlah;
  int? harga;

  CartItem({this.nama_product, this.images, this.jumlah, this.harga});

  factory CartItem.fromJson(Map<dynamic, dynamic> json) {
    return CartItem(
      nama_product: json['nama_product'] as String?,
      images: json['images'] as String?,
      jumlah: json['jumlah'] as int?,
      harga: json['harga'] as int?,
    );
  }

}