import 'package:flutter/material.dart';
import 'package:flutter_drawing_app/core/theme/app_color.dart';
import 'package:flutter_drawing_app/model/drawing_point_model.dart';
import 'package:flutter_drawing_app/screen/custom_drawing_painter.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.pink,
    Colors.orange,
    Colors.cyan,
    Colors.teal
  ];

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentDrawingPoint = DrawingPoint(
                  id: DateTime.now().microsecondsSinceEpoch,
                  offsets: [details.localPosition],
                  color: selectedColor,
                  width: selectedWidth,
                );
                if (currentDrawingPoint == null) return;
                drawingPoints.add(currentDrawingPoint!);
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentDrawingPoint == null) return;
                currentDrawingPoint = currentDrawingPoint?.copyWith(
                  offsets: currentDrawingPoint!.offsets
                    ..add(details.localPosition),
                );
                drawingPoints.last = currentDrawingPoint!;
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanEnd: (_) {
              currentDrawingPoint = null;
            },
            child: CustomPaint(
              painter: DrawingPainter(
                drawingPoints: drawingPoints,
              ),
              child: SizedBox(
                height: height,
                width: width,
              ),
            ),
          ),

          // for color selection
          Positioned(
            top: MediaQuery.paddingOf(context).top,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: avaiableColor.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = avaiableColor[index];
                      });
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: avaiableColor[index],
                        shape: BoxShape.circle,
                      ),
                      foregroundDecoration: BoxDecoration(
                        border: selectedColor == avaiableColor[index]
                            ? Border.all(color: AppColor.primaryColor, width: 4)
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // for slider
          Positioned(
            top: MediaQuery.paddingOf(context).top + 20,
            right: 0,
            bottom: 80,
            child: RotatedBox(
              quarterTurns: 3, // 270 deggrees
              child: Slider(
                value: selectedWidth,
                min: 1,
                max: 20,
                onChanged: (val) {
                  setState(() {
                    selectedWidth = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Undo",
            onPressed: () {
              if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                setState(() {
                  drawingPoints.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "Redo",
            onPressed: () {
              setState(() {
                if (drawingPoints.length < historyDrawingPoints.length) {
                  final index = drawingPoints.length;
                  drawingPoints.add(historyDrawingPoints[index]);
                }
              });
            },
            child: const Icon(Icons.redo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "New",
            onPressed: () {
              if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                setState(() {
                  drawingPoints.clear();
                });
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
