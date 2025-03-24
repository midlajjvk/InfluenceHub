import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influencehub/brand/Home/profilepagebrand.dart';

class EditBrandProfilePage extends StatefulWidget {
  final String brandId;

  EditBrandProfilePage({required this.brandId, required userId});

  @override
  _EditBrandProfilePageState createState() => _EditBrandProfilePageState();
}

class _EditBrandProfilePageState extends State<EditBrandProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> brandDetails;

  bool isLoading = true;

  // Controllers for each field
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _yearStartedController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBrandDetails();
  }

  Future<void> fetchBrandDetails() async {
    try {
      print("Fetching brand details for ID: ${widget.brandId}");

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('brands')
          .doc(widget.brandId)
          .get();

      if (snapshot.exists) {
        print("Brand details found: ${snapshot.data()}");

        setState(() {
          var data = snapshot.data()!;
          _brandNameController.text = data['brandName'] ?? '';
          _websiteController.text = data['website'] ?? '';
          _yearStartedController.text = data['yearStarted']?.toString() ?? '';
          _categoryController.text = data['category'] ?? '';
          _extraDetailsController.text = data['extraDetails'] ?? '';
          isLoading = false;
        });
      } else {
        print("Brand details not found.");
        throw 'Brand details not found.';
      }
    } catch (e) {
      print("Error fetching brand details: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching brand details: $e')),
      );
      Navigator.pop(context);
    }
  }


  Future<void> updateBrandDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('brands').doc(widget.brandId).update({
          'brandName': _brandNameController.text.trim(),
          'website': _websiteController.text.trim(),
          'yearStarted': int.tryParse(_yearStartedController.text.trim()),
          'category': _categoryController.text.trim(),
          'extraDetails': _extraDetailsController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to the Brand Profile Page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BrandProfilePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating profile: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Edit Brand Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.purple[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: _brandNameController,
                    decoration: InputDecoration(labelText: 'Brand Name'),
                    validator: (value) => value!.isEmpty ? 'Enter brand name' : null,
                  ),
                  TextFormField(
                    controller: _websiteController,
                    decoration: InputDecoration(labelText: 'Website'),
                    validator: (value) => value!.isEmpty ? 'Enter website' : null,
                  ),
                  TextFormField(
                    controller: _yearStartedController,
                    decoration: InputDecoration(labelText: 'Year Started'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (value!.isEmpty || int.tryParse(value) == null) ? 'Enter valid year' : null,
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) => value!.isEmpty ? 'Enter category' : null,
                  ),
                  TextFormField(
                    controller: _extraDetailsController,
                    decoration: InputDecoration(labelText: 'Extra Details'),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 58.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: Size(70, 40)),
                      onPressed: updateBrandDetails,
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