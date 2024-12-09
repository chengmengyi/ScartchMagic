class Play8Bean{
  String icon;
  int reward;
  bool is8;
  Play8Bean({
    required this.icon,
    required this.reward,
    required this.is8,
});

  @override
  String toString() {
    return 'Play8Bean{icon: $icon, reward: $reward, is8: $is8}';
  }
}