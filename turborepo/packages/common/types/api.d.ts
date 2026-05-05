import 'axios';

declare module "axios" {
  interface AxiosRequestConfig {
    showErrorPopup?: boolean
    showLoading?: boolean;
  }
  interface CreateAxiosDefaults {
    showErrorPopup?: boolean
  }
}
