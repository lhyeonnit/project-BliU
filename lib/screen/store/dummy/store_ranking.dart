final List<Map<String, dynamic>> stores = List.generate(10, (index) {
  return {
    'rank': index + 1,
    'logo': 'assets/images/store/brand_logo@2x.png', // 임시 로고 이미지 URL
    'name': '가게 이름 $index',
    'description': '스포티 (Sporty),',
    'scrapCount': '175만',
    'images': [
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
    ]
  };
});
