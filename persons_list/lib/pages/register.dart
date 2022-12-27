import 'package:flutter/material.dart';
import 'register_form.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({Key? key}) : super(key: key);

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yetkili Ekranı"), //Giriş Yapma ve kayıt olma sayfalarında kullaılan başlık
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: const RegisterForm(),
    );
  }
}
