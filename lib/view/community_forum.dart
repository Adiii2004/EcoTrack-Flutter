import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class Comment {
  final String userName;
  final String userAvatarUrl;
  final String text;

  Comment({
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
  });
}

enum PostTag { trending, question, success, tip }

class ForumPost {
  final String id; // Added for unique identification
  final String userName;
  final String userAvatarUrl;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final PostTag tag;
  int likes;
  List<Comment> comments;
  bool isBookmarked;

  ForumPost({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.tag,
    required this.likes,
    required this.comments,
    this.isBookmarked = false,
  });
}

// --- Main App Entry Point ---

void main() {
  runApp(const EcoConnectApp());
}

class EcoConnectApp extends StatelessWidget {
  const EcoConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco-Connect Forum',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF0FDF4),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const ForumScreen(),
    );
  }
}

// --- The Main Screen Widget ---

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<ForumPost> _allPosts = [
    ForumPost(
      id: '1',
      userName: 'Sarah Green',
      userAvatarUrl:
          'https://lawschoolpolicyreview.com/wp-content/uploads/2018/06/passport-size-photo-2-e1558013566564.jpg',
      timeAgo: '2 hours ago',
      content:
          'Just started composting at home! Amazing to see how much waste we can reduce. Here\'s my setup after 2 weeks. Any tips for faster decomposition?',
      imageUrl:
          'https://cdn.britannica.com/02/154202-050-001D9E0A/Bulldozer-sanitary-landfill-waste-garbage.jpg',
      tag: PostTag.trending,
      likes: 24,
      comments: [
        Comment(
          userName: "Admin",
          userAvatarUrl: "https://i.pravatar.cc/150?img=10",
          text: "Great start!",
        ),
      ],
      isBookmarked: true,
    ),
    ForumPost(
      id: '2',
      userName: 'Mike Eco',
      userAvatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXHApkcWRIFEnfLnUzDboR74fV_pJfYU3Ry7Fh_bxuIKwnB9YFqU-0iHUdAT4vZtQa9zE&usqp=CAU',
      timeAgo: '4 hours ago',
      content:
          'Does anyone know the best way to dispose of old electronics in our city? I have some old phones and laptops that need proper e-waste disposal.',
      tag: PostTag.question,
      likes: 12,
      comments: [],
    ),
    ForumPost(
      id: '3',
      userName: 'Emma Nature',
      userAvatarUrl:
          'https://thumbs.dreamstime.com/b/passport-picture-laughing-turkish-businesswoman-isolated-white-background-cut-out-53082981.jpg',
      timeAgo: '6 hours ago',
      content:
          'Update: Our neighborhood clean-up drive was a huge success! 50+ volunteers collected 200kg of waste. Next month we\'re planning a tree plantation. Who\'s in?',
      imageUrl:
          'https://images.forbesindia.com/blog/wp-content/uploads/media/images/2023/Mar/img_205293_wastemanagement.jpg?im=Resize,width=500,aspect=fit,type=normal',
      tag: PostTag.success,
      likes: 45,
      comments: [],
    ),
    ForumPost(
      id: '4',
      userName: 'Leo Gardener',
      userAvatarUrl:
          'https://www.shutterstock.com/image-photo/head-shot-young-business-attractive-260nw-95286856.jpg',
      timeAgo: '8 hours ago',
      content:
          'My vertical garden is thriving! It\'s a great way to grow herbs in a small apartment. #urbanGardening',
      imageUrl:
          'https://media.istockphoto.com/id/1425232352/photo/expired-organic-bio-waste-mix-vegetables-and-fruits-in-a-huge-container-in-a-rubbish-bin-heap.jpg?s=612x612&w=0&k=20&c=_hIv18ePoswfw6BTJK9j7JMC4mhgXU-GX8rpIEbIJ5s=',
      tag: PostTag.success,
      likes: 78,
      comments: [],
    ),
    ForumPost(
      id: '5',
      userName: 'Alex Green',
      userAvatarUrl:
          'https://i.pinimg.com/736x/2a/7d/4c/2a7d4c4bc1381a476b8b8a85885ac392.jpg',
      timeAgo: '1 day ago',
      content:
          'Pro tip: Use rice water for watering plants! It\'s rich in nutrients and reduces kitchen waste. My plants have been thriving since I started this practice.',
      tag: PostTag.tip,
      likes: 18,
      comments: [],
    ),
    ForumPost(
      id: '6',
      userName: 'Olivia Watt',
      userAvatarUrl:
          'https://t4.ftcdn.net/jpg/00/96/00/45/360_F_96004593_WDtj2et37EATdIhZ86vHbtFAf54XYRJu.jpg',
      timeAgo: '1 day ago',
      content:
          'Has anyone tried solar-powered chargers for their phones? Looking for recommendations that are effective and durable.',
      tag: PostTag.question,
      likes: 9,
      comments: [],
    ),
    ForumPost(
      id: '7',
      userName: 'David Renew',
      userAvatarUrl:
          'https://www.shutterstock.com/image-photo/passport-photo-portrait-man-on-260nw-2582459733.jpg',
      timeAgo: '2 days ago',
      content:
          'The city just announced a new bike lane initiative connecting downtown to the suburbs! This is a huge win for sustainable transport. #GoGreen',
      tag: PostTag.trending,
      likes: 152,
      comments: [],
    ),
  ];

  late List<ForumPost> _filteredPosts;
  PostTag _selectedTag = PostTag.trending;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPosts = [];
    _filterPosts(_selectedTag);
  }

  void _filterPosts(PostTag tag) {
    setState(() {
      _selectedTag = tag;
      _filteredPosts =
          _allPosts.where((post) => post.tag == _selectedTag).toList();
    });
  }

  void _toggleBookmark(String postId) {
    setState(() {
      final post = _allPosts.firstWhere((p) => p.id == postId);
      post.isBookmarked = !post.isBookmarked;
    });
  }

  void _sharePost(ForumPost post) {
    final textToShare =
        'Check out this post from the Eco-Connect Forum:\n\n"${post.content}"\n- ${post.userName}';
    Share.share(textToShare);
  }

  void _addComment(String postId, String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      final post = _allPosts.firstWhere((p) => p.id == postId);
      post.comments.add(
        Comment(
          userName: 'You',
          userAvatarUrl: 'https://placehold.co/150/FFC0CB/000000?text=ME',
          text: text.trim(),
        ),
      );
      _commentController.clear();
    });
    Navigator.of(context).pop(); // Close bottom sheet after commenting
    _showComments(
      context,
      _allPosts.firstWhere((p) => p.id == postId),
    ); // Re-open to see new comment
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Stack(
        children: [
          _buildDecorativeBackground(context),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildHeader(),
                      _buildFilterChips(),
                      const SizedBox(height: 16),
                      ..._filteredPosts
                          .map(
                            (post) => PostCard(
                              post: post,
                              onBookmark: () => _toggleBookmark(post.id),
                              onShare: () => _sharePost(post),
                              onComment: () => _showComments(context, post),
                            ),
                          )
                          ,
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                _buildCommentInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Widgets ---

  Widget _buildDecorativeBackground(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 169, 231, 187),
            Color.fromARGB(255, 225, 230, 226),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.green.shade200.withOpacity(1.0),
                    Colors.green.shade200.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.lightBlue.shade200.withOpacity(1.0),
                    Colors.lightBlue.shade200.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderIcon(Icons.people_alt_rounded),
              const SizedBox(width: 16),
              _buildHeaderIcon(Icons.eco_rounded),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Eco-Connect Forum',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14532D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Share ideas, ask questions, connect with citizens',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return GlassmorphicContainer(
      blur: 10,
      borderRadius: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, color: const Color(0xFF16A34A), size: 28),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterChipButton(
            label: 'Trending',
            icon: Icons.local_fire_department,
            isSelected: _selectedTag == PostTag.trending,
            onPressed: () => _filterPosts(PostTag.trending),
          ),
          const SizedBox(width: 8),
          FilterChipButton(
            label: 'Questions',
            icon: Icons.help_outline,
            isSelected: _selectedTag == PostTag.question,
            onPressed: () => _filterPosts(PostTag.question),
          ),
          const SizedBox(width: 8),
          FilterChipButton(
            label: 'Success',
            icon: Icons.check_circle_outline,
            isSelected: _selectedTag == PostTag.success,
            onPressed: () => _filterPosts(PostTag.success),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return GlassmorphicContainer(
      blur: 20,
      borderRadius: 0,
      color: Colors.white.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://lawschoolpolicyreview.com/wp-content/uploads/2018/06/passport-size-photo-2-e1558013566564.jpg',
              ),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                // Note: This is a decorative input field.
                // The real commenting happens in the bottom sheet.
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey.shade800),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF22C55E),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  // This button is also decorative.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW: Bottom Sheet for Comments ---
  void _showComments(BuildContext context, ForumPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return GlassmorphicContainer(
              blur: 20,
              borderRadius: 20,
              color: Colors.white.withOpacity(0.8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Comments (${post.comments.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF14532D),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              comment.userAvatarUrl,
                            ),
                          ),
                          title: Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14532D),
                            ),
                          ),
                          subtitle: Text(
                            comment.text,
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              fillColor: Colors.white.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (value) => _addComment(post.id, value),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF16A34A),
                          ),
                          onPressed:
                              () =>
                                  _addComment(post.id, _commentController.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// --- Reusable Widgets ---

class GlassmorphicContainer extends StatelessWidget {
  final double blur;
  final double borderRadius;
  final Widget child;
  final Color color;

  const GlassmorphicContainer({
    super.key,
    required this.blur,
    required this.borderRadius,
    required this.child,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color.withOpacity(0.45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onBookmark,
    required this.onShare,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GlassmorphicContainer(
        blur: 15,
        borderRadius: 16,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostHeader(),
              const SizedBox(height: 12),
              Text(
                post.content,
                style: const TextStyle(fontSize: 15, color: Color(0xFF14532D)),
              ),
              if (post.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(post.imageUrl!),
                ),
              ],
              const SizedBox(height: 12),
              _buildPostFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(post.userAvatarUrl),
          radius: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF14532D),
                ),
              ),
              Text(
                post.timeAgo,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
        ),
        _buildTagChip(),
      ],
    );
  }

  Widget _buildPostFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildFooterIcon(
              post.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border_rounded,
              post.likes,
              onTap: onBookmark,
            ),
            const SizedBox(width: 20),
            _buildFooterIcon(
              Icons.chat_bubble_outline_rounded,
              post.comments.length,
              onTap: onComment,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.share_outlined, color: Colors.grey.shade700),
              onPressed: onShare,
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.arrow_upward_rounded, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Icon(Icons.arrow_downward_rounded, color: Colors.grey.shade700),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterIcon(IconData icon, int count, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text('$count', style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildTagChip() {
    Color color;
    IconData icon;
    String label;

    switch (post.tag) {
      case PostTag.trending:
        color = Colors.red.shade100;
        icon = Icons.local_fire_department;
        label = 'Trending';
        break;
      case PostTag.question:
        color = Colors.blue.shade100;
        icon = Icons.help;
        label = 'Question';
        break;
      case PostTag.success:
        color = Colors.green.shade100;
        icon = Icons.check_circle;
        label = 'Success';
        break;
      case PostTag.tip:
        color = Colors.orange.shade100;
        icon = Icons.lightbulb;
        label = 'Tip';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GlassmorphicContainer(
        blur: 10,
        borderRadius: 20,
        color: isSelected ? Colors.green.shade200 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Colors.green.shade900 : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? Colors.green.shade900 : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
