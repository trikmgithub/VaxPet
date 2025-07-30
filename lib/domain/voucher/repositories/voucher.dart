import 'package:dartz/dartz.dart';

abstract class VoucherRepository {
  //Get
  Future<Either> getAllVouchers(Map<String, dynamic>? params);
  Future<Either> getCustomerVoucher(int customerId);
}