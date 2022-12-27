import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_staff.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  String? mevcutkullaniciUidTutucu;
  @override
  void initState() { //mevcut kullanıcı id si alınacak kullanıcı daha önce giriş yapmış mı kontrol edilecek
    // TODO: implement initState
    mevcutkullaniciUidsiAl();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Personel Listesi"),
        actions: [//Uygulamadan çıkmak için veya önceki sayfaya dönmek için
          IconButton(onPressed: () async { //uygulamadan çıkış yapılıyor
            await FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder( //anlık yapılan işlemleri firestoreda uyguladığı için kullanıldı hangi personel hangi özellikleri eklensin belirmemiz için kullanıldı
          stream: FirebaseFirestore.instance.
          collection("Personeller")
          .doc(mevcutkullaniciUidTutucu)
          .collection("Personellerim")
          .snapshots(), //firestoredan çekilen verileri görmemiz için kullanılan metod
          builder: (context, AsyncSnapshot<QuerySnapshot> veriTabanindanGelenVeriler){
            if (veriTabanindanGelenVeriler.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(), //veriler gelirken beklemesi
              );
            }else {
              final alinanVeri = veriTabanindanGelenVeriler.data!.docs;
              return ListView.builder( //for döngüsü gibi veri tabanında bulunan verileri listede yazdırmak için
                  itemCount: veriTabanindanGelenVeriler.data!.docs.length,
                  itemBuilder: (context , index){
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 8, 10, 3),//sayfadaki konumları ayarlanıyor
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(15) //kenarlara ovallik verildi
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), //aralarındaki boşluk ayarlandı
                    child: Row( //gelen personellerin alt alta sıralanması için
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, //her veri arasını hizalandırmak için
                      children: [
                        Flexible( //orantılama yapılıyor sütunsal olarak
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(alinanVeri[index]['ad'],
                                        style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),),
                                    ),
                                  )
                              ),
                              SizedBox(
                                height: 20,

                                child: Center(
                                  child: ElevatedButton(
                                      child: const Text("CV"),
                                    onPressed: (){

                                    }),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(alinanVeri[index]['dogumTarihi'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () async{
                              await FirebaseFirestore.instance
                                  .collection('Personeller')
                                  .doc(mevcutkullaniciUidTutucu)
                                  .collection('Personellerim')
                                  .doc(alinanVeri[index]['zaman'],) //zaman yazıyordu sildim
                                  .delete();
                            } , icon: const Icon(Icons.delete),//silme butonu
                        )
                      ],
                    ),
                  ),
                );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( //icona tıkladığımızda personel eklemek için gerekli olan sayfaya yönlendirilecek
        backgroundColor: Colors.cyan,
        onPressed: (){ //ekleme(+) butonuna basıldığında personel ekleme sayfasına yönlendiriliyor
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonelEkle()));
        }, //icona tıkladığımızda personel eklemek için gerekli olan sayfaya yönlendirilecek
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

      ),
    );
  }

  void mevcutkullaniciUidsiAl() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = yetki.currentUser;
    setState(() {
    mevcutkullaniciUidTutucu= mevcutKullanici!.uid;
    });
  }
}


