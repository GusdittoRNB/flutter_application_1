part of 'pages.dart';

class TransaksiMemberPage extends StatefulWidget {
  @override
  _TransaksiMemberPageState createState() => _TransaksiMemberPageState();
}

class _TransaksiMemberPageState extends State<TransaksiMemberPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        // Parsing data JSON
        Map<String, dynamic> responseData = response.data;
        List<dynamic> anggotaList = responseData['data']['anggotas'];

        // Mengubah setiap item dalam daftar anggota menjadi objek Member
        List<Member> members =
            anggotaList.map((item) => Member.fromJson(item)).toList();

        // Memperbarui daftar anggota dalam state
        setState(() {
          _members = members;
        });
      } else {
        // Respons gagal
        print('Failed to load members: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load members',
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
            'Token is expired. Please login again.',
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
        title: Text('Member'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        member.name,
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/addtabungan',
                                arguments: {
                                  'id': member.id,
                                  'nomor_induk': member.nomorInduk,
                                  'nama': member.name,
                                },
                              );
                            },
                            icon: Icon(Icons.add_card),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/saldotabungan',
                                arguments: member.id,
                              );
                            },
                            icon: Icon(Icons.account_balance_wallet),
                            color: secondaryColor,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/listtabungan',
                          arguments: member.id,
                        );
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Members {
  int? id;
  int? nomorInduk;
  String? name;
  String? alamat;
  String? tanggalLahir;
  String? telepon;
  int? statusAktif;

  Members({
    this.id,
    this.nomorInduk,
    this.name,
    this.alamat,
    this.tanggalLahir,
    this.telepon,
    this.statusAktif,
  });

  Members.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nomorInduk = json['nomor_induk'],
        name = json['nama'],
        alamat = json['alamat'],
        tanggalLahir = json['tgl_lahir'],
        telepon = json['telepon'],
        statusAktif = json['status_aktif'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_induk': nomorInduk,
      'nama': name,
      'alamat': alamat,
      'tgl_lahir': tanggalLahir,
      'telepon': telepon,
      'status_aktif': statusAktif,
    };
  }
}
