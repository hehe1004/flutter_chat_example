import 'package:chat_example/add_image/add_image.dart';
import 'package:chat_example/config/palette.dart';
import 'package:chat_example/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  //사용자 등록과 인증에 사용. 이메일과 사용자 인증 등록할수잇는 메소드 사용 가능.

  bool isSignupScreen = true;
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  File? userPickedImage;

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context) {
    //팝업이 되면 위젯트리에 삽입되야함으로 인자값으로 BuildContext context

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white, child: AddImage(pickedImage));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          //마우스 바탕 선택시 키보드 사라짐
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/red.jpg'), fit: BoxFit.fill),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 90, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'welcome',
                                style: TextStyle(
                                    letterSpacing: 1.0,
                                    fontSize: 25,
                                    color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: isSignupScreen
                                        ? ' to Yummy Chat'
                                        : ' back',
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            isSignupScreen
                                ? 'sign up to continue'
                                : 'Sign in to continue',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              //배경
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen ? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5)
                      ]),
                  child: SingleChildScrollView(
                    //스크롤
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (!isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'SIGNUP',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: isSignupScreen
                                                ? Palette.activeColor
                                                : Palette.textColor1),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      if (isSignupScreen)
                                        GestureDetector(
                                          onTap: () {
                                            showAlert(context);
                                          },
                                          child: Icon(
                                            Icons.image,
                                            color: isSignupScreen
                                                ? Colors.cyan
                                                : Colors.grey[300],
                                          ),
                                        )
                                    ],
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 3, 35, 0),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey(1),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return 'please enter at leaset 4 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    onChanged: (value) {
                                      userName = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      hintText: 'User name',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey(2),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'please enter at valid email adress';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: ValueKey(3),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return 'please enter at least 7 characters long';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey(4),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return 'please enter at leaset 4 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      hintText: 'User name',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: ValueKey(5),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return 'please enter at least 7 characters long';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0))),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              //텍스트 폼 필드
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? 430 : 390,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (isSignupScreen) {
                          if (userPickedImage == null) {
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please pick your image'),
                              backgroundColor: Colors.blue,
                            ));
                          }
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                                    email: userEmail, password: userPassword);

                            final refImage = FirebaseStorage.instance
                                .ref()
                                .child('picked_image')
                                .child(newUser.user!.uid + '.png');
                            //클라우스 스토리지 경로에 접근할수 있게 역할
                            //ref() 매소드는 하나의 클라우드 버킷 스토리지를 참조 하고있음.

                           await refImage.putFile(userPickedImage!);
                           final url = await refImage.getDownloadURL();


                            //user id 등록
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(newUser.user!.uid)
                                .set(
                              {
                                'userName': userName,
                                'email': userEmail,
                                'picked_image': url,
                              },
                            );

                            if (newUser.user != null) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) {
                              //     return ChatScreen();
                              //   }),
                              // );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            print(e);
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'please check your email and password'),
                                backgroundColor: Colors.blue,
                              ));
                            }
                          }
                        }
                        try {
                          if (!isSignupScreen) {
                            _tryValidation();
                            final newUser = await _authentication
                                .signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            if (newUser.user != null) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return ChatScreen();
                              //     },
                              //   ),
                              // );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          print(e);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.red],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //전송버튼
              AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  top: isSignupScreen
                      ? MediaQuery.of(context).size.height - 145
                      : MediaQuery.of(context).size.height - 165,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(
                          isSignupScreen ? 'or signup with' : 'or signin with'),
                      TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: Size(155, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Palette.googleColor),
                        icon: Icon(Icons.add),
                        label: Text('google'),
                      ),
                    ],
                  ))
              //구글로그인
            ],
          ),
        ),
      ),
    );
  }
}
