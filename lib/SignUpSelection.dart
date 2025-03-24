import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencehub/brand/SignUpBrand/SignupDetails.dart';
import 'brand/SignUpBrand/SignupBrand.dart';
import 'influencer/SignUp/SignUpInfluencer.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shakehand.jpg"),
                fit: BoxFit.cover)),
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SignUp as",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> InfluencerSignUp()));
                  },
                  child: Text(
                    "Influencer",
                    style: TextStyle(color: Colors.white,fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blueGrey)),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SaveDataPage()));
                  },
                  child: Text("    Brand    ",
                      style: TextStyle(color: Colors.white,fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blueGrey)),
            ],
          ),
        )),
      ),
    );
  }
}

