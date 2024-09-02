import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';
// 마이페이지
class MyPageRepository {
  final Dio _dio = Dio();
  // TODO
  //비밀번호 확인
  Future<Response<dynamic>?> reqMyPageCheckMyPage({
    required int mtIdx,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageCheckMyPageUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'password': password,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //마이페이지 정보
  Future<Response<dynamic>?> reqMyPage({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageUrl,
          data: {
            'mt_idx': mtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //내정보 수정 상세
  Future<Response<dynamic>?> reqMyPageInfo({
    required int mtIdx,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageInfoUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'auth_token': authToken,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // 내정보 수정 저장
  Future<Response<dynamic>?> reqMyPageSave({
    required int mtIdx,
    required String mtBirth,
    required String mtGender,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageSaveUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'mt_birth': mtBirth,
            'mt_gender': mtGender,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // 이름 변경
  Future<Response<dynamic>?> reqMyPageChangeName({
    required int mtIdx,
    required String mtName,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageChangeNameUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'mt_name': mtName,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //휴대폰 번호 변경
  Future<Response<dynamic>?> reqMyPageChangeHp({
    required int mtIdx,
    required String mtHp,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageChangeHpUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'mt_hp': mtHp,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //탈퇴
  Future<Response<dynamic>?> reqMyPageRetire({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageRetireUrl,
          data: {
            'mt_idx': mtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //주문/배송 리스트
  Future<Response<dynamic>?> reqMyPageOrderList({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderListUrl,
          data: {
            'mt_idx': mtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //주문/배송 상세
  Future<Response<dynamic>?> reqMyPageOrderDetail({
    required int mtIdx,
    required int ctIdx,
    required String otCode,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'ct_idx': ctIdx.toString(),
            'ot_code': otCode,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //주문취소 카테고리
  Future<Response<dynamic>?> reqMyPageOrderCancelCategory() async {
    try {
      final response = await _dio.get(
          Constant.apiMyPageOrderCancelCategoryUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //주문 취소
  Future<Response<dynamic>?> reqMyPageOrderCancel({
    required int mtIdx,
    required String odtCode,
    required int ctIdx,
    required String ctReason,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderCancelUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'odt_code': odtCode,
            'ct_idx': ctIdx.toString(),
            'ct_reason': ctReason,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  // 주문 취소 상세
  Future<Response<dynamic>?> reqMyPageOrderCancelDetail({
    required int mtIdx,
    required String odtCode,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderCancelDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'odt_code': odtCode,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //주무 교환/환불 카테고리
  Future<Response<dynamic>?> reqMyPageOrderReturnCategory({
    required int ctType,
  }) async {
    try {
      final response = await _dio.get(
          Constant.apiMyPageOrderReturnCategoryUrl,
          queryParameters: {
            'ct_type': ctType.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //주문 교환/환불 상세
  Future<Response<dynamic>?> reqMyPageOrderReturnDetail({
    required int mtIdx,
    required String odtCode,
    required int ctType,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderReturnDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'odt_code': odtCode,
            'ct_type': ctType.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //주문 교환/환불
  Future<Response<dynamic>?> reqMyPageOrderReturn({
    required int mtIdx,
    required String odtCode,
    required int ctType,
    required int ctIdx,
    required String ctReason,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageOrderReturnUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'odt_code': odtCode,
            'ct_type': ctType.toString(),
            'ct_idx': ctIdx,
            'ct_reason': ctReason,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //나의리뷰 리스트
  Future<Response<dynamic>?> reqMyPageReviewList({
    required int mtIdx,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageReviewListUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'pg': pg,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //TODO
  //나의리뷰 등록
  Future<Response<dynamic>?> reqMyPageReviewWrite({
    required int mtIdx,
    required int ctIdx,
    required int rtStart,
    required String rtContent,
    required String rtImg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageReviewWriteUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'ct_idx': ctIdx.toString(),
            'rt_start': rtStart.toString(),
            'rt_content': rtContent,
            'rt_img': rtImg,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //나의리뷰 수정
  Future<Response<dynamic>?> reqMyPageReviewUpdate({
    required int mtIdx,
    required int rtIdx,
    required int rtStart,
    required String rtContent,
    required String rtImg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageReviewUpdateUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'rt_idx': rtIdx.toString(),
            'rt_start': rtStart.toString(),
            'rt_content': rtContent,
            'rt_img': rtImg,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //나의리뷰 삭제
  Future<Response<dynamic>?> reqMyPageReviewDel({
    required int mtIdx,
    required int rtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageReviewDelUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'rt_idx': rtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  // 쿠폰함
  Future<Response<dynamic>?> reqMyPageCoupon({
    required int mtIdx,
    required String couponStatus,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageCouponUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'coupon_status': couponStatus,
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //포인트
  Future<Response<dynamic>?> reqMyPagePoint({
    required int mtIdx,
    required String pointStatus,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPagePointUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'point_status': pointStatus,
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //faq 카테고리
  Future<Response<dynamic>?> reqMyPageFaqCategory() async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageFaqCategoryUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //faq
  Future<Response<dynamic>?> reqMyPageFaq({
    required String searchTxt,
    required String faqCategory,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageFaqUrl,
          data: {
            'search_txt': searchTxt,
            'faq_category': faqCategory,
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //공지사항
  Future<Response<dynamic>?> reqMyPageNotice({
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageNoticeUrl,
          data: {
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //공지사항 상세
  Future<Response<dynamic>?> reqMyPageNoticeDetail({
    required int ntIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageNoticeDetailUrl,
          data: {
            'nt_idx': ntIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //이벤트 리스트
  Future<Response<dynamic>?> reqMyPageEvent({
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageEventUrl,
          data: {
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //이벤트 상세
  Future<Response<dynamic>?> reqMyPageEventDetail({
    required int btIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageEventDetailUrl,
          data: {
            'bt_idx': btIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //고객센터 정보
  Future<Response<dynamic>?> reqMyPageQna({
    required int btIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageQnaUrl,
          data: {
            'bt_idx': btIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //문의 리스트
  Future<Response<dynamic>?> reqMyPageQnaList({
    required int btIdx,
    required int qnaType,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageQnaListUrl,
          data: {
            'bt_idx': btIdx.toString(),
            'qna_type': qnaType.toString(),
            'pg': pg.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //문의 리스트 상세
  Future<Response<dynamic>?> reqMyPageQnaDetail({
    required int mtIdx,
    required int qtIdx,
    required int qnaType,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageQnaDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'qt_idx': qtIdx.toString(),
            'qna_type': qnaType.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  // 문의 삭제
  Future<Response<dynamic>?> reqMyPageQnaDel({
    required int mtIdx,
    required int qtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPageQnaDelUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'qt_idx': qtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // 판매 문의 등록
  Future<Response<dynamic>?> reqMyPageQnaSeller({
    required int qnaType,
    required int mtIdx,
    required String mtHp,
    required String qtTitle,
    required String qtContent,
    required List<String> sellerImgs, // TODO 여러 이미지

  }) async {
    try {
      var multiPartDio = Dio();
      multiPartDio.options.contentType = 'multipart/form-data';
      multiPartDio.options.maxRedirects.isFinite;

      final Iterable imgs = sellerImgs.map((imgPath) => MultipartFile.fromFileSync(imgPath));

      var formData = FormData.fromMap(
          {
            'qna_type': qnaType.toString(),
            'mt_idx': mtIdx.toString(),
            'mt_hp': mtHp,
            'qt_title': qtTitle,
            'qt_content': qtContent,
            'seller_imgs': imgs,
          }
      );

      final response = await multiPartDio.post(
          Constant.apiMyPageQnaSellerUrl,
          data: formData
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //문의 등록
  Future<Response<dynamic>?> reqMyPageQnaWrite({
    required int qnaType,
    required int mtIdx,
    required int ptIdx,
    required String qtTitle,
    required String qtContent,
    required List<String> qnaImg, // TODO 여러 이미지

  }) async {
    try {
      var multiPartDio = Dio();
      multiPartDio.options.contentType = 'multipart/form-data';
      multiPartDio.options.maxRedirects.isFinite;

      final Iterable imgs = qnaImg.map((imgPath) => MultipartFile.fromFileSync(imgPath));

      var formData = FormData.fromMap(
          {
            'qna_type': qnaType.toString(),
            'mt_idx': mtIdx.toString(),
            'pt_idx': ptIdx.toString(),
            'qt_title': qtTitle,
            'qt_content': qtContent,
            'qna_img': imgs,
          }
      );

      final response = await multiPartDio.post(
          Constant.apiMyPageQnaWriteUrl,
          data: formData
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //알림 정보
  Future<Response<dynamic>?> reqMyPagePushInfo({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPagePushInfoUrl,
          data: {
            'mt_idx': mtIdx.toString(),
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // 알림 설정
  Future<Response<dynamic>?> reqMyPagePush({
    required int mtIdx,
    required int mtPushing,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiMyPagePushUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'mt_pushing': mtPushing,
          }
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //이용약관
  Future<Response<dynamic>?> reqMyPageTerms() async {
    try {
      final response = await _dio.get(
          Constant.apiMyPageTermsUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //개인정보처리방침
  Future<Response<dynamic>?> reqMyPagePrivacy() async {
    try {
      final response = await _dio.get(
        Constant.apiMyPageTermsUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }

}