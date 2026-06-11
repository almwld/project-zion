import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  String _searchQuery = '';
  List<HelpArticle> _articles = [];
  List<FAQItem> _faqs = [];
  List<SupportTicket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _loadFAQs();
    _loadTickets();
  }

  void _loadArticles() {
    _articles = [
      HelpArticle(
        id: '1',
        title: 'Getting Started with Zion OS',
        content: 'Learn the basics of Zion OS, navigation, and essential features...',
        category: 'Beginner',
        readTime: '5 min',
        icon: Icons.rocket_launch,
        color: Colors.green,
      ),
      HelpArticle(
        id: '2',
        title: 'Understanding SI Agent',
        content: 'Complete guide to Sentient Intelligence Agent and its capabilities...',
        category: 'Advanced',
        readTime: '10 min',
        icon: Icons.psychology,
        color: Colors.purple,
      ),
      HelpArticle(
        id: '3',
        title: 'Network Scanning Tutorial',
        content: 'Step-by-step guide to using ZionNet for network reconnaissance...',
        category: 'Intermediate',
        readTime: '8 min',
        icon: Icons.network_check,
        color: Colors.cyan,
      ),
      HelpArticle(
        id: '4',
        title: 'Customizing Your Desktop',
        content: 'Personalize your Zion OS experience with themes and layouts...',
        category: 'Beginner',
        readTime: '6 min',
        icon: Icons.palette,
        color: Colors.orange,
      ),
      HelpArticle(
        id: '5',
        title: 'Advanced Exploitation Techniques',
        content: 'Master the art of exploitation with ZionExploit...',
        category: 'Expert',
        readTime: '15 min',
        icon: Icons.flash_on,
        color: Colors.red,
      ),
    ];
  }

  void _loadFAQs() {
    _faqs = [
      FAQItem(
        question: 'How do I install Kali Linux on Zion OS?',
        answer: 'Zion OS comes with built-in tools. No separate Kali installation needed.',
        category: 'Installation',
      ),
      FAQItem(
        question: 'Does Zion OS require root access?',
        answer: 'No, Zion OS works completely without root access on Android devices.',
        category: 'General',
      ),
      FAQItem(
        question: 'How to update Zion OS?',
        answer: 'Go to Settings > Updates to check and install latest updates.',
        category: 'Updates',
      ),
      FAQItem(
        question: 'Is SI Agent safe to use?',
        answer: 'Yes, SI Agent operates locally on your device with full privacy controls.',
        category: 'Security',
      ),
      FAQItem(
        question: 'How to report bugs?',
        answer: 'Use the Support section to create a ticket or email support@zion-os.com',
        category: 'Support',
      ),
    ];
  }

  void _loadTickets() {
    _tickets = [
      SupportTicket(
        id: 'TKT-001',
        subject: 'Installation issue',
        status: 'Resolved',
        date: DateTime.now().subtract(const Duration(days: 5)),
        lastUpdate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SupportTicket(
        id: 'TKT-002',
        subject: 'Feature request: Dark mode',
        status: 'In Progress',
        date: DateTime.now().subtract(const Duration(days: 2)),
        lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _createTicket() {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Support Ticket'),
        backgroundColor: Colors.grey.shade900,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket created successfully!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _openArticle(HelpArticle article) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(article.title),
        backgroundColor: Colors.grey.shade900,
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(article.icon, color: article.color),
                  const SizedBox(width: 8),
                  Text('${article.readTime} read', style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: article.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(article.category, style: TextStyle(color: article.color, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(article.content, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          TextButton(
            onPressed: () => Share.share(article.content),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  List<HelpArticle> get _filteredArticles {
    if (_searchQuery.isEmpty) return _articles;
    return _articles.where((a) =>
      a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      a.content.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs.where((f) =>
      f.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      f.answer.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildArticlesSection()),
          SliverToBoxAdapter(child: _buildFAQSection()),
          SliverToBoxAdapter(child: _buildSupportSection()),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAction(
              'Documentation',
              Icons.description,
              Colors.blue,
              () => _openLink('https://docs.zion-os.com'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(
              'Community',
              Icons.people,
              Colors.green,
              () => _openLink('https://community.zion-os.com'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(
              'GitHub',
              Icons.code,
              Colors.white,
              () => _openLink('https://github.com/almwld/project-zion'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Help Articles', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._filteredArticles.map((article) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(article.icon, color: article.color),
              title: Text(article.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${article.readTime} read • ${article.category}', style: const TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () => _openArticle(article),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._filteredFAQs.map((faq) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.help, color: Colors.blue),
              title: Text(faq.question, style: const TextStyle(color: Colors.white)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(faq.answer, style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Support Tickets', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._tickets.map((ticket) => ListTile(
            leading: CircleAvatar(
              backgroundColor: ticket.status == 'Resolved' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              child: Icon(Icons.confirmation_number, color: ticket.status == 'Resolved' ? Colors.green : Colors.orange, size: 20),
            ),
            title: Text(ticket.subject, style: const TextStyle(color: Colors.white)),
            subtitle: Text('Status: ${ticket.status} • ${_formatDate(ticket.date)}', style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () => _viewTicket(ticket),
          )),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _createTicket,
            icon: const Icon(Icons.add),
            label: const Text('CREATE NEW TICKET'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  void _viewTicket(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ticket ${ticket.id}'),
        backgroundColor: Colors.grey.shade900,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject: ${ticket.subject}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Status: ${ticket.status}', style: TextStyle(color: ticket.status == 'Resolved' ? Colors.green : Colors.orange)),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(ticket.date)}', style: const TextStyle(color: Colors.grey)),
            Text('Last Update: ${_formatDate(ticket.lastUpdate)}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Search Help'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search articles or FAQs...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class HelpArticle {
  final String id;
  final String title;
  final String content;
  final String category;
  final String readTime;
  final IconData icon;
  final Color color;

  HelpArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.readTime,
    required this.icon,
    required this.color,
  });
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class SupportTicket {
  final String id;
  final String subject;
  final String status;
  final DateTime date;
  final DateTime lastUpdate;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.date,
    required this.lastUpdate,
  });
}
