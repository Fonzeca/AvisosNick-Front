import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nick_tecnologia_notices/manager/api_calls.dart';
import 'package:nick_tecnologia_notices/manager/login_in.dart';
import 'package:nick_tecnologia_notices/utilities/constants.dart';
import 'package:nick_tecnologia_notices/utilities/strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  Color colorTextLogin = Colors.black;

  final kHintTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'OpenSans',
      fontSize: 12
  );

  final kLabelStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans',
      fontSize: 12
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: nickAccentColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final ServidorRest _servidorRest = ServidorRest();

  String emailText = "";
  String passwordText = "";

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          sLabelEmail,
          style: kLabelStyle,
        ),
        SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            onChanged: (text) => emailText = text,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: sHintTextEmail,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          sLabelClave,
          style: kLabelStyle,
        ),
        SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            onChanged: (text) => passwordText = text,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: sHintTextClave,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          sLabelOlvidoContrasenia,
          style: kLabelStyle,
        ),
      ),
    );
  }
  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Theme.of(context).accentColor,
              activeColor: Colors.black26,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            sLabelRecuerdame,
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => signIn(3, context, emailText, passwordText),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          sBtnLogin,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  Widget _buildSignInWithText() {
    return Text(
      sLabelIniciarSesionConOtros,
      style: TextStyle(
        color: colorTextLogin,
        fontWeight: FontWeight.w400,
      ),
    );
  }
  Widget _buildSingularSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }
  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSingularSocialBtn(
            () {
              signIn(2, context);
            },
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSingularSocialBtn(
            (){
              signIn(1, context);
            },
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: sLabelNoTieneCuenta,
              style: TextStyle(
                color: colorTextLogin,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: sLabelRegistrese,
              style: TextStyle(
                color: colorTextLogin,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.show();
    _servidorRest.validateToken().then((value) {
      EasyLoading.dismiss();
      if(value){
        Navigator.of(context).pushReplacementNamed("/dashBoard");
      }
    }).catchError((e){
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: 25.0,
                  bottom: 60.0,
                  right: 30.0,
                  left: 30.0
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'NICK',
                      style: TextStyle(
                        fontFamily: 'NickMayus',
                        fontSize: 80
                      ),
                    ),
                    Text(
                      'TECNOLOGÍA',
                      style: TextStyle(
                        fontFamily: 'NickMin',
                        fontSize: 28
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 0,
                                      blurRadius: 7,
                                      offset: Offset(0,0)
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,top: 60, right: 20, bottom: 40),
                              child: Column(
                                children: <Widget>[
                                  _buildEmailTF(),
                                  SizedBox(height: 10.0,),
                                  _buildPasswordTF(),
                                  _buildForgotPasswordBtn(),
                                  //_buildRememberMeCheckbox(),
                                  _buildLoginBtn(),
                                  _buildSignInWithText(),
                                  _buildSocialBtnRow(),
                                  _buildSignupBtn()
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: ExactAssetImage('assets/logos/nick.png')
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(0,-5)
                              )
                            ]
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

}
