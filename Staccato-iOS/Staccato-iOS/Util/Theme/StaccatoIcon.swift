//
//  StaccatoIcon.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

/// `StaccatoIcon`은 앱 전반에서 사용하는 **아이콘(SF Symbols 혹은 커스텀 에셋)**을
/// 열거형으로 관리하기 위한 타입입니다.
///
/// - Usage:
///   ```swift
///   // SF Symbol 사용 예시
///   Image(.chevronLeft)
///     .resizable()
///     .frame(width: 24, height: 24)
///   ```
enum StaccatoIcon: String {
    // MARK: - Toolbar
    case chevronLeft = "chevron.left"

    // MARK: - Categories
    case folderFill = "folder.fill"
    case sliderHorizontal3 = "slider.horizontal.3"

    // MARK: - Category
    case pencilLine = "pencil.line"
    case calendar = "calendar"

    // MARK: - Category Creation/Update
    case camera = "camera"
    case xCircleFill = "x.circle.fill"

    // MARK: - Staccato Creation/Update
    case location = "location"
    case minusCircle = "minus.circle"
    case magnifyingGlass = "magnifyingglass"

    // MARK: - MyPage
    case pencilCircleFill = "pencil.circle.fill"
    case squareOnSquare = "square.on.square"
    case chevronRight = "chevron.right"
    case personCircleFill = "person.circle.fill"
    
    // MARK: - Staccato Detail
    case arrowRightCircleFill = "arrow.right.circle.fill"
    
    // MARK: - Home
    case dotScope = "dot.scope"
}
