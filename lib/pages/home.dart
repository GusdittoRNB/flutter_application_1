part of 'pages.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> dataList = [
    {'id': '32', 'name': 'budi', 'email': 'budi@gmail.com'},
    {'id': '33', 'name': 'cece', 'email': 'cece@gmail.com'},
    {'id': '34', 'name': 'dede', 'email': 'dede@gmail.com'},
  ];

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
                      'Id',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
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
                          data['id'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['name'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['email'] ?? '',
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
                    leading: Icon(Icons.wallet),
                    title: Text(
                      'Wallet',
                      style: blackTextStyle,
                    ),
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
            icon: Icon(Icons.attach_money_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Activty',
            icon: Icon(Icons.local_activity),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
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
