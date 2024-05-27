part of 'pages.dart';

class EditMemberPage extends StatefulWidget {
  final Member member;

  const EditMemberPage({Key? key, required this.member}) : super(key: key);

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  late TextEditingController _nomorIndukController;
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;
  late int id;
  late int _selectedStatus; // Nilai default status aktif

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal yang akan diedit
    id = widget.member.id;
    _nomorIndukController =
        TextEditingController(text: widget.member.nomorInduk.toString());
    _namaController = TextEditingController(text: widget.member.name);
    _alamatController = TextEditingController(text: widget.member.alamat);
    _teleponController = TextEditingController(text: widget.member.telepon);
    _selectedStatus = widget.member.statusAktif;
    _selectedDate = DateTime.parse(widget.member.tanggalLahir);
  }

  @override
  void dispose() {
    // Dispose controller ketika widget dihilangkan
    _nomorIndukController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void goEditMember() async {
    try {
      final _response = await _dio.put(
        '${_apiUrl}/anggota/${id}',
        data: {
          'nomor_induk': _nomorIndukController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _selectedDate != null ? _selectedDate!.toString() : '',
          'telepon': _teleponController.text,
          'status_aktif': _selectedStatus,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );
      print(_response.data);
      Navigator.pushNamed(context, '/member');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Update failed. Please check your data or login again.',
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
          'Edit Member',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Update Member",
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Expand the community reach by make the members up to date',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: _nomorIndukController,
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
              SizedBox(height: 20.0),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Name',
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
              SizedBox(height: 20.0),
              TextField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
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
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true, // Membuat TextField hanya bisa dibaca
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                          : '', // Tampilkan tanggal yang dipilih jika ada
                    ),
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
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
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _teleponController,
                decoration: InputDecoration(
                  labelText: 'Telepon',
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
              SizedBox(height: 20.0),
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
                      Radio(
                        value: 1,
                        groupValue: _selectedStatus,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedStatus = value ??
                                _selectedStatus; // Pertahankan nilai _selectedStatus jika value null
                          });
                        },
                      ),
                      Text('Aktif'),
                      Radio(
                        value: 0,
                        groupValue: _selectedStatus,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedStatus = value ??
                                _selectedStatus; // Pertahankan nilai _selectedStatus jika value null
                          });
                        },
                      ),
                      Text('Non-Aktif'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/member');
                    },
                    child: Text(
                      'Cancel',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna merah
                    ),
                  ),
                  SizedBox(width: 8), // Jarak antara tombol
                  ElevatedButton(
                    onPressed: () {
                      // Aksi kedua ketika tombol ditekan
                      goEditMember();
                    },
                    child: Text(
                      'Update',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor, // Warna merah
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
