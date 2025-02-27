import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/stock_bloc.dart';
import '../models/stock.dart';
import '../providers/theme_provider.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Market Tracker'),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stocks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                // Trigger search when the user types
                if (query.isNotEmpty) {
                  context.read<StockBloc>().add(SearchStocks(query));
                } else {
                  // If the search query is empty, fetch top stocks
                  context.read<StockBloc>().add(FetchStocks());
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<StockBloc, StockState>(
              builder: (context, state) {
                if (state is StockLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is StockLoaded) {
                  return Column(
                    children: [
                      if (state
                          .isCached) // Show a message if cached data is displayed
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Showing cached data',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<StockBloc>().add(FetchStocks());
                          },
                          child: ListView.builder(
                            itemCount: state.stocks.length,
                            itemBuilder: (context, index) {
                              final stock = state.stocks[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                elevation: 4,
                                child: ListTile(
                                  title: Text(stock.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(stock.symbol),
                                  trailing: Text(
                                    '\$${stock.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: stock.change >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsScreen(stock: stock),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is StockError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to fetch stocks. Please try again.'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<StockBloc>().add(FetchStocks());
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
