part of 'pages.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

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
      body: SafeArea(
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
                'Create an account so you can explore all the existing jobs',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.0),
              TextField(
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
              SizedBox(height: 50.0),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
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
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
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
              SizedBox(height: 70.0),
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

}
