import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class MissingPersonForm extends StatefulWidget {
  const MissingPersonForm({super.key});

  @override
  State<MissingPersonForm> createState() => _MissingPersonFormState();
}

class _MissingPersonFormState extends State<MissingPersonForm> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _lastSeenController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDateTime;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Add Missing Person Data",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.white70),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, "Full Name"),
            _buildTextField(_ageController, "Age",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 2),
            _buildDropdown(),
            _buildTextField(_lastSeenController, "Last Seen Location"),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: .4),
              ),
              child: ListTile(
                title: Text(
                  _selectedDateTime == null
                      ? "Select Date & Time Last Seen"
                      : "Last Seen: ${_selectedDateTime!.toLocal()}"
                          .split('.')[0],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onTap: () => _pickDateTime(context),
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(_contactController, "Contact Number",
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10),
            _buildTextField(_descriptionController, "Additional Details",
                maxLines: 4),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _validateAndSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        items: ["Male", "Female", "Others"].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        decoration: InputDecoration(
          labelText: "Select Gender",
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dropdownColor: Colors.black,
      ),
    );
  }

  void _validateAndSubmit() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _selectedGender == null ||
        _lastSeenController.text.isEmpty ||
        _contactController.text.length != 10) {
      _showErrorDialog("Please fill in all required fields correctly.");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Missing person report submitted successfully."),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
