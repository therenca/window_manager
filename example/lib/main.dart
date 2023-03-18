import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;
import 'package:window_manager/window_manager.dart' as wm;

void main() {
  runApp(MaterialApp(
		debugShowCheckedModeBanner: true,
		title: 'Window Manager',
		theme: ThemeData(
			primarySwatch: Colors.orange,
		),
		home: const Shell()
	));
}


class Shell extends StatefulWidget {
	const Shell({Key? key}) : super(key: key);
  @override
  ShellState createState() => ShellState();
}

class ShellState extends State<Shell>{

  Widget? selectedWidget;
  late wm.NavigationStreamer mainNavStreamer;
  late StreamSubscription mainNavStreamSubscription;

  @override
  void initState(){
    super.initState();
    mainNavStreamer = wm.NavigationStreamer();

    mainNavStreamSubscription = mainNavStreamer.listen((data){
      aqua.pretifyOutput('[SHELL] data from nav stream: $data');

      selectedWidget = data['window'];
      setState((){});
    });
  }

  @override
  void dispose(){
    mainNavStreamSubscription.cancel();
    mainNavStreamer.close();
    super.dispose();
  }

  Widget _buildShell(BuildContext context){
    Map<String, Map<String, dynamic>> generatedRoutes = _buildGeneratedRoutes();

    return Scaffold(
      appBar: null,
      body: aqua.DynamicDimensions(
				renderWidget: (double width, double height){
					return SizedBox(
						width: width,
						height: height,
						child: Row(
							children: [
								Expanded(
									child: wm.Navigation(
										header: Container(
											height: 100.0,
											color: Colors.red,
											child: const Center(
												child: Text(
													'Header',
													style: TextStyle(
														color: Colors.white,
														fontWeight: FontWeight.bold
													),
												),
											),
										),
										routes: generatedRoutes,
										bgColors: const <Color>[
											Colors.blue,
											Colors.blueAccent
										],
										hoverColor: Colors.brown.withOpacity(0.5),
										selectedColor: Colors.white.withOpacity(0.5),
										navStreamer: mainNavStreamer,
									),
								),

								Expanded(
									flex: 6,
									child: selectedWidget == null ? aqua.requestFocus(
										generatedRoutes['Home']!['window'],
										context
									) : aqua.requestFocus(
										selectedWidget!,
										context
									)
								),
							]
						),
					);
				},
			)
    );
  }

  @override
  Widget build(BuildContext context) => _buildShell(context);

  Map<String, Map<String, dynamic>> _buildGeneratedRoutes(){
    buildIconHelper (IconData iconData){
      return Icon(iconData, color: Colors.black, size: 15.0,);
    }

		buildWindow (String name, double width, double height, Color color){
			return Container(
				width: width,
				height: height,
				color: color,
				child: Center(
					child: Text(
						name,
						style: const TextStyle(
							fontSize: 30.0,
							color: Colors.white,
							fontWeight: FontWeight.bold
						),
					),
				),
			);
		}

    return {
      'Home': {
        'window': aqua.DynamicDimensions(
          renderWidget: (double width, double height){
            return buildWindow('Home', width, height, Colors.purple);
          }
        ),
        'icon': buildIconHelper(Icons.home)
      },
      'Search': {
        'window': aqua.DynamicDimensions(
          renderWidget: (double width, double height){
            return buildWindow('Search', width, height, Colors.red);
					}
        ),
        'icon': buildIconHelper(Icons.search)
      },
      'Settings': {
        'window': aqua.DynamicDimensions(
          renderWidget: (double width, double height){
            return buildWindow('Settings', width, height, Colors.blue);
          }
        ),
        'icon': buildIconHelper(Icons.settings)
      }
    };
  }
}
