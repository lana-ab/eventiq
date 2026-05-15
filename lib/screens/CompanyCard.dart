import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final VoidCallback? onTap; // ✅ عشان نقدر نسمع للضغط

  const CompanyCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.onTap, // ✅ اختياري
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ صار يشتغل الضغط
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.4),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(Uri.encodeFull(imageUrl)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            _rowRating(),
          ],
        ),
      ),
    );
  }

  Widget _rowRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, size: 20, color: Colors.amber);
        } else if (index < rating && rating - index >= 0.5) {
          return const Icon(Icons.star_half, size: 20, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 20, color: Colors.amber);
        }
      }),
    );
  }
}
