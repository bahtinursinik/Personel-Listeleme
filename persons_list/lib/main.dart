import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persons_list/pages/register.dart';
import 'pages/home_page.dart';

//uygulama ilk açıldığında hangi sayfa açılacak yönlendirmeleri hangi şartlarda yapılacak
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //daha önce oturum açıldı mı açılmadı kontrol yapmak için bu metod
  await Firebase.initializeApp();
  runApp(( Yapilacaklar()));
}

class Yapilacaklar extends StatelessWidget {
  const Yapilacaklar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.light(), //uygulamanın arka plan rengi ayarlanıyor
      debugShowCheckedModeBanner: false,
       home: StreamBuilder(
         stream: FirebaseAuth.instance.authStateChanges(),
         builder: (context, kullaniciVerisi){
           if(kullaniciVerisi.hasData)
              return Anasayfa();
           else
              return KayitEkrani();
  },
  ),
    );
  }
}
