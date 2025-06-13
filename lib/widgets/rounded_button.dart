import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.white,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.normalBtnLabel,
    this.elevation,
    this.shadowColor,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    Key? key,
  }) : super(key: key);

  const RoundedButton.primary({
    required this.label,
    required this.onPressed,
    this.elevation = 3,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.primaryBtnLabel,
    Key? key,
  })  : color = BrandColors.primary,
        shadowColor = Colors.black,
        super(key: key);

  const RoundedButton.primaryDark({
    required this.label,
    required this.onPressed,
    this.elevation,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.primaryBtnLabel,
    Key? key,
  })  : color = BrandColors.primaryDark,
        shadowColor = Colors.black,
        super(key: key);

  const RoundedButton.secondary({
    required this.label,
    required this.onPressed,
    this.elevation,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.secondaryBtnLabel,
    Key? key,
  })  : color = MainColors.mildGray,
        shadowColor = null,
        super(key: key);

  const RoundedButton.negative({
    required this.label,
    required this.onPressed,
    this.elevation,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.negativeBtnLabel,
    Key? key,
  })  : color = Colors.white,
        shadowColor = null,
        super(key: key);

  final String label;
  final Function() onPressed;

  final Color color;
  final TextStyle textStyle;

  final double? elevation;
  final Color? shadowColor;
  final Size? minimumSize;
  final Size? maximumSize;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        visualDensity: visualDensity,
        backgroundColor: color,
        surfaceTintColor: color,
        shape: shape,
        padding: padding,
      ),
      child: Text(label, style: textStyle, textAlign: TextAlign.center),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = Colors.pink,
    this.shape = const StadiumBorder(),
    this.textStyle = TextStyles.primaryBtnLabel,
    this.elevation = 3,
    this.shadowColor,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.visualDensity,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function() onPressed;
  final Icon icon;

  final Color color;
  final TextStyle textStyle;

  final double? elevation;
  final Color? shadowColor;
  final Size? minimumSize;
  final Size? maximumSize;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label, style: textStyle),
      icon: icon,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        visualDensity: visualDensity,
        backgroundColor: color,
        surfaceTintColor: color,
        shape: shape,
        padding: padding,
      ),
    );
  }
}

class RoundTranslucentButton extends StatelessWidget {
  const RoundTranslucentButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = MainColors.dullBlackOpaque,
    this.blur,
    super.key,
  });

  final Color backgroundColor;
  final Color iconColor;
  final Widget icon;
  final VoidCallback onPressed;
  final ImageFilter? blur;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: blur ?? ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: backgroundColor.withOpacity(0.9),
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
