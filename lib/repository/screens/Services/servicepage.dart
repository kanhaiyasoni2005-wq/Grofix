import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/repository/widgets/Document_detail.dart';
import 'package:grofix/repository/widgets/userdata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


class ServiceFormScreen extends StatefulWidget {
  final String categoryName;

  const ServiceFormScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<ServiceFormScreen> createState() =>
      _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      Provider.of<Viewmodel>(context, listen:  false).fatchAdress();
      loadServices();
      
    });
  }


  Future<Position> getLocation() async {

  // 🔴 Check service ON है या नहीं
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location service is OFF");
  }

  // 🔴 Permission check
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Permission permanently denied");
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
  
  

  bool isLoading = false;
  bool isPickingImage = false;
bool isPickingPDF = false;

  File? selectedImage;
  String selectedService = "";

  TextEditingController descriptionController = TextEditingController();
  

  List<String> services = [];

  String? pdfName;
  String? pdfPath;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  void loadServices() {
    switch (widget.categoryName) {
      case "CSC Service":
        services = [ "Samagra ID", "Mool Niwasi", "Online Form","Printing", "Other CSC Services"];
        break;
      case "Electrician":
        services = ["Fan Repair", "Wiring", "Switch Repair","other electrician services"];
        break;
      case "Plumber":
        services = ["Leak Fix", "Pipe Install", "Tap Repair","other plumber services"];
        break;
      case "AC Service":
        services = ["AC Repair", "Gas Filling", "Cleaning", "other AC services"];
        break;
      default:
        services = ["General Service"];
    }
    setState(() {});
  }

  // 📸 Image Picker
  Future pickImage() async {

  if (isPickingImage) return; // 🔥 double click रोकने के लिए

  isPickingImage = true;

  try {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path); // 🔥 replace old image
      });
    }

  } catch (e) {
    print("Image Error: $e");
  }

  isPickingImage = false;
}

  // 📄 PDF Picker
  Future pickPDF() async {

  if (isPickingPDF) return;

  isPickingPDF = true;

  try {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfPath = result.files.single.path; // 🔥 replace old pdf
        pdfName = result.files.single.name;
      });
    }

  } catch (e) {
    print("PDF Error: $e");
  }

  isPickingPDF = false;
}

  // 🔥 IMAGE UPLOAD (USER-WISE)
  Future<String> uploadImage(File file) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = _storage
        .ref()
        .child("users/$userId/images/$fileName");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  // 🔥 PDF UPLOAD (USER-WISE)
  Future<String> uploadPDF(String path) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    File file = File(path);

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = _storage
        .ref()
        .child("users/$userId/pdfs/$fileName.pdf");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  // 🔥 SAVE BOOKING (USER-WISE)
  Future saveBooking() async {

    Position pos = await getLocation();

double lat = pos.latitude;
double lng = pos.longitude;


  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    String userId = user.uid;

    String imageUrl = "";
    String pdfUrl = "";

    if (selectedImage != null) {
      imageUrl = await uploadImage(selectedImage!);
    }

    if (widget.categoryName == "CSC Service" && pdfPath != null) {
      pdfUrl = await uploadPDF(pdfPath!);
    }
    var vm = Provider.of<Viewmodel>(context, listen: false);



    await _firestore
    .collection("bookings")
    .add({
  "category": widget.categoryName,
  "service": selectedService,
  "description": descriptionController.text,

  "address": {
    "name": vm.selectedAddress!["name"],
    "phone": vm.selectedAddress!["phone"],
    "Address": vm.selectedAddress!["Address"],
  },

  // 🔥 ADD THIS
  "latitude": lat,
"longitude": lng,

  "image": imageUrl,
  "pdf": pdfUrl,
  "createdAt": DateTime.now(),
  'userId': userId,
});

    // ✅ 🔥 YAHAN ADD KARO (reset form)
    setState(() {
      selectedImage = null;
      pdfPath = null;
      pdfName = null;
      selectedService = "";
      descriptionController.clear();
      // addressController.clear();
    });

  } catch (e) {
    print("Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.categoryName),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            GestureDetector(
  onTap: isPickingImage ? null : pickImage,
  child: Stack(
    children: [
      Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedImage == null
            ? Center(child: Text("Upload Image"))
            : Image.file(selectedImage!, fit: BoxFit.cover),
      ),

      // 🔁 CHANGE BUTTON
      if (selectedImage != null)
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ),
    ],
  ),
),

            // PDF
            if (widget.categoryName == "CSC Service") ...[
              SizedBox(height: 15),
              Text("Upload PDF", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GestureDetector(
  onTap: isPickingPDF ? null : pickPDF,
  child: Container(
    height: 100,
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: pdfName == null
          ? Text("Upload required Documents (PDF)")
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(pdfName!),
                SizedBox(height: 5),
                Text(
                  "Change PDF",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
    ),
  ),
),
SizedBox(height: 10),

Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DocumentDetail()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please wait..")),
      );
    },
    child: Text("Document details?"),
  ),
),
            ],
            

            SizedBox(height: 15),

            // SERVICES
            Wrap(
              spacing: 10,
              children: services.map((service) {
                return ChoiceChip(
                  label: Text(service),
                  selected: selectedService == service,
                  onSelected: (val) {
                    setState(() {
                      selectedService = service;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 15),

            // DESCRIPTION
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Describe your required service",
                border: OutlineInputBorder(),
              ),
            ),

SizedBox(height: 15),

// ADDRESS
Consumer<Viewmodel>(
  builder: (context, vm, _) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.12),
          blurRadius: 8,
          offset: Offset(0, 3),
        )
      ],
    ),
    child: vm.selectedAddress == null
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_off, color: Colors.grey),
                SizedBox(width: 8),
                Text("No address selected"),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => userProfile()),
                );
              },
              child: Text("Add"),
            )
          ],
        )
      : Row(
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.selectedAddress!["name"] ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(vm.selectedAddress?["phone"]?.toString() ?? ""),
                  Text(
                    vm.selectedAddress!["Address"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => userProfile()),
                );
              },
              child: Text("Change"),
            ),
          ],
        ),
  ),
),

    SizedBox(height: 20),

            // BUTTON
            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: isLoading ? null : () async {

      if (selectedService.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Select a service")),
        );
        return;
      }

      if (widget.categoryName == "CSC Service" && pdfPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload PDF")),
        );
        return;
      }

      setState(() => isLoading = true);

      await saveBooking();

      setState(() => isLoading = false);

      // ✅ SUCCESS DIALOG
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success 🎉"),
          content: Text("Your booking has been submitted"),
          actions: [
            TextButton(
              onPressed: () {
                var vm = Provider.of<Viewmodel>(context, listen: false);

if (vm.selectedAddress == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Please select address"))
  );
  return;
}
                Navigator.pop(context); // dialog close
                Navigator.pop(context); // screen back
              },
              child: Text("OK"),
            )
          ],
        ),
      );
    },
    child: isLoading
        ? CircularProgressIndicator(color: Colors.white)
        : Text("Book Now"),
  ),
)
          ],
        ),
      ),
    );
  }
}


