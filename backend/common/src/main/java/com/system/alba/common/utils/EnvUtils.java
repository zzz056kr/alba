package com.system.alba.common.utils;

import com.system.alba.common.AppType;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.core.env.Environment;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class EnvUtils {

    public static String getClientAddress() {
        HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getHeader("Proxy-Client-IP");
        if (ip == null) ip = req.getHeader("WL-Proxy-Client-IP");
        if (ip == null) ip = req.getHeader("HTTP_CLIENT_IP");
        if (ip == null) ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        if (ip == null) ip = req.getRemoteAddr();

        // IPv6 loopback → IPv4로 변환
        if ("0:0:0:0:0:0:0:1".equals(ip)) ip = "127.0.0.1";

        // IP 다중일 경우 첫 번째 IP 사용
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        return ip;
    }


    public static String getBrowser() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String agent = request.getHeader("User-Agent");
        if (agent == null) return "Unknown";

        if (agent.contains("Trident")) return "MSIE";
        if (agent.contains("Chrome")) return "Chrome";
        if (agent.contains("Firefox")) return "Firefox";
        if (agent.contains("Safari") && !agent.contains("Chrome")) return "Safari";
        if (agent.contains("Opera") || agent.contains("OPR")) return "Opera";
        if (agent.contains("iPhone")) return "iPhone";
        if (agent.contains("Android")) return "Android";

        return "Unknown";
    }

    public static String getOs() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String agent = request.getHeader("User-Agent");
        if (agent == null) return "Unknown";

        if (agent.contains("Windows NT")) return "Windows NT";
        if (agent.contains("Mac OS X")) return "macOS";
        if (agent.contains("Linux")) return "Linux";
        if (agent.contains("Android")) return "Android";
        if (agent.contains("iPhone") || agent.contains("iPad")) return "iOS";

        return "Unknown";
    }

    public static String getWebType() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String agent = request.getHeader("User-Agent");
        if (agent == null) return "Unknown";

        String mobileKeywords = "iphone|ipod|android|windows ce|blackberry|symbian|windows phone|webos|opera mini|opera mobi|polaris|iemobile|lgtelecom|nokia|sonyericsson|lg|samsung|tablet|ipad";
        for (String keyword : mobileKeywords.split("\\|")) {
            if (agent.toLowerCase().contains(keyword)) {
                return keyword.contains("tablet") || keyword.contains("ipad") ? "Tablet" : "Mobile";
            }
        }
        return "PC";
    }

    public static String getClientInfo() {
        return String.format("browser=[%s] os=[%s] type=[%s]", getBrowser(), getOs(), getWebType());
    }


    public static AppType.Profile[] getActiveProfiles(Environment environment) {
        final String[] profileNames = environment.getActiveProfiles();
        final int profileCount = profileNames.length;

        final AppType.Profile[] profiles = new AppType.Profile[profileCount];
        for (int profileIndex = 0; profileIndex < profileCount; profileIndex++) {
            String profileName = profileNames[profileIndex];
            profiles[profileIndex] = AppType.Profile.valueOf(profileName);
        }

        return profiles;
    }

    public static boolean containsProfile(Environment environment, AppType.Profile profile) {
        AppType.Profile[] activeProfiles = getActiveProfiles(environment);
        return ArrayUtils.contains(activeProfiles, profile);
    }

}
