ToastService.md

ToastService (Enhanced Version)

نسخة محسنة من ToastService بدون أي باكدج، تعمل على Flutter باستخدام Overlay.
تدعم Singleton، ToastType، Icons، Animation Fade+Slide، وقابلة للاختبار.


---

1️⃣ IToastService (Interface)

import 'package:flutter/material.dart';

abstract class IToastService {
  void show(
    BuildContext context, {
    required String message,
    ToastType type,
    Duration duration,
  });
}


---

2️⃣ ToastType Enum

enum ToastType { success, error, warning, info }


---

3️⃣ ToastService Implementation

import 'package:flutter/material.dart';

class ToastService implements IToastService {
  ToastService._internal();
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;

  OverlayEntry? _overlayEntry;

  @override
  void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _removeCurrentToast();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    Color bgColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = Colors.green.withOpacity(0.85);
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        bgColor = Colors.red.withOpacity(0.85);
        icon = Icons.error;
        break;
      case ToastType.warning:
        bgColor = Colors.orange.withOpacity(0.85);
        icon = Icons.warning;
        break;
      case ToastType.info:
      default:
        bgColor = Colors.blue.withOpacity(0.85);
        icon = Icons.info;
        break;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          message: message,
          backgroundColor: bgColor,
          icon: icon,
        );
      },
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(duration, () => _removeCurrentToast());
  }

  void _removeCurrentToast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 60,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


---

4️⃣ طريقة الاستخدام

final toast = ToastService();

// رسالة نجاح
toast.show(
  context,
  message: "تم الحفظ بنجاح!",
  type: ToastType.success,
);

// رسالة خطأ
toast.show(
  context,
  message: "حدث خطأ، حاول مرة أخرى",
  type: ToastType.error,
);

// تحذير
toast.show(
  context,
  message: "البيانات غير مكتملة",
  type: ToastType.warning,
);

// معلومات
toast.show(
  context,
  message: "جارٍ التحميل…",
  type: ToastType.info,
);


---

5️⃣ مميزات النسخة المحسنة

Singleton → نفس الخدمة في كل المشروع

Testable → باستخدام IToastService يمكن عمل Mock

ToastType → لتغيير اللون تلقائيًا

Icon لكل نوع رسالة

Animation Fade + Slide

بدون أي باكدج



---

6️⃣ ملاحظات

يمكن تعديل مكان Toast (bottomMargin) حسب الحاجة

يمكن تغيير مدة العرض (duration) لكل رسالة

Animation سلسة وجميلة على كل الأجهزة
