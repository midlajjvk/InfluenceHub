import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Home/BrandHome.dart';

class SignupDetails extends StatefulWidget {
  final String brandId;

  SignupDetails({required this.brandId});

  @override
  _SignupDetailsState createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _famousForController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> imageList = [
    'assets/images/puma.png',
    'assets/images/nike.png',
    'assets/images/adidas.png',
  ];

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String brandName = _brandNameController.text;
        String productName = _productNameController.text;

        await FirebaseFirestore.instance
            .collection('brands')
            .doc(widget.brandId)
            .set({
          'brandName': brandName,
          'productName': productName,
          'website':
              _websiteController.text.isEmpty ? null : _websiteController.text,
          'yearStarted': int.tryParse(_yearController.text) ?? null,
          'category': _famousForController.text,
          'amount': _amountController.text,
          'extraDetails': _extraDetailsController.text.isEmpty
              ? null
              : _extraDetailsController.text,
          'createdAt': FieldValue.serverTimestamp(),
          'userType': 'Brand'
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brand details saved successfully!')),
        );

        print('Brand details saved successfully for UID: ${widget.brandId}');

        Get.off(
          () => BrandHomePage(brandId: widget.brandId, name: brandName),
        );
      } catch (e) {
        print('Error saving brand details: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving details. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Product Here..",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              scrollDirection: Axis.vertical,
              height: double.infinity,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 300),
              autoPlayCurve: Curves.ease,
            ),
            items: imageList.map((image) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _brandNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Brand Name',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Brand name is required' : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _productNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Product Name',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Brand name is required' : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _websiteController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Website (Optional)',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _yearController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Brand Started Year',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Year is required';
                          } else if (int.tryParse(value) == null ||
                              int.parse(value) < 1800 ||
                              int.parse(value) > DateTime.now().year) {
                            return 'Enter a valid year';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _famousForController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Brand Category',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'This field is required' : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _amountController,
                        keyboardType: TextInputType
                            .number, // Ensures only numbers are entered
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor:
                              Colors.white.withOpacity(0.1), // Light background
                          labelText: 'Collaboration Budget ',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Enter the budget for influencer marketing',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the budget amount';
                          } else if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _extraDetailsController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Extra Details',
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
