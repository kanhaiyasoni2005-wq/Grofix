
import 'package:flutter/material.dart';
import 'package:grofix/data/ViewModel.dart';
import 'package:grofix/repository/screens/account/adress.dart';
import 'package:provider/provider.dart';

class userProfile extends StatefulWidget{
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      Provider.of<Viewmodel>(context, listen:  false).fatchAdress();
    });
  }
  @override
Widget build(BuildContext context) {
  var vm = Provider.of<Viewmodel>(context);
    
    
    return Scaffold(
body: Column(
  children: [

    Expanded(
      child: Consumer<Viewmodel>(
        builder: (context, vm, child) {

          if (vm.userData.isEmpty) {
            return Center(
              child: Text(
                "No Address Found",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: vm.userData.length,
            itemBuilder: (context, index) {

              var data = vm.userData[index];

              bool isSelected = vm.selectedAddress == data;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [

                    // ================= ICON =================
                    Icon(
                      Icons.location_on,
                      color: isSelected ? Colors.green : Colors.grey,
                    ),

                    SizedBox(width: 10),

                    // ================= DETAILS =================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            data["name"]?.toString() ?? "No Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            data["phone"]?.toString() ?? "",
                            style: TextStyle(color: Colors.grey),
                          ),

                          Text(
                            data["Address"]?.toString() ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),

                    // ================= ACTIONS =================
                    Column(
                      children: [

                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            vm.selectAddress(data);
                            Navigator.pop(context);
                          },
                        ),

                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Address"),
                                content: Text(
                                  "Are you sure you want to delete this address?",
                                ),
                                actions: [

                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      vm.deleteAddress(data["id"]);
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ),

    // ================= ADD BUTTON =================
    Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Adress()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add New Address",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
)
    );
  
  }
}


