import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shugo/screens/report_details.dart';
import 'package:get/get.dart';
import '../constants/constant_data.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int _visibleItemCount = 2;

  void _showMoreItems() {
    setState(() {
      _visibleItemCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0XFF1A1A1A).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 8,
                  left: 10,
                  child: Icon(Icons.warning, size: 30, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "You are entering a high-crime area.\nPlease stay alert and take precautions.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Past crime records :",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _visibleItemCount.clamp(0, crimeDetails.length),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final crimeData = crimeDetails[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ReportCard(
                      crime: crimeData['Crime'] ?? "Unknown Crime",
                      location: crimeData['location'] ?? "Unknown Location",
                      date: crimeData['date'] ?? "Unknown Date",
                      image: crimeData['image'] ?? "assets/images/default.png",
                    ),
                  );
                },
              ),
              if (_visibleItemCount < crimeDetails.length)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _showMoreItems,
                    child: const Text(
                      "Show More",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.crime,
    required this.image,
    required this.date,
    required this.location,
  });

  final String crime, image, date, location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 18, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          "Date: $date",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DottedLine(dashColor: Colors.white),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.green),
                  const SizedBox(width: 6),
                  const Text(
                    "Location:",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => ReportDetailScreen());
                    },
                    child: const Text(
                      "View Details",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const Icon(Icons.arrow_forward,
                      size: 18, color: Colors.green),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
