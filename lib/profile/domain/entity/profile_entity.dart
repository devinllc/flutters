class ProfileEntity {
  final String name;
  final String username;
  final String profilePictureUrl;
  final String? bio;
  final String? instagramUrl;
  final String? tiktokUrl;
  final String? website;
  final int followerCount;
  final int followingCount;
  final int postCount;

  ProfileEntity({
    required this.name,
    required this.username,
    required this.profilePictureUrl,
    this.bio,
    this.instagramUrl,
    this.tiktokUrl,
    this.website,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      name: json['name'],
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
      bio: json['bio'],
      instagramUrl: json['instagram_url'],
      tiktokUrl: json['tiktok_url'],
      website: json['website'],
      followerCount: json['follower_count'],
      followingCount: json['following_count'],
      postCount: json['post_count'],
    );
  }
}
