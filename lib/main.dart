import 'package:flutter/material.dart';
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(const BloodDonorRegistrationApp());
}

class BloodDonorRegistrationApp extends StatelessWidget {
  const BloodDonorRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donor Registration',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      color: Colors.red,
     
      home: BloodDonorRegistrationForm(),
    );
  }
}

class BloodDonorRegistrationForm extends StatefulWidget {
  @override
  _BloodDonorRegistrationFormState createState() => _BloodDonorRegistrationFormState();
}

class _BloodDonorRegistrationFormState extends State<BloodDonorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _usn = '';
  String _email = '';
  int _age = 0;
  String _gender = '';
  String _bloodGroup = '';
  String _mobile = '';
  String _additionalMobile = '';
  String _address = '';
  String _pinCode = '';
  String _donatedBefore = '';
  int _numberOfDonations = 0;
  DateTime? _lastDateOfDonation;
  String _medicalCondition = '';
  String _drinkingOrSmoking = '';
  String _experience = '';
  File? _donationPhoto;
  bool _isSubmitting = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _yesNoOptions = ['Yes', 'No'];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _donationPhoto = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _lastDateOfDonation) {
      setState(() {
        _lastDateOfDonation = picked;
      });
    }
  }

  

  Widget _buildRadioButtonGroup(String title, List<String> options, String selectedOption, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedOption,
            onChanged: onChanged,
            activeColor: Color.fromARGB(255, 200, 56, 4),
          );
        }).toList(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved, String validatorText, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: validatorText,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (value!.isEmpty && validatorText.isNotEmpty) {
              return validatorText;
            }
            return null;
          },
          keyboardType: keyboardType,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donor Registration Form',style: TextStyle(color: Colors.red),),
         backgroundColor:Color.fromARGB(255, 79, 40, 180),
      ),
       body: Container(
        color: Color.fromARGB(255, 186, 241, 240), 
        child:Padding(
        
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Name of donor', (value) => _name = value!, 'Your answer'),
              _buildTextField('USN', (value) => _usn = value!, 'Your answer'),
              _buildTextField('Email ID', (value) => _email = value!, 'Your answer', keyboardType: TextInputType.emailAddress),
              _buildTextField('Donor Age', (value) => _age = int.parse(value!), 'Your answer', keyboardType: TextInputType.number),
              _buildRadioButtonGroup('Donor Gender', _genders, _gender, (value) => setState(() => _gender = value!)),
              _buildRadioButtonGroup('Donor Blood Group', _bloodGroups, _bloodGroup, (value) => setState(() => _bloodGroup = value!)),
              _buildTextField('Mobile Number', (value) => _mobile = value!, 'Your answer', keyboardType: TextInputType.phone),
              _buildTextField('Additional Mobile Number', (value) => _additionalMobile = value!, 'Your answer', keyboardType: TextInputType.phone),
              _buildTextField('Address', (value) => _address = value!, 'Your answer'),
              _buildTextField('Pin Code', (value) => _pinCode = value!, 'Your answer', keyboardType: TextInputType.number),
              _buildRadioButtonGroup('Have you donated before?', _yesNoOptions, _donatedBefore, (value) => setState(() => _donatedBefore = value!)),
              _buildTextField('Number of Donations', (value) => _numberOfDonations = int.parse(value!), 'Your answer', keyboardType: TextInputType.number),
              SizedBox(height: 16),
              Text(
                'Last Date of Donation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _lastDateOfDonation == null
                          ? 'Select Date'
                          : '${_lastDateOfDonation!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 151, 102, 4)),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildRadioButtonGroup('Are you under any medical condition?', _yesNoOptions, _medicalCondition, (value) => setState(() => _medicalCondition = value!)),
              _buildRadioButtonGroup('Do you drink or smoke?', _yesNoOptions, _drinkingOrSmoking, (value) => setState(() => _drinkingOrSmoking = value!)),
              _buildTextField('Write a few lines about your blood donation experience', (value) => _experience = value!, 'Your answer'),
              SizedBox(height: 16),
              Text(
                'Upload Blood donation photo (for activity points)',
                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _donationPhoto == null ? 'No file chosen' : 'File chosen',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.upload_file, color: Color.fromARGB(255, 165, 106, 4)),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              SizedBox(height: 20),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: ()=>{},
                      child: Text('Submit', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 50, 50),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

