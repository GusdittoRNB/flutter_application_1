part of 'pages.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Member> _members = [];

  Member? _selectedMember;

  @override
  void initState() {
    super.initState();
    _loadMembers(); // Panggil metode untuk memuat anggota saat widget diinisialisasi
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
          content: Text('Token is expired. Please login again.', textAlign: TextAlign.center,),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating, 
        ),
      );
    }
  }

  // Fungsi untuk menampilkan detail anggota dalam bottom sheet
  void _showMemberDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'e-Silih Member Details',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 16),
              if (_selectedMember != null) ...[
                Text('Id: ${_selectedMember!.id}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
                Text('Nomor Induk: ${_selectedMember!.nomorInduk}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
                Text('Name: ${_selectedMember!.name}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
                Text('Alamat: ${_selectedMember!.alamat}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
                Text('Tanggal Lahir: ${_selectedMember!.tanggalLahir}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
                Text('Telepon: ${_selectedMember!.telepon}',
                style: blackTextStyle.copyWith(
                  fontSize: 17,
                ),),
              ]
            ],
          ),
        );
      },
    );
  }

  void _editMember(Member member) {
  Navigator.pushNamed(
    context,
    '/editmember',
    arguments: member, // Meneruskan data anggota sebagai argumen
  );
}

  void _confirmDeleteMember(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Member'),
          content: Text('Are you sure to delete this member?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteMember(member.id); // Hapus anggota
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMember(int id) async {
  try {
      final _response = await _dio.delete(
        '${_apiUrl}/anggota/${id}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      Navigator.pushNamed(context, '/home');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed. Please login again', textAlign: TextAlign.center,),
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/addmember');
            },
            icon: Icon(Icons.add),
            iconSize: 35,
          ),
        ],
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => secondaryColor),
                columns: [
                  DataColumn(
                    label: Text(
                      'Id',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nomor Induk',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: _members.map((member) {
                  return DataRow(
                    color: MaterialStateColor.resolveWith((states) => primaryColor),
                    cells: [
                      DataCell(
                        Text(
                          member.id.toString(),
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Ketika ID diklik, tampilkan detail anggota
                          setState(() {
                            _selectedMember = member;
                          });
                          _showMemberDetails(context);
                        },
                      ),
                      DataCell(
                        Text(
                          member.nomorInduk.toString(),
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          member.name,
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Aksi pertama ketika tombol ditekan
                                _editMember(member);
                              },
                              child: Text('Edit'),
                            ),
                            SizedBox(width: 8), // Jarak antara tombol
                            ElevatedButton(
                              onPressed: () {
                                // Aksi kedua ketika tombol ditekan
                                _confirmDeleteMember(member);
                              },
                              child: Text(
                                'Delete',
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Warna merah
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model data untuk anggota
class Member {
  final int id;
  final int nomorInduk;
  final String name;
  final String alamat;
  final String tanggalLahir;
  final String telepon;

  Member({
    required this.id,
    required this.nomorInduk,
    required this.name,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      nomorInduk: json['nomor_induk'],
      name: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
    );
  }

}
