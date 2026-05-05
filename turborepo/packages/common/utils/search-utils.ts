/**
 * 검색 파라미터 관련 유틸리티 함수들
 */

type StringKeyOf<T extends object> = Extract<keyof T, string>

/**
 * 제네릭 serialize 함수를 생성하는 팩토리 함수
 * @param excludeFromUrl - URL에서 제외할 키들 (기본값: ['size'])
 * @returns serialize 함수
 */
export function createSerializer<T extends object>(
  excludeFromUrl: StringKeyOf<T>[] = ['size' as StringKeyOf<T>]
) {
  return (values: T): Record<string, string> => {
    const params: Record<string, string> = {}

    ;(Object.entries(values) as Array<[StringKeyOf<T>, T[StringKeyOf<T>]]>).forEach(([key, value]) => {
      // 제외할 키들 스킵
      if (excludeFromUrl.includes(key)) return

      // 값이 없으면 스킵
      if (!value || value === '' || value === 0) return

      // 배열 처리
      if (Array.isArray(value)) {
        if (value.length > 0) {
          params[key] = value.join(',')
        }
        return
      }

      // 페이지가 1이면 URL에 포함하지 않음 (1-indexed 기본값)
      if (key === 'page' && value === 1) return

      // 기본값 처리
      params[key] = String(value)
    })

    return params
  }
}

/**
 * 제네릭 deserialize 함수를 생성하는 팩토리 함수
 * @param defaultValues - 기본값 객체
 * @param arrayFields - 배열로 처리할 필드들 (기본값: [])
 * @returns deserialize 함수
 */
export function createDeserializer<T extends object>(
  defaultValues: T,
  arrayFields: StringKeyOf<T>[] = []
) {
  return (params: URLSearchParams): T => {
    const result = { ...defaultValues }
    const typedResult = result as Record<StringKeyOf<T>, T[StringKeyOf<T>]>

    ;(Object.keys(defaultValues) as StringKeyOf<T>[]).forEach((key) => {
      const param = params.get(key)
      if (!param) return

      // 배열 필드 처리
      if (arrayFields.includes(key)) {
        typedResult[key] = param.split(',').filter(Boolean) as T[StringKeyOf<T>]
        return
      }

      // 숫자 필드 처리
      if (typeof defaultValues[key] === 'number') {
        const num = parseInt(param, 10)
        typedResult[key] = (num >= 0 ? num : defaultValues[key]) as T[StringKeyOf<T>]
        return
      }

      // 문자열 필드 처리
      typedResult[key] = param as T[StringKeyOf<T>]
    })

    return result
  }
}
