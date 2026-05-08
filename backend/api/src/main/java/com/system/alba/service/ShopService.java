package com.system.alba.service;

import com.system.alba.common.AppResultCode;
import com.system.alba.common.AppType;
import com.system.alba.exception.ServerException;
import com.system.alba.model.PageListDto;
import com.system.alba.model.domain.Account;
import com.system.alba.model.domain.Attendance;
import com.system.alba.model.domain.Schedule;
import com.system.alba.model.domain.Shop;
import com.system.alba.model.domain.ShopMember;
import com.system.alba.model.dto.AttendanceDto;
import com.system.alba.model.dto.ShopDto;
import com.system.alba.model.dto.ScheduleDto;
import com.system.alba.model.dto.ShopMemberDto;
import com.system.alba.repository.AttendanceRepository;
import com.system.alba.repository.ScheduleRepository;
import com.system.alba.repository.ShopRepository;
import com.system.alba.repository.ShopMemberRepository;
import com.system.alba.service.common.ThrowService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED)
public class ShopService {
    private static final String SERVICE = "SHOP";
    private static final int MAX_REPEAT_DAYS = 90;
    private static final int MAX_SCHEDULE_VIEW_ROWS = 500;

    private final AccountService accountService;
    private final AttendanceRepository attendanceRepository;
    private final ScheduleRepository scheduleRepository;
    private final ShopRepository shopRepository;
    private final ShopMemberRepository shopMemberRepository;
    private final ShopGeocodingService shopGeocodingService;
    private final ThrowService throwService;

    @Transactional(readOnly = true)
    public List<ShopMemberDto.Summary> getMyShops(Authentication authentication) throws ServerException {
        final String CATEGORY = "GET_MY_SHOPS";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        List<ShopMember> shopMembers = shopMemberRepository
                .findByAccount_NoAndStatusAndShop_StatusOrderByNoDesc(
                        account.getNo(),
                        AppType.ShopMemberStatus.ACTIVE,
                        AppType.ShopStatus.ACTIVE
                );

        return ShopMemberDto.Summary.Mapper.INSTANCE.sourceListToDestinationList(shopMembers);
    }

    @Transactional(readOnly = true)
    public PageListDto.Response<ShopMemberDto.Summary> getShopMembers(Long shopId, ShopMemberDto.SearchParams params) {
        var page = shopMemberRepository.findMembers(shopId, params);
        PageListDto.Response<ShopMemberDto.Summary> response = new PageListDto.Response<>();
        response.pageToResponse(page, ShopMemberDto.Summary.Mapper.INSTANCE);
        return response;
    }

    public ShopDto.Detail createShop(ShopDto.CreateForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "CREATE_SHOP";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = new Shop();
        ShopDto.CreateForm.Mapper.INSTANCE.updateSourceToDestination(form, shop);
        ShopGeocodingService.Coordinates coordinates = shopGeocodingService.resolveCoordinates(shop.getBaseAddress());
        shop.setLatitude(coordinates.getLatitude());
        shop.setLongitude(coordinates.getLongitude());
        shop.setStatus(AppType.ShopStatus.ACTIVE);
        shop.setInviteCode(generateInviteCode());
        shop.setQrCodeValue(UUID.randomUUID().toString());
        shop.setCreatedNo(account.getNo());
        shop.setModifiedNo(account.getNo());
        shop = shopRepository.save(shop);

        ShopMember ownerMember = new ShopMember();
        ownerMember.setShop(shop);
        ownerMember.setAccount(account);
        ownerMember.setName(account.getName());
        ownerMember.setShopRole(AppType.ShopRole.OWNER);
        ownerMember.setIsAppUser(true);
        ownerMember.setEmploymentType(AppType.EmploymentType.REGULAR);
        ownerMember.setStatus(AppType.ShopMemberStatus.ACTIVE);
        ownerMember.setJoinedAt(java.time.LocalDate.now());
        ownerMember.setCreatedNo(account.getNo());
        ownerMember.setModifiedNo(account.getNo());
        shopMemberRepository.save(ownerMember);

        return ShopDto.Detail.Mapper.INSTANCE.sourceToDestination(shop);
    }

