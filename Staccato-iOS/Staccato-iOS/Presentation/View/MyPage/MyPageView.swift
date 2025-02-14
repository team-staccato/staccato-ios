//
//  MyPageView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/14/25.
//

import SwiftUI

struct MyPageView: View {
    @State var copyButtonPressed: Bool = false

    var body: some View {
        VStack {
            profileImageSection
                .padding(.bottom, 24)
                .padding(.top, 35)

            userNameSection
                .padding(.bottom, 16)

            recoveryCodeCopyButton
                .padding(.bottom, 40)

            Divider()

            menuSection

            Spacer()
        }
        .staccatoNavigationBar(title: "마이페이지", titlePosition: .center)
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}

extension MyPageView {
    private var profileImageSection: some View {
        ZStack {
            Image(.personCircleFill)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray2)
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Image(.pencilCircleFill)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray5)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .frame(width: 84, height: 84)
    }

    private var userNameSection: some View {
        Text("사용자 이름")
            .typography(.body1)
            .foregroundStyle(.staccatoBlack)
    }

    private var recoveryCodeCopyButton: some View {
        Button {
            UIPasteboard.general.string = "복구코드 붙여넣기"
            copyButtonPressed.toggle()
        } label: {
            HStack(spacing: 10) {
                Text("복구 코드 복사하기")
                    .foregroundStyle(.gray3)

                Image(.squareOnSquare)
                    .scaleEffect(x: -1)
                    .foregroundStyle(.gray4)
            }
        }
        .sensoryFeedback(.success, trigger: copyButtonPressed)
        .typography(.body2)
    }

    private var menuSection: some View {
        VStack {
            NavigationLink {
                EmbedWebView(title: "개인정보처리방침", urlString: "https://app.websitepolicies.com/policies/view/7jel2uwv")
            } label: {
                HStack {
                    Text("개인정보처리방침")
                        .typography(.title3)
                        .foregroundStyle(.staccatoBlack)

                    Spacer()

                    Image(.chevronRight)
                        .foregroundStyle(.gray2)
                }
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 24)


            Divider()

            NavigationLink {
                EmbedWebView(title: "피드백으로 혼내주기", urlString: "https://forms.gle/fuxgta7HxDNY5KvSA")
            } label: {
                HStack {
                    Text("피드백으로 혼내주기")
                        .typography(.title3)
                        .foregroundStyle(.staccatoBlack)

                    Spacer()

                    Image(.chevronRight)
                        .foregroundStyle(.gray2)
                }
                .padding(.vertical, 26)
                .padding(.horizontal, 24)
            }

            Divider()

            HStack {
                Text("앱 버전 \(Bundle.main.appVersion)")
                    .typography(.body4)
                    .foregroundStyle(.gray4)
                    .padding(.leading, 24)

                Spacer()

                Image("instagram_icon")
                    .padding(.trailing, 20)
            }
            .padding(.top, 12)
        }
    }
}
