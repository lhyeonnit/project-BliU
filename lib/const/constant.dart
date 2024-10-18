class Constant {
  static const TOSS_CLIENT_KEY = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";//테스트

  static const DOMAIN = "https://bground.api.dmonster.kr/";
  static const API_URL = "${DOMAIN}api/";
  static const USER_URL = "${API_URL}user/";

  //회원관리
  static const apiAuthLoginUrl = "auth/login";//로그인
  static const apiAuthAutoLoginUrl = "auth/auto_login";//자동 로그인
  static const apiAuthJoinUrl = "auth/join";//회원가입
  static const apiAuthSnsLoginUrl = "auth/sns_login";//sns 회원가입
  static const apiAuthCheckIdUrl = "auth/check_id";//아이디 중복 확인
  static const apiAuthSendCodeUrl = "auth/send_code";//휴대폰 인증번호 방송
  static const apiAuthCheckCodeUrl = "auth/check_code";//휴대폰 인증번호 인증
  static const apiAuthFindIdUrl = "auth/find_id";//아이디 찾기
  static const apiAuthFindPwdUrl = "auth/find_pwd";//비밀번호 찾기
  static const apiAuthChangePwdUrl = "auth/change_pwd";//비밀번호 변경
  static const apiAuthStyleCategoryUrl = "auth/style_category";//스타일 카테고리
  static const apiAuthChildInfoUrl = "auth/child_info";//추천 정보

  //홈
  static const apiMainBannerUrl = "main/banner";// 배너 리스트 && 배너 이벤트 상세
  static const apiMainCategoryUrl = "main/category";//카테고리 리스트
  static const apiMainExhibitionListUrl = "main/exhibition_list";//기획전 리스트
  static const apiMainExhibitionDetailUrl = "main/exhibition_detail";//기획전 상세
  static const apiMainAiListUrl = "main/ai_list";//ai 추천 리스트
  static const apiMainSellRankUrl = "main/sell_rank";//판매 베스트
  static const apiCartCountUrl = "cart/count";//장바구니 수
  static const apiMainPushListUrl = "main/push_list";//알림 리스트

  //푸터
  static const apiFootUrl = "foot";//푸터

  //검색
  static const apiSearchPopularListUrl = "search/popular_list";//인기 검색어
  static const apiSearchUrl = "search/";//검색
  static const apiSearchSmartLensUrl = "search/smart_lens";//스마트 렌즈
  static const apiSearchMyListUrl = "search/my_list";//최근 검색 리스트
  static const apiSearchMyDelUrl = "search/my_del";//최근 검색 삭제 && 최근 검색 전체 삭제

  //상품
  static const apiProductListUrl = "product/list";//상품 리스트
  static const apiProductDetailUrl = "product/detail";//상품 상세
  static const apiProductOptionUrl = "product/option";//상품 옵션
  static const apiProductCouponListUrl = "product/coupon_list";//상품 쿠폰
  static const apiProductCouponDownUrl = "product/coupon_down";//상품 쿠폰 다운로드
  static const apiProductLikeUrl = "product/like";//상품 좋아요
  static const apiProductReviewListUrl = "product/review_list";//리뷰 리스트
  static const apiProductReviewDetailUrl = "product/review_detail";//리뷰 상세
  static const apiProductReviewSingoUrl = "product/review_singo";//리뷰 신고
  static const apiProductSingoCateUrl = "product/singo_cate";//리뷰 신고 카테고리
  static const apiProductQnaListUrl = "product/qna_list";//문의 리스트
  static const apiCartAddUrl = "cart/add";//장바구니 담기
  static const apiProductLikeListUrl = "product/like_list";//상품 좋아요 리스트

  //장바구니
  static const apiCartListUrl = "cart/list";//장바구니 리스트
  static const apiCartDelUrl = "cart/del";//장바구니 삭제
  static const apiCartUpdateUrl = "cart/update";//장바구니 수량 증차감

  //결제
  static const apiOrderDetailUrl = "order/detail";//결제 상세
  static const apiOrderLocalUrl = "order/local";//제주/도서산간 추가 비용
  static const apiOrderPointUrl = "order/point";//포인트 사용
  static const apiOrderCouponUrl = "order/coupon";//쿠폰 리스트
  static const apiOrderCouponUseUrl = "order/coupon/use";//쿠폰 사용
  static const apiOrderUrl = "order/";//결제 요청
  static const apiOrderCheckUrl = "order/check";//결제 검증
  static const apiOrderEndUrl = "order/end";//결제 완료

  //스토어
  static const apiStoreRankUrl = "store/rank";//랭킹
  static const apiStoreBookMarkUrl = "store/bookmark";//즐겨찾기 상단 상점 리스트
  static const apiStoreProductsUrl = "store/product";//즐겨찾기 상품 리스트
  static const apiStoreLikeUrl = "store/like";//즐겨찾기
  static const apiStoreCouponUrl = "store/coupon";//쿠폰 다운로드
  static const apiStoreUrl = "store/";//상점 상품 리스트

  //마이페이지
  static const apiMyPageCheckMyPageUrl = "mypage/check_mypage";//비밀번호 확인
  static const apiMyPageUrl = "mypage/";//마이페이지 정보
  static const apiMyPageInfoUrl = "mypage/info";//내정보 수정 상세
  static const apiMyPageSaveUrl = "mypage/save";//내정보 수정 저장
  static const apiMyPageChangeNameUrl = "mypage/change_name";//이름 변경
  static const apiMyPageChangeHpUrl = "mypage/change_hp";//휴대폰 번호 변경
  static const apiMyPageRetireUrl = "mypage/retire";//탈퇴
  static const apiMyPageOrderUrl = "mypage/order";//구매확정
  static const apiMyPageOrderListUrl = "mypage/order_list";//주문/배송 리스트
  static const apiMyPageOrderDetailUrl = "mypage/order_detail";//주문/배송 상세
  static const apiMyPageOrderDeliveryUrl = "mypage/order_delivery";//주문/배송 상세
  static const apiMyPageOrderCancelCategoryUrl = "mypage/order_cancel_category";//주문 취소 카테고리
  static const apiMyPageOrderCancelUrl = "mypage/order_cancel";//주문 취소
  static const apiMyPageOrderCancelDetailUrl = "mypage/order_cancel_detail";//주문 취소 상세
  static const apiMyPageOrderReturnCategoryUrl = "mypage/order_return_category";//주문 교환/환불 카테고리
  static const apiMyPageOrderReturnPayUrl = "mypage/order_return_pay";//주문 교환 배송비 지불방법
  static const apiMyPageOrderReturnDetailUrl = "mypage/order_return_detail";//주문 교환/환불 상세
  static const apiMyPageOrderReturnUrl = "mypage/order_return";//주문 교환/환불
  static const apiMyPageReviewListUrl = "mypage/review_list";//나의리뷰 리스트
  static const apiMyPageReviewWriteUrl = "mypage/review_write";//나의리뷰 등록
  static const apiMyPageReviewUpdateUrl = "mypage/review_update";//나의리뷰 수정
  static const apiMyPageReviewDelUrl = "mypage/review_del";//나의리뷰 삭제
  static const apiMyPageCouponUrl = "mypage/coupon";//쿠폰함
  static const apiMyPagePointUrl = "mypage/point";//포인트
  static const apiMyPageFaqCategoryUrl = "mypage/faq_category";//faq 카테고리
  static const apiMyPageFaqUrl = "mypage/faq";//faq
  static const apiMyPageNoticeUrl = "mypage/notice";//공지사항
  static const apiMyPageNoticeDetailUrl = "mypage/notice_detail";//공지사항 상세
  static const apiMyPageEventUrl = "mypage/event";//이벤트 리스트
  static const apiMyPageEventDetailUrl = "mypage/event_detail";//이벤트 상세
  static const apiMyPageQnaUrl = "mypage/qna";//고객센터 정보
  static const apiMyPageQnaListUrl = "mypage/qna_list";//문의 리스트
  static const apiMyPageQnaDetailUrl = "mypage/qna_detail";//문의 리스트 상세
  static const apiMyPageQnaDelUrl = "mypage/qna_del";//문의 삭제
  static const apiMyPageQnaSellerUrl = "mypage/qna_seller";//판매 문의 등록
  static const apiMyPageQnaWriteUrl = "mypage/qna_write";//문의 등록
  static const apiMyPagePushInfoUrl = "mypage/push_info";//알림 정보
  static const apiMyPagePushUrl = "mypage/push";//알림 설정
  static const apiMyPageTermsUrl = "mypage/terms";//이용약관
  static const apiMyPagePrivacyUrl = "mypage/privacy";//개인정보 처리방침
  static const apiMyPageChildInfoUrl = "mypage/child_info";//추천 정보
  //비회원
  //static const apiMyPageUrl = "${USER_URL}mypage";

  //카테고리
  static const apiCategoryAgeUrl = "category/age";

  // 기본 테스트용
  static const iamportUserCode = "iamport";// 테스트용
  static const iamportPg = "html5_inicis";// 테스트용

  //토스페이먼츠 테스트용
  // static const iamportUserCode = "iamporttest_3";// 토스테스트용
  // static const iamportPg = "tosspayments";// 테스트용

  //static const iamportUserCode = "imp56882344";// 실서비스
  //static const iamportPg = "tosspayments";// 테스트용
}