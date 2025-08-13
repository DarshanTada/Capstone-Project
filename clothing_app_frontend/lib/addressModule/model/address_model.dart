class Address {
  final String? id;
  final String type;
  final String fullName;
  final String houseNumber;
  final String address;
  final String city;
  final String zip;
  final String province;
  final String userId;

  Address({
    this.id,
    required this.type,
    required this.fullName,
    required this.houseNumber,
    required this.address,
    required this.city,
    required this.zip,
    required this.province,
    required this.userId,
  });

  // Convert JSON to Address object
  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        type: json['type']?.toString() ?? '',
        fullName: json['full_name']?.toString() ?? '',
        houseNumber: json['house_number']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        zip: json['zip']?.toString() ?? '',
        province: json['provience']?.toString() ?? json['province']?.toString() ?? '', // Note: backend has typo 'provience'
        userId: json['userId']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing address JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Convert Address object to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'type': type,
      'full_name': fullName,
      'house_number': houseNumber,
      'address': address,
      'city': city,
      'zip': zip,
      'provience': province, // Using backend's typo for compatibility
      'userId': userId,
    };
  }

  // Create copy with modified values
  Address copyWith({
    String? id,
    String? type,
    String? fullName,
    String? houseNumber,
    String? address,
    String? city,
    String? zip,
    String? province,
    String? userId,
  }) {
    return Address(
      id: id ?? this.id,
      type: type ?? this.type,
      fullName: fullName ?? this.fullName,
      houseNumber: houseNumber ?? this.houseNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      province: province ?? this.province,
      userId: userId ?? this.userId,
    );
  }

  // Get formatted full address
  String get fullAddress {
    return '$houseNumber $address, $city, $province $zip';
  }

  // Get display name for address type
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'home':
        return 'Home';
      case 'work':
        return 'Work';
      case 'friend':
        return 'Friend';
      case 'other':
        return 'Other';
      default:
        return type;
    }
  }

  @override
  String toString() {
    return 'Address(id: $id, type: $type, fullName: $fullName, fullAddress: $fullAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Constants for address types and provinces
class AddressConstants {
  static const List<String> addressTypes = [
    'home',
    'work',
    'friend',
    'other',
  ];

  static const List<String> provinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Nova Scotia',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Northwest Territories',
    'Nunavut',
    'Yukon',
  ];

  // City mappings for each province/territory
  static const Map<String, List<String>> provinceCities = {
    'Alberta': [
      'Calgary',
      'Edmonton',
      'Red Deer',
      'Lethbridge',
      'Medicine Hat',
      'Grande Prairie',
      'Airdrie',
      'Spruce Grove',
      'Okotoks',
      'Cochrane',
    ],
    'British Columbia': [
      'Vancouver',
      'Victoria',
      'Surrey',
      'Burnaby',
      'Richmond',
      'Abbotsford',
      'Coquitlam',
      'Kelowna',
      'Saanich',
      'Delta',
    ],
    'Manitoba': [
      'Winnipeg',
      'Brandon',
      'Steinbach',
      'Thompson',
      'Portage la Prairie',
      'Winkler',
      'Selkirk',
      'Morden',
      'Dauphin',
      'The Pas',
    ],
    'New Brunswick': [
      'Saint John',
      'Moncton',
      'Fredericton',
      'Dieppe',
      'Riverview',
      'Miramichi',
      'Edmundston',
      'Rothesay',
      'Quispamsis',
      'Bathurst',
    ],
    'Newfoundland and Labrador': [
      'St. John\'s',
      'Mount Pearl',
      'Corner Brook',
      'Conception Bay South',
      'Bay Roberts',
      'Grand Falls-Windsor',
      'Happy Valley-Goose Bay',
      'Gander',
      'Paradise',
      'Labrador City',
    ],
    'Nova Scotia': [
      'Halifax',
      'Sydney',
      'Dartmouth',
      'Truro',
      'New Glasgow',
      'Glace Bay',
      'Sydney Mines',
      'Yarmouth',
      'Kentville',
      'Amherst',
    ],
    'Ontario': [
      'Toronto',
      'Ottawa',
      'Mississauga',
      'Brampton',
      'Hamilton',
      'London',
      'Markham',
      'Vaughan',
      'Kitchener',
      'Windsor',
      'Richmond Hill',
      'Oakville',
      'Burlington',
      'Oshawa',
      'Barrie',
      'St. Catharines',
      'Cambridge',
      'Waterloo',
      'Guelph',
      'Kingston',
    ],
    'Prince Edward Island': [
      'Charlottetown',
      'Summerside',
      'Stratford',
      'Cornwall',
      'Montague',
      'Kensington',
      'Souris',
      'Alberton',
      'Tignish',
      'Georgetown',
    ],
    'Quebec': [
      'Montreal',
      'Quebec City',
      'Laval',
      'Gatineau',
      'Longueuil',
      'Sherbrooke',
      'Lévis',
      'Saguenay',
      'Trois-Rivières',
      'Terrebonne',
      'Saint-Jean-sur-Richelieu',
      'Repentigny',
      'Boucherville',
      'Saint-Jérôme',
      'Châteauguay',
    ],
    'Saskatchewan': [
      'Saskatoon',
      'Regina',
      'Prince Albert',
      'Moose Jaw',
      'Swift Current',
      'Yorkton',
      'North Battleford',
      'Estevan',
      'Weyburn',
      'Lloydminster',
    ],
    'Northwest Territories': [
      'Yellowknife',
      'Hay River',
      'Inuvik',
      'Fort Smith',
      'Behchokò',
      'Aklavik',
      'Fort Simpson',
      'Norman Wells',
      'Tuktoyaktuk',
      'Enterprise',
    ],
    'Nunavut': [
      'Iqaluit',
      'Rankin Inlet',
      'Arviat',
      'Baker Lake',
      'Igloolik',
      'Pond Inlet',
      'Kugluktuk',
      'Pangnirtung',
      'Gjoa Haven',
      'Cape Dorset',
    ],
    'Yukon': [
      'Whitehorse',
      'Dawson City',
      'Watson Lake',
      'Haines Junction',
      'Mayo',
      'Faro',
      'Carmacks',
      'Pelly Crossing',
      'Teslin',
      'Old Crow',
    ],
  };

  static List<String> getCitiesForProvince(String province) {
    return provinceCities[province] ?? [];
  }

  static String getTypeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return 'Home';
      case 'work':
        return 'Work';
      case 'friend':
        return 'Friend';
      case 'other':
        return 'Other';
      default:
        return type;
    }
  }
}
