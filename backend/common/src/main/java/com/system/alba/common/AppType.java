package com.system.alba.common;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

public interface AppType {

    enum Profile {
        test,
        local,
        development,
        production
    }

    @Getter
    @RequiredArgsConstructor
    enum AccountRole {
        GUEST("GUEST", "손님"),
        USER("USER", "일반 사용자"),
        ADMIN("ADMIN", "관리자"),
        SUPER_ADMIN("SUPER_ADMIN", "최고 관리자");

        private final String key;
        private final String title;
    }


    @Getter
    @RequiredArgsConstructor
    enum AuthProvider {
        LOCAL("LOCAL", "local"),
        GOOGLE("GOOGLE", "google"),
        NAVER("NAVER", "naver"),
        KAKAO("KAKAO", "kakao");

        private final String code;
        private final String registrationId;

        public static AuthProvider fromRegistrationId(String registrationId) {
            for (AuthProvider provider : values()) {
                if (provider.registrationId.equalsIgnoreCase(registrationId)) {
                    return provider;
                }
            }
            throw new IllegalArgumentException("Unsupported provider: " + registrationId);
        }
    }


    enum Status {
        PENDING,
        ACTIVE,
        INACTIVE,
        DELETED
    }

    @Getter
    @RequiredArgsConstructor
    enum ShopStatus {
        ACTIVE("ACTIVE", "운영 중"),
        CLOSED("CLOSED", "운영 종료"),
        SUSPENDED("SUSPENDED", "정지");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ShopRole {
        OWNER("OWNER", "사장"),
        MANAGER("MANAGER", "매니저"),
        STAFF("STAFF", "직원");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum EmploymentType {
        REGULAR("REGULAR", "정직원"),
        DAILY("DAILY", "일일대타");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ShopMemberStatus {
        PENDING("PENDING", "대기"),
        ACTIVE("ACTIVE", "활성"),
        INACTIVE("INACTIVE", "비활성"),
        QUIT("QUIT", "퇴사");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ScheduleStatus {
        SCHEDULED("SCHEDULED", "예정"),
        CANCELED("CANCELED", "취소");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ShopNoticeStatus {
        ACTIVE("ACTIVE", "노출"),
        HIDDEN("HIDDEN", "숨김"),
        DELETED("DELETED", "삭제");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum AttendanceAuthType {
        QR_GPS("QR_GPS", "QR+GPS"),
        MANUAL("MANUAL", "수기입력");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ClockInStatus {
        NORMAL("NORMAL", "정상"),
        LATE("LATE", "지각"),
        EXCEPTION("EXCEPTION", "예외");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ClockOutStatus {
        NORMAL("NORMAL", "정상"),
        EARLY_LEAVE("EARLY_LEAVE", "조퇴"),
        EXCEPTION("EXCEPTION", "예외");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum EmailAuthType {
        JOIN("JOIN", "회원가입"),
        PASSWORD_RESET("PASSWORD_RESET", "비밀번호 재설정");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum TokenRevokeReason {
        NEW_LOGIN("NEW_LOGIN", "새로운 로그인"),
        REFRESH_TOKEN_USED("REFRESH_TOKEN_USED", "리프레시 토큰 사용"),
        LOGOUT("LOGOUT", "로그아웃");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum DevicePlatform {
        ANDROID("ANDROID", "안드로이드"),
        IOS("IOS", "iOS"),
        WEB("WEB", "웹");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ClientState {
        ACTIVE("ACTIVE", "포그라운드"),
        BACKGROUND("BACKGROUND", "백그라운드"),
        OFFLINE("OFFLINE", "오프라인");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ChatRoomType {
        DIRECT("DIRECT", "1:1 채팅"),
        GROUP("GROUP", "단체 채팅"),
        SECRET("SECRET", "비밀 대화");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum ChatRoomRole {
        OWNER("OWNER", "방장"),
        ADMIN("ADMIN", "부방장"),
        MEMBER("MEMBER", "일반");

        private final String code;
        private final String title;
    }

    @Getter
    @RequiredArgsConstructor
    enum DeliveryChannel {
        STOMP("STOMP", "WebSocket(STOMP) 실시간 전송"),
        FCM("FCM", "Firebase Cloud Messaging 푸시");

        private final String code;
        private final String title;
    }
}
