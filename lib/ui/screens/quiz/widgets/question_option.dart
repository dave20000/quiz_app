import 'package:flutter/material.dart';
import 'package:quiz_app/ui_helper.dart';

class QuestionOption extends StatefulWidget {
  final int optionNumber;
  final String? optionValue;
  final bool isSelected;
  final void Function(int) selectOption;
  final void Function(int) deSelectOption;
  const QuestionOption({
    Key? key,
    required this.optionNumber,
    required this.optionValue,
    required this.isSelected,
    required this.selectOption,
    required this.deSelectOption,
  }) : super(key: key);

  @override
  State<QuestionOption> createState() => _QuestionOptionState();
}

class _QuestionOptionState extends State<QuestionOption> {
  @override
  Widget build(BuildContext context) {
    return widget.optionValue == null
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              if (widget.isSelected) {
                widget.deSelectOption(widget.optionNumber);
              } else {
                widget.selectOption(widget.optionNumber);
              }
            },
            child: AnimatedContainer(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: UIHelper.mainThemeColor,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: UIHelper.mainThemeColor.withOpacity(0.4),
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: const Offset(-1, 1),
                  ),
                ],
                color: widget.isSelected
                    ? UIHelper.mainThemeColor.withOpacity(0.8)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: widget.isSelected,
                    checkColor: UIHelper.mainThemeColor,
                    activeColor: Colors.white,
                    side: BorderSide(
                      color: UIHelper.mainThemeColor,
                      width: 2,
                    ),
                    onChanged: (value) {
                      if (widget.isSelected) {
                        widget.deSelectOption(widget.optionNumber);
                      } else {
                        widget.selectOption(widget.optionNumber);
                      }
                    },
                  ),
                  UIHelper.horizontalDividerSmall(),
                  Expanded(
                    child: Text(
                      widget.optionValue!,
                      style: TextStyle(
                        color: widget.isSelected ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          );
  }
}
