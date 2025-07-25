import 'package:flutter/material.dart';

void main() => runApp(PreferenceScreenApp());

class PreferenceScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PreferenceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PreferenceScreen extends StatefulWidget {
  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String gender = 'Male';
  int age = 24;
  int height = 176;
  String bodyType = 'Ectomorph';

  int selectedSkin = 3;
  Set<String> selectedStyles = {};
  Set<String> selectedOccasions = {};
  Set<String> selectedFestivals = {};
  Set<int> selectedColors = {};
  String selectedUndertone = 'Neutral';

  // App permissions state
  bool notificationsEnabled = true;
  bool locationEnabled = false;
  bool cameraEnabled = true;
  bool storageEnabled = true;
  bool microphoneEnabled = false;

  List<Color> skinTones = [
    Color(0xFFFFE0BD),
    Color(0xFFFFCD94),
    Color(0xFFEAC086),
    Color(0xFFC68642),
    Color(0xFF8D5524),
    Color(0xFF5C4033),
  ];

  List<Color> colorPalette = [
    Colors.red,
    Colors.white,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
    Colors.yellow,
    Colors.green,
    Colors.red,
    Colors.white,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
    Colors.yellow,
    Colors.green,
  ];

  void toggleSelection(Set<String> list, String value) {
    setState(() {
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
    });
  }

  List<String> getBodyTypeOptions(String gender) {
    if (gender == "Male") {
      return ["Ectomorph", "Mesomorph", "Endomorph"];
    } else if (gender == "Female") {
      return [
        "Hourglass",
        "Pear (Triangle)",
        "Apple (Round)",
        "Rectangle (Straight)",
        "Inverted Triangle",
      ];
    } else {
      return ["Slim", "Athletic", "Average", "Heavy"];
    }
  }

  IconData getBodyTypeIcon(String bodyType, String gender) {
    if (gender == "Male") {
      switch (bodyType) {
        case "Ectomorph":
          return Icons.accessibility_new; // Lean figure
        case "Mesomorph":
          return Icons.fitness_center; // Athletic figure
        case "Endomorph":
          return Icons.sports_martial_arts; // Broader/fuller figure
        default:
          return Icons.person;
      }
    } else if (gender == "Female") {
      switch (bodyType) {
        case "Hourglass":
          return Icons.hourglass_bottom; // Hourglass shape
        case "Pear (Triangle)":
          return Icons.change_history; // Triangle shape
        case "Apple (Round)":
          return Icons.circle; // Round shape
        case "Rectangle (Straight)":
          return Icons.crop_portrait; // Rectangle shape
        case "Inverted Triangle":
          return Icons.details; // Inverted triangle
        default:
          return Icons.person;
      }
    } else {
      switch (bodyType) {
        case "Slim":
          return Icons.accessibility_new;
        case "Athletic":
          return Icons.fitness_center;
        case "Average":
          return Icons.person;
        case "Heavy":
          return Icons.sports_martial_arts; // Better representation for fuller figure
        default:
          return Icons.person;
      }
    }
  }

