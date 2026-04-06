part of '../pages.dart';

class TextFieldCustom extends StatefulWidget {
  final int? maxLength;
  final String hintText;
  final String lebel;
  final bool obscureText;
  final bool icon;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double cursorHeight;
  final Color cursorColor;
  final double borderRadius;
  final Color fillColor;
  final Color hintColor;
  final bool filled;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool onlyNumbers;
  final BorderSide borderSide;
  final BorderSide? focusedBorderSide;
  final BorderSide? enabledBorderSide;
  final BorderSide? errorBorderSide;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final FormFieldValidator<String>? validator;
  final bool? enable;
  final VoidCallback? onTap;
  final ScrollPhysics? scroll;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool denyWhitespace;

  const TextFieldCustom({
    super.key,
    this.maxLength,
    required this.hintText,
    required this.lebel,
    this.obscureText = false,
    this.icon = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.controller,
    this.focusNode,
    required this.cursorHeight,
    this.cursorColor = Colors.white,
    this.borderRadius = 10.0,
    this.fillColor = Colors.white,
    this.hintColor = Colors.white,
    this.filled = true,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.onlyNumbers = false,
    this.borderSide = BorderSide.none,
    this.focusedBorderSide,
    this.enabledBorderSide,
    this.errorBorderSide,
    this.suffixIcon,
    this.prefixIcon,
    this.minLines,
    this.maxLines,
    this.contentPadding,
    this.validator,
    this.enable = true,
    this.onTap,
    this.scroll,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.denyWhitespace = false,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant TextFieldCustom oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isObscure = _obscureText;

    return TextFormField(
      scrollPhysics: widget.scroll,
      onTap: widget.onTap,
      enabled: widget.enable,
      validator: widget.validator,
      minLines: isObscure ? 1 : (widget.minLines ?? 1),
      maxLines: isObscure ? 1 : widget.maxLines,
      style: const TextStyle(),
      cursorHeight: widget.cursorHeight,
      cursorColor: widget.cursorColor,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscureText: isObscure,
      readOnly: widget.readOnly,
      controller: widget.controller,
      onChanged: widget.onChanged,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
        if (widget.onlyNumbers)
          FilteringTextInputFormatter.digitsOnly,
        if (widget.denyWhitespace)
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.lebel.isNotEmpty ? widget.lebel : null,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor,
          fontSize: 12,
        ),
        contentPadding:
        widget.contentPadding ?? const EdgeInsets.only(left: 12),
        filled: widget.filled,
        fillColor: widget.fillColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: widget.focusedBorderSide ??
              const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: widget.enabledBorderSide ??
              const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:
          widget.errorBorderSide ?? const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide:
          widget.errorBorderSide ?? const BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: widget.borderSide,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ??
            (widget.obscureText
                ? IconButton(
              icon: Icon(
                size: 20,
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null),
      ),
    );
  }
}