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

  void updateBodyTypeOnGenderChange(String newGender) {
    List<String> options = getBodyTypeOptions(newGender);
    if (!options.contains(bodyType)) {
      bodyType = options.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigate to avatar selection screen'),
                  ),
                );
                // final result = await Navigator.push<File?>(
                //   context,
                //   MaterialPageRoute(builder: (context) => ImagePickerScreen()),
                // );

                // if (result != null) {
                //   setState(() {
                //     _profileImage = result;
                //   });
                // }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: _profileImage != null
                    //     ? FileImage(_profileImage!)
                    //     : AssetImage('assets/avatar.png') as ImageProvider,
                    backgroundImage:
                        AssetImage('assets/avatar.png') as ImageProvider,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text(
              "Jerry Wilson",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("+1 000-000-0000", style: TextStyle(color: Colors.grey)),

            SizedBox(height: 20),
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
              final selected = await _showOptionsDialog(
                "Select Body Type",
                options,
              );
              if (selected != null) setState(() => bodyType = selected);
            }),

            SizedBox(height: 20),
            _sectionTitle("Select Skin Tone"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(skinTones.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedSkin = index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: selectedSkin == index
                          ? Border.all(width: 2)
                          : null,
                      color: skinTones[index],
                      shape: BoxShape.circle,
                    ),
                    width: 32,
                    height: 32,
                  ),
                );
              }),
            ),

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

            _sectionTitle("Select Color Palette"),
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(colorPalette.length, (index) {
                    final isSelected = selectedColors.contains(index);
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
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
                              width: isSelected ? 3 : 0,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            color: colorPalette[index],
                          ),
                          width: 32,
                          height: 32,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            _chipSection(
              "Select Undertone",
              ["Cold", "Neutral", "Warm"],
              {selectedUndertone},
              singleSelection: true,
              onSelect: (val) => setState(() => selectedUndertone = val),
            ),

            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              label: Text(
                "Get Curated Results",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Color(0xFFF1ECE7),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          spacing: 10,
          children: options.map((option) {
            final isSelected =
                selected.contains(option) || selected.firstOrNull == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) {
                if (singleSelection && onSelect != null) {
                  onSelect(option);
                } else {
                  toggleSelection(selected, option);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<String?> _showOptionsDialog(String title, List<String> options) {
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: options
            .map(
              (option) => SimpleDialogOption(
                child: Text(option),
                onPressed: () => Navigator.pop(context, option),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<int?> _showNumberInputDialog(String title, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "Enter value"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
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
}
