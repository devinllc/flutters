import 'package:assign/profile/presentation/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch profile once after the build phase
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    // Check if profile has already been fetched
    if (profileProvider.profile == null) {
      // Delay the fetchProfile call to avoid calling it during the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileProvider.fetchProfile(widget.username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }

        final profile = provider.profile;
        if (profile == null) {
          return Center(child: Text('No profile data available'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(profile.name),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.profilePictureUrl),
                ),
                SizedBox(height: 16),
                Text('Name: ${profile.name}', style: TextStyle(fontSize: 18)),
                Text('Username: ${profile.username}',
                    style: TextStyle(fontSize: 16)),
                Text('Bio: ${profile.bio ?? 'No bio'}',
                    style: TextStyle(fontSize: 16)),
                Text('Followers: ${profile.followerCount}',
                    style: TextStyle(fontSize: 16)),
                Text('Following: ${profile.followingCount}',
                    style: TextStyle(fontSize: 16)),
                Text('Posts: ${profile.postCount}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Links:', style: TextStyle(fontSize: 18)),
                Text('Instagram: ${profile.instagramUrl}',
                    style: TextStyle(fontSize: 16)),
                Text('Tiktok: ${profile.tiktokUrl}',
                    style: TextStyle(fontSize: 16)),
                Text('Website: ${profile.website}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
