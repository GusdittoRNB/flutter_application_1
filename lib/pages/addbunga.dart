part of 'pages.dart';

class AddBungaPage extends StatefulWidget {
  const AddBungaPage({Key? key}) : super(key: key);

  @override
  _AddBungaPageState createState() => _AddBungaPageState();
}

class _AddBungaPageState extends State<AddBungaPage> {
  final TextEditingController bungaController = TextEditingController();
  int? selectedAktif;
  List<dynamic> activeBunga = [];
  // List<dynamic> settingBungas = [];

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    getBunga();
  }

  Future<void> getBunga() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (_response.statusCode == 200) {
        setState(() {
          activeBunga = [_response.data['data']['activebunga']];
          // settingBungas = _response.data['data']['settingbungas'];
        });
        print(_response.data);
      } else {
        print('Failed to load saldo: ${_response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Token is Expired. Please Login Again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

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
              content: Text('Add bunga berhasil dilakukan'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add failed. Please check your data.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: bungaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Persentase Bunga (Contoh: 1.1)',
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
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Aktif:',
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
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
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  if (bungaController.text.isNotEmpty &&
                      selectedAktif != null) {
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
            SizedBox(height: 80),
            Center(
              child: Text(
                'Active Bunga:',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: activeBunga.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: activeBunga.map((bunga) {
                        return Text(
                          '${bunga['persen']}%',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        );
                      }).toList(),
                    )
                  : Text(
                      'No active bunga found',
                      style: blackTextStyle,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
