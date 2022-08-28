import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/services/DateTimeFormatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class _NewTextField extends StatefulWidget {
  final double widthRatio;
  final String labelText;
  final String? content;
  final void Function()? onTap;
  final double fontSize;
  final bool enabled;
  final bool readOnly;
  final TextEditingController? controller;
  final IconData icon;

  _NewTextField({
    this.widthRatio = 0.85,
    required this.labelText,
    this.content,
    this.enabled = true,
    this.fontSize = 15,
    this.onTap,
    this.readOnly = true,
    this.controller,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  _NewTextFieldState createState() => _NewTextFieldState();
}

class _NewTextFieldState extends State<_NewTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.widthRatio,
      child: TextFormField(
        enableInteractiveSelection: false,
        onTap: widget.onTap,
        controller: widget.controller,
        initialValue: widget.content,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        style: TextStyle(
          height: 1.5,
            fontSize: widget.fontSize,
            color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Transform.scale(
            child: Icon(widget.icon),
            scale: 0.5,
          ),
          prefixIconConstraints: BoxConstraints.tightFor(width: 30),
          contentPadding: const EdgeInsets.all(5),
          enabled: widget.enabled,
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

class NewDateField extends StatefulWidget {

  final void Function() onTap;
  NewDateField({required this.onTap});

  @override
  _NewDateFieldState createState() => _NewDateFieldState();
}

class _NewDateFieldState extends State<NewDateField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsCubit, TransactionDetails>(
      buildWhen: (previous, current) {
        return previous.date != current.date;
      },
      builder: (context, state) {
        return _NewTextField(
          key: ObjectKey(state.date),
          labelText: AppLocalizations.of(context)!.date,
          widthRatio: 0.3,
          onTap: widget.onTap,
          content: state.date?.format(),
          icon: FontAwesomeIcons.clock,
        );
      },
    );
  }

  
}

class NewRepetitionDateField extends StatelessWidget {

  final void Function() onTap;
  final String content ;
  final bool enabled ;

  NewRepetitionDateField({
    required this.content,
    required this.onTap,
    required this.enabled
  });

  @override
  Widget build(BuildContext context) {
    return _NewTextField(
      key: ValueKey(content),
      enabled: enabled,
      labelText: AppLocalizations.of(context)!.endDate,
      widthRatio: 0.5,
      onTap: onTap,
      content: content,
      icon: FontAwesomeIcons.repeat
    );
  }
}

class NewAccountField extends StatefulWidget {
  
  final void Function() onTap;
  NewAccountField({required this.onTap, Key? key}) : super(key: key);

  @override
  _NewAccountFieldState createState() => _NewAccountFieldState();
}

class _NewAccountFieldState extends State<NewAccountField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsCubit, TransactionDetails>(
      buildWhen: (previous, current) => previous.account != current.account,
      builder: (context, state) {
        return _NewTextField(
          key: ObjectKey(state.account),
          labelText: AppLocalizations.of(context)!.account,
          onTap: widget.onTap,
          widthRatio: 0.5,
          content: state.account.toString(),
          icon: FontAwesomeIcons.creditCard
        );
      },
    );
  }
}

class NewRepetitionField extends StatefulWidget {
  
  final void Function() onTap;
  NewRepetitionField({required this.onTap});

  @override
  _NewRepetitionFieldState createState() => _NewRepetitionFieldState();
}

class _NewRepetitionFieldState extends State<NewRepetitionField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsCubit, TransactionDetails>(
      buildWhen: (previous, current) => previous.repetition != current.repetition,
      builder: (context, state) {
        return _NewTextField(
          key: ObjectKey(state.repetition),
          labelText: AppLocalizations.of(context)!.repetition,
          onTap: widget.onTap,
          content: state.repetition!.toLocalizedString(context),
          icon: FontAwesomeIcons.repeat
        );
      },
    );
  }
}

class NewTitleTextField extends StatefulWidget {

  final void Function(TextEditingController controller) setTitleController;

  const NewTitleTextField({
    Key? key, 
    required this.setTitleController}) : super(key: key);

  @override
  State<NewTitleTextField> createState() => _NewTitleTextFieldState();
}

class _NewTitleTextFieldState extends State<NewTitleTextField> {
  
  final TextEditingController controller = TextEditingController();
  late final TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);

  @override
  void initState() { 
    widget.setTitleController(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionDetailsCubit, TransactionDetails>(
      listener: (context, state) {
        if (state.name != controller.text) {
          if (state.name != null) controller.text = state.name!;
        }
      },
      child : SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextField(
          enableInteractiveSelection: false,
          controller: controller,
          onTap: () {
            KeyboardWidget.of(context)?.triggerKeyboard(false);
          },
          onChanged: (name) {
            TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
            cubit.projectDetails(cubit.state.copyWith(
              name: name
            ));
          },
          style: TextStyle(
            height: 1.5,
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            prefixIcon: Transform.scale(
            child: Icon(FontAwesomeIcons.pen),
            scale: 0.5,
            ),
            prefixIconConstraints: BoxConstraints.tightFor(width: 30),
            contentPadding: const EdgeInsets.all(5),
            enabled: true,
            labelText: "Name",
            labelStyle: TextStyle(fontSize: 15),
            border: OutlineInputBorder(
            )
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}


