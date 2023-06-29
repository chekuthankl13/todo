import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/config/config.dart';
import 'package:todo/utils/utils.dart';

BottomAppBar btmnav(BuildContext context,
    {required String txt, required void Function()? fun}) {
  return BottomAppBar(
      height: 70,
      surfaceTintColor: Config.white,
      child: ElevatedButton(
        onPressed: fun,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(sW(context) / 2, 30),
            backgroundColor: Config.baseClr,
            foregroundColor: Config.white),
        child: Text(txt),
      ));
}

BottomAppBar btmnavLoading(
  BuildContext context,
) {
  return BottomAppBar(
      height: 70,
      surfaceTintColor: Config.white,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            fixedSize: Size(sW(context) / 2, 30),
            backgroundColor: Config.baseClr,
            foregroundColor: Config.white),
        child: const CupertinoActivityIndicator(color: Config.white),
      ));
}

Column fields({
  required txt,
  required TextEditingController? controller,
  isread = false,
  isNote = false,
  void Function()? onTap,
  IconData? ic,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      spaceHeight(10),
      Text(
        txt,
        style: const TextStyle(
            color: Config.txtClr, fontWeight: FontWeight.w500, fontSize: 12),
      ),
      spaceHeight(5),
      TextFormField(
        controller: controller,
        readOnly: isread ? true : false,
        maxLines: isNote ? 5 : 1,
        onTap: isread ? onTap : null,
        decoration: InputDecoration(
            labelText: txt,
            suffixIcon: isread
                ? Icon(
                    ic,
                    color: Config.baseClr,
                  )
                : null,
            labelStyle:
                TextStyle(color: Colors.grey.withOpacity(.5), fontSize: 11),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            isDense: true,
            filled: true,
            fillColor: Config.white),
      )
    ],
  );
}

/////////// date picker

startDatePicker(BuildContext context, TextEditingController cntr) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDatePickerMode: DatePickerMode.day,
    initialDate: DateTime.now(), // Refer step 1
    firstDate: DateTime.now(),
    lastDate: DateTime(2025),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Config.baseClr),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  log(picked.toString());
  if (picked != null) {
    log(picked.toString());
    cntr.text = picked.toString().split(" ")[0];
  }
}

//////////// time picker

startTimePicker(BuildContext context, TextEditingController cntr) async {
  TimeOfDay? pickedTime = await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  );

  if (pickedTime != null) {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    String formattedTime = DateFormat('hh:mm a').format(selectedDateTime);
    print(formattedTime); // Output: 12:37:00
    cntr.text = formattedTime;
  } else {
    print("Time is not selected");
  }
}

///////// toast

errorToast(context, {required error}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(5),
      ),
    );
