import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shugo/screens/missing_person_form.dart';
import 'package:shugo/screens/report_form.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Emergency Report",
          style: TextStyle(fontSize: 22, color: Colors.green),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              PageCard(
                iconData: Icons.assignment_add,
                title: "Report a Crime",
                description:
                    "File a detailed report about a crime incident or suspicious activity.",
                onTap: () {
                  Get.to(() => ReportFormScreen());
                },
              ),
              const SizedBox(height: 30),
              PageCard(
                iconData: Icons.person_add,
                title: "Report Missing Person",
                description:
                    "Submit information about a missing person to help locate them.",
                onTap: () {
                  Get.to(() => const MissingPersonForm());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageCard extends StatefulWidget {
  const PageCard({
    super.key,
    required this.iconData,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData iconData;
  final String title, description;
  final VoidCallback onTap;

  @override
  _PageCardState createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 253, 203, 203),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    widget.iconData,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
