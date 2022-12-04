part of 'custom_marker_map_widget.dart';

class _MarkerGenerator extends StatefulWidget {
  final List<MarkerWidget> markerWidgets;
  final ValueChanged<List<Marker>> callbackAction;
  const _MarkerGenerator(
      {Key? key, required this.markerWidgets, required this.callbackAction})
      : super(key: key);

  @override
  State<_MarkerGenerator> createState() => _MarkerGeneratorState();
}

class _MarkerGeneratorState extends State<_MarkerGenerator> {
  List<GlobalKey> globalKeys = [];

  @override
  void initState() {
    super.initState();
    globalKeys =
        widget.markerWidgets.map((e) => GlobalKey()).toList(growable: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => onBuildCompleted());
  }

  Future<void> onBuildCompleted() async {
    final markers =
        await Future.wait(globalKeys.map((key) => _convertToMarker(key)));
    widget.callbackAction(markers);
  }

  Future<Marker> _convertToMarker(GlobalKey key) async {
    final widgetMarker = widget.markerWidgets[globalKeys.indexOf(key)].marker;
    return Marker(
      onTap: widgetMarker.onTap,
      markerId: widgetMarker.markerId,
      position: widgetMarker.position,
      icon: await _widgetToIcon(key),
    );
  }

  static Future<BitmapDescriptor> _widgetToIcon(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        -MediaQuery.of(context).size.width * 2,
        -MediaQuery.of(context).size.height * 2,
      ),
      child: Stack(children: [
        /// Loop for generate each unique price widget for marker
        for (var i = 0; i < widget.markerWidgets.length; i++)
          RepaintBoundary(
            key: globalKeys[i],
            child: widget.markerWidgets[i].widget,
          ),
      ]),
    );
  }
}
