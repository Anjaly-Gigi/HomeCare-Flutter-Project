import 'package:flutter/material.dart';
import 'package:serviceprovider/screen/changepass.dart';
import 'package:serviceprovider/screen/editprofile.dart';
import 'package:serviceprovider/screen/requestview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_colors/awesome_colors.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isLoading = true;
  Map<String, dynamic> spdetails = {};
  final supabase = Supabase.instance.client;
  final Color primaryColor = const Color.fromRGBO(29, 51, 74, 1);
  final Color accentColor = const Color.fromARGB(255, 86, 130, 3);
  final Color backgroundColor = Whites.signalWhite;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from("tbl_sp")
          .select("*,tbl_place(*,tbl_district(*))")
          .eq("id", supabase.auth.currentUser!.id)
          .single();
      print("Fetched data: $response");
      setState(() {
        spdetails = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:backgroundColor,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(29, 51, 74, 1),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Overview Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: spdetails['sp_photo'] != null
                                ? NetworkImage(spdetails['sp_photo'])
                                : null,
                            backgroundColor: primaryColor,
                            child: spdetails['sp_photo'] == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome, ${spdetails['sp_name'] ?? "Service Provider"}!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            spdetails['sp_description'] ??
                                'Providing quality services with excellence.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Details and Actions Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Account",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.deepOrange,
                            thickness: 2,
                            endIndent: 200,
                          ),
                          const SizedBox(height: 10),
                          InfoRow(
                            label: "Name",
                            value: spdetails["sp_name"] ?? "No name",
                          ),
                          InfoRow(
                            label: "Address",
                            value: spdetails["sp_address"] ?? "No address",
                          ),
                          InfoRow(
                            label: "Email",
                            value: spdetails["sp_email"] ?? "No email",
                          ),
                          InfoRow(
                            label: "Phone",
                            value: spdetails["sp_contact"] ?? "No contact",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => Editpro()));
                                  // Handle Edit Profile
                                },
                                
                                child: const Text("Edit Profile"),
                              ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder: (context) => Requestview()));
                        // Handle View Requests
                      },
                      child: const Text("View Requests"),
                    ),
                              
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => passwordChange()));
                                  // Handle Change Password
                                },
                                child: const Text("Change Password"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}