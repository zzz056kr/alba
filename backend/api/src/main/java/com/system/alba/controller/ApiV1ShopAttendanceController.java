package com.system.alba.controller;

import com.system.alba.exception.ServerException;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.AttendanceDto;
import com.system.alba.service.ShopService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/shops")
@RequiredArgsConstructor
public class ApiV1ShopAttendanceController {

    private final ShopService shopService;

    @PostMapping("/{shopId}/attendances/clock-out/qr")
    @PreAuthorize("@shopAuth.isStaff(#shopId)")
    public ResponseEntity<ResponseModel<AttendanceDto.Detail>> clockOutByQr(
            @PathVariable Long shopId,
            @Valid @RequestBody AttendanceDto.ClockOutQrForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.clockOutByQr(shopId, form, authentication));
    }
}
