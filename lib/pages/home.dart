part of 'pages.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> dataList = [
    {'nama': 'Alif Abas', 'telp': '123456789', 'alamat': 'Jalan raya angantaka'},
    {'nama': 'Budi Bakrie', 'telp': '987654321', 'alamat': 'Jalan raya badung'},
    {'nama': 'Calista Chris', 'telp': '246813579', 'alamat': 'Jalan raya ciungwanara'},
    {'nama': 'Danu Daksawan', 'telp': '135792468', 'alamat': 'Jalan raya danau poso'},
  ];

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
              style: blackTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => secondaryColor),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Nama',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Telp',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Alamat',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: dataList.map(
                  (data) => DataRow(
                    color: MaterialStateColor.resolveWith((states) => primaryColor),
                    cells: [
                      DataCell(
                        Text(
                          data['nama'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['telp'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['alamat'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
              ),
            ),
          ],
        ),
      ),
      endDrawer: NavigationDrawer(
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
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
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
                      goUser();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Home',
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
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
            
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  } 

  void goUser() async{
    try{
      final _response = await _dio.get(
        '${_apiUrl}/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
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
      Navigator.pushReplacementNamed(context, '/');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

}
