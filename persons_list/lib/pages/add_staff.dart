import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persons_list/pages/upload_cv.dart';

//personellerin eklenebileceği sayfa
class PersonelEkle extends StatefulWidget {
  const PersonelEkle({Key? key}) : super(key: key);

  @override
  State<PersonelEkle> createState() => _PersonelEkleState();
}

class _PersonelEkleState extends State<PersonelEkle> {

  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Personel Ekle"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(//ekranda taşma olmasını engellemek için kullandım
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Image.asset("images/man.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: adAlici,
                decoration: const InputDecoration(
                  labelText: "Personel Adı Soyadı :",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: tarihAlici,
              decoration: const InputDecoration(
                labelText: "Doğum Tarihi : ",
                border: OutlineInputBorder()
              ),
            ),),
            Padding( //cv yükleme kısmı
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 70,
                width: 130,
                child: ElevatedButton( //tıklanabilir buton oluşturularak yükleme alanına yönlendirildi
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadFile())); //yükleme işleminin yapıldığı sınıf
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26
                  ), //tıklanabilir buton oluşturularak yükleme alanına yönlendirildi
                  child: const Text( "CV Yükle"),
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 70,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  verileriEkle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan
                ),
                child: const
                Text("Personeli Ekle" ,
                  style: TextStyle(
                      fontSize: 24 ,
                      fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }

  void verileriEkle() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = yetki.currentUser;

    String uidTutucu = mevcutKullanici!.uid;
    var zamanTutucu = DateTime.now();

    await FirebaseFirestore.instance //veri tabanından hangi verilerin alınacağı belirtiliyor
        .collection('Personeller')
        .doc(uidTutucu)
        .collection('Personellerim')
        .doc(zamanTutucu.toString())
        .set({
      'ad': adAlici.text,
      'dogumTarihi': tarihAlici.text,
      'zaman': zamanTutucu.toString(),
      'tamZaman': zamanTutucu
    });
    Fluttertoast.showToast(msg: "Personel başarıyla eklenmiştir.."); //personel eklemesi yapılınca eklendiğine dair mesaj veriliyor
  }

}
