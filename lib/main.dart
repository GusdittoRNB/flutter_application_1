import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/member': (context) => MemberPage(),
        '/addmember': (context) => AddMemberPage(),
        '/editmember': (context) {
          final member = ModalRoute.of(context)!.settings.arguments as Member;
          return EditMemberPage(member: member);
        },
        // '/jenistransaksi': (context) => TransactionTypePage(),
        '/addtabungan': (context) => AddTabunganPage(),
        '/transaksimember': (context) => TransaksiMemberPage(),
        '/listtabungan': (context) => ListTabunganPage(),
        '/saldotabungan': (context) => SaldoTabunganPage(),
      },
      initialRoute: '/',
    );
  }
}