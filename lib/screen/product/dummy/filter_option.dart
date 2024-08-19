class FilterOption {
  final String label;

  FilterOption({required this.label});
}
List<FilterOption> ageOptions = [
  FilterOption(label: '베이비(0-24개월)'),
  FilterOption(label: '키즈(3-8세)'),
  FilterOption(label: '주니어(9세 이상)'),
];

List<FilterOption> styleOptions = [
  FilterOption(label: '캐주얼'),
  FilterOption(label: '스포티'),
  FilterOption(label: '포멀/클래식'),
  FilterOption(label: '베이직'),
  FilterOption(label: '프린세스/페어리'),
  FilterOption(label: '힙스터'),
  FilterOption(label: '럭셔리'),
  FilterOption(label: '어반 스트릿'),
  FilterOption(label: '로맨틱'),
];
