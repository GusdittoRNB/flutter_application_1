part of 'pages.dart';

class ListTabunganPage extends StatefulWidget {
  const ListTabunganPage({Key? key}) : super(key: key);

  @override
  _ListTabunganPageState createState() => _ListTabunganPageState();
}

class _ListTabunganPageState extends State<ListTabunganPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late int memberId = 0;

  List<Tabungan> tabunganList = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      memberId = arguments as int;
      getTabunganMember();
    }
  }

  Future<void> getTabunganMember() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tabunganData = responseData['data']['tabungan'];
        List<Tabungan> tempList = [];
        for (var tabungan in tabunganData) {
          tempList.add(Tabungan.fromJson(tabungan));
        }
        setState(() {
          tabunganList = tempList;
        });
      } else {
        // Respons gagal
        print('Failed to load saldo: ${response.statusCode}');
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Tabungan',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tabunganList.isEmpty
              ? Center(child: Text('Belum Memiliki Tabungan'))
              : ListView.builder(
                  itemCount: tabunganList.length,
                  itemBuilder: (context, index) {
                    final tabungan = tabunganList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5, // Mengurangi jarak vertikal antara tile
                        horizontal: 24, // Padding horizontal tetap
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Color.fromARGB(255, 241, 238, 247),
                          title: Text(
                            'ID transaksi: ${tabungan.trxId}',
                            style: blackTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Jumlah: Rp${tabungan.trxNominal}',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Tabungan {
  int? trxId;
  int? anggotaId;
  int? trxNominal;

  Tabungan({
    this.trxId,
    this.anggotaId,
    this.trxNominal,
  });

  Tabungan.fromJson(Map<String, dynamic> json)
      : trxId = json['trx_id'],
        anggotaId = json['anggota_id'],
        trxNominal = json['trx_nominal'];

  Map<String, dynamic> toJson() {
    return {
      'trx_id': trxId,
      'anggota_id': anggotaId,
      'trx_nominal': trxNominal,
    };
  }
}
