import 'package:flutter/material.dart';

class ArtisteCard extends StatelessWidget {
  const ArtisteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x32000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/cover.jpg',
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: const [
                Expanded(
                  child: Text(
                      'Nom artiste',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF242424),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: const [
                Expanded(
                  child: Text(
                      'Origine : 123 disney Way, Willingmington, WV, 20492',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF57636C),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Icon(
                    Icons.star_rounded,
                    color: Colors.yellowAccent,
                    size: 24,
                  ),
                  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Text(
                      '4/5',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Text(
                      'Vote',
                      style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF8B97A2),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
