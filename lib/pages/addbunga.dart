part of 'pages.dart';

class AddBungaPage extends StatefulWidget {
  const AddBungaPage({Key? key}) : super(key: key);

  @override
  _AddBungaPageState createState() => _AddBungaPageState();
}

class _AddBungaPageState extends State<AddBungaPage> {
  final TextEditingController bungaController = TextEditingController();
  int? selectedAktif;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getSaldoMember();
  }

  Future<void> getSaldoMember() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (_response.statusCode == 200) {
        print(_response.data);
      } else {
        print('Failed to load saldo: ${_response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  // Function to add bunga
  Future<void> addBunga() async {
    final persentaseBunga = bungaController.text;

    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'persen': persentaseBunga,
          'isaktif': selectedAktif,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Transaksi berhasil dilakukan'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/member', (route) => false);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog('Something went wrong. Please try again');
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

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/member', (route) => false);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Bunga',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Aktif',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: selectedAktif,
                      onChanged: (value) {
                        setState(() {
                          selectedAktif = value;
                        });
                      },
                    ),
                    Text('Aktif'),
                    Radio<int>(
                      value: 0,
                      groupValue: selectedAktif,
                      onChanged: (value) {
                        setState(() {
                          selectedAktif = value;
                        });
                      },
                    ),
                    Text('Non-Aktif'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: bungaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Persentase Bunga',
                filled: true,
                fillColor: fieldColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelStyle: blackTextStyle.copyWith(fontSize: 15),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  if (bungaController.text.isNotEmpty && selectedAktif != null) {
                    addBunga();
                  } else {
                    _showErrorDialog(
                        'Status Aktif dan Bunga tidak boleh kosong.');
                  }
                },
                color: secondaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Submit',
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}