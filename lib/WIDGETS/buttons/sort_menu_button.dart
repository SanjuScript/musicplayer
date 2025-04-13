import 'package:flutter/material.dart';
import 'package:music_player/EXTENSION/capitalizer.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import '../../HELPER/sort_enum.dart';

class SortOptionDialog extends StatelessWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption> onSelected;

  const SortOptionDialog({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: SortOption.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final option = SortOption.values[index];
                final title = _getTitleForSortOption(option);

                return GestureDetector(
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: selectedOption == option
                          ? Colors.deepPurple[400]
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        title.capitalize(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'rounder',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).cardColor),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getTitleForSortOption(SortOption option) {
    switch (option) {
      case SortOption.atitle:
        return "Name A-z";
      case SortOption.ztitle:
        return "Name Z-a";
      case SortOption.aartist:
        return "Artist A-z";
      case SortOption.zartist:
        return "Artist Z-a";
      case SortOption.aduration:
        return "Smallest Duration";
      case SortOption.zduaration:
        return "Largest Duration";
      case SortOption.adate:
        return "Newest Date First";
      case SortOption.zdate:
        return "Oldest Date First";
      case SortOption.afileSize:
        return "Largest File First";
      case SortOption.zfileSize:
        return "Smallest File First";
    }
  }
}
