export * as AuthDto from './auth-dto';

export interface SignUpRequest {
  id?: string;
  password?: string;
  name?: string;
  email?: string;
}


export interface SendAuthCodeRequest {
  email?: string;
}

export interface VerifyAuthCodeRequest {
  email?: string;
  authCode?: string;
}
