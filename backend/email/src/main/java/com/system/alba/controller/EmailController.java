package com.system.alba.controller;

import com.system.alba.common.AppConstants;
import com.system.alba.common.Loggable;
import com.system.alba.exception.ServerException;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.EmailDto;
import com.system.alba.service.EmailAuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/email")
@RequiredArgsConstructor
public class EmailController {

    private final EmailAuthService emailAuthService;

    @PostMapping("/send-auth-code")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> sendAuthCode(@Valid @RequestBody EmailDto.SendAuthCodeForm form) {
        emailAuthService.sendAuthCode(form.getEmail(), form.getType());
        return ResponseModel.ok(null);
    }

    @PostMapping("/verify")
    @Loggable(saveTypes = {AppConstants.LOGGABLE_TYPE.Request})
    public ResponseEntity<ResponseModel<Void>> verify(@Valid @RequestBody EmailDto.VerifyForm form) throws ServerException {
        emailAuthService.verify(form.getEmail(), form.getCode(), form.getType());
        return ResponseModel.ok(null);
    }

}