import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}
String? kullaniciAdi, email, parola;
bool kayitDurumu = false;

class _RegisterFormState extends State<RegisterForm> {

  final _dogrulamaAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dogrulamaAnahtari,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 200,
                child: Image.asset("images/kisiler.png"),
              ),
            ),
            if (!kayitDurumu)
              Padding(padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (alinanAd){
                  kullaniciAdi = alinanAd;
                },
                validator: (alinanAd){ //kullanıcı adı girilmiş mi kontrol ediliyor
                  return alinanAd!.isEmpty
                      ? "Kullanıcı adı boş bırakılamaz!"
                      : null;
                },
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı : ",
                  border: OutlineInputBorder(),
                ),
              ),),
            Padding(padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (alinanEmail){
                email = alinanEmail;
              },
              validator: (alinanEmail){ //kullanıcının girdiği mail adresinin geçerliliği kontrol ediliyor
                return alinanEmail!.contains("@") //@ işaareti yoksa geçersiz mail olarak atandı
                    ? null
                    : "Geçersiz Email !" ;
              },
              decoration: const InputDecoration( //ekranda görünen kısım için ayaarlamalar yapılıyor
                labelText: "Email :",
                border: OutlineInputBorder(),
              ),
            ),),
            Padding(padding: const EdgeInsets.all(8.0), //parola girişi ayarları yapılıyor
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanParola){
                  parola= alinanParola;
                },
                validator: (alinanParola){ //Parola kontrolleri yapılıyor
                  return alinanParola!.length >=6
                      ? null
                      : "Parolaniz en az 6 karakter olmalıdır !";
                },
                decoration: const InputDecoration(
                  labelText: "Parola :",
                      border: OutlineInputBorder()
                ),

              ),
            ),
            Padding( //Uygulamaya girecek kişi yetkili mi yeni mi kayıt yapılacak kontrolleri
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    kayitEkle();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shadowColor: Colors.black //gölgelendirme yapıldı
                  ),
                  child: kayitDurumu
                  ? const Text("Giriş Yap" , style: TextStyle(fontSize: 24))
                  :const Text("Kayıt Ol" , style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
            //Hesabın var mı yok mu kontrolleri yapılacak
            Container(
              alignment: Alignment.centerRight, //konumunun nerede olacağını ayarladık
              child: TextButton(
                onPressed: (){
                  setState(() {
                    kayitDurumu = !kayitDurumu;
                  });
                },
                child: kayitDurumu
                ? const Text("Hesabım Yok")
                : const Text("Zaten Hesabim Var"),

              ),
            )

          ],
        ),
      ),
    );
  }

  void kayitEkle() { //mail ve parola alınarak kayıt ekeleniyor
    if (_dogrulamaAnahtari.currentState!.validate()){
      formuTestEt(kullaniciAdi!, email! , parola!);
    }
  }

  void formuTestEt(String kullaniciAdi, String email, String parola) async { //Firebase içerisindeki yetki kontrol ediliyor
    final yetki = FirebaseAuth.instance;
    AuthCredential? yetkiSonucu;

    if(kayitDurumu){
      yetkiSonucu = (await yetki.signInWithEmailAndPassword
        (email: email, password: parola)) as AuthCredential;//Firebase kontrol ediliyor bu kullanıcı adı ve şifrede kayıtlı biri var mı
    }else{
      yetkiSonucu = (await yetki.createUserWithEmailAndPassword(email: email, password: parola)) as AuthCredential;
    }
    String uidTutucu = yetkiSonucu.toString();
    await FirebaseFirestore.instance.
    collection("kullanicilar")
        .doc(uidTutucu)
        .set({"kullaniciAdi": kullaniciAdi , "email" : email});
  }
}
