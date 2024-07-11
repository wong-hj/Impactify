import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';

class FilterOptions extends StatefulWidget {
  final Function(String, List<String>) onApplyFilters;
  final String selectedFilter;
  final List<String> selectedTags;

  FilterOptions({
    required this.onApplyFilters,
    required this.selectedFilter,
    required this.selectedTags,
  });

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String _selectedFilter = 'All';
  List<String> _selectedTags = [];

  final List<String> tags = [
    'Tag1',
    'Tag2',
    'Tag3',
    'Tag4',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _selectedTags = List.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Filter by Type',
              style: GoogleFonts.nunito(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Column(
            children: ['All', 'Events', 'Speeches'].map((String filter) {
              return RadioListTile(
                title: Text(filter),
                value: filter,
                activeColor: AppColors.primary,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value.toString();
                  });
                },
              );
            }).toList(),
          ),
          Divider(),
          Text('Filter by Tags',
              style: GoogleFonts.nunito(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            children: tags.map((tag) {
              final bool isSelected = _selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag,
                    style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : AppColors.primary)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    isSelected
                        ? _selectedTags.remove(tag)
                        : _selectedTags.add(tag);
                  });
                },
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
          SizedBox(height: 40),
          CustomPrimaryButton(
            text: 'Apply Filters',
            onPressed: () {
              widget.onApplyFilters(_selectedFilter, _selectedTags);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
