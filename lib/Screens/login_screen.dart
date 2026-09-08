import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4D7DED),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Habitt', style: TextStyle(
              fontSize: 40,
             fontWeight: FontWeight.bold,
             color: Colors.white 
            ),),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: 'Email',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: 'Password',
                  alignLabelWithHint: true,
                prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 35),
                child: GestureDetector(
                  child: Text('Forgot Password?', style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(190,40)),
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 54, 113, 250)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
            
                onPressed: () async {
                  try{
                    await Provider.of<AuthProvider>(context, listen: false).Login(
                      _emailController.text.trim(), _passwordController.text);
                     Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()))
                    );
                  }
                
                 
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.center,
              child: Text('OR', style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(height: 15,),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ButtonStyle(
                   minimumSize: MaterialStateProperty.all<Size>(Size(190,40)),
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 8, 39, 109)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Register'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}