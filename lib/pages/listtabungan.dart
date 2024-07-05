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
  List<Tabungan> filteredTabunganList = [];
  bool isLoading = false;

  String transactionType = '';
  String _searchKeyword = '';

  int currentPage = 1;
  int itemsPerPage = 5;

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
          filteredTabunganList = tempList;
        });
      } else {
        print('Failed to load tabungan: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load tabungan',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioError catch (e) {
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

  List<Tabungan> getPaginatedData() {
  // Urutkan filteredTabunganList berdasarkan trxTanggal dari terbaru ke terlama
  filteredTabunganList.sort((a, b) => DateTime.parse(b.trxTanggal!).compareTo(DateTime.parse(a.trxTanggal!)));

  // Hitung indeks awal berdasarkan halaman saat ini dan items per halaman
  int startIndex = (currentPage - 1) * itemsPerPage;

  // Ambil sejumlah itemsPerPage data terbaru dari startIndex
  return filteredTabunganList.skip(startIndex).take(itemsPerPage).toList();
}


  void filterTabunganList(String keyword) {
    setState(() {
      _searchKeyword = keyword.toLowerCase();
      filteredTabunganList = tabunganList.where((tabungan) {
        return tabungan.trxNominal.toString().contains(_searchKeyword) ||
            getTransactionType(tabungan.trxId)
                .toLowerCase()
                .contains(_searchKeyword);
      }).toList();
      currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tabungan> paginatedData = getPaginatedData();
    int totalPages = (filteredTabunganList.length / itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Transaction',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterTabunganList(value);
              },
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : tabunganList.isEmpty
                    ? Center(child: Text('Belum Memiliki Tabungan'))
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columnSpacing: 0.0,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      secondaryColor), // Warna latar belakang header kolom
                              dataRowColor: MaterialStateColor.resolveWith(
                                  (states) => Color.fromARGB(255, 236, 234,
                                      255)), // Warna latar belakang sel data
                              columns: [
                                DataColumn(
                                  label: Container(
                                    width: 70,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Tanggal',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width: 110,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '   Jenis',
                                          style: whiteTextStyle.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Transaksi',
                                          style: whiteTextStyle.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width: 70,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Nominal',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: paginatedData
                                  .map(
                                    (tabungan) => DataRow(cells: [
                                      DataCell(
                                        Container(
                                          width: 120,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              tabungan.trxTanggal ?? 'N/A'),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100,
                                          alignment: Alignment.centerLeft,
                                          child: Text(getTransactionType(
                                              tabungan.trxId)),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 120,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Rp${NumberFormat("#,##0", "id_ID").format(tabungan.trxNominal)}',
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
          ),
          if (filteredTabunganList.length > itemsPerPage)
            _buildPaginationControls(totalPages),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20.0), // Adjust the padding as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                : null,
          ),
          Text('Page $currentPage of $totalPages'),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  String getTransactionType(int? trxId) {
    switch (trxId) {
      case 1:
        return 'Saldo Awal';
      case 2:
        return 'Simpanan';
      case 3:
        return 'Penarikan';
      case 4:
        return 'Bunga Simpanan';
      case 5:
        return 'Koreksi Penambahan';
      case 6:
        return 'Koreksi Pengurangan';
      default:
        return 'null';
    }
  }
}

class Tabungan {
  int? trxId;
  int? anggotaId;
  int? trxNominal;
  String? trxTanggal;

  Tabungan({
    this.trxId,
    this.anggotaId,
    this.trxNominal,
    this.trxTanggal,
  });

  Tabungan.fromJson(Map<String, dynamic> json)
      : trxId = json['trx_id'],
        anggotaId = json['anggota_id'],
        trxNominal = json['trx_nominal'],
        trxTanggal = json['trx_tanggal'];

  Map<String, dynamic> toJson() {
    return {
      'trx_id': trxId,
      'anggota_id': anggotaId,
      'trx_nominal': trxNominal,
      'trx_tanggal': trxTanggal,
    };
  }
}
