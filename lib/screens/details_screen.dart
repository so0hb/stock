import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/stock.dart';
import '../services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  final Stock stock;

  DetailsScreen({required this.stock});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<List<double>> _historicalPrices;

  @override
  void initState() {
    super.initState();
    _historicalPrices =
        _fetchHistoricalPrices(); // Initialize _historicalPrices
  }

  Future<List<double>> _fetchHistoricalPrices() async {
    try {
      final apiService = ApiService();
      return await apiService.fetchHistoricalPrices(widget.stock.symbol);
    } catch (e) {
      throw Exception('Failed to fetch historical prices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stock.name),
      ),
      body: FutureBuilder<List<double>>(
        future: _historicalPrices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load historical prices'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${widget.stock.price.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  Text('Last 5 Days:'),
                  SizedBox(height: 8),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: snapshot.data!
                                .asMap()
                                .entries
                                .map((entry) =>
                                FlSpot(entry.key.toDouble(), entry.value))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No historical data available'));
          }
        },
      ),
    );
  }
}
