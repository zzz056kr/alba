package com.system.alba.controller;

import com.system.alba.exception.ServerException;
import com.system.alba.model.PageListDto;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.AttendanceDto;
import com.system.alba.model.dto.ShopDto;
import com.system.alba.model.dto.ShopMemberDto;
import com.system.alba.model.dto.ShopNoticeDto;
import com.system.alba.model.dto.ScheduleDto;
import com.system.alba.service.ShopService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/shop")
@RequiredArgsConstructor
public class ShopController {

    private final ShopService shopService;

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ResponseModel<ShopDto.Detail>> createShop(
            @Valid @RequestBody ShopDto.CreateForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.createShop(form, authentication));
    }

    @PostMapping("/{shopId}/notices")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ShopNoticeDto.Detail>> createShopNotice(
            @PathVariable Long shopId,
            @Valid @RequestBody ShopNoticeDto.CreateForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.createShopNotice(shopId, form, authentication));
    }

    @PostMapping("/{shopId}/schedules")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ScheduleDto.CreateResponse>> createSchedules(
            @PathVariable Long shopId,
            @Valid @RequestBody ScheduleDto.CreateForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.createSchedules(shopId, form, authentication));
    }

    @PostMapping("/{shopId}/attendances/clock-in/qr")
    @PreAuthorize("@shopAuth.isStaff(#shopId)")
    public ResponseEntity<ResponseModel<AttendanceDto.Detail>> clockInByQr(
            @PathVariable Long shopId,
            @Valid @RequestBody AttendanceDto.ClockInQrForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.clockInByQr(shopId, form, authentication));
    }

    @PostMapping("/{shopId}/attendances/clock-out/qr")
    @PreAuthorize("@shopAuth.isStaff(#shopId)")
    public ResponseEntity<ResponseModel<AttendanceDto.Detail>> clockOutByQr(
            @PathVariable Long shopId,
            @Valid @RequestBody AttendanceDto.ClockOutQrForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.clockOutByQr(shopId, form, authentication));
    }

    @PostMapping("/{shopId}/daily-worker/quick-create")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<AttendanceDto.QuickDailyCreateResponse>> createQuickDailyAttendance(
            @PathVariable Long shopId,
            @Valid @RequestBody AttendanceDto.QuickDailyCreateForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.createQuickDailyAttendance(shopId, form, authentication));
    }

    @GetMapping("/{shopId}/attendances")
    @PreAuthorize("@shopAuth.isMember(#shopId)")
    public ResponseEntity<ResponseModel<PageListDto.Response<AttendanceDto.Summary>>> getAttendances(
            @PathVariable Long shopId,
            AttendanceDto.SearchParams params,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.getAttendances(shopId, params, authentication));
    }

    @PutMapping("/{shopId}/attendances/{attendanceId}")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<AttendanceDto.Detail>> editAttendance(
            @PathVariable Long shopId,
            @PathVariable Long attendanceId,
            @Valid @RequestBody AttendanceDto.EditForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.editAttendance(shopId, attendanceId, form, authentication));
    }

    @GetMapping("/{shopId}/schedules")
    @PreAuthorize("@shopAuth.isMember(#shopId)")
    public ResponseEntity<ResponseModel<ScheduleDto.SearchResponse>> getSchedules(
            @PathVariable Long shopId,
            @Valid ScheduleDto.SearchParams params,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.getSchedules(shopId, params, authentication));
    }

    @DeleteMapping("/{shopId}/schedules/{scheduleId}")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<Void>> cancelSchedule(
            @PathVariable Long shopId,
            @PathVariable Long scheduleId,
            Authentication authentication
    ) throws ServerException {
        shopService.cancelSchedule(shopId, scheduleId, authentication);
        return ResponseModel.ok(null);
    }

    @PutMapping("/{shopId}/schedules/{scheduleId}")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ScheduleDto.Detail>> editSchedule(
            @PathVariable Long shopId,
            @PathVariable Long scheduleId,
            @Valid @RequestBody ScheduleDto.EditForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.editSchedule(shopId, scheduleId, form, authentication));
    }

    @GetMapping("/{shopId}")
    @PreAuthorize("@shopAuth.isMember(#shopId)")
    public ResponseEntity<ResponseModel<ShopDto.Detail>> getShop(@PathVariable Long shopId) throws ServerException {
        return ResponseModel.ok(shopService.getShop(shopId));
    }

    @GetMapping("/{shopId}/notices")
    @PreAuthorize("@shopAuth.isMember(#shopId)")
    public ResponseEntity<ResponseModel<List<ShopNoticeDto.Summary>>> getShopNotices(
            @PathVariable Long shopId
    ) throws ServerException {
        return ResponseModel.ok(shopService.getShopNotices(shopId));
    }

    @GetMapping("/{shopId}/members")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<PageListDto.Response<ShopMemberDto.Summary>>> getShopMembers(
            @PathVariable Long shopId,
            ShopMemberDto.SearchParams params
    ) {
        return ResponseModel.ok(shopService.getShopMembers(shopId, params));
    }

    @PostMapping("/{shopId}/members/manual")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ShopMemberDto.Detail>> createManualShopMember(
            @PathVariable Long shopId,
            @Valid @RequestBody ShopMemberDto.ManualCreateForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.createManualShopMember(shopId, form, authentication));
    }

    @PutMapping("/{shopId}/members/{shopMemberId}/approve")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ShopMemberDto.Detail>> approveShopMember(
            @PathVariable Long shopId,
            @PathVariable Long shopMemberId,
            @Valid @RequestBody ShopMemberDto.ApproveForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.approveShopMember(shopId, shopMemberId, form, authentication));
    }

    @PutMapping("/{shopId}")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ShopDto.Detail>> editShop(
            @PathVariable Long shopId,
            @Valid @RequestBody ShopDto.EditForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.editShop(shopId, form, authentication));
    }

    @PostMapping("/{shopId}/qr/reissue")
    @PreAuthorize("@shopAuth.isOwner(#shopId)")
    public ResponseEntity<ResponseModel<ShopDto.QrReissueResponse>> reissueQrCode(
            @PathVariable Long shopId,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.reissueQrCode(shopId, authentication));
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ResponseModel<List<ShopMemberDto.Summary>>> getMyShops(Authentication authentication) throws ServerException {
        return ResponseModel.ok(shopService.getMyShops(authentication));
    }
}
