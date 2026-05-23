
import 'package:flutter/material.dart';
import 'package:grofix/User/user.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:provider/provider.dart';

class Adress extends StatefulWidget {
  const Adress({super.key});

  @override
  State<Adress> createState() => _AdressState();
}

class _AdressState extends State<Adress> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Address",
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // ================= NAME =================
                _buildField(
                  controller: nameController,
                  hint: "Enter your Name",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15),

                // ================= PHONE =================
                _buildField(
                  controller: phoneController,
                  hint: "Enter your Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }

                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Only numbers allowed";
                    }

                    if (value.length != 10) {
                      return "Phone must be 10 digits";
                    }

                    return null;
                  },
                ),

                SizedBox(height: 15),

                // ================= ADDRESS =================
                _buildField(
                  controller: addressController,
                  hint: "Enter your Address",
                  icon: Icons.location_on,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                // ================= SAVE BUTTON =================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await saveuserDetails(
                            name: nameController.text.trim(),
                            phoneno: phoneController.text.trim(),
                            adress: addressController.text.trim(),
                          );

                          if (context.mounted) {
                            context.read<Viewmodel>().fatchAdress();
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Address save failed: ${e.toString()}",
                              ),
                            ),
                          );
                        }
                      }
                    },

                    child: Text(
                      "Save Address",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CUSTOM INPUT FIELD =================
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}


