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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
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
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.loadingProgress.description != null) Text(widget.loadingProgress.description!),
                  const SizedBox(width: 10),
                  if (widget.loadingProgress.progress != null) Text(secondaryProgress),
                ],
              ),
            ],
          );
        }
      ),
      actions: [
        AnimatedBuilder(
          animation: widget.loadingProgress,
          builder: (context, child) {
            if (widget.loadingProgress.finished) {
              return okButton(context);
            }
            else {
              return const SizedBox.square(dimension:0);
            }
          }
        )
      ],
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
  int _actualValue = 0;
  int _maxValue = -1;
  String? _description;
  bool _finished = false;

  double? get progress => _progress;
  int get actualValue => _actualValue;
  int get maxValue => _maxValue;
  String? get description => _description;
  bool get finished => _finished;

  void initialize(int maxValue, [String? description]) {
    if (_maxValue != -1) throw StateError("Already Initialized");
    if (_finished) throw StateError("Loading progress already finished");
    if (maxValue < 1) throw ArgumentError.value(
      maxValue, 
      "maxValue", 
      "Must be greater than 1"
    );
    if (description == "") throw ArgumentError.value(
      description,
      "actualItem",
      "Can not be empty"
    );
    _actualValue = actualValue;
    _maxValue = maxValue;
    _progress = _actualValue / _maxValue;
    _description = description;
    notifyListeners();
  }

  void update(int actualValue) {
    if (_maxValue == -1) throw StateError("LoadingProgress not initialized yet");
    if (_finished) throw StateError("Loading progress already finished");
    if (actualValue > maxValue || actualValue < 1) {
      throw ArgumentError.value(
        actualValue,
        "actualValue",
        "Must not be less than one or greater than maxValue which is: $maxValue"
      );
    }
    if (actualValue == _actualValue) {
      return;
    }
    _actualValue = actualValue;
    _progress = _actualValue / maxValue;
    notifyListeners();
  }

  void forward() {
    update(actualValue + 1);
  }

  void reset() {
    _progress = null;
    _description = "";
    _actualValue = 0;
    _maxValue = -1;
    notifyListeners();
  }

  void finish() {
    if (_finished) throw StateError("Loading progress already finished");
    _finished = true;
  }
}