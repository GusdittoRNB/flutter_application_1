part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  String _id = '';
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    goUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              // Menampilkan foto profil pengguna jika tersedia
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'ID: $_id',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Name: $_name',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Email: $_email',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                goLogout(context);
              },
              child: Text(
                'Logout',
                style: whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goUser() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      if (_response.statusCode == 200) {
        // Parsing data JSON
        Map<String, dynamic> responseData = _response.data;
        Map<String, dynamic> userData = responseData['data']['user'];

        // Mengambil id, name, dan email dari userData
        String id = userData['id'].toString();
        String name = userData['name'];
        String email = userData['email'];

        setState(() {
          _id = id;
          _name = name;
          _email = email;
        });
      } else {
        // Respons gagal
        print('Failed to load user data: ${_response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token is expired. Please login again.', textAlign: TextAlign.center,),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating, 
        ),
      );
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
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

}
