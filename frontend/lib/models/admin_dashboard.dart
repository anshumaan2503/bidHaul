class AdminDashboardModel {
  final int totalUsers;
  final int activeCompanies;
  final int activeTransporters;
  final int liveTenders;
  final int openNegotiations;

  const AdminDashboardModel({
    required this.totalUsers,
    required this.activeCompanies,
    required this.activeTransporters,
    required this.liveTenders,
    required this.openNegotiations,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      activeCompanies: (json['activeCompanies'] as num?)?.toInt() ?? 0,
      activeTransporters: (json['activeTransporters'] as num?)?.toInt() ?? 0,
      liveTenders: (json['liveTenders'] as num?)?.toInt() ?? 0,
      openNegotiations: (json['openNegotiations'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeCompanies': activeCompanies,
      'activeTransporters': activeTransporters,
      'liveTenders': liveTenders,
      'openNegotiations': openNegotiations,
    };
  }
}
