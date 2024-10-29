import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediapp/consts/consts.dart';
import 'package:mediapp/controlers/auth_controller.dart';
// import 'package:mediapp/views/appointment_view/appointment_view.dart';
import 'package:mediapp/views/home_view/home.dart';
import 'package:mediapp/views/signup_view/signup_view.dart';
import 'package:mediapp/views/forgot_pass_outside/fogot_pass_outside.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediapp/views/welcome_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mediapp/views/doc_view.dart';

String? _validateEmail(value) {
  if (value!.isEmpty) {
    return 'Please enter an email';
  }
  RegExp emailRegex = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var isDoctor = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(() => WelcomeScreen());
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please log in to continue.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'EMAIL',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                        ),
                        controller: controller.passwordController,
                        obscureText: !_isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (password) => password!.length < 6
                            ? 'Password should be at least 6 characters'
                            : null,
                      ),
                      SizedBox(height: 20),
                      SwitchListTile(
                        value: isDoctor,
                        onChanged: (newValue) {
                          setState(() {
                            isDoctor = newValue;
                          });
                        },
                        title: Text(
                          'Log in as Doctor',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            Get.to(() => const PasswordResetPage());
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          final email = controller.emailController.text.trim();
                          final password =
                              controller.passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please enter a valid email and password',
                            );
                            return;
                          }

                          try {
                            await controller.loginUser(
                              email: email,
                              password: password,
                            );

                            if (controller.userCredential != null) {
                              if (isDoctor) {
                                Get.to(() => const DocView());
                              } else {
                                Get.to(() => const Home());
                              }
                              VxToast.show(context, msg: "Login Successful");
                            } else {
                              VxToast.show(context,
                                  msg: "Login Failed! Check the details");
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage;
                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage = 'No user found for that email.';
                                break;
                              case 'wrong-password':
                                errorMessage =
                                    'Wrong password provided for that user.';
                                break;
                              default:
                                errorMessage =
                                    'Incorrect Details Please try again.';
                            }
                            Get.snackbar(
                              'Error',
                              errorMessage,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'An unexpected error occurred. Please try again.',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                              EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const SignupView());
                            },
                            child: Text(
                              ' Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
