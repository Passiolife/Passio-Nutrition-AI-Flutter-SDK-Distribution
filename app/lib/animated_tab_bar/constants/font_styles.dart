part of animated_segment;

/// [AnimatedSegmentAppFontStyles] class have all the static and const members.
/// Here, we have defined used TextStyle inside the package.
class AnimatedSegmentAppFontStyles {
  static const TextStyle textNormal = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: AnimatedSegmentDimens.textNormal,
    color: AnimatedSegmentAppColors.primary,
    overflow: TextOverflow.ellipsis,
  );
}
