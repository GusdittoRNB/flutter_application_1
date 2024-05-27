// part of 'pages.dart';

// class TransactionTypePage extends StatefulWidget {
//   @override
//   _TransactionTypePageState createState() => _TransactionTypePageState();
// }

// class _TransactionTypePageState extends State<TransactionTypePage> {
//   final Dio _dio = Dio();
//   final _storage = GetStorage();
//   final _apiUrl = 'https://mobileapis.manpits.xyz/api';
//   List<TransactionType> _transactionTypes = [];
//   TransactionType? _selectedTransactionType;

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactionTypes();
//   }

//   Future<void> _loadTransactionTypes() async {
//     try {
//       final response = await _dio.get(
//         '$_apiUrl/jenistransaksi',
//         options: Options(
//           headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
//         ),
//       );
//       print(response.data);
//       if (response.statusCode == 200) {
//         // Parsing data JSON
//         Map<String, dynamic> responseData = response.data;
//         List<dynamic> transactionTypeList =
//             responseData['data']['jenistransaksi'];

//         // Mengubah setiap item dalam daftar jenis transaksi menjadi objek TransactionType
//         List<TransactionType> transactionTypes = transactionTypeList
//             .map((item) => TransactionType.fromJson(item))
//             .toList();

//         // Memperbarui daftar jenis transaksi dalam state
//         setState(() {
//           _transactionTypes = transactionTypes;
//           if (_transactionTypes.isNotEmpty) {
//             _selectedTransactionType = _transactionTypes.first;
//           }
//         });
//       } else {
//         // Respons gagal
//         print('Failed to load transaction types: ${response.statusCode}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Failed to load transaction types',
//               textAlign: TextAlign.center,
//             ),
//             duration: Duration(seconds: 3),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } on DioException catch (e) {
//       print('${e.response} - ${e.response?.statusCode}');
//       Navigator.pushReplacementNamed(context, '/');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Token is expired. Please login again.',
//             textAlign: TextAlign.center,
//           ),
//           duration: Duration(seconds: 3),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Transaction Types',
//           style: blackTextStyle.copyWith(
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _transactionTypes.isNotEmpty
//                   ? DropdownButton<TransactionType>(
//                       value: _selectedTransactionType,
//                       onChanged: (TransactionType? newValue) {
//                         setState(() {
//                           _selectedTransactionType = newValue;
//                         });
//                       },
//                       items: _transactionTypes.map((TransactionType type) {
//                         return DropdownMenuItem<TransactionType>(
//                           value: type,
//                           child: Text(
//                             type.trxName,
//                             style: blackTextStyle.copyWith(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     )
//                   : CircularProgressIndicator(),
//               SizedBox(height: 20),
//               _selectedTransactionType != null
//                   ? Text(
//                       'Selected Type: ${_selectedTransactionType!.trxName}',
//                       style: blackTextStyle.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Model data untuk jenis transaksi
// class TransactionType {
//   final int id;
//   final String trxName;
//   final int trxMultiply;

//   TransactionType({
//     required this.id,
//     required this.trxName,
//     required this.trxMultiply,
//   });

//   factory TransactionType.fromJson(Map<String, dynamic> json) {
//     return TransactionType(
//       id: json['id'],
//       trxName: json['trx_name'],
//       trxMultiply: json['trx_multiply'],
//     );
//   }
// }
