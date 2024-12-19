class EmojiBean{
  String icon;
  int reward;
  bool? hasKey;
  EmojiBean({
    required this.icon,
    required this.reward,
    this.hasKey,
});
}