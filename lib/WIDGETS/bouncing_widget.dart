import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BouncableEffect extends StatefulWidget {
  final Widget child;
  final bool onDoubletap;
  final SongModel songModel;

  const BouncableEffect({
    super.key,
    required this.child,
    required this.onDoubletap,
    required this.songModel,
  });

  @override
  State<BouncableEffect> createState() => _BouncableEffectState();
}

class _BouncableEffectState extends State<BouncableEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Shorter for smooth effect
      vsync: this,
    );

    // Smooth scaling animation
    _animation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  void onTap() {
    // Simple bounce effect for tap
    _controller.forward().then((_) => _controller.reverse());
  }

  void onLongPress() {
    // Shrink smoothly on long press
    _controller.forward();
  }

  void onLongPressEnd(LongPressEndDetails details) {
    // Return to normal size when finger is lifted
    _controller.reverse();
  }

  void onDoubleTap() {
    // Double-tap favorite functionality
    _controller.forward().then((_) => _controller.reverse());
    if (FavoriteDb.isFavor(widget.songModel)) {
      FavoriteDb.delete(widget.songModel.id);
    } else {
      FavoriteDb.add(widget.songModel);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDoubletap ? null : onTap,
      onDoubleTap: widget.onDoubletap ? onDoubleTap : null,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
