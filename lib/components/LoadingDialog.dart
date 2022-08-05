import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({
    Key? key,
    required this.loadingProgress,
    required this.title,
    this.description
  }) : super(key: key);

  final LoadingProgress loadingProgress;
  final String title;
  final String? description;

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.loadingProgress.progress == 1) {
      _controller.animateTo(
        1,
        duration: Duration(milliseconds: 0),
      );
    }
    else {
      widget.loadingProgress.addListener(() {
        double? progress = widget.loadingProgress.progress;
        if (progress != null) {
          _controller.animateTo(
            progress,
            curve: Curves.easeOutQuad
          );
        }
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double? progress = widget.loadingProgress.progress;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: progress == null ? null : _controller.value,
                color: Color.fromRGBO(56, 100, 132, 1),
                backgroundColor: Color.fromRGBO(56, 100, 132, 0.75),
              ),
              SizedBox(height: 10),
              if (widget.loadingProgress.progress != null) Text(secondaryProgress),
              SizedBox(height: 10),
              if (widget.loadingProgress.progress == 1) okButton(context)
            ],
          );
        }
      )
    );
  }

  TextButton get abortButton => TextButton(
    onPressed: () {}, 
    child: Text("Abort")
  );

  TextButton okButton(BuildContext context) => TextButton(
    onPressed: () => Navigator.of(context).pop(), 
    child: Text("OK")
  );

  String get secondaryProgress {
    int percentage = ((widget.loadingProgress.progress ?? 0) * 100).round(); 
    return "$percentage %";
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    widget.loadingProgress.dispose();
  }
}

class LoadingProgress extends ChangeNotifier{

  double? _progress;
  String _actualItem = "";
  int _actualValue = 0;
  int _maxValue = -1;

  double? get progress => _progress;
  String get actualItem => _actualItem;
  int get actualValue => _actualValue;
  int get maxValue => _maxValue;

  void initialize(int maxValue, [String? actualItem, int? actualValue]) {
    if (_maxValue != -1) throw StateError("Already Initialized");
    if (maxValue <= 1) throw ArgumentError.value(
      maxValue, 
      "maxValue", 
      "Must be greater than 1"
    );
    if (actualItem == "") throw ArgumentError.value(
      actualItem,
      "actualItem",
      "Can not be empty"
    );
    if (actualValue != null) {
      if (actualValue <= 1 || actualValue > maxValue) {
        throw ArgumentError.value(
          actualValue, 
          "actualValue", 
          "Must not be less than one and greater than maxValue which is: $maxValue");
      }
      _actualValue = actualValue;
    }
    _maxValue = maxValue;
    if (actualItem != null) _actualItem = actualItem;
    _progress = _actualValue / _maxValue;
    notifyListeners();
  }

  void update(String actualItem, int actualValue) {
    if (_maxValue == -1) throw StateError("LoadingProgress not initialized yet");
    if (actualValue > maxValue || actualValue < 1) {
      throw ArgumentError.value(
        actualValue,
        "actualValue",
        "Must not be less than one or greater than maxValue which is: $maxValue"
      );
    }
    if (actualItem == _actualItem && actualValue == _actualValue) {
      return;
    }
    _actualItem = actualItem;
    _actualValue = actualValue;
    _progress = _actualValue / maxValue;
    notifyListeners();
  }

  void reset() {
    _progress = null;
    _actualItem = "";
    _actualValue = 0;
    _maxValue = -1;
  }
}