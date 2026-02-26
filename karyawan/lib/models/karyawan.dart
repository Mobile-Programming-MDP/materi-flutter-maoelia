import 'package:flutter/foundation.dart';

class karyawan {
}

class Karyawan {
  final String nama;
  final int umur; 
  // dinamic bisa terima tipe data apa saja 
  //data text bisa pakai rootbundle 
  // kenapa ada toList, kluarnya adlh objek dr fromjson
  final Alamat alamat; 
  final List<String> hobi; 

  Karyawan ({
  required this.nama,
  required this.umur, 
  required this.alamat
  required this.hobi
  }); 

  Factory Karyawan.fromJson(Map<String, dynamic> json){
    return Karyawan(
      nama: json['nama'], 
      umur: json['umur'], 
      alamat: Alamat.fromJson(json['alamat']),
      hobi: Hobi.fromJson(json['hobi']),
      )l 
    }
  }

class Alamat {
  final String jalan;
  final String kota; 
  // dinamic bisa terima tipe data apa saja 
  final String provinsi; 

  Alamat ({
  required this.jalan,
  required this.kota, 
  required this.provinsi
  )}; 

  Factory Alamat.fromJson(Map<String, dynamic> json){
    return Alamat(
      jalan: json['jalan'], 
      kota: json['kota'], 
      provinsi: json['provinsi']
      )l 
    }
  }