    @Transactional(readOnly = true)
    public ShopDto.Detail getShop(Long shopId) throws ServerException {
        final String CATEGORY = "GET_SHOP";

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        return ShopDto.Detail.Mapper.INSTANCE.sourceToDestination(shop);
    }

    public ShopDto.Detail editShop(Long shopId, ShopDto.EditForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "EDIT_SHOP";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        ShopDto.EditForm.Mapper.INSTANCE.updateSourceToDestination(form, shop);
        ShopGeocodingService.Coordinates coordinates = shopGeocodingService.resolveCoordinates(shop.getBaseAddress());
        shop.setLatitude(coordinates.getLatitude());
        shop.setLongitude(coordinates.getLongitude());
        shop.setModifiedNo(account.getNo());
        shop = shopRepository.save(shop);

        return ShopDto.Detail.Mapper.INSTANCE.sourceToDestination(shop);
    }

    public ShopDto.QrReissueResponse reissueQrCode(Long shopId, Authentication authentication) throws ServerException {
        final String CATEGORY = "REISSUE_QR_CODE";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        shop.setQrCodeValue(UUID.randomUUID().toString());
        shop.setModifiedNo(account.getNo());
        shop = shopRepository.save(shop);

        return ShopDto.QrReissueResponse.Mapper.INSTANCE.sourceToDestination(shop);
    }

    public ShopMemberDto.Detail joinShop(ShopMemberDto.JoinForm form, Authentication authentication) throws ServerException {
        final String CATEGORY = "JOIN_SHOP";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findByInviteCodeAndStatus(
                form.getInviteCode().trim(),
                AppType.ShopStatus.ACTIVE
        ).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        boolean alreadyMember = shopMemberRepository.existsByShop_NoAndAccount_No(shop.getNo(), account.getNo());
        if (alreadyMember) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_SHOP_MEMBER_ALREADY_EXISTS");
        }

        ShopMember shopMember = new ShopMember();
        shopMember.setShop(shop);
        shopMember.setAccount(account);
        shopMember.setName(account.getName());
        shopMember.setShopRole(AppType.ShopRole.STAFF);
        shopMember.setIsAppUser(true);
        shopMember.setEmploymentType(AppType.EmploymentType.REGULAR);
        shopMember.setStatus(AppType.ShopMemberStatus.PENDING);
        shopMember.setJoinedAt(java.time.LocalDate.now());
        shopMember.setCreatedNo(account.getNo());
        shopMember.setModifiedNo(account.getNo());
        shopMember = shopMemberRepository.save(shopMember);

