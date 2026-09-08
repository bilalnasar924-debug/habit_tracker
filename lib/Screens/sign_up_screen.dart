import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:provider/provider.dart' show Provider;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final int minAge = 7;
  final int maxAge = 100;
   int _selectedAge = 7;
  String? _selectedCountry;
    final List<String> _countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 
    'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 
    'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 
    'Bhutan', 'Bolivia', 'Brazil', 'Canada', 'China', 'Egypt', 'France', 
    'Germany', 'India', 'Indonesia', 'Italy', 'Japan', 'Mexico', 'Pakistan', 
    'Saudi Arabia', 'South Africa', 'Spain', 'United Kingdom', 'United States'
  ];
  final List<String> _habits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude'
  ];
  
  final List<String> _selectedHabits = [];

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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        backgroundColor: Color(0xff4D7DED),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
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
            SizedBox(height: 20,),
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
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Age : $_selectedAge', style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SizedBox(height: 10,),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
                thumbColor: Colors.white,
                overlayColor: Colors.white.withOpacity(0.2),
                valueIndicatorColor: Colors.white,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                activeColor: Colors.white,
                thumbColor: Colors.white,
                value: _selectedAge.toDouble(),
                min: minAge.toDouble(),
                max: maxAge.toDouble(),
                divisions: maxAge - minAge,
                label: '$_selectedAge',
                onChanged: (double value) {
                  setState(() {
                    _selectedAge = value.toInt();   
                  });
                },
              ),
            ),
            SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 35),
            child: DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: 'Select Country',
                alignLabelWithHint: true,
              ),
              items: _countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              },
            )
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Your Habits', style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: _habits.map((habit){
                  final isSelected = _selectedHabits.contains(habit);
                  return ChoiceChip(label: Text(habit), selected: isSelected,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xff4D7DED),
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 1.5
                    )
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: const Color.fromARGB(255, 68, 114, 213),
                  showCheckmark: false,
                  onSelected: (bool selected){
                    setState(() {
                      if(selected){
                        _selectedHabits.add(habit);
                      }else{
                    _selectedHabits.remove(habit);
                      }
                    });
                  },
                  );
                }).toList(),
              ),
            ),
            ),
            SizedBox(height: 25,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(190,40)),
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 54, 113, 250)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () async {
                  try{
                    await Provider.of<AuthProvider>(context, listen : false).signUp(
                      _emailController.text.trim(), _passwordController.text, _selectedAge, _selectedCountry ?? '', _selectedHabits);
                    if(!mounted) return ;
                     Navigator.pushReplacementNamed(context, '/home');
                  }catch(e){
                     if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                 
                }, child: Text('Register', style: TextStyle(
                color: Colors.white
              ),)),),
            )
          ]
          ),
        ),
      ),
    );
  }
}