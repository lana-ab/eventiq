import 'package:flutter/material.dart';
import 'package:untitled2/eventservices/serviceModel.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: service.image != null && service.image!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(
                    'http://10.0.2.2:8000/storage/${service.image}',
                  ),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (service.image == null || service.image!.isEmpty)
                  ? const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                ),
              )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.serviceName,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A3C9A),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            service.serviceDescription,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${service.serviceQuantity}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Text(
                '\$${service.servicePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3C9A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}