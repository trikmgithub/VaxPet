import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/customer_profile/bloc/customer_profile_cubit.dart';

import '../bloc/customer_profile_state.dart';
import '../widgets/customer_profile.dart';

class CustomerProfilePage extends StatelessWidget {
  final int? accountId;
  const CustomerProfilePage({super.key, this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CustomerProfileCubit()..getCustomerProfile(accountId!),
      child: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
        builder: (context, state) {
          if (state is CustomerProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomerProfileLoaded) {
            return CustomerProfile(customerProfile: state.customerProfile);
          }

          if (state is CustomerProfileError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return Container();
        },
      ),
    );
  }
}
