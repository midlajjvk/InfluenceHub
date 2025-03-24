import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeInfluencer.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> userDetails;
  bool isLoading = true;

  // Controllers for each field
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          userDetails = snapshot.data()!;
          _fullNameController.text = userDetails['fullName'] ?? '';
          _ageController.text = userDetails['age']?.toString() ?? '';
          _genderController.text = userDetails['gender'] ?? '';
          _pincodeController.text = userDetails['pincode'] ?? '';
          _locationController.text = userDetails['location'] ?? '';
          _whatsappController.text = userDetails['whatsapp'] ?? '';
          _categoryController.text = userDetails['category'] ?? '';
          isLoading = false;
        });
      } else {
        throw 'User details not found.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'fullName': _fullNameController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'gender': _genderController.text.trim(),
          'pincode': _pincodeController.text.trim(),
          'location': _locationController.text.trim(),
          'whatsapp': _whatsappController.text.trim(),
          'category': _categoryController.text.trim(),
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully.')),
        );

        // Navigate to HomeUser page with updated details
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeUser(
              name: _fullNameController.text.trim(),
              userId: widget.userId,
            ),
          ),
        );
      } catch (e) {
        // Show an error message if the update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,iconTheme: IconThemeData(color: Colors.white),
        title: Text('Edit your Profile',style: TextStyle(color: Colors.white),),
        
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.purple[100]),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age.';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Age must be a number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _genderController,
                    decoration: InputDecoration(labelText: 'Gender'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gender.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: InputDecoration(labelText: 'Pincode'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pincode.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _whatsappController,
                    decoration: InputDecoration(labelText: 'WhatsApp'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your WhatsApp number.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your category.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 58.0 ,right: 58),
                    child: ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: Size(70, 40)),
                      onPressed: updateUserDetails,
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
