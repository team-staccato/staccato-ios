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
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.dismiss) var dismiss

    let title: String?
    let subtitle: String?
    let backButtonImage: Image
    let trailingButtons: T
    let titlePosition: TitlePosition
    let barType: STNavigationBarType

    init(
        title: String?,
        subtitle: String?,
        titlePosition: TitlePosition = .leading,
        barType: STNavigationBarType,
        backButtonImage: Image = Image(.chevronLeft),
        @ViewBuilder trailingButtons: () -> T
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titlePosition = titlePosition
        self.barType = barType
        self.backButtonImage = backButtonImage
        self.trailingButtons = trailingButtons()
    }

    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack(spacing: 16) {
                    Button  {
                        barType == .navigation ? navigationManager.dismiss() : dismiss()
                    } label: {
                        backButtonImage
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
                    .padding(.trailing, 16)
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
        backButtonImage: Image = Image(.chevronLeft),
        @ViewBuilder trailingButtons: () -> T
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .navigation, backButtonImage: backButtonImage, trailingButtons: trailingButtons))
            .background(.staccatoWhite)
            .padding(.top, 10)
    }

    func staccatoNavigationBar(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading,
        backbuttonImage: Image = Image(.chevronLeft)
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .navigation, backButtonImage: backbuttonImage, trailingButtons: { }))
            .background(.staccatoWhite)
            .padding(.top, 10)
    }

    func staccatoModalBar<T: View>(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading,
        backButtonImage: Image = Image(.chevronLeft),
        @ViewBuilder trailingButtons: () -> T
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .modal, backButtonImage: backButtonImage, trailingButtons: trailingButtons))
            .background(.staccatoWhite)
    }

    func staccatoModalBar(
        title: String? = nil,
        subtitle: String? = nil,
        titlePosition: TitlePosition = .leading,
        backButtonImage: Image = Image(.chevronLeft)
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, titlePosition: titlePosition, barType: .modal, backButtonImage: backButtonImage, trailingButtons: { }))
            .background(.staccatoWhite)
    }

}