        return ShopMemberDto.Detail.Mapper.INSTANCE.sourceToDestination(shopMember);
    }

    public ShopMemberDto.Detail approveShopMember(
            Long shopId,
            Long shopMemberId,
            ShopMemberDto.ApproveForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "APPROVE_SHOP_MEMBER";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        ShopMember shopMember = shopMemberRepository.findByNoAndShop_No(shopMemberId, shopId).orElse(null);
        if (shopMember == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_MEMBER_NOT_FOUND");
        }

        shopMember.setBaseWage(form.getBaseWage());
        shopMember.setStatus(AppType.ShopMemberStatus.ACTIVE);
        shopMember.setModifiedNo(account.getNo());
        shopMember = shopMemberRepository.save(shopMember);

        return ShopMemberDto.Detail.Mapper.INSTANCE.sourceToDestination(shopMember);
    }

    public ShopMemberDto.Detail createManualShopMember(
            Long shopId,
            ShopMemberDto.ManualCreateForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "CREATE_MANUAL_SHOP_MEMBER";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        ShopMember shopMember = new ShopMember();
        shopMember.setShop(shop);
        shopMember.setAccount(null);
        shopMember.setName(form.getName().trim());
        shopMember.setShopRole(AppType.ShopRole.STAFF);
        shopMember.setBaseWage(form.getBaseWage());
        shopMember.setIsAppUser(false);
        shopMember.setEmploymentType(form.getEmploymentType());
        shopMember.setStatus(AppType.ShopMemberStatus.ACTIVE);
        shopMember.setJoinedAt(java.time.LocalDate.now());
        shopMember.setCreatedNo(account.getNo());
        shopMember.setModifiedNo(account.getNo());
        shopMember = shopMemberRepository.save(shopMember);

        return ShopMemberDto.Detail.Mapper.INSTANCE.sourceToDestination(shopMember);
    }

    public ScheduleDto.CreateResponse createSchedules(
            Long shopId,
            ScheduleDto.CreateForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "CREATE_SCHEDULES";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        ShopMember shopMember = shopMemberRepository.findByNoAndShop_No(form.getShopMemberId(), shopId).orElse(null);
        if (shopMember == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_MEMBER_NOT_FOUND");
        }

        if (form.getEndTime().isBefore(form.getStartTime()) || form.getEndTime().equals(form.getStartTime())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        List<LocalDate> workDates = resolveScheduleDates(form);
        List<Schedule> schedules = new ArrayList<>();
        for (LocalDate workDate : workDates) {
            Schedule schedule = new Schedule();
            schedule.setShop(shop);
            schedule.setShopMember(shopMember);
            schedule.setWorkDate(workDate);
            schedule.setStartTime(form.getStartTime());
            schedule.setEndTime(form.getEndTime());
            schedule.setStatus(AppType.ScheduleStatus.SCHEDULED);
            schedule.setCreatedNo(account.getNo());
            schedule.setModifiedNo(account.getNo());
            schedules.add(schedule);
        }

        schedules = scheduleRepository.saveAll(schedules);

        ScheduleDto.CreateResponse response = new ScheduleDto.CreateResponse();
        response.setSchedules(ScheduleDto.Detail.Mapper.INSTANCE.sourceListToDestinationList(schedules));
        return response;
    }

    @Transactional(readOnly = true)
    public ScheduleDto.SearchResponse getSchedules(Long shopId, ScheduleDto.SearchParams params, Authentication authentication) throws ServerException {
        final String CATEGORY = "GET_SCHEDULES";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);
        ShopMember callerShopMember = shopMemberRepository
                .findByShop_NoAndAccount_NoAndStatus(shopId, account.getNo(), AppType.ShopMemberStatus.ACTIVE)
                .orElse(null);
        if (callerShopMember == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        LocalDate baseDate = params.getBaseDate();
        LocalDate startDate;
        LocalDate endDate;

        if (params.getViewType() == ScheduleDto.ViewType.WEEK) {
            startDate = baseDate.minusDays(baseDate.getDayOfWeek().getValue() - 1L);
            endDate = startDate.plusDays(6);
        } else {
            startDate = baseDate.withDayOfMonth(1);
            endDate = baseDate.withDayOfMonth(baseDate.lengthOfMonth());
        }

        Long targetShopMemberId = null;
        if (callerShopMember.getShopRole() == AppType.ShopRole.OWNER) {
            targetShopMemberId = params.getShopMemberId();
        } else {
            targetShopMemberId = callerShopMember.getNo();
        }

        List<Schedule> schedules = scheduleRepository.findSchedules(
                shopId,
                targetShopMemberId,
                startDate,
                endDate,
                MAX_SCHEDULE_VIEW_ROWS + 1L
        );

        if (schedules.size() > MAX_SCHEDULE_VIEW_ROWS) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        ScheduleDto.SearchResponse response = new ScheduleDto.SearchResponse();
        response.setViewType(params.getViewType());
        response.setBaseDate(baseDate);
        response.setStartDate(startDate);
        response.setEndDate(endDate);
        response.setSchedules(ScheduleDto.Summary.Mapper.INSTANCE.sourceListToDestinationList(schedules));
        return response;
    }

    public void cancelSchedule(Long shopId, Long scheduleId, Authentication authentication) throws ServerException {
        final String CATEGORY = "CANCEL_SCHEDULE";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Schedule schedule = scheduleRepository.findByNoAndShop_No(scheduleId, shopId).orElse(null);
        if (schedule == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_NOT_FOUND");
        }

        schedule.setStatus(AppType.ScheduleStatus.CANCELED);
        schedule.setModifiedNo(account.getNo());
        scheduleRepository.save(schedule);
    }

    public AttendanceDto.Detail clockInByQr(
            Long shopId,
            AttendanceDto.ClockInQrForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "CLOCK_IN_QR";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        if (!form.getQrCodeValue().trim().equals(shop.getQrCodeValue())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        ShopMember shopMember = shopMemberRepository
                .findByShop_NoAndAccount_NoAndStatus(shopId, account.getNo(), AppType.ShopMemberStatus.ACTIVE)
                .orElse(null);
        if (shopMember == null || shopMember.getShopRole() != AppType.ShopRole.STAFF) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDate workDate = now.toLocalDate();

        Attendance existingOpenAttendance = attendanceRepository
                .findFirstByShopMember_NoAndWorkDateAndClockOutAtIsNullOrderByClockInAtDesc(shopMember.getNo(), workDate)
                .orElse(null);
        if (existingOpenAttendance != null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.CONFLICT, "RESULT_CONFLICT");
        }

        Schedule schedule = scheduleRepository
                .findFirstByShopMember_NoAndWorkDateAndStatusOrderByStartTimeAsc(
                        shopMember.getNo(),
                        workDate,
                        AppType.ScheduleStatus.SCHEDULED
                )
                .orElse(null);

        Attendance attendance = new Attendance();
        attendance.setShop(shop);
        attendance.setShopMember(shopMember);
        attendance.setSchedule(schedule);
        attendance.setWorkDate(workDate);
        attendance.setClockInAt(now);
        attendance.setClockInLat(form.getLatitude());
        attendance.setClockInLng(form.getLongitude());
        attendance.setAuthType(AppType.AttendanceAuthType.QR_GPS);
        attendance.setCreatedNo(account.getNo());
        attendance.setModifiedNo(account.getNo());
        attendance = attendanceRepository.save(attendance);

        return AttendanceDto.Detail.Mapper.INSTANCE.sourceToDestination(attendance);
    }

    public AttendanceDto.Detail clockOutByQr(
            Long shopId,
            AttendanceDto.ClockOutQrForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "CLOCK_OUT_QR";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        if (!form.getQrCodeValue().trim().equals(shop.getQrCodeValue())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        ShopMember shopMember = shopMemberRepository
                .findByShop_NoAndAccount_NoAndStatus(shopId, account.getNo(), AppType.ShopMemberStatus.ACTIVE)
                .orElse(null);
        if (shopMember == null || shopMember.getShopRole() != AppType.ShopRole.STAFF) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        Attendance attendance = attendanceRepository
                .findFirstByShopMember_NoAndClockOutAtIsNullOrderByClockInAtDesc(shopMember.getNo())
                .orElse(null);
        if (attendance == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_NOT_FOUND");
        }

        attendance.setClockOutAt(LocalDateTime.now());
        attendance.setClockOutLat(form.getLatitude());
        attendance.setClockOutLng(form.getLongitude());
        attendance.setClockOutStatus(AppType.ClockOutStatus.NORMAL);
        attendance.setModifiedNo(account.getNo());
        attendance = attendanceRepository.save(attendance);

        return AttendanceDto.Detail.Mapper.INSTANCE.sourceToDestination(attendance);
    }

    public AttendanceDto.QuickDailyCreateResponse createQuickDailyAttendance(
            Long shopId,
            AttendanceDto.QuickDailyCreateForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "CREATE_QUICK_DAILY_ATTENDANCE";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        if (form.getEndTime().isBefore(form.getStartTime()) || form.getEndTime().equals(form.getStartTime())) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_SHOP_NOT_FOUND");
        }

        ShopMember shopMember = new ShopMember();
        shopMember.setShop(shop);
        shopMember.setAccount(null);
        shopMember.setName(form.getName().trim());
        shopMember.setShopRole(AppType.ShopRole.STAFF);
        shopMember.setBaseWage(form.getBaseWage());
        shopMember.setIsAppUser(false);
        shopMember.setEmploymentType(AppType.EmploymentType.DAILY);
        shopMember.setStatus(AppType.ShopMemberStatus.ACTIVE);
        shopMember.setJoinedAt(form.getWorkDate());
        shopMember.setCreatedNo(account.getNo());
        shopMember.setModifiedNo(account.getNo());
        shopMember = shopMemberRepository.save(shopMember);

        Schedule schedule = new Schedule();
        schedule.setShop(shop);
        schedule.setShopMember(shopMember);
        schedule.setWorkDate(form.getWorkDate());
        schedule.setStartTime(form.getStartTime());
        schedule.setEndTime(form.getEndTime());
        schedule.setStatus(AppType.ScheduleStatus.SCHEDULED);
        schedule.setCreatedNo(account.getNo());
        schedule.setModifiedNo(account.getNo());
        schedule = scheduleRepository.save(schedule);

        Attendance attendance = new Attendance();
        attendance.setShop(shop);
        attendance.setShopMember(shopMember);
        attendance.setSchedule(schedule);
        attendance.setWorkDate(form.getWorkDate());
        attendance.setClockInAt(LocalDateTime.of(form.getWorkDate(), form.getStartTime()));
        attendance.setClockOutAt(LocalDateTime.of(form.getWorkDate(), form.getEndTime()));
        attendance.setAuthType(AppType.AttendanceAuthType.MANUAL);
        attendance.setClockInStatus(AppType.ClockInStatus.NORMAL);
        attendance.setClockOutStatus(AppType.ClockOutStatus.NORMAL);
        attendance.setCreatedNo(account.getNo());
        attendance.setModifiedNo(account.getNo());
        attendance = attendanceRepository.save(attendance);

        AttendanceDto.QuickDailyCreateResponse response = new AttendanceDto.QuickDailyCreateResponse();
        response.setShopMember(ShopMemberDto.Detail.Mapper.INSTANCE.sourceToDestination(shopMember));
        response.setSchedule(ScheduleDto.Detail.Mapper.INSTANCE.sourceToDestination(schedule));
        response.setAttendance(AttendanceDto.Detail.Mapper.INSTANCE.sourceToDestination(attendance));
        return response;
    }

    @Transactional(readOnly = true)
    public PageListDto.Response<AttendanceDto.Summary> getAttendances(
            Long shopId,
            AttendanceDto.SearchParams params,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "GET_ATTENDANCES";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        ShopMember shopMember = shopMemberRepository
                .findByShop_NoAndAccount_NoAndStatus(shopId, account.getNo(), AppType.ShopMemberStatus.ACTIVE)
                .orElse(null);
        if (shopMember == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.FORBIDDEN, "RESULT_FORBIDDEN");
        }

        Long targetShopMemberId = shopMember.getShopRole() == AppType.ShopRole.OWNER ? null : shopMember.getNo();
        LocalDate startDate = params != null ? params.getStartDate() : null;
        LocalDate endDate = params != null ? params.getEndDate() : null;

        int page = params != null ? Math.max(params.getPage() - 1, 0) : 0;
        int size = params != null ? params.getSize() : 20;

        var attendancePage = attendanceRepository.findAttendances(shopId, startDate, endDate, targetShopMemberId, page, size);
        List<Attendance> attendances = attendancePage.getContent();
        List<AttendanceDto.Summary> summaries = AttendanceDto.Summary.Mapper.INSTANCE.sourceListToDestinationList(attendances);
        enrichAttendanceSummaries(attendances, summaries);

        PageListDto.Response<AttendanceDto.Summary> response = new PageListDto.Response<>();
        response.pageToResponse(attendancePage, AttendanceDto.Summary.Mapper.INSTANCE);
        response.setList(summaries);
        return response;
    }

    public AttendanceDto.Detail editAttendance(
            Long shopId,
            Long attendanceId,
            AttendanceDto.EditForm form,
            Authentication authentication
    ) throws ServerException {
        final String CATEGORY = "EDIT_ATTENDANCE";

        String principalName = authentication.getName();
        if (principalName == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.UNAUTHORIZED, "RESULT_UNAUTHORIZED");
        }

        Account account = accountService.activeUserCheckByPrincipalName(SERVICE, CATEGORY, principalName);

        Attendance attendance = attendanceRepository.findByNoAndShop_No(attendanceId, shopId).orElse(null);
        if (attendance == null) {
            throw throwService.throwErrorByCode(SERVICE, CATEGORY, AppResultCode.NOT_FOUND, "RESULT_NOT_FOUND");
        }

        AttendanceDto.EditForm.Mapper.INSTANCE.updateSourceToDestination(form, attendance);
        attendance.setModifiedNo(account.getNo());
        attendance = attendanceRepository.save(attendance);

        AttendanceDto.Detail detail = AttendanceDto.Detail.Mapper.INSTANCE.sourceToDestination(attendance);
        Integer baseWage = attendance.getShopMember() != null ? attendance.getShopMember().getBaseWage() : null;
        detail.setBaseWage(baseWage);
        if (attendance.getClockInAt() != null && attendance.getClockOutAt() != null) {
            long workedMinutes = Duration.between(attendance.getClockInAt(), attendance.getClockOutAt()).toMinutes();
            detail.setWorkedMinutes(workedMinutes);
            if (baseWage != null) {
                detail.setEstimatedPay(Math.round(baseWage * (workedMinutes / 60.0d)));
            }
        }
        return detail;
    }

    private List<LocalDate> resolveScheduleDates(ScheduleDto.CreateForm form) throws ServerException {
        List<LocalDate> dates = new ArrayList<>();
        LocalDate startDate = form.getWorkDate();
        LocalDate repeatUntil = form.getRepeatUntil();

        if (repeatUntil == null) {
            dates.add(startDate);
            return dates;
        }

        if (repeatUntil.isBefore(startDate)) {
            throw throwService.throwErrorByCode(SERVICE, "CREATE_SCHEDULES", AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        if (ChronoUnit.DAYS.between(startDate, repeatUntil) > MAX_REPEAT_DAYS) {
            throw throwService.throwErrorByCode(SERVICE, "CREATE_SCHEDULES", AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        List<DayOfWeek> repeatDays = form.getRepeatDaysOfWeek();
        if (repeatDays == null || repeatDays.isEmpty()) {
            repeatDays = List.of(startDate.getDayOfWeek());
        }

        LocalDate cursor = startDate;
        while (!cursor.isAfter(repeatUntil)) {
            if (repeatDays.contains(cursor.getDayOfWeek())) {
                dates.add(cursor);
            }
            cursor = cursor.plusDays(1);
        }

        if (dates.isEmpty()) {
            throw throwService.throwErrorByCode(SERVICE, "CREATE_SCHEDULES", AppResultCode.BAD_REQUEST, "RESULT_INVALID_PARAMETER");
        }

        return dates;
    }

    private void enrichAttendanceSummaries(List<Attendance> attendances, List<AttendanceDto.Summary> summaries) {
        for (int index = 0; index < attendances.size(); index++) {
            Attendance attendance = attendances.get(index);
            AttendanceDto.Summary summary = summaries.get(index);

            Integer baseWage = attendance.getShopMember() != null ? attendance.getShopMember().getBaseWage() : null;
            summary.setBaseWage(baseWage);

            if (attendance.getClockInAt() != null && attendance.getClockOutAt() != null) {
                long workedMinutes = Duration.between(attendance.getClockInAt(), attendance.getClockOutAt()).toMinutes();
                summary.setWorkedMinutes(workedMinutes);

                if (baseWage != null) {
                    long estimatedPay = Math.round(baseWage * (workedMinutes / 60.0d));
                    summary.setEstimatedPay(estimatedPay);
                }
            }
        }
    }

    private String generateInviteCode() {
        for (int attempt = 0; attempt < 20; attempt++) {
            String candidate = UUID.randomUUID().toString().replace("-", "").substring(0, 10).toUpperCase();
            if (!shopRepository.existsByInviteCode(candidate)) {
                return candidate;
            }
        }

        throw new IllegalStateException("Failed to generate unique invite code");
    }
}
