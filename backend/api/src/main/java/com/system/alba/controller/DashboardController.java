package com.system.alba.controller;

import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.DashboardDto;
import com.system.alba.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/stats")
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    public ResponseEntity<ResponseModel<DashboardDto.Stats>> getStats() {
        return ResponseModel.ok(dashboardService.getStats());
    }
}
