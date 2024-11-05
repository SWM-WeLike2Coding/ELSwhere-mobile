// ignore_for_file: constant_identifier_names

// 공통
const String MSG_ERR_UNEXPECTED = "예상치 못한 오류가 발생했습니다.";

// 로딩 관련
const String MSG_LOADING_DATA = "데이터 로딩 중입니다...";
const String MSG_LOADING_PRODUCT_INFO = "상품 정보를 불러오는 중입니다...";
const String MSG_LOADING_USER_INFO = "사용자 정보를 불러오는 중입니다...";
const String MSG_LOADING_STOCK_PRICE = "주가 정보를 불러오는 중입니다...";
const String MSG_LOADING_ANALYSIS_RESULT = "분석 정보를 불러오는 중입니다...";
const String MSG_LOADING_PRICE_RATIO = "기준가 정보를 받아오는 중입니다...";

// 메시지
// const String MSG_DESCRIPTION_MONTECARLO = '분석 결과는 ELSwhere만의 수학적인 분석 결과를 통해 제공되는 수치이며, 절대적인 수치가 아님을 알려드립니다.';
// const String MSG_DESCRIPTION_AI = "안전 점수는 ELSwhere의 AI 분석 결과에 따라 '저위험', '중위험', '고위험', '초고위험'으로 분류되며, 안전 점수가 낮을수록 손실 확률이 높습니다.";
const String MSG_DESCRIPTION_MONTECARLO = '분석 결과는 ELS 상품 공정가격을 계산하는 기법을 통해 산출된 것으로, 만기 손실율이 높을수록 원금 손실 가능성도 증가합니다.';
const String MSG_DESCRIPTION_AI = "안전 점수는 ELS 투자 시 중요한 지표들을 반영하여 ELSwhere AI가 산출한 결과입니다. 이 점수를 기반으로 상품은 '저위험', '중위험', '고위험', '초고위험'으로 분류되며, 안전 점수가 낮을수록 원금 손실 가능성이 커집니다.";

const String MSG_TO_BE_UPDATED = "추후 업데이트를 통해 제공될 예정입니다.";

// HOT 상품 관련
const String MSG_DESCRIBE_HOT_PRODUCTS = '일일 HOT 상품은 매일 00시 00분을 기준으로 상품들에 대한 일일 조회수와 좋아요의 증감 수에 따라 결정됩니다.';
const String MSG_NO_HOT_PRODUCTS = '일일 HOT 상품이 존재하지 않습니다.';

// 상품 관련
const String MSG_NO_PRICERATIO = '현재 상품의 기준가가 정해지지 않았습니다.';

// 로딩 실패
const String MSG_ERR_FETCH = "정보를 불러오는데 실패했습니다. 다시 시도해 주세요.";
const String MSG_ERR_FETCH_LIKE = "좋아요 정보를 불러오는데 실패했습니다.";
const String MSG_ERR_FETCH_USER_INFO = "사용자 정보를 불러오는데 실패했습니다.";

// 닉네임 관련
const String MSG_NICKNAME_RULE_TITLE = "• 닉네임 변경 규칙:";
const String MSG_NICKNAME_RULE_BODY = "3-16자, 영어/숫자/한글/밑줄/공백 가능, 연속된 공백 불가";
const String MSG_INVALID_NICKNAME = "사용할 수 없는 닉네임입니다.";
const String MSG_EXIST_NICKNAME = "이미 사용 중인 닉네임입니다";
const String MSG_INSERT_NICKNAME = "닉네임을 입력하세요";

// 공지사항 관련
const String MSG_NO_NOTICES = "공지사항이 없습니다.";
const String MSG_ERR_FETCH_NOTICES = "공지사항을 불러오는데 실패했습니다.";

// 약관 동의 관련
const String TITLE_SERVICE_AGREEMENT = "ELSwhere 서비스 이용을 위해\n동의해 주세요.";

// AI 위험 분석도 관련
const String MSG_AI_RESULT_STATISTICS = '''최근 6년 증권사 ELS 상품 데이터 기반 각 위험도별 원금 손실 상품 비율
1. 초고위험 : 85.88%
2. 고위험 : 30.45%
3. 중위험 : 13.04%
4. 저위험 : 0.16%''';
const String MSG_ANALYSIS_NOT_YET = '현재 스텝다운 상품에 대해서만 위험도 분석 정보를 제공하고 있습니다. 추후 업데이트를 통해 다양한 상품에 대해서도 제공할 수 있도록 노력하겠습니다.';
const String LABEL_LOW_RISK = "저위험";
const String LABEL_MODERATE_RISK = "중위험";
const String LABEL_HIGH_RISK = "고위험";
const String LABEL_VERY_HIGH_RISK = "초고위험";

// 상품 화면
const String LABEL_SEARCH_TEXT_FILED = "상품 상세 검색";
const String LABEL_DETAIL_SEARCH = "기초자산명을 입력하세요";
const String LABEL_SEARCH_BUTTON = "상품 검색";
const String MSG_INVALID_DATE = "마감일이 시작일보다 빠를 수 없습니다.";

// 보유 상품 관련
const String MSG_LOADING_HOLDING_PRODUCTS = "보유 상품을 불러오는 중입니다...";
