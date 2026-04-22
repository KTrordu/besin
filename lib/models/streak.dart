class StreakData {
  final int currentStreak;
  final int longestStreak;

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
      };

  factory StreakData.fromJson(Map<String, dynamic> json) => StreakData(
        currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
        longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      );
}
