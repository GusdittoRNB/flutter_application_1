part of 'pages.dart';

class SaldoTabunganPage extends StatefulWidget {
  const SaldoTabunganPage({Key? key}) : super(key: key);

  @override
  _SaldoTabunganPageState createState() => _SaldoTabunganPageState();
}

class _SaldoTabunganPageState extends State<SaldoTabunganPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late int memberId = 0;
  int saldo = 0; // Default value should not be late

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      memberId = arguments as int;
      getSaldoMember();
    }
  }

  Future<void> getSaldoMember() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/saldo/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (_response.statusCode == 200) {
        final responseData = _response.data;
        setState(() {
          saldo = responseData['data']['saldo'];
        });
        print(_response.data);
      } else {
        // Respons gagal
        print('Failed to load saldo: ${_response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load saldo',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong. Please try again',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saldo Tabungan',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, Color.fromARGB(255, 207, 202, 231)],
              ),
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 100,
                      color: secondaryColor,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Saldo',
                      style: blackTextStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Rp$saldo',
                      style: blackTextStyle.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            60), // Add this SizedBox to push content upwards
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
