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

    // MARK: - CategoryList
    case folderFillBadgePlus = "folder.fill.badge.plus"
    case sliderHorizontal3 = "slider.horizontal.3"
    case line3HorizontalDecrease = "line.3.horizontal.decrease"
    case arrowtriangleDownFill = "arrowtriangle.down.fill"
    case photoBadgeExclamationmark = "photo.badge.exclamationmark"

    // MARK: - Category
    case pencilLine = "pencil.line"
    case calendar = "calendar"

    // MARK: - Category Edit
    case camera = "camera"
    case xCircleFill = "x.circle.fill"
    case xmark = "xmark"
    case infoCircle = "info.circle"
    case chevronDown = "chevron.down"

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
    case trash = "trash"
    case squareAndArrowUp = "square.and.arrow.up"
    
    // MARK: - Home
    case plus = "plus"
    case dotScope = "dot.scope"
}
