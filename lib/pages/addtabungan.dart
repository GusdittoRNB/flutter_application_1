part of 'pages.dart';

class TransactionType {
  final int id;
  final String trxName;

  TransactionType({required this.id, required this.trxName});

  // Define static transaction types
  static final List<TransactionType> predefinedTransactionTypes = [
    TransactionType(id: 1, trxName: 'Saldo Awal'),
    TransactionType(id: 2, trxName: 'Simpanan'),
    TransactionType(id: 3, trxName: 'Penarikan'),
    TransactionType(id: 4, trxName: 'Bunga Simpanan'),
    TransactionType(id: 5, trxName: 'Koreksi Penambahan'),
    TransactionType(id: 6, trxName: 'Koreksi Pengurangan'),
  ];
}

class AddTabunganPage extends StatefulWidget {
  const AddTabunganPage({Key? key}) : super(key: key);

  @override
  _AddTabunganPageState createState() => _AddTabunganPageState();
}

class _AddTabunganPageState extends State<AddTabunganPage> {
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController anggotaIdController = TextEditingController();
  final TextEditingController nomorIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late int memberId;
  late int nomorInduk;
  String nama = '';
  late TransactionType _selectedTransactionType;

  @override
  void initState() {
    super.initState();
    // Initialize selected transaction type with the first item
    _selectedTransactionType = TransactionType.predefinedTransactionTypes.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch arguments and set initial values for the fields
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    memberId = arguments['id'] as int;
    nomorInduk = arguments['nomor_induk'] as int;
    nama = arguments['nama'] as String;

    // Set the initial values for the readonly fields
    anggotaIdController.text = memberId.toString();
    nomorIndukController.text = nomorInduk.toString();
    namaController.text = nama;
  }

  Future<void> addTabungan() async {
    final trxNominal = nominalController.text;

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': memberId,
          'trx_id': _selectedTransactionType.id,
          'trx_nominal': int.parse(trxNominal),
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
                        context, '/transaksimember', (route) => false);
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
                    context, '/transaksimember', (route) => false);
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
          'Add Transaction',
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
            GestureDetector(
              onTap: () {},
              child: AbsorbPointer(
                child: TextField(
                  controller: anggotaIdController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'ID Anggota',
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
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: AbsorbPointer(
                child: TextField(
                  controller: nomorIndukController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Nomor Induk',
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
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: AbsorbPointer(
                child: TextField(
                  controller: namaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Nama',
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
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Jenis Transaksi', // Label for the dropdown
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
                // You can customize the appearance of the dropdown label here
                labelStyle: blackTextStyle.copyWith(fontSize: 15),
              ),
              child: DropdownButton<TransactionType>(
                value: _selectedTransactionType,
                onChanged: (TransactionType? newValue) {
                  setState(() {
                    _selectedTransactionType = newValue!;
                  });
                },
                items: TransactionType.predefinedTransactionTypes
                    .map((TransactionType type) {
                  return DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Text(
                      type.trxName,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
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
                  if (nominalController.text.isNotEmpty) {
                    addTabungan();
                  } else {
                    _showErrorDialog(
                        'ID Transaksi dan jumlah menabung tidak boleh kosong.');
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
