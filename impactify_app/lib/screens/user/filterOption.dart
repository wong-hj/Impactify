import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/tag.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class FilterOptions extends StatefulWidget {
  final Function(String, List<String>, List<String>) onApplyFilters;
  final String selectedFilter;
  final List<String> selectedTags;
  final List<String> selectedTagIDs;
  
  FilterOptions({
    required this.onApplyFilters,
    required this.selectedFilter,
    required this.selectedTags,
    required this.selectedTagIDs,
  });

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String _selectedFilter = 'All';
  List<String> _selectedTags = [];
  List<String> _selectedTagIDs = [];
  

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
    _selectedTags = List.from(widget.selectedTags);
    _selectedTagIDs = List.from(widget.selectedTagIDs);
     WidgetsBinding.instance.addPostFrameCallback((_) {
      
      Provider.of<EventProvider>(context, listen: false).fetchAllTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final List<Tag> tags = eventProvider.tags;

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Filter by Type',
              style: GoogleFonts.nunito(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Column(
            children: ['All', 'Project', 'Speech'].map((String filter) {
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
              final bool isSelected = _selectedTags.contains(tag.name);
              return ChoiceChip(
                label: Text(tag.name,
                    style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : AppColors.primary)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {

                    if(isSelected) {
                      _selectedTags.remove(tag.name);
                      _selectedTagIDs.remove(tag.tagID);
                    } else {
                      _selectedTagIDs.add(tag.tagID);
                      _selectedTags.add(tag.name);
                    }

                    // isSelected
                    //     ? _selectedTags.remove(tag.name)
                    //     : _selectedTags.add(tag.name);
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
              widget.onApplyFilters(_selectedFilter, _selectedTags, _selectedTagIDs);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
