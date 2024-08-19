final List<Map<String, String>> favoriteStores = List.generate(70, (index) {
  return {
    'logo': 'assets/images/store/brand_logo@2x.png', // 임시 로고 이미지 URL
    'name': index % 2 == 0 ? '트래블' : index % 3 == 0 ? '밀크마일' : '로토토베베',
    'description': index % 2 == 0
        ? '스포티 (Sporty), 베이비(0-24개월)'
        : index % 3 == 0
        ? '캐주얼 (Casual), 베이비(0-24개월)'
        : '캐주얼 (Casual), 키즈(3-8세)',
    'scrapCount': '175만',
  };
});
