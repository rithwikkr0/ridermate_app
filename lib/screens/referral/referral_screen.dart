import 'package:flutter/material.dart';
import 'package:ridermate_app/services/points_service.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  void _onShare(BuildContext context) {
    PointsService.addReferralPoints();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral shared! +100 pts')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const referralCode = 'RIDE1234';

    return Scaffold(
      appBar: AppBar(title: const Text('Invite & Earn')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Referral Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    referralCode,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.copy),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _onShare(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              child: const Text('Share Invite (mock)'),
            ),
          ],
        ),
      ),
    );
  }
}
