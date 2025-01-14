//
//  StaccatoNavigationBar.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/9/25.
//

import SwiftUI

struct StaccatoNavigationBar<T: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss

    let title: String?
    let subtitle: String?
    let trailingButtons: T

    init(title: String?, subtitle: String?, @ViewBuilder trailingButtons: () -> T) {
        self.title = title
        self.subtitle = subtitle
        self.trailingButtons = trailingButtons()
    }

    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack(spacing: 16) {
                    Button  {
                        dismiss()
                    } label: {
                        Image(.chevronLeft)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.leading, 16)
                            .foregroundStyle(.gray2)
                    }

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

                    Spacer()

                    // 여기에 오른쪽 요소들
                    HStack(spacing: 16) {
                        trailingButtons
                    }
                    .padding(.trailing, 10)
                    .typography(.body2)
                    .foregroundStyle(.gray5)
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

#Preview {
    NavigationStack {
        NavigationLink {
            VStack {
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
                Text("컨텐츠")
            }
            .staccatoNavigationBar(title: "카테고리 만들기", subtitle: "스타카토를 담을 카테고리를 만들어 보세요!")
        } label: {
            Text("NavigationTest : 다음 화면으로 이동")
        }
    }
}

extension View {
    func staccatoNavigationBar<T: View>(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder trailingButtons: () -> T
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, trailingButtons: trailingButtons))
    }

    func staccatoNavigationBar(
        title: String? = nil,
        subtitle: String? = nil
    ) -> some View {
        self
            .modifier(StaccatoNavigationBar(title: title, subtitle: subtitle, trailingButtons: { }))
    }
}
