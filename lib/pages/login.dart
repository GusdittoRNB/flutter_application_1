part of 'pages.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
                "Login Here",
                style: secondaryTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Welcome back you’ve been missed!',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.0),
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
                    labelStyle: blackTextStyle.copyWith(fontSize: 15)),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: _isHidden,
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
                            _isHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey))),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot your password?',
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    goLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Create new account',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 110.0),
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
      _isHidden = !_isHidden;
    });
  }

  void goLogin() async{
    try{
      final _response = await _dio.post(
        '${_apiUrl}/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
      emailController.clear();
      passwordController.clear();
      Navigator.pushNamed(context, '/home');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

}
