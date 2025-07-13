import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../bloc/change_password_cubit.dart';
import '../bloc/change_password_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state.status == ChangePasswordStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage ?? 'Đổi mật khẩu thành công'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).pop();
            } else if (state.status == ChangePasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return _buildResponsiveLayout(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, ChangePasswordState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: isDesktop
              ? _buildDesktopLayout(context, state)
              : isTablet
                  ? _buildTabletLayout(context, state)
                  : _buildMobileLayout(context, state),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ChangePasswordState state) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Row(
          children: [
            // Left side - Information panel
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security_rounded,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bảo mật tài khoản',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thay đổi mật khẩu thường xuyên để bảo vệ tài khoản của bạn khỏi các mối đe dọa bảo mật.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildSecurityTips(),
                  ],
                ),
              ),
            ),
            // Right side - Form
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.all(24),
                child: _buildForm(context, state, true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ChangePasswordState state) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
                     MediaQuery.of(context).viewInsets.bottom -
                     MediaQuery.of(context).padding.top -
                     kToolbarHeight,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 48,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bảo mật tài khoản',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Đổi mật khẩu để bảo vệ tài khoản của bạn',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Form section
                  Expanded(
                    child: _buildScrollableForm(context, state, false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ChangePasswordState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
                     MediaQuery.of(context).viewInsets.bottom -
                     MediaQuery.of(context).padding.top -
                     kToolbarHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bảo mật tài khoản',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Đổi mật khẩu để bảo vệ tài khoản của bạn',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Form
              Expanded(
                child: _buildScrollableForm(context, state, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ChangePasswordState state, bool isDesktop) {
    return _buildScrollableForm(context, state, isDesktop);
  }

  Widget _buildScrollableForm(BuildContext context, ChangePasswordState state, bool isDesktop) {
    final spacing = isDesktop ? 32.0 : 24.0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Old Password Field
          _buildPasswordField(
            controller: _oldPasswordController,
            label: 'Mật khẩu hiện tại',
            hintText: 'Nhập mật khẩu hiện tại',
            isVisible: _isOldPasswordVisible,
            onVisibilityToggle: () {
              setState(() {
                _isOldPasswordVisible = !_isOldPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu hiện tại';
              }
              return null;
            },
            isDesktop: isDesktop,
          ),

          SizedBox(height: spacing),

          // New Password Field
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'Mật khẩu mới',
            hintText: 'Nhập mật khẩu mới',
            isVisible: _isNewPasswordVisible,
            onVisibilityToggle: () {
              setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu mới';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
            isDesktop: isDesktop,
          ),

          SizedBox(height: spacing),

          // Confirm Password Field
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Xác nhận mật khẩu mới',
            hintText: 'Nhập lại mật khẩu mới',
            isVisible: _isConfirmPasswordVisible,
            onVisibilityToggle: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu mới';
              }
              if (value != _newPasswordController.text) {
                return 'Mật khẩu xác nhận không khớp';
              }
              return null;
            },
            isDesktop: isDesktop,
          ),

          SizedBox(height: spacing),

          // Password Requirements
          _buildPasswordRequirements(isDesktop),

          SizedBox(height: isDesktop ? 40 : 32),

          // Change Password Button
          SizedBox(
            width: double.infinity,
            height: isDesktop ? 72 : 64,
            child: ElevatedButton(
              onPressed: state.status == ChangePasswordStatus.loading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ChangePasswordCubit>().changePassword(
                              oldPassword: _oldPasswordController.text.trim(),
                              newPassword: _newPasswordController.text.trim(),
                              confirmPassword: _confirmPasswordController.text.trim(),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                ),
                elevation: 3,
                shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
              child: state.status == ChangePasswordStatus.loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: isDesktop ? 24 : 16),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isDesktop ? 12 : 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          style: TextStyle(fontSize: isDesktop ? 16 : 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: isDesktop ? 16 : 14,
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[400],
              size: isDesktop ? 24 : 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[400],
                size: isDesktop ? 24 : 20,
              ),
              onPressed: onVisibilityToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 20 : 16,
              vertical: isDesktop ? 20 : 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: isDesktop ? 20 : 16,
              ),
              SizedBox(width: isDesktop ? 12 : 8),
              Text(
                'Yêu cầu mật khẩu:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                  fontSize: isDesktop ? 16 : 14,
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          _buildRequirement('Ít nhất 6 ký tự', isDesktop),
          _buildRequirement('Khác với mật khẩu hiện tại', isDesktop),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.only(top: isDesktop ? 8 : 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green[600],
            size: isDesktop ? 18 : 14,
          ),
          SizedBox(width: isDesktop ? 12 : 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isDesktop ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTips() {
    return Column(
      children: [
        _buildSecurityTip(
          Icons.timer,
          'Thay đổi định kỳ',
          'Đổi mật khẩu mỗi 3-6 tháng',
        ),
        const SizedBox(height: 16),
        _buildSecurityTip(
          Icons.security,
          'Mật khẩu mạnh',
          'Sử dụng ký tự đặc biệt và số',
        ),
        const SizedBox(height: 16),
        _buildSecurityTip(
          Icons.visibility_off,
          'Bảo mật',
          'Không chia sẻ với người khác',
        ),
      ],
    );
  }

  Widget _buildSecurityTip(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
