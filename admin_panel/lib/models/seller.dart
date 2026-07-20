class KycDocument {
  final int id;
  final String documentType;
  final String filePath;
  final String status;
  final String? adminNotes;
  final String? reviewedAt;
  final Map<String, dynamic>? reviewer;

  KycDocument({
    required this.id,
    required this.documentType,
    required this.filePath,
    required this.status,
    this.adminNotes,
    this.reviewedAt,
    this.reviewer,
  });

  factory KycDocument.fromJson(Map<String, dynamic> json) {
    return KycDocument(
      id: json['id'],
      documentType: json['document_type'] ?? '',
      filePath: json['file_path'] ?? '',
      status: json['status'] ?? 'pending',
      adminNotes: json['admin_notes'],
      reviewedAt: json['reviewed_at'],
      reviewer: json['reviewer'] as Map<String, dynamic>?,
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? logo;
  final bool isActive;
  final String status;
  final String? kycSubmittedAt;
  final String? kycReviewedAt;
  final String? kycNotes;
  final String createdAt;
  final Map<String, dynamic>? owner;
  final List<KycDocument> kycDocuments;

  Seller({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.logo,
    required this.isActive,
    required this.status,
    this.kycSubmittedAt,
    this.kycReviewedAt,
    this.kycNotes,
    required this.createdAt,
    this.owner,
    required this.kycDocuments,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      logo: json['logo'],
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? 'pending',
      kycSubmittedAt: json['kyc_submitted_at'],
      kycReviewedAt: json['kyc_reviewed_at'],
      kycNotes: json['kyc_notes'],
      createdAt: json['created_at'] ?? '',
      owner: json['owner'] as Map<String, dynamic>?,
      kycDocuments: (json['kyc_documents'] as List? ?? [])
          .map((d) => KycDocument.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
