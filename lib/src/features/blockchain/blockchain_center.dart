import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class BlockchainCenter extends StatefulWidget {
  const BlockchainCenter({super.key});

  @override
  State<BlockchainCenter> createState() => _BlockchainCenterState();
}

class _BlockchainCenterState extends State<BlockchainCenter> {
  int _selectedTab = 0;
  
  // Cryptocurrency Prices
  Map<String, CryptoPrice> _cryptoPrices = {};
  Map<String, List<double>> _priceHistory = {};
  double _totalPortfolioValue = 0;
  
  // Wallet Management
  List<Wallet> _wallets = [];
  List<Transaction> _transactions = [];
  double _totalBalance = 0;
  
  // Smart Contracts
  List<SmartContract> _contracts = [];
  List<ContractExecution> _executions = [];
  
  // Blockchain Network
  Map<String, NetworkStats> _networkStats = {};
  List<Block> _recentBlocks = [];

  @override
  void initState() {
    super.initState();
    _loadCryptoPrices();
    _loadWallets();
    _loadSmartContracts();
    _loadNetworkStats();
    _startPriceUpdates();
  }

  void _loadCryptoPrices() {
    _cryptoPrices = {
      'BTC': CryptoPrice('Bitcoin', 45230.50, 2.5, Icons.currency_bitcoin, Colors.orange),
      'ETH': CryptoPrice('Ethereum', 3240.75, 1.8, Icons.currency_bitcoin, Colors.blue),
      'BNB': CryptoPrice('BNB', 312.45, -0.5, Icons.currency_bitcoin, Colors.yellow),
      'SOL': CryptoPrice('Solana', 98.20, 5.2, Icons.currency_bitcoin, Colors.green),
      'XRP': CryptoPrice('XRP', 0.62, -1.2, Icons.currency_bitcoin, Colors.blue),
      'ADA': CryptoPrice('Cardano', 0.48, 0.8, Icons.currency_bitcoin, Colors.cyan),
    };
    
    _priceHistory = {
      'BTC': [44500, 44800, 45200, 45000, 45100, 45300, 45230],
      'ETH': [3100, 3150, 3180, 3200, 3220, 3235, 3240],
      'SOL': [92, 94, 95, 96, 97, 97.5, 98.2],
    };
    
    _totalPortfolioValue = 45230 + 3240 + 98.2;
  }

  void _loadWallets() {
    _wallets = [
      Wallet('Bitcoin Wallet', '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', 0.5, 'BTC', Icons.account_balance_wallet, Colors.orange),
      Wallet('Ethereum Wallet', '0x742d35Cc6634C0532925a3b844Bc9e7595f0b0b0', 2.3, 'ETH', Icons.account_balance_wallet, Colors.blue),
      Wallet('Solana Wallet', '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM', 45.2, 'SOL', Icons.account_balance_wallet, Colors.green),
    ];
    
    _totalBalance = 0.5 * 45230 + 2.3 * 3240 + 45.2 * 98.2;
    
    _transactions = [
      Transaction('0x1234...5678', 'Received', 0.1, 'BTC', DateTime.now().subtract(const Duration(hours: 2)), 'Completed'),
      Transaction('0x8765...4321', 'Sent', 0.05, 'BTC', DateTime.now().subtract(const Duration(days: 1)), 'Completed'),
      Transaction('0xabcd...efgh', 'Received', 1.5, 'ETH', DateTime.now().subtract(const Duration(days: 3)), 'Pending'),
    ];
  }

  void _loadSmartContracts() {
    _contracts = [
      SmartContract('TokenSwap', '0x1234...', 'Active', 1250, Icons.swap_horiz, Colors.cyan),
      SmartContract('Lending Pool', '0x5678...', 'Active', 3400, Icons.attach_money, Colors.green),
      SmartContract('NFT Market', '0x9abc...', 'Inactive', 0, Icons.image, Colors.purple),
    ];
    
    _executions = [
      ContractExecution('TokenSwap', 'Swap ETH for BTC', DateTime.now().subtract(const Duration(hours: 1)), 'Success', 0.05),
      ContractExecution('Lending Pool', 'Deposit 1 ETH', DateTime.now().subtract(const Duration(days: 2)), 'Success', 0.02),
    ];
  }

