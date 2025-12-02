import 'package:flutter/material.dart';
import 'dart:math';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = false;
  String _lastScannedCode = '';
  bool _isAdmin = true; // Current user is admin
  
  // Mock database of valid tickets
  final List<Map<String, dynamic>> _validTickets = [
    {'code': 'TKT001', 'event': 'Garba Night 2024', 'used': false, 'holder': 'John Doe'},
    {'code': 'TKT002', 'event': 'Garba Night 2024', 'used': true, 'holder': 'Jane Smith'},
    {'code': 'TKT003', 'event': 'Diwali Celebration', 'used': false, 'holder': 'Mike Johnson'},
    {'code': 'TKT004', 'event': 'Garba Night 2024', 'used': false, 'holder': 'Sarah Wilson'},
  ];
  
  // Mock scanner accounts database
  final List<Map<String, dynamic>> _scannerAccounts = [
    {'username': 'gate1', 'password': '1234', 'name': 'Gate Staff 1', 'active': true},
    {'username': 'gate2', 'password': '5678', 'name': 'Gate Staff 2', 'active': true},
    {'username': 'gate3', 'password': '9999', 'name': 'Gate Staff 3', 'active': false},
  ];
  
  final String _currentEvent = 'Garba Night 2024';

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });
    
    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      if (_isScanning) {
        _simulateQRScan();
      }
    });
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
  }

  void _simulateQRScan() {
    // Generate random ticket codes for demo
    final codes = ['TKT001', 'TKT002', 'TKT003', 'TKT004', 'TKT999', 'INVALID'];
    final randomCode = codes[Random().nextInt(codes.length)];
    
    setState(() {
      _lastScannedCode = randomCode;
      _isScanning = false;
    });
    
    _validateTicket(randomCode);
  }

  void _validateTicket(String code) {
    final ticket = _validTickets.firstWhere(
      (t) => t['code'] == code,
      orElse: () => {},
    );

    if (ticket.isEmpty) {
      _showValidationResult(
        'Invalid Ticket',
        'Ticket does not match event',
        Colors.red,
        Icons.error,
      );
    } else if (ticket['event'] != _currentEvent) {
      _showValidationResult(
        'Invalid Event',
        'Ticket is for ${ticket['event']}',
        Colors.red,
        Icons.error,
      );
    } else if (ticket['used']) {
      _showValidationResult(
        'Duplicate Entry',
        'Ticket already used by ${ticket['holder']}',
        Colors.red,
        Icons.warning,
      );
    } else {
      // Mark ticket as used
      ticket['used'] = true;
      _showValidationResult(
        'Check-in Successful',
        'Welcome ${ticket['holder']}!',
        Colors.green,
        Icons.check_circle,
      );
    }
  }

  void _showValidationResult(String title, String message, Color color, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.people, color: Colors.white),
              onPressed: () => _showScannerAccounts(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Event Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF001F3F),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Event',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentEvent,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isAdmin ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isAdmin ? 'ADMIN' : 'SCANNER',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Scanner Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isScanning ? Colors.green : Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Scanner Frame
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isScanning ? Icons.qr_code_scanner : Icons.qr_code,
                          size: 80,
                          color: _isScanning ? Colors.green : Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isScanning ? 'Scanning...' : 'Position QR code in frame',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_lastScannedCode.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Last scanned: $_lastScannedCode',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Scanning Animation
                  if (_isScanning)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.green.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Controls
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isScanning ? _stopScanning : _startScanning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isScanning ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isScanning ? Icons.stop : Icons.qr_code_scanner),
                        const SizedBox(width: 8),
                        Text(
                          _isScanning ? 'Stop Scanning' : 'Start Scanning',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Manual Entry
                OutlinedButton(
                  onPressed: () => _showManualEntry(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Manual Entry'),
                ),
                
                if (_isAdmin) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => _showScannerAccounts(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Manage Scanner Accounts'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntry() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Ticket Entry'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Ticket Code',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.isNotEmpty) {
                setState(() {
                  _lastScannedCode = controller.text;
                });
                _validateTicket(controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001F3F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Validate'),
          ),
        ],
      ),
    );
  }

  void _showScannerAccounts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scanner Accounts'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gate Staff Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => _createScannerAccount(),
                    icon: const Icon(Icons.add, color: Color(0xFF001F3F)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _scannerAccounts.length,
                  itemBuilder: (context, index) {
                    final account = _scannerAccounts[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: account['active'] ? Colors.green : Colors.grey,
                        ),
                        title: Text(account['name']),
                        subtitle: Text('Username: ${account['username']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: account['active'],
                              onChanged: (value) {
                                setState(() {
                                  account['active'] = value;
                                });
                                Navigator.pop(context);
                                _showScannerAccounts();
                              },
                            ),
                            IconButton(
                              onPressed: () => _deleteScannerAccount(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createScannerAccount() {
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Scanner Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Staff Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Scanner accounts have scan-only permissions. They cannot access other features.',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  usernameController.text.isNotEmpty && 
                  passwordController.text.isNotEmpty) {
                setState(() {
                  _scannerAccounts.add({
                    'username': usernameController.text,
                    'password': passwordController.text,
                    'name': nameController.text,
                    'active': true,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Scanner account created successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001F3F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteScannerAccount(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete ${_scannerAccounts[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _scannerAccounts.removeAt(index);
              });
              Navigator.pop(context);
              Navigator.pop(context);
              _showScannerAccounts();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}