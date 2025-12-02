import 'package:flutter/material.dart';

class ArtistFillProfileScreen extends StatefulWidget {
  const ArtistFillProfileScreen({super.key});

  @override
  State<ArtistFillProfileScreen> createState() => _ArtistFillProfileScreenState();
}

class _ArtistFillProfileScreenState extends State<ArtistFillProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  
  String? _selectedGenre;
  final List<String> _genres = [
    'Classical',
    'Rock',
    'Pop',
    'Jazz',
    'Hip Hop',
    'Electronic',
    'Folk',
    'Country',
    'R&B',
    'Reggae',
    'Blues',
    'Metal',
  ];

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
           _bioController.text.isNotEmpty &&
           _selectedGenre != null;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _bioController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fill Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo upload functionality')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001F3F),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Name Field
            _buildLabel('Name', true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hintText: 'Enter your full name',
            ),
            const SizedBox(height: 24),
            
            // Bio Field
            _buildLabel('Bio', true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _bioController,
              hintText: 'Tell us about yourself and your musical journey...',
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            
            // Genre Selection
            _buildLabel('Genre', true),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGenre,
                  hint: Text(
                    'Select your music genre',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  isExpanded: true,
                  items: _genres.map((genre) {
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGenre = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pricing Field (Optional)
            _buildLabel('Pricing per Hour', false),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _pricingController,
              hintText: 'Enter your rate (optional)',
              keyboardType: TextInputType.number,
              prefixText: '₹ ',
            ),
            const SizedBox(height: 40),
            
            // Create Profile Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile created successfully!')),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? const Color(0xFF001F3F) : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isRequired) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF001F3F), width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _pricingController.dispose();
    super.dispose();
  }
}