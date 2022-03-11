//
//  RegisterError.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//
enum RegisterError: Error {
    case emptyTextField
    case duplicatenames
    
    var errorMessage: String {
        get {
            switch self {
            case .emptyTextField:
                return "공백은 등록할 수 없습니다"
            case .duplicatenames:
                return "중복된 이름입니다"
            }
        }
    }
}
