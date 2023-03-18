import 'dart:async';
import 'package:flutter/material.dart';

import 'route_manager.dart';

class Navigation extends StatefulWidget {
	final Alignment? end;
	final Alignment? begin;
	final List<Color>? bgColors;
	final Color? selectedColor;
	final Color? hoverColor;
	final Color? textColor;
	final Color? hoverTextColor;
	final double? fontSize;
	final FontWeight? fontWeight;
	final BuildContext? parentContext;
	
	final String type;

	final Widget? header;
	final Map<String, Map<String, dynamic>> routes;

	final NavigationStreamer navStreamer;

	const Navigation({
		Key? key,
		this.selectedColor,
		this.hoverColor,
		this.textColor,
		this.hoverTextColor,
		this.fontSize,
		this.fontWeight,
		this.bgColors,
		this.begin,
		this.end,

		this.header,
		this.parentContext,
		this.type='standard',
		
		required this.routes,
		required this.navStreamer
	}) : super(key: key);

	@override
	NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {

	BuildContext? currentContext;

	Widget _buildNavigation(BuildContext context){
		currentContext = context;

		return RouteManager(
			type: widget.type,
			routes: widget.routes,
			bgColors: widget.bgColors,
			header: widget.header,
			hoverColor: widget.hoverColor,
			selectedColor: widget.selectedColor,
			textColor: widget.textColor,
			hoverTextColor: widget.hoverTextColor,
			fontSize: widget.fontSize,
			fontWeight: widget.fontWeight,
			navStreamer: widget.navStreamer,
			end: widget.end,
			begin: widget.begin,
		);
	}

	@override
	Widget build(BuildContext context) => _buildNavigation(context);
}

class NavigationStreamer {
	
	Function()? onDone;
	Function? onError;
	// ignore: close_sinks
	StreamController<Map<String, dynamic>>? _controller;

	NavigationStreamer({this.onDone, this.onError}){
		_controller = StreamController.broadcast();
	}



	StreamController? get controller => _controller;
	Stream? get stream => _controller!.stream;

	StreamSubscription listen(Function listenCallback){
		StreamSubscription sub = _controller!.stream.distinct().listen(
			(data){
				listenCallback(data);
			},
			onError: onError ?? (err){
			},
			cancelOnError: false,
			onDone: onDone ?? (){
			}
		);

		return sub;
	}

	void close(){
		_controller!.close();
		// _controller!.sink.close();
	}
}