  void _loadNetworkStats() {
    _networkStats = {
      'Bitcoin': NetworkStats(325, 145.2, 5.2, 98.5),
      'Ethereum': NetworkStats(18, 85.6, 12.8, 99.2),
      'Solana': NetworkStats(2800, 1850, 0.4, 99.8),
    };
    
    _recentBlocks = [
      Block(815234, '0000000000000000000...', DateTime.now().subtract(const Duration(minutes: 10)), '1.2 MB', 3250),
      Block(815233, '0000000000000000000...', DateTime.now().subtract(const Duration(minutes: 20)), '1.1 MB', 3245),
      Block(815232, '0000000000000000000...', DateTime.now().subtract(const Duration(minutes: 30)), '1.3 MB', 3255),
    ];
  }

  void _startPriceUpdates() {
    final random = Random();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          for (var key in _cryptoPrices.keys) {
            final change = (random.nextDouble() - 0.5) * 2;
            _cryptoPrices[key]!.price += (_cryptoPrices[key]!.price * change / 100);
            _cryptoPrices[key]!.change = change;
          }
          _totalPortfolioValue = _cryptoPrices.values.map((c) => c.price).reduce((a, b) => a + b);
        });
      }
    });
  }

  void _sendTransaction() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Transaction'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items: ['BTC', 'ETH', 'SOL'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: 'Currency'),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Recipient Address'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Send')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Blockchain Center'),
        backgroundColor: Colors.amber.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildPortfolioCard()),
          SliverToBoxAdapter(child: _buildCryptoPrices()),
          SliverToBoxAdapter(child: _buildWalletsCard()),
          SliverToBoxAdapter(child: _buildSmartContractsCard()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendTransaction,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildPortfolioCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.amber.shade900, Colors.orange.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Total Portfolio Value', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text('\$${_totalPortfolioValue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('+2.4% (24h)', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildCryptoPrices() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cryptocurrency Prices', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._cryptoPrices.entries.map((entry) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(entry.value.icon, color: entry.value.color),
              title: Text(entry.value.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(entry.key, style: const TextStyle(color: Colors.grey)),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${entry.value.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                  Text(
                    '${entry.value.change > 0 ? '+' : ''}${entry.value.change.toStringAsFixed(2)}%',
                    style: TextStyle(color: entry.value.change > 0 ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWalletsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wallets', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Total: \$0.00', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          ..._wallets.map((wallet) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: Icon(wallet.icon, color: wallet.color),
              title: Text(wallet.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${wallet.balance} ${wallet.currency} • ${wallet.address.substring(0, 10)}...', style: const TextStyle(color: Colors.grey)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTransactionList(),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: _transactions.map((tx) => ListTile(
        leading: Icon(tx.type == 'Received' ? Icons.arrow_downward : Icons.arrow_upward, color: tx.type == 'Received' ? Colors.green : Colors.red),
        title: Text(tx.type, style: const TextStyle(color: Colors.white)),
        subtitle: Text(tx.hash, style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${tx.amount} ${tx.currency}', style: const TextStyle(color: Colors.white)),
            Text(tx.status, style: TextStyle(color: tx.status == 'Completed' ? Colors.green : Colors.orange)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildSmartContractsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Smart Contracts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._contracts.map((contract) => Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(contract.icon, color: contract.color),
              title: Text(contract.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(contract.address, style: const TextStyle(color: Colors.grey)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: contract.status == 'Active' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(contract.status, style: TextStyle(color: contract.status == 'Active' ? Colors.green : Colors.red)),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class CryptoPrice {
  final String name;
  double price;
  double change;
  final IconData icon;
  final Color color;

  CryptoPrice(this.name, this.price, this.change, this.icon, this.color);
}

class Wallet {
  final String name;
  final String address;
  final double balance;
  final String currency;
  final IconData icon;
  final Color color;

  Wallet(this.name, this.address, this.balance, this.currency, this.icon, this.color);
}

class Transaction {
  final String hash;
  final String type;
  final double amount;
  final String currency;
  final DateTime date;
  final String status;

  Transaction(this.hash, this.type, this.amount, this.currency, this.date, this.status);
}

class SmartContract {
  final String name;
  final String address;
  final String status;
  final int interactions;
  final IconData icon;
  final Color color;

  SmartContract(this.name, this.address, this.status, this.interactions, this.icon, this.color);
}

class ContractExecution {
  final String contract;
  final String action;
  final DateTime date;
  final String status;
  final double fee;

  ContractExecution(this.contract, this.action, this.date, this.status, this.fee);
}

class NetworkStats {
  final int tps;
  final double gasPrice;
  final double blockTime;
  final double uptime;

  NetworkStats(this.tps, this.gasPrice, this.blockTime, this.uptime);
}

class Block {
  final int height;
  final String hash;
  final DateTime time;
  final String size;
  final int transactions;

  Block(this.height, this.hash, this.time, this.size, this.transactions);
}
