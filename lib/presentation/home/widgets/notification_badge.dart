import 'package:flutter/material.dart';

class NotificationBadge extends StatefulWidget {
  final int count;
  final Widget child;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Tăng thời gian để nhẹ nhàng hơn
      vsync: this,
    );

    // Giảm hiệu ứng pulse từ 1.3 xuống 1.1 để ít che khuất hơn
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Chỉ nhấp nháy khi có thông báo (count > 0)
    if (widget.count > 0) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Cập nhật animation khi count thay đổi
    if (widget.count > 0 && oldWidget.count == 0) {
      // Bắt đầu nhấp nháy khi có lịch hẹn mới
      _animationController.repeat(reverse: true);
    } else if (widget.count == 0 && oldWidget.count > 0) {
      // Dừng nhấp nháy khi không còn lịch hẹn
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Icon chính - luôn hiển thị bình thường
        widget.child,
        // Badge - chỉ hiển thị khi có thông báo
        if (widget.count > 0)
          Positioned(
            right: -6, // Điều chỉnh vị trí để không che icon
            top: -6,   // Điều chỉnh vị trí để không che icon
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 3,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      widget.count > 99 ? '99+' : '${widget.count}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
