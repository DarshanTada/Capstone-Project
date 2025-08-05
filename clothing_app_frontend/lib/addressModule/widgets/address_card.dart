import 'package:flutter/material.dart';
import '../model/address_model.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final bool isSelected;
  final bool showActions;
  final bool isSelectionMode;

  const AddressCard({
    super.key,
    required this.address,
    this.onEdit,
    this.onDelete,
    this.onSelect,
    this.isSelected = false,
    this.showActions = true,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isSelected 
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFD2B193).withOpacity(0.15),
                const Color(0xFFB8956A).withOpacity(0.1),
              ],
            )
          : null,
        color: isSelected ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isSelected 
              ? const Color(0xFFB8956A).withOpacity(0.25)
              : Colors.black.withOpacity(0.08),
            blurRadius: isSelected ? 16 : 12,
            offset: const Offset(0, 4),
            spreadRadius: isSelected ? 2 : 0,
          ),
        ],
        border: Border.all(
          color: isSelected 
            ? const Color(0xFFB8956A).withOpacity(0.4)
            : const Color(0xFFD2B193).withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xFFD2B193).withOpacity(0.15),
          highlightColor: const Color(0xFFB8956A).withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header with type and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getTypeColor(address.type),
                            _getTypeColor(address.type).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _getTypeColor(address.type).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTypeIcon(address.type),
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            address.typeDisplayName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showActions)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2B193).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onEdit != null)
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: onEdit,
                                  icon: const Icon(Icons.edit_rounded),
                                  iconSize: 20,
                                  color: const Color(0xFFB8956A),
                                  tooltip: 'Edit Address',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),
                              ),
                            if (onDelete != null)
                              Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: onDelete,
                                  icon: const Icon(Icons.delete_rounded),
                                  iconSize: 20,
                                  color: const Color(0xFF8D5524),
                                  tooltip: 'Delete Address',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Enhanced Full name with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2B193).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: const Color(0xFFB8956A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        address.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3440),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Enhanced Address details with better styling
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2B193).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFD2B193).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _getTypeColor(address.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: _getTypeColor(address.type),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address.houseNumber} ${address.address}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E3440),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFD2B193).withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${address.city}, ${address.province} ${address.zip}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF8D5524),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Enhanced Selection indicator
                if (isSelected) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD2B193).withOpacity(0.15),
                          const Color(0xFFB8956A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFB8956A).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8956A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Currently Selected',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFB8956A),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Add selection button when in selection mode
                if (isSelectionMode && onSelect != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onSelect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected 
                          ? const Color(0xFFB8956A) 
                          : const Color(0xFFD2B193),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isSelected ? 4 : 2,
                      ),
                      icon: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 20,
                      ),
                      label: Text(
                        isSelected ? 'Selected' : 'Select This Address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    // Using warm brown/beige theme to match preference screen
    switch (type.toLowerCase()) {
      case 'home':
        return const Color(0xFFB8956A); // Warm brown
      case 'work':
        return const Color(0xFFD2B193); // Light beige
      case 'friend':
        return const Color(0xFFC68642); // Medium brown
      case 'other':
        return const Color(0xFF8D5524); // Darker brown
      default:
        return const Color(0xFFB8956A); // Default warm brown
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.business_rounded;
      case 'friend':
        return Icons.people_rounded;
      case 'other':
        return Icons.place_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
