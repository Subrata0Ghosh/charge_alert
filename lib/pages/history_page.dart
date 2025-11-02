import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class ChargeHistoryPage extends StatefulWidget {
  const ChargeHistoryPage({super.key});

  @override
  State<ChargeHistoryPage> createState() => _ChargeHistoryPageState();
}

class _ChargeHistoryPageState extends State<ChargeHistoryPage> {
  List<_Sample> _samples = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('chargeHistory');
    final List<_Sample> data = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw);
        if (list is List) {
          for (final e in list) {
            final m = Map<String, dynamic>.from(e as Map);
            final ts = (m['ts'] as num).toInt();
            final level = (m['level'] as num).toInt();
            final state = (m['state'] as String? ?? 'unknown');
            data.add(_Sample(ts: ts, level: level, state: state));
          }
        }
      } catch (_) {}
    }
    setState(() {
      _samples = data;
      _loading = false;
    });
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chargeHistory');
    if (mounted) {
      setState(() {
        _samples = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge History'),
        actions: [
          IconButton(
            onPressed: _samples.isEmpty ? null : _clear,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _samples.isEmpty
              ? const Center(child: Text('No history yet'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: _HistoryChart(samples: _samples),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _samples.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final s = _samples[_samples.length - 1 - index];
                            final dt = DateTime.fromMillisecondsSinceEpoch(s.ts);
                            return ListTile(
                              leading: Icon(
                                s.state == 'charging' ? Icons.bolt : Icons.power_settings_new,
                                color: s.state == 'charging'
                                    ? Colors.green
                                    : theme.colorScheme.primary,
                              ),
                              title: Text('${s.level}%'),
                              subtitle: Text('${dt.toLocal()}'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _Sample {
  final int ts;
  final int level;
  final String state;
  _Sample({required this.ts, required this.level, required this.state});
}

class _HistoryChart extends StatelessWidget {
  final List<_Sample> samples;
  const _HistoryChart({required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) return const SizedBox.shrink();

    // Downsample if too dense
    final data = samples.length > 300
        ? [for (int i = 0; i < samples.length; i += (samples.length ~/ 300)) samples[i]]
        : samples;

    int minTs = data.first.ts;
    int maxTs = data.last.ts;
    for (final s in data) {
      if (s.ts < minTs) minTs = s.ts;
      if (s.ts > maxTs) maxTs = s.ts;
    }
    if (minTs == maxTs) maxTs = minTs + 1;

    double nx(int ts) => (ts - minTs) / (maxTs - minTs);

    final spots = <FlSpot>[
      for (final s in data) FlSpot(nx(s.ts), s.level.toDouble()),
    ];

    final color = Theme.of(context).colorScheme.primary;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 1,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        clipData: const FlClipData.all(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32, interval: 25),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((ts) {
                final frac = ts.x.clamp(0, 1.0);
                final tMillis = (minTs + (frac * (maxTs - minTs))).toInt();
                final dt = DateTime.fromMillisecondsSinceEpoch(tMillis).toLocal();
                return LineTooltipItem(
                  '${ts.y.toStringAsFixed(0)}%\n${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}/${dt.month}',
                  TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.15)),
          ),
        ],
      ),
    );
  }
}
