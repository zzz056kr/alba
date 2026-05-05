typedef FieldValidator = String? Function(String? value);

class AccountSchema {
  const AccountSchema._();

  static FieldValidator get loginId => (value) {
    if (value == null || value.trim().isEmpty) {
      return '아이디를 입력해주세요.';
    }
    return null;
  };

  static FieldValidator get loginPassword => (value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    return null;
  };

  static FieldValidator get registerId => (value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '아이디는 필수입니다';
    }
    if (normalized.length < 3) {
      return '아이디는 최소 3자 이상이어야 합니다';
    }
    if (normalized.length > 50) {
      return '아이디는 최대 50자까지 입력 가능합니다';
    }
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(normalized)) {
      return '아이디는 영문, 숫자, _, - 만 사용 가능합니다';
    }
    return null;
  };

  static FieldValidator get registerName => (value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '이름은 필수입니다';
    }
    if (normalized.length > 50) {
      return '이름은 최대 50자까지 입력 가능합니다';
    }
    return null;
  };

  static FieldValidator get registerEmail => (value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '이메일은 필수입니다';
    }
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(normalized)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  };

  static FieldValidator get authCode => (value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '인증 코드를 입력해주세요.';
    }
    if (normalized.length != 6) {
      return '인증 코드는 6자리여야 합니다.';
    }
    return null;
  };

  static FieldValidator get registerPassword => (value) {
    if (value == null || value.isEmpty) {
      return '비밀번호는 필수입니다';
    }
    if (value.length < 4) {
      return '비밀번호는 최소 4자 이상이어야 합니다';
    }
    if (value.length > 100) {
      return '비밀번호는 최대 100자까지 입력 가능합니다';
    }
    return null;
  };

  static FieldValidator confirmPassword(String password) => (value) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인은 필수입니다';
    }
    if (value != password) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  };
}
