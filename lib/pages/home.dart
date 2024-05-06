part of 'pages.dart';

class HomePage extends StatelessWidget {

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.account_circle),
            iconSize: 30,
          ),
        ],
      ),
      drawer: NavigationDrawer(
        children:  [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                      'Home',
                      style: blackTextStyle,
                    ),
                    onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      'Profile',
                      style: blackTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.wallet),
                    title: Text(
                      'Wallet',
                      style: blackTextStyle,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Member',
                      style: blackTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/member');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style: blackTextStyle,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text(
                      'Logout',
                      style: blackTextStyle,
                    ),
                    onTap: () {
                      goLogout(context);
                    },
                  ),
                ],
              )
            ],
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Wallet',
            icon: Icon(Icons.wallet),
          ),
          BottomNavigationBarItem(
            label: 'Pay',
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor, // Warna latar belakang
              ),
              padding: EdgeInsets.all(
                  10), // Padding agar ikon tidak terlalu dekat dengan tepi latar belakang
              child: Icon(Icons.attach_money_sharp,
                  size: 30,
                  color: primaryColor), // Ikon yang ditempatkan di dalam latar belakang
            ),
          ),
          BottomNavigationBarItem(
            label: 'Activty',
            icon: Icon(FontAwesomeIcons.fileInvoiceDollar),
          ),
          BottomNavigationBarItem(
            label: 'Me',
            icon: Icon(Icons.person_2),
          ),
        ],
      ),
    );
  } 

  void goLogout(BuildContext context) async{
    try{
      final _response = await _dio.get(
        '${_apiUrl}/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

}
