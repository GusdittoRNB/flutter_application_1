part of 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'e-Silih',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
            iconSize: 30,
          ),
        ],
      ),
      drawer: NavigationDrawer(children: [
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
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
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
                  leading: Icon(Icons.percent),
                  title: Text(
                    'Interest',
                    style: blackTextStyle,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/addbunga');
                  },
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
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Ubah _selectedIndex saat item diklik
            if (index == 1) {
              Navigator.pushNamed(
                  context, '/member'); // Menuju halaman member untuk transaksi
            } else if (index == 3) {
              Navigator.pushNamed(context,
                  '/addbunga'); // Menuju halaman profil jika item 'Me' ditekan
            } else if (index == 4) {
              Navigator.pushNamed(context,
                  '/profile'); // Menuju halaman profil jika item 'Me' ditekan
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Members',
            icon: Icon(Icons.people),
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
                  color:
                      primaryColor), // Ikon yang ditempatkan di dalam latar belakang
            ),
          ),
          BottomNavigationBarItem(
            label: 'Interest',
            icon: Icon(Icons.percent),
          ),
          BottomNavigationBarItem(
            label: 'Me',
            icon: Icon(Icons.person_2),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card untuk aplikasi simpan pinjam
              Card(
                elevation: 4, // Elevasi card
                child: Padding(
                  padding: const EdgeInsets.all(110.0),
                ),
              ),
              SizedBox(height: 16), // Jarak antara card dan kotak-kotak kecil
              // GridView untuk kotak-kotak kecil
              GridView.count(
                crossAxisCount: 3, // 3 kolom
                shrinkWrap:
                    true, // Agar tidak mengambil ruang lebih dari yang diperlukan
                physics:
                    NeverScrollableScrollPhysics(), // Tidak dapat di-scroll
                children: List.generate(
                  9, // Jumlah kotak-kotak kecil
                  (index) {
                    return Container(
                      color: Colors.grey[200], // Warna latar belakang kotak
                      margin: EdgeInsets.all(
                          4), // Margin untuk memberikan jarak antara kotak-kotak kecil
                      child: Center(
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goLogout(BuildContext context) async {
    try {
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
