import 'package:equatable/equatable.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  final String? fullName;
  final bool isProfileComplete;

  const VerifyOtpSuccess({this.fullName, required this.isProfileComplete});

  @override
  List<Object?> get props => [fullName, isProfileComplete];
}

class VerifyOtpFailure extends VerifyOtpState {
  final String message;

  const VerifyOtpFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
