//
//  StaccatoNavigationBar.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/9/25.
//

import SwiftUI

// MARK: - Enums

enum STNavigationBarType {
    case navigation, modal
}

enum TitlePosition {
    case center, leading
}


// MARK: - ViewModifier

struct StaccatoNavigationBar<T: View>: ViewModifier {
    
    @Environment(NavigationState.self) var navigationState
    @Environment(\.dismiss) var dismiss

    let title: String?
    let subtitle: String?
    let trailingButtons: T
    let titlePosition: TitlePosition
    let barType: STNavigationBarType

    init(
        title: String?,
        subtitle: String?,
        titlePosition: TitlePosition = .leading,
        barType: STNavigationBarType,
        @ViewBuilder trailingButtons: () -> T
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titlePosition = titlePosition
        self.barType = barType
        self.trailingButtons = trailingButtons()
    }

    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack(spacing: 16) {
                    Button  {
                        barType == .navigation ? navigationState.dismiss() : dismiss()
                    } label: {
                        Image(.chevronLeft)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.leading, 16)
                            .foregroundStyle(.gray3)
                    }

                    if titlePosition == .leading {
                        VStack(alignment: .leading) {
                            if let title {
                                Text(title)
                                    .typography(.title2)
                                    .foregroundStyle(.gray5)
                            }

                            if let subtitle {
                                Text(subtitle)
                                    .typography(.body4)
                                    .foregroundStyle(.gray5)
                            }
                        }
                    }

                    Spacer()

                    // 여기에 오른쪽 요소들
                    HStack(spacing: 16) {
                        trailingButtons
                    }
                    .padding(.trailing, 10)
                    .typography(.body2)
                    .foregroundStyle(.gray5)
                }

                if titlePosition == .center {
                    HStack {
                        Spacer()

                        if let title {
                            Text(title)
                                .typography(.title2)
                                .foregroundStyle(.gray5)
                        }

                        Spacer()
                    }
                }

            }
            .frame(height: 56)

            Spacer()

            content

            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}


#Preview("Position - Leading") {
    NavigationStack {
        NavigationLink {
            VStack {
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
            }
            .staccatoNavigationBar(title: "카테고리 만들기", subtitle: "스타카토를 담을 카테고리를 만들어 보세요!") {
                Button("버튼") { }
                Button("버튼") { }
                Button("버튼") { }
            }
        } label: {
            Text("NavigationTest : 다음 화면으로 이동")
        }
    }
}

#Preview("Position - Center") {
    NavigationStack {
        NavigationLink {
            VStack {
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
            }
            .staccatoNavigationBar(title: "마이페이지", titlePosition: .center)
        } label: {
            Text("NavigationTest : 다음 화면으로 이동")
        }
    }
}


// MARK: - Ex+View

extension View {

    func staccatoNavigationBar<T: View>(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading,
        @ViewBuilder trailingButtons: () -> T
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .navigation, trailingButtons: trailingButtons))
    }

    func staccatoNavigationBar(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .navigation, trailingButtons: { }))
    }

    func staccatoModalBar<T: View>(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading,
        @ViewBuilder trailingButtons: () -> T
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .modal, trailingButtons: trailingButtons))
    }

    func staccatoModalBar(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .modal, trailingButtons: { }))
    }

}
