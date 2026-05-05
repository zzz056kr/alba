package com.system.alba.controller;

import com.system.alba.exception.ServerException;
import com.system.alba.model.ResponseModel;
import com.system.alba.model.dto.ShopMemberDto;
import com.system.alba.service.ShopService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/shop-member")
@RequiredArgsConstructor
public class ShopMemberController {

    private final ShopService shopService;

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ResponseModel<ShopMemberDto.Detail>> joinShop(
            @Valid @RequestBody ShopMemberDto.JoinForm form,
            Authentication authentication
    ) throws ServerException {
        return ResponseModel.ok(shopService.joinShop(form, authentication));
    }
}
