import 'package:flutter/widgets.dart';
import '../navigation.dart';

class WindowSwitcher {
	
	String routeName;
	NavigationStreamer navStreamer;
	Map<String, Map<String, dynamic>> routes;

	WindowSwitcher({
		required this.routes,
		required this.routeName,
		required this.navStreamer,
	});

	Widget switcher(){

		Map<String, dynamic> selectedWidget = {
			'routeName': routeName,
			'window': routes[routeName]!['window'],
			'hoverColor': routes[routeName]!['hoverColor'],
			'selectedColor': routes[routeName]!['selectedColor'],
		};

		navStreamer.controller!.sink.add(selectedWidget);

		return routes[routeName]!['window'];
	}
}