//@dart=2.9
import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:rent_app/DialogBox/loadingDialog.dart';
import 'package:rent_app/HomeScreen.dart';
import 'package:rent_app/globalVar.dart';
import 'package:toast/toast.dart';
class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({Key key}) : super(key: key);

  @override
  _UploadAdScreenState createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {

  bool uploading = false, next = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  String imgFile="",imgFile1="",imgFile2="",imgFile3="";

  List<File> _image = [];
  List<String> urlsList = [];
  final picker = ImagePicker();

  FirebaseAuth auth = FirebaseAuth.instance;
  String userName = "";
  String userNumber="";
  String itemPrice="";
  String itemModel="";
  String description="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          next ? "Fill in item's description" : "Please upload your item's images",
          style: TextStyle(fontSize: 16.5, fontFamily: "Lobster", letterSpacing: 1.7),
        ),
        actions: [
          next ? Container() :
              ElevatedButton(
                  onPressed: (){
                    if(_image.length == 4){
                      setState(() {
                        uploading = true;
                        next = true;
                      });
                    }
                    else{
                      showToast(
                        "Please upload 4 images...",
                        duration: 2,
                        gravity: Toast.CENTER,
                      );
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "Varela"),
                  ),
              ),
        ],
      ),

      body: next ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Enter Your Name"),
                onChanged: (value){
                  this.userName = value;
                },
              ),
              SizedBox(height: 5.0),
              TextField(
                decoration: InputDecoration(hintText: "Enter Your Phone Number"),
                onChanged: (value){
                  this.userNumber = value;
                },
              ),
              SizedBox(height: 5.0),
              TextField(
                decoration: InputDecoration(hintText: "Enter Item's Name"),
                onChanged: (value){
                  this.itemModel = value;
                },
              ),
              SizedBox(height: 5.0),
              TextField(
                decoration: InputDecoration(hintText: "Enter Item's Price in Rupees"),
                onChanged: (value){
                  this.itemPrice = value;
                },
              ),
              SizedBox(height: 5.0),
              TextField(
                decoration: InputDecoration(hintText: "Enter Item's Description"),
                onChanged: (value){
                  this.description = value;
                },
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width*0.5,
                child: ElevatedButton(
                  onPressed: (){
                    showDialog(context: context, builder: (con){
                      return LoadingAlertDialog(message: "Uploading...",);
                    });
                    
                    uploadFile().whenComplete((){
                      Map<String,dynamic> adData ={
                        'userName': this.userName,
                        'uId': auth.currentUser.uid,
                        'userNumber': this.userNumber,
                        'itemPrice': this.itemPrice,
                        'itemModel': this.itemModel,
                        'description': this.description,
                        'urlImage1': urlsList[0].toString(),
                        'urlImage2': urlsList[1].toString(),
                        'urlImage3': urlsList[2].toString(),
                        'urlImage4': urlsList[3].toString(),
                        'imgPro': userImageUrl,
                        'lat': position.latitude,
                        'lng': position.longitude,
                        'address': completeAddress,
                        'time': DateTime.now(),
                        'status': "not approved",
                      };

                      FirebaseFirestore.instance.collection('items').add(adData).then((value){
                        print("Data added successfully.");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }).catchError((onError){
                        print(onError);
                      });
                    });
                  },

                  child: Text("Upload", style: TextStyle(color: Colors.white),),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ) : Stack(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            child: GridView.builder(
              itemCount: _image.length +1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
                ),
              itemBuilder: (context, index){
                return index == 0
                    ? Center(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      if(_image.length==4){
                        showToast(
                          "Maximum 4 images can be uploaded",
                          duration: 2,
                          gravity: Toast.CENTER,
                        );
                      }else{
                        if(!uploading){
                          chooseImage();
                        }
                      }
                    }),
                  ) : Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image[index-1]),
                      fit: BoxFit.cover
                    ),
                  ),
                );
              }),
          ),
          uploading ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    "uploading...",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  value: val,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )
              ],
            ),
          )
              :Container()
        ],
      ),
    );
  }

  chooseImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async{
    final LostData response = await picker.getLostData();
    if(response.isEmpty){return;}
    if (response.file != null){
      setState(() {
        _image.add(File(response.file.path));
      });
    }else{
      print(response.file);
    }
  }

  Future uploadFile() async{
    int i= 1;
    for(var img in _image){
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance.ref().child('image/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value){
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  void showToast(String msg, {int duration, int gravity}){
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageUrls');
  }
}
