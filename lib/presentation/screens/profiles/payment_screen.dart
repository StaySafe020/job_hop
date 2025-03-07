import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Function(String) onPaymentComplete;

  const PaymentScreen({super.key, required this.onPaymentComplete});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'MTN Mobile Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'MTN Mobile Money', child: Text('MTN Mobile Money')),
                DropdownMenuItem(value: 'Orange Mobile Money', child: Text('Orange Mobile Money')),
                DropdownMenuItem(value: 'Bank', child: Text('Bank')),
              ],
              isExpanded: true,
            ),
            const SizedBox(height: 24),
            const Text('Amount: \$10', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (_selectedPaymentMethod == 'MTN Mobile Money' || _selectedPaymentMethod == 'Orange Mobile Money') ...[
              const Text('Enter Phone Number', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
            if (_selectedPaymentMethod == 'Bank') ...[
              const Text('Enter Card Details', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Process payment based on _selectedPaymentMethod
                widget.onPaymentComplete(_selectedPaymentMethod);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Complete Payment'),
            ),
          ],
        ),
      ),
    );
  }
}