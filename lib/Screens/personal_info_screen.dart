import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  
  
  int _seletedAge = 25;
  final int maxage  = 100;
  final int minage = 7;
  String? _selectedCountry;
  final List<String> _countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 
    'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 
    'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 
    'Bhutan', 'Bolivia', 'Brazil', 'Canada', 'China', 'Egypt', 'France', 
    'Germany', 'India', 'Indonesia', 'Italy', 'Japan', 'Mexico', 'Pakistan', 
    'Saudi Arabia', 'South Africa', 'Spain', 'United Kingdom', 'United States'
  ];

  TextEditingController username = TextEditingController();
 
   @override
    void initState(){
     super.initState();
     final authprovider = context.read<AuthProvider>();
     _seletedAge = authprovider.age ?? 25;
     _selectedCountry = authprovider.country;
     username.text = authprovider.username ?? '';
    
    }

  @override
  void dispose() {
    username.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4D7DED),
        centerTitle: true,
        title: Text('Personal Info' , style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: username,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15,),
            Align(
              alignment: Alignment.center,
              child: Text(' AGE : $_seletedAge', style: TextStyle( fontSize: 30),)),
            const SizedBox(height: 10,),
            SliderTheme(data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.indigo,
                  inactiveTrackColor: Colors.black.withOpacity(0.3),
                  thumbColor: Colors.white70,
                  overlayColor: Colors.blueAccent.withOpacity(0.2),
                  valueIndicatorColor: Colors.lightBlue,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ), child: Slider( 
              activeColor: Colors.blueAccent,
                thumbColor: Colors.white,
                min: minage.toDouble(),
                max: maxage.toDouble(),
                divisions: maxage - minage,
              value: _seletedAge.toDouble(), onChanged: (value) {
              setState(() {
                _seletedAge = value.toInt();
              });
            })),
            const SizedBox(height: 15,),
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
        
            const SizedBox(height: 20,),
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
                    await context.read<AuthProvider>().updatePersonalInfo(username.text.trim(), _selectedCountry ?? '', _seletedAge);
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated')));
                  } , 
                  child:Text('Save Changes', style: TextStyle(
                  color: Colors.white
                )
                )
                )
            )
            )
        
        
        
          ],
        ),
      ),
    );
  }
}