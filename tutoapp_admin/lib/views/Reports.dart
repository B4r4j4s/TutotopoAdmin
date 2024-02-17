import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes', style: title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Column(children: [
          Row(
            children: [
              ReportMenuOpt(onPressed: () {}, text: 'Citas'),
              ReportMenuOpt(onPressed: () {}, text: 'Historico'),
              ReportMenuOpt(onPressed: () {}, text: 'Estadisticas'),
              ReportMenuOpt(onPressed: () {}, text: 'Soporte')
            ],
          ),
          const Divider(),
          const Expanded(
              child: Placeholder(
            color: Colors.blueAccent,
            child: Text('Reportesss'),
          ))
        ]),
      ),
    );
  }

  final TextStyle title = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w600,
  );
}

class ReportMenuOpt extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final bool isPressed;

  ReportMenuOpt({
    required this.onPressed,
    required this.text,
    this.borderRadius = 0.0,
    this.isPressed = false,
  });

  @override
  _ReportMenuOptState createState() => _ReportMenuOptState();
}

class _ReportMenuOptState extends State<ReportMenuOpt> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        fillColor: widget.isPressed
            ? Colors.orange
            : isHovered
                ? Colors.orange.withOpacity(0.1)
                : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
            bottomLeft: Radius.circular(widget.borderRadius),
            bottomRight: Radius.circular(widget.borderRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
