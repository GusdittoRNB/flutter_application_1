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

  @override
  void initState() {
    super.initState();
    _loadMemberDetail();
  }

  Future<void> _loadMemberDetail() async {
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
                  buildDetailCard("ID", _member!.id.toString()),
                  SizedBox(height: 15),
                  buildDetailCard(
                      "Nomor Induk", _member!.nomorInduk.toString()),
                  SizedBox(height: 15),
                  buildDetailCard("Nama", _member!.name),
                  SizedBox(height: 15),
                  buildDetailCard("Alamat", _member!.alamat),
                  SizedBox(height: 15),
                  buildDetailCard("Tanggal Lahir", _member!.tanggalLahir),
                  SizedBox(height: 15),
                  buildDetailCard("Telepon", _member!.telepon),
                  SizedBox(height: 15),
                  buildDetailCard("Status",
                      _member!.statusAktif == 1 ? 'Active' : 'Inactive'),
                ],
              ),
            ),
    );
  }

  Widget buildDetailCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 238, 247),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
