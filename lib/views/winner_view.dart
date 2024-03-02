import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WinnerCard extends StatelessWidget {
  final VoidCallback onPressedCallback;

  const WinnerCard({super.key, required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(
        child: Card(
          child: SizedBox(
            height: size.height * 0.8,
            width: size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/winner.gif'),
                Text(
                  "Objetivo Encontrado",
                  style: GoogleFonts.greatVibes(fontSize: 60),
                ),
                TextButton.icon(
                  onPressed: onPressedCallback,
                  icon: const Icon(Icons.restart_alt),
                  label: Text(
                    "Reiniciar",
                    style: GoogleFonts.koHo(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
