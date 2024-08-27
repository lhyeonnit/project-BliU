class BookmarkStoreDTO {
  final int stIdx;
  final String stName;
  final String stProfile;
  final int stLike;

  BookmarkStoreDTO({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stLike,
  });

  // JSON 데이터를 BookmarkStoreDTO 객체로 변환하는 factory 메서드
  factory BookmarkStoreDTO.fromJson(Map<String, dynamic> json) {
    return BookmarkStoreDTO(
      stIdx: json['st_idx'],  // int로 안전하게 변환
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stLike: json['st_like'],  // int로 안전하게 변환
    );
  }

  // BookmarkStoreDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_like': stLike,
    };
  }
}


class BookmarkResponseDTO {
  final bool result;
  final List<BookmarkStoreDTO> stores;

  BookmarkResponseDTO({
    required this.result,
    required this.stores,
  });

  factory BookmarkResponseDTO.fromJson(Map<String, dynamic> json) {
    return BookmarkResponseDTO(
      result: json['result'],
      stores: (json['data']['list'] as List)
          .map((item) => BookmarkStoreDTO.fromJson(item))
          .toList(),
    );
  }
}
