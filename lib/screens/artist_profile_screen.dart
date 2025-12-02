import 'package:flutter/material.dart';

class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cover Image & Profile Picture
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF001F3F), Color(0xFF003366)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.camera_alt, color: Colors.white54, size: 40),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(Icons.person, size: 50, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Edit Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Professional Musician',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF001F3F),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Bio Section
                _buildSection(
                  'Bio',
                  'Passionate musician with 10+ years of experience in classical and contemporary music. Specialized in live performances and studio recordings.',
                ),
                
                // Genres/Skills
                _buildSection(
                  'Genres & Skills',
                  null,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Classical', 'Jazz', 'Pop', 'Guitar', 'Piano']
                        .map((skill) => Chip(
                              label: Text(skill),
                              backgroundColor: Color(0xFF001F3F).withOpacity(0.1),
                              labelStyle: TextStyle(color: Color(0xFF001F3F)),
                            ))
                        .toList(),
                  ),
                ),
                
                // Pricing
                _buildSection(
                  'Pricing',
                  '₹5,000 per hour\n₹25,000 per event',
                ),
                
                // Gallery Section
                _buildSection(
                  'Gallery',
                  null,
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              index % 2 == 0 ? Icons.photo : Icons.videocam,
                              color: Colors.grey.shade500,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add Media'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF001F3F),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String? content, {Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (content != null)
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        if (child != null) child,
        const SizedBox(height: 24),
      ],
    );
  }
}