import 'package:flutter/material.dart';
import 'package:data_siswa/components/my_button.dart';
import 'package:flutter/gestures.dart';
import 'package:data_siswa/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:email_validator/email_validator.dart";
import 'package:data_siswa/main.dart';
import 'package:data_siswa/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.onClickSignIn}) : super(key: key);
  final VoidCallback onClickSignIn;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const SquareTile(imagePath: 'lib/images/school.png'),
                const SizedBox(height: 15),
                const Text(
                  'DAFTAR',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade600),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  validator: (email) =>
                      (email != null && !EmailValidator.validate(email))
                          ? 'Masukkan Email yang benar'
                          : null,
                ),
                const SizedBox(height: 10),
                // password textfield
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade600),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Kata Sandi',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  validator: (value) => (value != null && value.length < 6)
                      ? 'Masukkan minimal 6 karakter'
                      : null,
                ),
                const SizedBox(height: 20),
                //  sign in button
                MyButton(
                  onTap: signUpUser,
                  hint: 'Daftar',
                ),
                const SizedBox(height: 24),
                RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        text: 'Sudah Punya Akun?  ',
                        children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickSignIn,
                          text: 'Masuk',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary))
                    ]))
              ],
            ),
          )));
  Future signUpUser() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      e;
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
