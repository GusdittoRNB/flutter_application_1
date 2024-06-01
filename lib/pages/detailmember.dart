part of 'pages.dart';

class MemberDetailPage extends StatefulWidget {
  final int memberId;

  const MemberDetailPage({Key? key, required this.memberId}) : super(key: key);

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  Member? _member;
  int saldo = 0;

  @override
  void initState() {
    super.initState();
    getMemberDetail();
    getSaldoMember();
  }

  Future<void> getMemberDetail() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/anggota/${widget.memberId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (_response.statusCode == 200) {
        final responseData = _response.data;
        final memberData = responseData['data']['anggota'];
        setState(() {
          _member = Member.fromJson(memberData);
        });
        print(_response.data);
      } else {
        print('Failed to load member detail: ${_response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load member detail',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load member detail',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Future<void> getSaldoMember() async {
    try {
      final _response = await _dio.get(
        '$_apiUrl/saldo/${widget.memberId}',
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
        print('Failed to load saldo: ${_response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Member Detail',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: _member == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: NetworkImage(_member!.profileImageUrl ?? ''),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: buildDetailCard("ID", _member!.id.toString()),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildDetailCard(
                            "Nomor Induk", _member!.nomorInduk.toString()),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  buildDetailCard("Nama", _member!.name),
                  SizedBox(height: 10),
                  buildDetailCard("Alamat", _member!.alamat),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: buildDetailCard(
                            "Tanggal Lahir", _member!.tanggalLahir),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildDetailCard("Telepon", _member!.telepon),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  buildStatusCard("Status",
                      _member!.statusAktif == 1 ? 'Active' : 'Inactive'),
                  SizedBox(height: 10),
                  buildSaldoCard("Saldo",
                      'Rp${NumberFormat("#,##0", "id_ID").format(saldo)}'),
                  SizedBox(height: 105),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/listtabungan',
                              arguments: _member!.id,
                            );
                          },
                          child: Text(
                            'Daftar Transaksi',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/addtabungan',
                              arguments: {
                                'id': _member!.id,
                                'nomor_induk': _member!.nomorInduk,
                                'nama': _member!.name,
                              },
                            );
                          },
                          child: Text(
                            'Add Transaksi',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDetailCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 238, 247),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: value == 'Active' ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            value == 'Active' ? Icons.check_circle : Icons.cancel,
            color: value == 'Active' ? Colors.green : Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            '$label: $value',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaldoCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.blue,
          ),
          SizedBox(width: 8),
          Text(
            '$label: $value',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
