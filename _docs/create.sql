CREATE DATABASE alba
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE alba.t_account (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '번호',
    id                      VARCHAR(255) NOT NULL COMMENT '아이디',
    password                VARCHAR(255) NULL COMMENT '비밀번호 (자체 회원가입 시에만 사용, SSO 시 NULL)',
    name                    VARCHAR(50) NULL COMMENT '사용자 이름',
    email                   VARCHAR(100) NULL COMMENT '이메일',
    provider                VARCHAR(20) NOT NULL DEFAULT 'LOCAL' COMMENT '인증 제공자 (LOCAL, GOOGLE, KAKAO, NAVER 등)',
    roles                   VARCHAR(50) NOT NULL COMMENT '역할 (GUEST, USER, ADMIN, SUPER_ADMIN)',
    status                  VARCHAR(20) NOT NULL COMMENT '상태 (PENDING, ACTIVE, INACTIVE, DELETED)',
    login_fail_count        TINYINT NULL DEFAULT 0 COMMENT '로그인 실패 횟수',
    last_login_at           TIMESTAMP NULL COMMENT '마지막 로그인일시',
    password_modified_at    TIMESTAMP NULL COMMENT '비밀번호 수정일시',
    withdraw_at             TIMESTAMP NULL COMMENT '탈퇴일시',
    created_no              BIGINT NULL COMMENT '생성자',
    created_at              TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시',
    UNIQUE KEY t_account_unique_id_provider (id, provider),
    UNIQUE KEY t_account_unique_email_provider (email, provider)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '계정 정보';

CREATE TABLE alba.t_token (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '번호',
    account_no              BIGINT NOT NULL COMMENT '토큰 소유자 사용자 번호 (FK)',
    access_token            VARCHAR(255) NOT NULL UNIQUE COMMENT '액세스 토큰 값',
    refresh_token           VARCHAR(255) NOT NULL UNIQUE COMMENT '리프레시 토큰 값',
    roles                   VARCHAR(100) NOT NULL COMMENT '역할',
    access_expires_at       TIMESTAMP NOT NULL COMMENT '액세스 토큰 만료 시간',
    refresh_expires_at      TIMESTAMP NOT NULL COMMENT '리프레시 토큰 만료 시간',
    client_ip               VARCHAR(50) NULL COMMENT '토큰 발급 시 클라이언트 IP',
    user_agent              VARCHAR(255) NULL COMMENT '토큰 발급 시 User-Agent',
    revoked_yn              CHAR(1) DEFAULT 'N' NULL COMMENT '토큰 무효화 여부',
    revoked_at              TIMESTAMP NULL COMMENT '토큰 무효화 시간',
    revoked_reason          VARCHAR(100) NULL COMMENT '토큰 무효화 사유',
    created_no              BIGINT NULL COMMENT '생성자',
    created_at              TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시',
    FOREIGN KEY (account_no) REFERENCES t_account (no) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '토큰 정보';

CREATE TABLE alba.t_email_auth_code (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '번호',
    account_no              BIGINT NULL COMMENT '사용자 번호 (FK)',
    email                   VARCHAR(100) NOT NULL COMMENT '이메일',
    code                    VARCHAR(10) NOT NULL COMMENT '발송된 인증 번호 (예: 123456)',
    type                    VARCHAR(20) NOT NULL COMMENT '인증 타입 (JOIN:회원가입, PASSWORD:비밀번호재설정 등)',
    verified_yn             CHAR(1) DEFAULT 'N' COMMENT '인증 완료 여부 (Y: 인증됨, N: 미인증)',
    send_success_yn         CHAR(1) NULL COMMENT '발송 성공 여부 (Y: 성공, N: 실패)',
    send_fail_reason        VARCHAR(500) NULL COMMENT '발송 실패 시 에러 메시지 상세',
    fail_count              TINYINT DEFAULT 0 COMMENT '실패 횟수',
    expired_at              TIMESTAMP NOT NULL COMMENT '인증 번호 만료 일시',
    created_at              TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    FOREIGN KEY (account_no) REFERENCES t_account (no) ON DELETE SET NULL,
    INDEX idx_email_auth_search (email, code, type)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '이메일 인증 테이블';

CREATE TABLE alba.t_email_send_log (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '번호',
    account_no              BIGINT NULL COMMENT '사용자 번호 (FK)',
    email                   VARCHAR(100) NOT NULL COMMENT '이메일',
    title                   VARCHAR(255) NOT NULL COMMENT '발송된 이메일 제목',
    content                 TEXT COMMENT '발송된 이메일 본문 (HTML 포함)',
    success_yn              CHAR(1) NOT NULL COMMENT '발송 성공 여부 (Y: 성공, N: 실패)',
    fail_reason             VARCHAR(500) COMMENT '발송 실패 시 에러 메시지 상세',
    sent_at                 TIMESTAMP DEFAULT  CURRENT_TIMESTAMP() NOT NULL COMMENT '발송 시도 일시',
    FOREIGN KEY (account_no) REFERENCES t_account (no) ON DELETE SET NULL,
    INDEX idx_email_log_user (email),
    INDEX idx_email_log_date (sent_at)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '이메일 전송 이력';

CREATE TABLE alba.t_shop (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '매장 번호',
    name                    VARCHAR(100) NOT NULL COMMENT '매장명',
    zip_code                VARCHAR(10)  NOT NULL COMMENT '우편번호',
    base_address            VARCHAR(255) NOT NULL COMMENT '기본주소',
    detail_address          VARCHAR(255) NULL COMMENT '상세주소',
    invite_code             CHAR(10) NOT NULL UNIQUE COMMENT '합류 초대 코드 (예: X7A9KQ)',
    qr_code_value           CHAR(36) NOT NULL UNIQUE COMMENT 'QR 코드 값',
    latitude                DECIMAL(10,7) NULL COMMENT '매장 기준 위도',
    longitude               DECIMAL(10,7) NULL COMMENT '매장 기준 경도',
    status                  VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '매장 상태 (ACTIVE, CLOSED, SUSPENDED)',
    created_no              BIGINT NULL COMMENT '생성자 (최초 생성 사장님 account_no)',
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '매장(워크스페이스) 정보';

-- ※ account_no가 NULL일 수 있으므로 UNIQUE 인덱스는 제외하고, 앱 유저(Y)의 중복 가입 방어는 백엔드 로직에서 처리합니다.
CREATE TABLE alba.t_shop_member (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '매장 멤버 번호',
    shop_no                 BIGINT NOT NULL COMMENT '매장 번호 (FK)',
    account_no              BIGINT NULL COMMENT '사용자 번호 (FK - 사장님 수기 등록 직원은 NULL)',
    name                    VARCHAR(50) NULL COMMENT '직원 이름 (account_no가 NULL인 수기 직원을 위해 사용)',
    shop_role               VARCHAR(20) NOT NULL COMMENT '매장 내 역할 (OWNER, MANAGER, STAFF)',
    base_wage               INT NULL COMMENT '기본 시급',
    is_app_user             CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '앱 가입자 여부 (Y: 앱유저, N: 사장수기등록)',
    employment_type         VARCHAR(20) NOT NULL DEFAULT 'REGULAR' COMMENT '고용 형태 (REGULAR, DAILY)',
    status                  VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '상태 (PENDING, ACTIVE, INACTIVE, QUIT)',
    joined_at               DATE NULL COMMENT '매장 합류일',
    created_no              BIGINT NULL COMMENT '생성자',
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시',
    FOREIGN KEY (shop_no) REFERENCES t_shop (no) ON DELETE CASCADE,
    FOREIGN KEY (account_no) REFERENCES t_account (no) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '매장 소속 멤버 및 시급 정보';

CREATE TABLE alba.t_schedule (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '스케줄 번호',
    shop_no                 BIGINT NOT NULL COMMENT '매장 번호 (FK)',
    shop_member_no          BIGINT NOT NULL COMMENT '매장 멤버 번호 (FK - 대상 알바생)',
    work_date               DATE NOT NULL COMMENT '근무 예정일자',
    start_time              TIME NOT NULL COMMENT '근무 시작 예정시간',
    end_time                TIME NOT NULL COMMENT '근무 종료 예정시간',
    status                  VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED' COMMENT '스케줄 상태 (SCHEDULED, CANCELED)',
    created_no              BIGINT NULL COMMENT '생성자',
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시',
    FOREIGN KEY (shop_no) REFERENCES t_shop (no) ON DELETE CASCADE,
    FOREIGN KEY (shop_member_no) REFERENCES t_shop_member (no) ON DELETE CASCADE,
    INDEX idx_schedule_date (shop_no, work_date)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '근무 스케줄 계획';

CREATE TABLE alba.t_attendance (
    no                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '출결 번호',
    shop_no                 BIGINT NOT NULL COMMENT '매장 번호 (FK)',
    shop_member_no          BIGINT NOT NULL COMMENT '매장 멤버 번호 (FK)',
    schedule_no             BIGINT NULL COMMENT '연동된 스케줄 번호 (FK - 돌발 출근이나 일일 알바 간편 타각 시 NULL 허용)',
    work_date               DATE NOT NULL COMMENT '근무 귀속일자 (야간근무 철야 시 기준일)',
    clock_in_at             TIMESTAMP NOT NULL COMMENT '실제 출근 타각 일시',
    clock_in_lat            DECIMAL(10, 7) NULL COMMENT '출근 타각 시 앱에서 보낸 위도',
    clock_in_lng            DECIMAL(10, 7) NULL COMMENT '출근 타각 시 앱에서 보낸 경도',
    clock_out_at            TIMESTAMP NULL COMMENT '실제 퇴근 타각 일시',
    clock_out_lat           DECIMAL(10, 7) NULL COMMENT '퇴근 타각 시 앱에서 보낸 위도',
    clock_out_lng           DECIMAL(10, 7) NULL COMMENT '퇴근 타각 시 앱에서 보낸 경도',
    auth_type               VARCHAR(20) NOT NULL COMMENT '인증 방식 (QR_GPS, MANUAL)',
    clock_in_status         VARCHAR(20) NULL COMMENT '출근 상태 (NORMAL, LATE, EXCEPTION)',
    clock_out_status        VARCHAR(20) NULL COMMENT '퇴근 상태 (NORMAL, EARLY_LEAVE, EXCEPTION)',
    created_no              BIGINT NULL COMMENT '생성자',
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL COMMENT '생성일시',
    modified_no             BIGINT NULL COMMENT '수정자',
    modified_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL ON UPDATE CURRENT_TIMESTAMP() COMMENT '수정일시',
    FOREIGN KEY (shop_no) REFERENCES t_shop (no) ON DELETE CASCADE,
    FOREIGN KEY (shop_member_no) REFERENCES t_shop_member (no) ON DELETE CASCADE,
    FOREIGN KEY (schedule_no) REFERENCES t_schedule (no) ON DELETE SET NULL,
    INDEX idx_attendance_date (shop_no, work_date)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '실제 출퇴근 기록';
