import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Report Details",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Minor harassed by 3 Locals",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "Jalukbari,",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Guwahati",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Date: ",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "25/02/2025",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Incident Details: ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "According to police sources, the victim was returning home from a coaching center when three men started harassing her. They allegedly passed lewd comments and attempted to intimidate her.\n The girl managed to escape and sought help from nearby commuters. Eyewitnesses reported that the accused appeared intoxicated. She was visibly shaken and ran towards the main road asking for help, said a local shopkeeper. The men fled the scene when people intervened."),
              Text('data')
            ],
          ),
        ),
      ),
    );
  }
}
