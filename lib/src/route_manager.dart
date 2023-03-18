import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'navigation.dart';

class RouteManager extends StatefulWidget {

	final String type;
	final Widget? header;
	final Color? textColor;
	final Color? hoverTextColor;
	final List<Color>? bgColors;
	final Color? selectedColor;
	final Color? hoverColor;
	final double? fontSize;
	final FontWeight? fontWeight;
	final NavigationStreamer navStreamer;
	final Map<String, Map<String, dynamic>> routes;

	final Alignment? begin;
	final Alignment? end;

	RouteManager({
		required this.routes,
		required this.navStreamer,
		Key? key,
		this.type='standard',
		this.selectedColor,
		this.hoverColor,
		this.textColor,
		this.hoverTextColor,
		this.fontSize,
		this.fontWeight,
		this.header,
		this.bgColors,
		this.begin,
		this.end
	}) : super (key: key){
		routes.forEach((routeName, routeInfo){
			routeInfo['isHovering'] = false;
			routeInfo['hoverColor'] = hoverColor;
			routeInfo['selectedColor'] = selectedColor;
		});
	}

	@override
	RouteManagerState createState() => RouteManagerState();

}

class RouteManagerState extends State<RouteManager>{

	@override
	void initState(){
		super.initState();

	}

	Widget _buildRouteManager(BuildContext context){
		return SideBar(
			end: widget.end,
			begin: widget.begin,
			type: widget.type,
			routes: widget.routes,
			header: widget.header,
			bgColors: widget.bgColors,
			navStreamer: widget.navStreamer,
			selectedColor: widget.selectedColor,
			textColor: widget.textColor,
			hoverTextColor: widget.hoverTextColor,
			fontSize: widget.fontSize,
			fontWeight: widget.fontWeight,
		);
	}

	@override
	Widget build(BuildContext context) => _buildRouteManager(context);
}
