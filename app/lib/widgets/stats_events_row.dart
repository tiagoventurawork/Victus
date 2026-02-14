import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/event.dart';

class StatsEventsRow extends StatelessWidget {
  final double weightLost;
  final List<EventModel> events;
  final void Function(EventModel event) onEventTap;

  const StatsEventsRow({
    super.key,
    required this.weightLost,
    required this.events,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Weight progress circle
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: VictusTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(VictusTheme.radiusLarge),
                boxShadow: VictusTheme.softShadow,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                            value: (weightLost / 10).clamp(0, 1),
                            strokeWidth: 6,
                            backgroundColor: VictusTheme.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              VictusTheme.primaryPink,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${weightLost.toStringAsFixed(0)}kg',
                              style: VictusTheme.heading2.copyWith(fontSize: 18),
                            ),
                            Text(
                              'perdidos',
                              style: VictusTheme.bodySmall.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Upcoming events
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VictusTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(VictusTheme.radiusLarge),
                boxShadow: VictusTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Próximos eventos:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: VictusTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...events.take(2).map((event) => _EventRow(
                        event: event,
                        onTap: () => onEventTap(event),
                      )),
                  if (events.length > 2) ...[
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        // Could navigate to events list
                      },
                      child: Text(
                        '+ ${events.length - 2} evento${events.length - 2 > 1 ? 's' : ''}',
                        style: VictusTheme.bodySmall.copyWith(
                          color: VictusTheme.textLink,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const _EventRow({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: VictusTheme.divider),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                event.formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: VictusTheme.textDark,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                event.title,
                style: VictusTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}