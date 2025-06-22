import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/domain/disease/entities/disease.dart';

import '../bloc/disease_species_cubit.dart';
import '../bloc/disease_species_state.dart';

class DiseaseSpecies extends StatefulWidget {
  final String species;
  final Function(int diseaseId, String? diseaseName)? onDiseaseSelected;

  const DiseaseSpecies({
    super.key,
    required this.species,
    this.onDiseaseSelected,
  });

  @override
  State<DiseaseSpecies> createState() => _DiseaseSpeciesState();
}

class _DiseaseSpeciesState extends State<DiseaseSpecies> {
  int? selectedDiseaseId;
  String? selectedDiseaseName;

  late DiseaseSpeciesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DiseaseSpeciesCubit();
    // Đặt lại trạng thái đã chọn về null khi khởi tạo
    selectedDiseaseId = null;
    selectedDiseaseName = null;
    _loadDiseases();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _loadDiseases() {
    _cubit.getDiseaseBySpecies(widget.species.toLowerCase() == 'chó' ? 'dog' : 'cat');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DiseaseSpeciesCubit, DiseaseSpeciesState>(
        builder: (context, state) {
          if (state is DiseaseSpeciesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DiseaseSpeciesLoaded) {
            if (state.diseases.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Không tìm thấy thông tin bệnh cho loài ${widget.species}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Replace Column with a more appropriate layout
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 200, // Subtract space for headers, etc.
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Important to avoid flex overflow
                children: [
                  const Text(
                    'Danh sách bệnh',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.diseases.length,
                      itemBuilder: (context, index) {
                        final disease = state.diseases[index];
                        // Sử dụng logic dựa trên disease.diseaseId một cách nhất quán
                        final isSelected = disease.diseaseId == null
                            ? (selectedDiseaseName != null && disease.name == selectedDiseaseName)
                            : (selectedDiseaseId != null && disease.diseaseId == selectedDiseaseId);

                        return _buildDiseaseCard(
                          disease: disease,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              // SỬA LỖI: Cập nhật state để hiển thị đúng trạng thái đã chọn
                              // Đảm bảo luôn set giá trị mới, kể cả khi double click
                              selectedDiseaseId = disease.diseaseId;
                              selectedDiseaseName = disease.name;
                            });
                            // Thêm dòng này để log trạng thái, giúp debug nếu cần
                            debugPrint('Selected disease: ${disease.name}, ID: ${disease.diseaseId}');
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildConfirmButton(state.diseases),
                ],
              ),
            );
          }

          if (state is DiseaseSpeciesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadDiseases,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Unexpected state'),
          );
        },
      ),
    );
  }

  Widget _buildDiseaseCard({
    required DiseaseEntity disease,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Chỉ khi isSelected = true (người dùng đã chọn bệnh) thì mới hiển thị style đặc biệt
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      elevation: isSelected ? 4 : 1, // Tăng độ nổi khi được chọn
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor  // Viền màu primary khi được chọn
              : Colors.transparent,             // Viền trong suốt khi chưa chọn
          width: isSelected ? 2 : 0,            // Độ rộng viền = 0 khi chưa chọn
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      disease.name ?? 'Không có tên bệnh',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Theme.of(context).primaryColor  // Màu chữ primary khi được chọn
                            : Colors.black87,                 // Màu chữ thường khi chưa chọn
                      ),
                    ),
                  ),
                  // Chỉ hiển thị biểu tượng tích khi được chọn
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                ],
              ),
              // Hiển thị thông tin triệu chứng nếu có
              if (disease.symptoms != null && disease.symptoms!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mô tả: ${disease.description}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              // Hiển thị thông tin điều trị nếu có
              if (disease.treatment != null && disease.treatment!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Điều trị: ${disease.treatment}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              // Chỉ hiển thị badge "Đã chọn" khi thực sự đã chọn
              if (isSelected) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    // Sửa lại cách sử dụng withValues với tham số alpha thay vì opacity
                    color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Đã chọn',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(List<DiseaseEntity> diseases) {
    // Sửa logic kiểm tra đã chọn để hoạt động cả khi selectedDiseaseId là null
    // nhưng đã có selectedDiseaseName
    final bool hasSelection = selectedDiseaseId != null || selectedDiseaseName != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Hiển thị thông báo nếu chưa chọn bệnh
        if (!hasSelection) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                'Vui lòng chọn một bệnh để tiếp tục',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: hasSelection
                ? () {
                    if (widget.onDiseaseSelected != null) {
                      // Truyền đúng diseaseId từ bệnh đã chọn, không thay thế bằng giá trị mặc định
                      widget.onDiseaseSelected!(selectedDiseaseId!, selectedDiseaseName);
                    }
                    Navigator.pop(context, {
                      'diseaseId': selectedDiseaseId, // Giữ nguyên giá trị của diseaseId, kể cả khi là null
                      'diseaseName': selectedDiseaseName,
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasSelection)
                  const Icon(Icons.check_circle_outline, size: 20),
                if (hasSelection)
                  const SizedBox(width: 8),
                Text(
                  hasSelection ? 'Xác nhận' : 'Vui lòng chọn bệnh',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
