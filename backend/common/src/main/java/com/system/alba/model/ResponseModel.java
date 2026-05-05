package com.system.alba.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.ResponseEntity;

@Getter
@NoArgsConstructor
public class ResponseModel<T> {

    private String code;
    private String message;
    private T data;

    public ResponseModel(T data) {
        this.data = data;
    }

    public static <T> ResponseModel<?> error(String code, String message) {
        ResponseModel<T> responseModel = new ResponseModel<>();
        responseModel.code = code;
        responseModel.message = message;
        return responseModel;
    }

    public static <T> ResponseEntity<ResponseModel<T>> ok(T data) {
        ResponseModel<T> responseModel = new ResponseModel<>();
        responseModel.data = data;
        return ResponseEntity.ok(responseModel);
    }
}