  void updateBodyTypeOnGenderChange(String newGender) {
    List<String> options = getBodyTypeOptions(newGender);
    if (!options.contains(bodyType)) {
      bodyType = options.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    double dH = MediaQuery.of(context).size.height;
    double dW = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Preferences', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined, color: Colors.brown.shade300),
            onPressed: () {
              // Save preferences functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Preferences saved successfully!'),
                  backgroundColor: Color(0xFFB8956A),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
        child: Column(
          children: [
            SizedBox(height: dH * 0.02),
            // Profile Header Card
            Container(
              padding: EdgeInsets.all(dW * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main Profile Content
                  Row(
                    children: [
                      // Avatar Section
                      GestureDetector(
                        onTap: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Navigate to avatar selection screen'),
                              backgroundColor: Color(0xFFB8956A),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: dW * 0.22,
                              height: dW * 0.22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.person, size: 35, color: Colors.white),
                            ),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.edit, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: dW * 0.05),
                      
                      // User Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jerry Wilson",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$gender • $age years",
                                style: TextStyle(
                                  color: Color(0xFFB8956A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Row(
                              children: [
                                Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Text(
                                  "+1 000-000-0000",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dH * 0.008),
                            Row(
                              children: [
                                Icon(Icons.height, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Text(
                                  "$height cm",
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.fitness_center, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    bodyType,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Settings Icon - Positioned at top right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showPermissionsDialog(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD2B193).withOpacity(0.2),
                              Color(0xFFB8956A).withOpacity(0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFD2B193).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          color: Color(0xFFB8956A),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: dH * 0.025),
            
            // Basic Information Card
            _buildSectionCard(
              "Basic Information",
              Icons.person_outline,
              [
                _infoTile("Gender", gender, () async {
                  final selected = await _showOptionsDialog("Select Gender", [
                    "Male",
                    "Female",
                    "Other",
                  ]);
                  if (selected != null) {
                    setState(() {
                      gender = selected;
                      updateBodyTypeOnGenderChange(selected);
                    });
                  }
                }),
                _infoTile("Age", "$age Years", () async {
                  final selected = await _showNumberInputDialog("Enter Age", age);
                  if (selected != null) setState(() => age = selected);
                }),
                _infoTile("Height", "$height cm", () async {
                  final selected = await _showNumberInputDialog(
                    "Enter Height (cm)",
                    height,
                  );
                  if (selected != null) setState(() => height = selected);
                }),
                _infoTile("Body Type", bodyType, () async {
                  final options = getBodyTypeOptions(gender);
                  final selected = await _showBodyTypeDialog(
                    "Select Body Type",
                    options,
                    gender,
                  );
                  if (selected != null) setState(() => bodyType = selected);
                }),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Skin Tone Card
            _buildSectionCard(
              "Skin Tone",
              Icons.palette_outlined,
              [
                SizedBox(height: dH * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(skinTones.length, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedSkin = index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: selectedSkin == index
                              ? Border.all(width: 3, color: Color(0xFFB8956A))
                              : Border.all(width: 2, color: Colors.grey.shade300),
                          color: skinTones[index],
                          shape: BoxShape.circle,
                          boxShadow: selectedSkin == index ? [
                            BoxShadow(
                              color: Color(0xFFB8956A).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ] : [],
                        ),
                        width: 40,
                        height: 40,
                      ),
                    );
                  }),
                ),
                SizedBox(height: dH * 0.01),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Style Preferences Card
            _buildSectionCard(
              "Style Preferences",
              Icons.style_outlined,
              [
                _chipSection("Select Styles", [
                  "Casual",
                  "Formal",
                  "Ethnic",
                  "Party",
                  "Sports",
                ], selectedStyles),
                _chipSection("Select Occasions", [
                  "Daily",
                  "Vacation",
                  "Office",
                  "Festival",
                  "Wedding",
                ], selectedOccasions),
                _chipSection("Select Festivals", [
                  "Christmas",
                  "Diwali",
                  "New Year",
                  "Holi",
                  "Eid",
                ], selectedFestivals),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Color Preferences Card
            _buildSectionCard(
              "Color Preferences",
              Icons.color_lens_outlined,
              [
                SizedBox(height: dH * 0.01),
                Text(
                  "Select Color Palette",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: dH * 0.015),
                Container(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(colorPalette.length, (index) {
                        final isSelected = selectedColors.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedColors.remove(index);
                                } else {
                                  selectedColors.add(index);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: isSelected ? 3 : 2,
                                  color: isSelected
                                      ? Color(0xFFB8956A)
                                      : Colors.grey.shade300,
                                ),
                                color: colorPalette[index],
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: Color(0xFFB8956A).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ] : [],
                              ),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: dH * 0.02),
                _chipSection(
                  "Select Undertone",
                  ["Cold", "Neutral", "Warm"],
                  {selectedUndertone},
                  singleSelection: true,
                  onSelect: (val) => setState(() => selectedUndertone = val),
                ),
              ],
            ),

            SizedBox(height: dH * 0.03),
            
            // Action Button
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Getting curated results...'),
                      backgroundColor: Color(0xFFB8956A),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD2B193),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: dH * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Color(0xFFB8956A).withOpacity(0.4),
                ),
                icon: Icon(Icons.auto_awesome, size: 20),
                label: Text(
                  "Get Curated Results",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: dH * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD2B193).withOpacity(0.2),
                      Color(0xFFB8956A).withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFD2B193).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFFB8956A),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Color(0xFFD2B193).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFD2B193).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB8956A),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFFB8956A),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _chipSection(
    String title,
    List<String> options,
    Set<String> selected, {
    bool singleSelection = false,
    Function(String)? onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected =
                selected.contains(option) || selected.firstOrNull == option;
            return GestureDetector(
              onTap: () {
                if (singleSelection && onSelect != null) {
                  onSelect(option);
                } else {
                  toggleSelection(selected, option);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFB8956A)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xFFB8956A).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Future<String?> _showOptionsDialog(String title, List<String> options) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => 
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Color(0xFFD2B193).withOpacity(0.1),
                title: Text(
                  option,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.pop(context, option),
              ),
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFB8956A)),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showBodyTypeDialog(String title, List<String> options, String gender) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD2B193).withOpacity(0.2),
                    Color(0xFFB8956A).withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFFD2B193).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.accessibility_new,
                color: Color(0xFFB8956A),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) => 
              Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: InkWell(
                  onTap: () => Navigator.pop(context, option),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFD2B193).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFFD2B193).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD2B193).withOpacity(0.2),
                                Color(0xFFB8956A).withOpacity(0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFD2B193).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            getBodyTypeIcon(option, gender),
                            color: Color(0xFFB8956A),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _getBodyTypeDescription(option, gender),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFB8956A),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFB8956A)),
            ),
          ),
        ],
      ),
    );
  }

  String _getBodyTypeDescription(String bodyType, String gender) {
    if (gender == "Male") {
      switch (bodyType) {
        case "Ectomorph":
          return "Lean and tall with fast metabolism";
        case "Mesomorph":
          return "Naturally muscular with broad shoulders";
        case "Endomorph":
          return "Larger bone structure with slower metabolism";
        default:
          return "Select your body type";
      }
    } else if (gender == "Female") {
      switch (bodyType) {
        case "Hourglass":
          return "Balanced bust and hips with defined waist";
        case "Pear (Triangle)":
          return "Hips wider than bust and shoulders";
        case "Apple (Round)":
          return "Fuller midsection with narrower hips";
        case "Rectangle (Straight)":
          return "Similar measurements throughout";
        case "Inverted Triangle":
          return "Shoulders wider than hips";
        default:
          return "Select your body type";
      }
    } else {
      switch (bodyType) {
        case "Slim":
          return "Lean build with minimal curves";
        case "Athletic":
          return "Toned and muscular build";
        case "Average":
          return "Balanced proportions";
        case "Heavy":
          return "Fuller figure with curves";
        default:
          return "Select your body type";
      }
    }
  }

  Future<int?> _showNumberInputDialog(String title, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter value",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFD2B193)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFB8956A), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFD2B193).withOpacity(0.1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD2B193),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD2B193).withOpacity(0.2),
                          Color(0xFFB8956A).withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFFD2B193).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.security_outlined,
                      color: Color(0xFFB8956A),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'App Permissions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPermissionTile(
                      'Notifications',
                      'Receive updates and alerts',
                      Icons.notifications_outlined,
                      notificationsEnabled,
                      (value) => setDialogState(() {
                        setState(() => notificationsEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Location',
                      'Find stores and personalized content',
                      Icons.location_on_outlined,
                      locationEnabled,
                      (value) => setDialogState(() {
                        setState(() => locationEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Camera',
                      'Take photos and scan products',
                      Icons.camera_alt_outlined,
                      cameraEnabled,
                      (value) => setDialogState(() {
                        setState(() => cameraEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Storage',
                      'Save images and preferences',
                      Icons.storage_outlined,
                      storageEnabled,
                      (value) => setDialogState(() {
                        setState(() => storageEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Microphone',
                      'Voice commands and feedback',
                      Icons.mic_outlined,
                      microphoneEnabled,
                      (value) => setDialogState(() {
                        setState(() => microphoneEnabled = value);
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD2B193),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Permissions updated successfully!'),
                        backgroundColor: Color(0xFFB8956A),
                      ),
                    );
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD2B193).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD2B193).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? Color(0xFFD2B193).withOpacity(0.2) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? Color(0xFFB8956A) : Colors.grey.shade500,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFD2B193),
            activeTrackColor: Color(0xFFB8956A).withOpacity(0.3),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
