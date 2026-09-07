import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
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
                controller: emailController,
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
            
                onPressed: () {
                  // Handle login logic here
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