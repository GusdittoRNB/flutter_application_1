part of 'pages.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: defaultMargin),
              Text(
                "Creat Account",
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Create an account so you can explore all the existing features',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: nameController,
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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                controller: passwordController,
                obscureText: _isHiddenPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  suffixIcon: InkWell(
                    onTap: _tooglePasswordView,
                    child: Icon(
                        _isHiddenPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: confirmPasswordController,
                obscureText: _isHiddenConfirmPassword,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                    suffixIcon: InkWell(
                        onTap: _toogleConfirmPasswordView,
                        child: Icon(
                            _isHiddenConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey))),
              ),
              SizedBox(height: 40.0),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    goRegister(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Already have an account',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Or continue with',
                style: secondaryTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle Google sign up
                    },
                    icon: Icon(Icons.language),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Facebook sign up
                    },
                    icon: Icon(Icons.facebook),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Apple sign up
                    },
                    icon: Icon(Icons.apple),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tooglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toogleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  void goRegister(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      Navigator.pushNamed(context, '/login');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
