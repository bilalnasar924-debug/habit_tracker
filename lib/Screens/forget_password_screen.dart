import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4D7DED),
        centerTitle: true,
        title: Text('Reset Password' , style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter Email To Reset Password'),
              const SizedBox(height: 25,),
               Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                controller:emailController ,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: 'Email',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ButtonStyle(
                   minimumSize: MaterialStateProperty.all<Size>(Size(190,40)),
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 8, 39, 109)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed:authProvider.isLoading ? null: () async {
                  try{
                    await authProvider.forgetPassword(emailController.text.trim());
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email has been sent'), backgroundColor: Colors.green,));
                  }catch(e){
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red,));
                  }
                 
                },
                child:authProvider.isLoading
                    ? const CircularProgressIndicator(): const Text('Send Email'),
              ),
            ),

              
          
            ],
          ),
        ),
      ),
    );
  }
}