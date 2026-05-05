import { AppType } from "../../constants/app-type";
import * as AccountDto from "./account-dto";

export * as TokenDto from "./token-dto";

export interface TokenResponse {
  accessToken?: string
  accessTokenExpiresIn?: number
  roles?: Array<AppType.AccountRole>
  account?: AccountDto.Abbr
}
