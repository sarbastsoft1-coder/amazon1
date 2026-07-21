import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/localization/string_extension.dart';

class AuctionCountdownTimer extends StatefulWidget {
  final DateTime? auctionStart;
  final DateTime? auctionEnd;

  const AuctionCountdownTimer({
    super.key,
    this.auctionStart,
    this.auctionEnd,
  });

  @override
  State<AuctionCountdownTimer> createState() => _AuctionCountdownTimerState();
}

class _AuctionCountdownTimerState extends State<AuctionCountdownTimer> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    final days = d.inDays;
    final hours = d.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    
    if (days > 0) {
      return '${days}d $hours:$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auctionStart == null || widget.auctionEnd == null) {
      return const SizedBox.shrink();
    }

    final start = widget.auctionStart!;
    final end = widget.auctionEnd!;
    
    bool isUpcoming = _now.isBefore(start);
    bool isActive = _now.isAfter(start) && _now.isBefore(end);
    bool isEnded = _now.isAfter(end);

    Color bgColor = isEnded ? Colors.grey.shade300 : (isActive ? Colors.green.shade600 : Colors.orange.shade600);
    Color textColor = isEnded ? Colors.grey.shade700 : Colors.white;

    String labelText = '';
    String timeText = '';

    if (isUpcoming) {
      labelText = 'Starts in:'.tr(context);
      timeText = _formatDuration(start.difference(_now));
    } else if (isActive) {
      labelText = 'Ends in:'.tr(context);
      timeText = _formatDuration(end.difference(_now));
    } else {
      labelText = 'Auction Ended'.tr(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            labelText,
            style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          if (!isEnded) ...[
            const SizedBox(width: 4),
            Text(
              timeText,
              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w900, fontFamily: 'Courier'),
            ),
          ]
        ],
      ),
    );
  }
}
