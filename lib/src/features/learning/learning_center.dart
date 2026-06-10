import 'package:flutter/material.dart';

class LearningCenter extends StatefulWidget {
  const LearningCenter({super.key});

  @override
  State<LearningCenter> createState() => _LearningCenterState();
}

class _LearningCenterState extends State<LearningCenter> {
  String _selectedCategory = 'All';
  int _userLevel = 1;
  int _userXP = 0;
  int _nextLevelXP = 100;
  List<Course> _courses = [];
  List<Achievement> _achievements = [];

  final List<String> _categories = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Expert'];

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _loadAchievements();
    _loadUserProgress();
  }

  void _loadCourses() {
    _courses = [
      Course(
        id: '1',
        title: 'Introduction to Cybersecurity',
        description: 'Learn the basics of cybersecurity and ethical hacking',
        category: 'Beginner',
        duration: '2 hours',
        lessons: 8,
        progress: 0,
        icon: Icons.security,
        color: Colors.blue,
      ),
      Course(
        id: '2',
        title: 'Network Security Fundamentals',
        description: 'Understanding network protocols, firewalls, and IDS/IPS',
        category: 'Intermediate',
        duration: '3 hours',
        lessons: 12,
        progress: 0,
        icon: Icons.network_check,
        color: Colors.cyan,
      ),
      Course(
        id: '3',
        title: 'Penetration Testing Masterclass',
        description: 'Advanced penetration testing techniques and methodologies',
        category: 'Advanced',
        duration: '5 hours',
        lessons: 20,
        progress: 0,
        icon: Icons.flash_on,
        color: Colors.red,
      ),
      Course(
        id: '4',
        title: 'Malware Analysis & Reverse Engineering',
        description: 'Analyze and reverse engineer malicious software',
        category: 'Expert',
        duration: '4 hours',
        lessons: 15,
        progress: 0,
        icon: Icons.bug_report,
        color: Colors.purple,
      ),
      Course(
        id: '5',
        title: 'Web Application Security',
        description: 'SQL injection, XSS, CSRF and other web vulnerabilities',
        category: 'Intermediate',
        duration: '3 hours',
        lessons: 10,
        progress: 0,
        icon: Icons.web,
        color: Colors.green,
      ),
      Course(
        id: '6',
        title: 'Cryptography for Hackers',
        description: 'Encryption, decryption, and cryptographic attacks',
        category: 'Advanced',
        duration: '2.5 hours',
        lessons: 9,
        progress: 0,
        icon: Icons.lock,
        color: Colors.orange,
      ),
    ];
  }

  void _loadAchievements() {
    _achievements = [
      Achievement(
        id: '1',
        title: 'First Step',
        description: 'Complete your first lesson',
        icon: Icons.rocket_launch,
        color: Colors.blue,
        unlocked: false,
        xpReward: 50,
      ),
      Achievement(
        id: '2',
        title: 'Quick Learner',
        description: 'Complete 5 lessons in one day',
        icon: Icons.bolt,
        color: Colors.yellow,
        unlocked: false,
        xpReward: 100,
      ),
      Achievement(
        id: '3',
        title: 'Knowledge Seeker',
        description: 'Reach level 10',
        icon: Icons.auto_awesome,
        color: Colors.purple,
        unlocked: false,
        xpReward: 200,
      ),
      Achievement(
        id: '4',
        title: 'Master Hacker',
        description: 'Complete all advanced courses',
        icon: Icons.psychology,
        color: Colors.red,
        unlocked: false,
        xpReward: 500,
      ),
    ];
  }

  void _loadUserProgress() {
    _userXP = 45;
    _userLevel = 1;
    _updateLevel();
  }

  void _updateLevel() {
    while (_userXP >= _nextLevelXP) {
      _userXP -= _nextLevelXP;
      _userLevel++;
      _nextLevelXP = 100 * _userLevel;
    }
  }

  void _startCourse(Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(course.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${course.category}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Duration: ${course.duration}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Lessons: ${course.lessons}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text(course.description, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _enrollCourse(course);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Start Learning'),
          ),
        ],
      ),
    );
  }

  void _enrollCourse(Course course) {
    setState(() {
      course.progress = 0.1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enrolled in ${course.title}!')),
    );
  }

  void _completeLesson(Course course) {
    setState(() {
      course.progress += 1.0 / course.lessons;
      if (course.progress >= 1.0) {
        course.progress = 1.0;
        _userXP += 50;
        _updateLevel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course completed! +50 XP')),
        );
      } else {
        _userXP += 10;
        _updateLevel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lesson completed! +10 XP')),
        );
      }
    });
  }

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'All') return _courses;
    return _courses.where((c) => c.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Learning Center'),
        backgroundColor: Colors.teal.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildUserProfile()),
          SliverToBoxAdapter(child: _buildCategoryFilter()),
          SliverToBoxAdapter(child: _buildCoursesList()),
          SliverToBoxAdapter(child: _buildAchievementsSection()),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    final progressToNext = _userXP / _nextLevelXP;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Text(
                '$_userLevel',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Level $_userLevel', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progressToNext,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.teal,
                ),
                const SizedBox(height: 4),
                Text('$_userXP / $_nextLevelXP XP', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final category = _categories[i];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.grey.shade800,
              selectedColor: Colors.teal,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesList() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Courses', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._filteredCourses.map((course) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: Icon(course.icon, color: course.color),
              title: Text(course.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${course.duration} • ${course.lessons} lessons', style: const TextStyle(color: Colors.grey)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (course.progress > 0)
                    Text('${(course.progress * 100).toInt()}%', style: const TextStyle(color: Colors.green)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.description, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      if (course.progress > 0)
                        LinearProgressIndicator(
                          value: course.progress,
                          backgroundColor: Colors.grey.shade800,
                          color: Colors.green,
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (course.progress == 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _startCourse(course),
                                style: ElevatedButton.styleFrom(backgroundColor: course.color),
                                child: const Text('ENROLL'),
                              ),
                            ),
                          if (course.progress > 0 && course.progress < 1.0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _completeLesson(course),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('COMPLETE LESSON'),
                              ),
                            ),
                          if (course.progress >= 1.0)
                            const Expanded(
                              child: Text('✅ COMPLETED', textAlign: TextAlign.center, style: TextStyle(color: Colors.green)),
                            ),
                        ],
                      ),
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

  Widget _buildAchievementsSection() {
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
          const Text('Achievements', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: _achievements.map((ach) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ach.unlocked ? ach.color.withOpacity(0.2) : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ach.unlocked ? ach.color : Colors.grey, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(ach.icon, color: ach.unlocked ? ach.color : Colors.grey, size: 32),
                  const SizedBox(height: 8),
                  Text(ach.title, style: TextStyle(color: ach.unlocked ? ach.color : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(ach.description, style: TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('+${ach.xpReward} XP', style: TextStyle(color: ach.unlocked ? ach.color : Colors.grey, fontSize: 10)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final int lessons;
  double progress;
  final IconData icon;
  final Color color;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.lessons,
    required this.progress,
    required this.icon,
    required this.color,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  bool unlocked;
  final int xpReward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.xpReward,
  });
}
