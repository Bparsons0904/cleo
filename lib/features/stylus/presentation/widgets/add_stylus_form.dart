// lib/features/stylus/presentation/widgets/add_stylus_form.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../data/models/models.dart';

/// Data class for stylus form submission
class StylusFormData {
  final String name;
  final String? manufacturer;
  final int? expectedLifespan;
  final DateTime? purchaseDate;
  final bool active;
  final bool primary;

  StylusFormData({
    required this.name,
    this.manufacturer,
    this.expectedLifespan,
    this.purchaseDate,
    required this.active,
    required this.primary,
  });
}

/// Form widget for adding or editing a stylus
class AddStylusForm extends StatefulWidget {
  /// List of available base model styluses to copy from
  final List<Stylus> availableStyluses;

  /// Initial stylus data for editing (null for new stylus)
  final Stylus? initialStylus;

  /// Callback when form is submitted
  final Function(StylusFormData) onSubmit;

  /// Constructor
  const AddStylusForm({
    Key? key,
    required this.availableStyluses,
    this.initialStylus,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddStylusForm> createState() => _AddStylusFormState();
}

class _AddStylusFormState extends State<AddStylusForm> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _lifespanController = TextEditingController();

  // Form values
  DateTime? _purchaseDate;
  bool _isActive = true;
  bool _isPrimary = false;
  Stylus? _selectedBaseStylusModel;

  @override
  void initState() {
    super.initState();

    // Initialize form with existing stylus data if editing
    if (widget.initialStylus != null) {
      _nameController.text = widget.initialStylus!.name;
      _manufacturerController.text = widget.initialStylus!.manufacturer ?? '';
      _lifespanController.text =
          widget.initialStylus!.expectedLifespan?.toString() ?? '';
      _purchaseDate = widget.initialStylus!.purchaseDate;
      _isActive = widget.initialStylus!.active;
      _isPrimary = widget.initialStylus!.primary;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    _lifespanController.dispose();
    super.dispose();
  }

  // Copy values from the selected base stylus model
  void _copyFromBaseModel(Stylus baseModel) {
    setState(() {
      _nameController.text = baseModel.name;
      _manufacturerController.text = baseModel.manufacturer ?? '';
      _lifespanController.text = baseModel.expectedLifespan?.toString() ?? '';
      // Don't copy purchase date, active or primary status from base model
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialStylus != null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                isEditing ? 'Edit Stylus' : 'Add New Stylus',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Base stylus selection (only for new stylus)
              if (!isEditing && widget.availableStyluses.isNotEmpty) ...[
                const Text(
                  'Copy from existing stylus:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Stylus>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  hint: const Text('Select a stylus'),
                  value: _selectedBaseStylusModel,
                  isExpanded: true,
                  items:
                      widget.availableStyluses.map((stylus) {
                        return DropdownMenuItem<Stylus>(
                          value: stylus,
                          child: Text(stylus.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBaseStylusModel = value;
                      if (value != null) {
                        // Copy values from base model
                        _copyFromBaseModel(value);
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Name field
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Name *',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Manufacturer field
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Manufacturer',
                      controller: _manufacturerController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Expected lifespan field
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Expected Lifespan (hours)',
                      controller: _lifespanController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Please enter a valid number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Purchase date field
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Purchase Date',
                      value: _purchaseDate,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Checkboxes
              Row(
                children: [
                  // Active checkbox
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text(
                        'Active (Working Stylus / In Rotation)',
                      ),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ),
                ],
              ),

              // Primary checkbox
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Primary (default for new plays)'),
                      value: _isPrimary,
                      onChanged: (value) {
                        setState(() {
                          _isPrimary = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ),
                ],
              ),

              // Form actions
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(isEditing ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? DateFormat('MM/dd/yyyy').format(value)
                      : 'mm/dd/yyyy',
                  style: TextStyle(
                    color: value != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create stylus data object
      final stylusData = StylusFormData(
        name: _nameController.text,
        manufacturer:
            _manufacturerController.text.isEmpty
                ? null
                : _manufacturerController.text,
        expectedLifespan:
            _lifespanController.text.isEmpty
                ? null
                : int.tryParse(_lifespanController.text),
        purchaseDate: _purchaseDate,
        active: _isActive,
        primary: _isPrimary,
      );

      // Call onSubmit callback
      widget.onSubmit(stylusData);
    }
  }
}
