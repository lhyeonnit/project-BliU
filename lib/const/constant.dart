class Constant {
  static const DOMAIN = "https://bground.api.dmonster.kr/";
  static const API_URL = "${DOMAIN}api/";
  static const USER_URL = "${API_URL}user/";

  //회원관리
  static const apiAuthLoginUrl = "${USER_URL}auth/login";//로그인
  static const apiAuthAutoLoginUrl = "${USER_URL}auth/auto_login";//자동 로그인
  static const apiAuthJoinUrl = "${USER_URL}auth/join";//회원가입
  static const apiAuthSnsLoginUrl = "${USER_URL}auth/sns_login";//sns 회원가입
  static const apiAuthCheckIdUrl = "${USER_URL}auth/check_id";//아이디 중복 확인
  static const apiAuthSendCodeUrl = "${USER_URL}auth/send_code";//휴대폰 인증번호 방송
  static const apiAuthCheckCodeUrl = "${USER_URL}auth/check_code";//휴대폰 인증번호 인증
  static const apiAuthFindIdUrl = "${USER_URL}auth/find_id";//아이디 찾기
  static const apiAuthFindPwdUrl = "${USER_URL}auth/find_pwd";//비밀번호 찾기
  static const apiAuthChangePwdUrl = "${USER_URL}auth/change_pwd";//비밀번호 변경
  static const apiAuthStyleCategoryUrl = "${USER_URL}auth/style_category";//스타일 카테고리
  static const apiAuthChildInfoUrl = "${USER_URL}auth/child_info";//추천 정보

  //홈
  static const apiMainBannerUrl = "${USER_URL}main/banner";// 배너 리스트 && 배너 이벤트 상세
  static const apiMainCategoryUrl = "${USER_URL}main/category";//카테고리 리스트
  static const apiMainExhibitionListUrl = "${USER_URL}main/exhibition_list";//기획전 리스트
  static const apiMainExhibitionDetailUrl = "${USER_URL}main/exhibition_detail";//기획전 상세
  static const apiMainAiListUrl = "${USER_URL}main/ai_list";//ai 추천 리스트
  static const apiMainSellRankUrl = "${USER_URL}main/sell_rank";//판매 베스트
  static const apiCartCountUrl = "${USER_URL}cart/count";//장바구니 수
  static const apiMainPushListUrl = "${USER_URL}main/push_list";//알림 리스트

  //푸터
  static const apiFootUrl = "${USER_URL}foot";//푸터

  //검색
  static const apiSearchPopularListUrl = "${USER_URL}search/popular_list";//인기 검색어
  static const apiSearchUrl = "${USER_URL}search/";//검색
  static const apiSearchSmartLensUrl = "${USER_URL}search/smart_lens";//스마트 렌즈
  static const apiSearchMyListUrl = "${USER_URL}search/my_list";//최근 검색 리스트
  static const apiSearchMyDelUrl = "${USER_URL}search/my_del";//최근 검색 삭제 && 최근 검색 전체 삭제

  //상품
  static const apiProductListUrl = "${USER_URL}product/list";//상품 리스트
  static const apiProductDetailUrl = "${USER_URL}product/detail";//상품 상세
  static const apiProductOptionUrl = "${USER_URL}product/option";//상품 옵션
  static const apiProductCouponListUrl = "${USER_URL}product/coupon_list";//상품 쿠폰
  static const apiProductCouponDownUrl = "${USER_URL}product/coupon_down";//상품 쿠폰 다운로드
  static const apiProductLikeUrl = "${USER_URL}product/like";//상품 좋아요
  static const apiProductReviewListUrl = "${USER_URL}product/review_list";//리뷰 리스트
  static const apiProductReviewDetailUrl = "${USER_URL}product/review_detail";//리뷰 상세
  static const apiProductReviewSingoUrl = "${USER_URL}product/review_singo";//리뷰 신고
  static const apiProductSingoCateUrl = "${USER_URL}product/singo_cate";//리뷰 신고 카테고리
  static const apiProductQnaListUrl = "${USER_URL}product/qna_list";//문의 리스트
  static const apiCartAddUrl = "${USER_URL}cart/add";//장바구니 담기

  //장바구니
  static const apiCartListUrl = "${USER_URL}cart/list";//장바구니 리스트
  static const apiCartDelUrl = "${USER_URL}cart/del";//장바구니 삭제
  static const apiCartUpdateUrl = "${USER_URL}cart/update";//장바구니 수량 증차감

  //결제
  static const apiOrderDetailUrl = "${USER_URL}order/detail";//결제 상세
  static const apiOrderLocalUrl = "${USER_URL}order/local";//제주/도서산간 추가 비용
  static const apiOrderPointUrl = "${USER_URL}order/point";//포인트 사용
  static const apiOrderCouponUrl = "${USER_URL}order/coupon";//쿠폰 리스트
  static const apiOrderCouponUseUrl = "${USER_URL}order/coupon/use";//쿠폰 사용
  static const apiOrderUrl = "${USER_URL}order/";//결제 요청
  static const apiOrderCheckUrl = "${USER_URL}order/check";//결제 검증
  static const apiOrderEndUrl = "${USER_URL}order/end";//결제 완료

  //스토어
  static const apiStoreRankUrl = "${USER_URL}store/rank";//랭킹
  static const apiStoreBookMarkUrl = "${USER_URL}store/bookmark";//즐겨찾기 상단 상점 리스트
  static const apiStoreProductsUrl = "${USER_URL}store/product";//즐겨찾기 상품 리스트
  static const apiStoreLikeUrl = "${USER_URL}store/like";//즐겨찾기
  static const apiStoreCouponUrl = "${USER_URL}store/coupon";//쿠폰 다운로드
  static const apiStoreUrl = "${USER_URL}store/";//상점 상품 리스트

  //마이페이지
  static const apiMyPageCheckMyPageUrl = "${USER_URL}mypage/check_mypage";//비밀번호 확인
  static const apiMyPageUrl = "${USER_URL}mypage/";//마이페이지 정보
  static const apiMyPageInfoUrl = "${USER_URL}mypage/info";//내정보 수정 상세
  static const apiMyPageSaveUrl = "${USER_URL}mypage/save";//내정보 수정 저장
  static const apiMyPageChangeNameUrl = "${USER_URL}mypage/change_name";//이름 변경
  static const apiMyPageChangeHpUrl = "${USER_URL}mypage/change_hp";//휴대폰 번호 변경
  static const apiMyPageRetireUrl = "${USER_URL}mypage/retire";//탈퇴
  static const apiMyPageOrderListUrl = "${USER_URL}mypage/order_list";//주문/배송 리스트
  static const apiMyPageOrderDetailUrl = "${USER_URL}mypage/order_detail";//주문/배송 상세
  static const apiMyPageOrderCancelCategoryUrl = "${USER_URL}mypage/order_cancel_category";//주문 취소 카테고리
  static const apiMyPageOrderCancelUrl = "${USER_URL}mypage/order_cancel";//주문 취소
  static const apiMyPageOrderCancelDetailUrl = "${USER_URL}mypage/order_cancel_detail";//주문 취소 상세
  static const apiMyPageOrderReturnCategoryUrl = "${USER_URL}mypage/order_return_category";//주문 교환/환불 카테고리
  static const apiMyPageOrderReturnDetailUrl = "${USER_URL}mypage/order_return_detail";//주문 교환/환불 상세
  static const apiMyPageOrderReturnUrl = "${USER_URL}mypage/order_return";//주문 교환/환불
  static const apiMyPageReviewListUrl = "${USER_URL}mypage/review_list";//나의리뷰 리스트
  static const apiMyPageReviewWriteUrl = "${USER_URL}mypage/review_write";//나의리뷰 등록
  static const apiMyPageReviewUpdateUrl = "${USER_URL}mypage/review_update";//나의리뷰 수정
  static const apiMyPageReviewDelUrl = "${USER_URL}mypage/review_del";//나의리뷰 삭제
  static const apiMyPageCouponUrl = "${USER_URL}mypage/coupon";//쿠폰함
  static const apiMyPagePointUrl = "${USER_URL}mypage/point";//포인트
  static const apiMyPageFaqCategoryUrl = "${USER_URL}mypage/faq_category";//faq 카테고리
  static const apiMyPageFaqUrl = "${USER_URL}mypage/faq";//faq
  static const apiMyPageNoticeUrl = "${USER_URL}mypage/notice";//공지사항
  static const apiMyPageNoticeDetailUrl = "${USER_URL}mypage/notice_detail";//공지사항 상세
  static const apiMyPageEventUrl = "${USER_URL}mypage/event";//이벤트 리스트
  static const apiMyPageEventDetailUrl = "${USER_URL}mypage/event_detail";//이벤트 상세
  static const apiMyPageQnaUrl = "${USER_URL}mypage/qna";//고객센터 정보
  static const apiMyPageQnaListUrl = "${USER_URL}mypage/qna_list";//문의 리스트
  static const apiMyPageQnaDetailUrl = "${USER_URL}mypage/qna_detail";//문의 리스트 상세
  static const apiMyPageQnaDelUrl = "${USER_URL}mypage/qna_del";//문의 삭제
  static const apiMyPageQnaSellerUrl = "${USER_URL}mypage/qna_seller";//판매 문의 등록
  static const apiMyPageQnaWriteUrl = "${USER_URL}mypage/qna_write";//문의 등록
  static const apiMyPagePushInfoUrl = "${USER_URL}mypage/push_info";//알림 정보
  static const apiMyPagePushUrl = "${USER_URL}mypage/push";//알림 설정
  static const apiMyPageTermsUrl = "${USER_URL}mypage/terms";//이용약관
  static const apiMyPagePrivacyUrl = "${USER_URL}mypage/privacy";//개인정보 처리방침

  //비회원
  //static const apiMyPageUrl = "${USER_URL}mypage";//
}