import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../models/event.dart';
import '../providers/dashboard_provider.dart';
import '../../widgets/primary_button.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventModel? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final dashboard = context.read<DashboardProvider>();
    final event = await dashboard.getEventDetail(widget.eventId);
    if (mounted) {
      setState(() {
        _event = event;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VictusTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: VictusTheme.textDark),
        ),
        title: const Text(
          'Detalhe do Evento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: VictusTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: VictusTheme.primaryPink),
            )
          : _event == null
              ? const Center(child: Text('Evento não encontrado'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event image
                      if (_event!.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              VictusTheme.radiusLarge),
                          child: Image.network(
                            _event!.imageUrl!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: VictusTheme.primaryPinkLight,
                              child: const Center(
                                child: Icon(Icons.event,
                                    size: 48,
                                    color: VictusTheme.primaryPink),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: VictusTheme.primaryPinkLight,
                          borderRadius:
                              BorderRadius.circular(VictusTheme.radiusSmall),
                        ),
                        child: Text(
                          _event!.eventType,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: VictusTheme.primaryPinkDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(_event!.title, style: VictusTheme.heading1),

                      const SizedBox(height: 12),

                      // Date & time
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: VictusTheme.primaryPink),
                          const SizedBox(width: 8),
                          Text(
                            _event!.formattedDate,
                            style: VictusTheme.bodyMedium
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 20),
                          const Icon(Icons.access_time,
                              size: 18, color: VictusTheme.primaryPink),
                          const SizedBox(width: 8),
                          Text(
                            _event!.formattedTime,
                            style: VictusTheme.bodyMedium
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      if (_event!.location != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 18, color: VictusTheme.primaryPink),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _event!.location!,
                                style: VictusTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Description
                      if (_event!.description != null)
                        Text(
                          _event!.description!,
                          style: VictusTheme.bodyLarge.copyWith(height: 1.6),
                        ),

                      const SizedBox(height: 32),

                      // Meeting link button
                      if (_event!.meetingLink != null)
                        PrimaryButton(
                          text: 'Participar no Evento',
                          onPressed: () async {
                            final url = Uri.parse(_event!.meetingLink!);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                    ],
                  ),
                ),
    );
  }
}