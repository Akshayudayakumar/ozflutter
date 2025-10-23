class MenuItem {
  late String id;
  late String title;
  late String icon;
  late String route;

  // Default constructor for the MenuItem class.
  MenuItem(
      {required this.id,
      required this.title,
      required this.icon,
      required this.route});

  // Named constructor to create a MenuItem from a JSON map.
  MenuItem.fromJson(Map<String, dynamic> json) {
    // Assigns the 'id' from the JSON map to the id property.
    id = json['id'];
    // Assigns the 'title' from the JSON map to the title property.
    title = json['title'];
    // Assigns the 'icon' from the JSON map to the icon property.
    icon = json['icon'];
    // Assigns the 'route' from the JSON map to the route property.
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['route'] = route;
    return data;
  }
}
