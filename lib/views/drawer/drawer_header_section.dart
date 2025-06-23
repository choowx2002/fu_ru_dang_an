import 'package:flutter/material.dart';
// import 'package:fu_ru_dang_an/data/notifiers.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(color: isDark ? Colors.white : Colors.black87, width: 3.0),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/2.jpg',
                      width: 72.0,
                      height: 72.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Text("choowx"),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: GestureDetector(
        //     onTap: () => isDark.value = !isDark.value,
        //     child: ValueListenableBuilder(
        //       valueListenable: isDark,
        //       builder: (_, isDark, __) => Padding(
        //         padding: const EdgeInsets.all(8),
        //         child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
