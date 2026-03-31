import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/services/dashboard_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    super.key,
    this.service,
  });

  final DashboardService? service;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late final DashboardService _service;
  late Future<DashboardModel> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? DashboardService();
    _dashboardFuture = _service.fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: FutureBuilder<DashboardModel>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load community posts.'),
            );
          }

          final posts = snapshot.data!.communityPosts;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _CommunityHeader(),
              const SizedBox(height: 20),
              const _CategoryRow(),
              const SizedBox(height: 20),
              const _CreatePostCard(),
              const SizedBox(height: 20),
              ...posts.map(_CommunityPostCard.new),
            ],
          );
        },
      ),
    );
  }
}

class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.yellowTint,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A calm parent community',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Read experiences, ask questions, and share practical daily support.',
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _CategoryChip(label: 'Communication'),
        _CategoryChip(label: 'Behavior'),
        _CategoryChip(label: 'Daily life'),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CreatePostCard extends StatelessWidget {
  const _CreatePostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Post',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Text('Text or voice message'),
          SizedBox(height: 8),
          Text('Example: My child doesn’t eat well, any advice?'),
        ],
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard(this.post);

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.warmYellow,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    post.authorName.substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        post.category.replaceAll('_', ' '),
                        style: const TextStyle(color: AppColors.softCoral),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            const SizedBox(height: 12),
            const Row(
              children: [
                _PostAction(label: 'Like'),
                SizedBox(width: 16),
                _PostAction(label: 'Comment'),
                SizedBox(width: 16),
                _PostAction(label: 'Reply'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  const _PostAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.softBlue,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
