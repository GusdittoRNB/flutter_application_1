part of 'pages.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> dataList = [
    {'nama': 'Alif Abas', 'telp': '123456789', 'alamat': 'Jalan raya angantaka'},
    {'nama': 'Budi Bakrie', 'telp': '987654321', 'alamat': 'Jalan raya badung'},
    {'nama': 'Calista Chris', 'telp': '246813579', 'alamat': 'Jalan raya ciungwanara'},
    {'nama': 'Danu Daksawan', 'telp': '135792468', 'alamat': 'Jalan raya danau poso'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Implement action when profile icon is pressed
            },
            icon: Icon(Icons.account_circle),
            iconSize: 32,
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
                columns: <DataColumn>[
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
                      'Telp',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Alamat',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: dataList.map(
                  (data) => DataRow(
                    color: MaterialStateColor.resolveWith((states) => primaryColor),
                    cells: [
                      DataCell(
                        Text(
                          data['nama'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['telp'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data['alamat'] ?? '',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
