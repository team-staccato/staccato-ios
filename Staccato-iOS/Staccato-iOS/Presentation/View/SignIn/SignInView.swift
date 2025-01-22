//
//  SignInView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

struct SignInView: View {
    
    @State private var nickName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                //TODO: 이미지 바꿔야됨
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                TextField("닉네임을 입력해주세요", text: $nickName)
                    .padding()
                    .background(.gray1)
                    .cornerRadius(4)
                    .shadow(color: .gray3.opacity(0.5), radius: 10, x: 0, y: 5)
                    .onChange(of: nickName) { _, newValue in
                        if newValue.count > 20 {
                            nickName = String(newValue.prefix(20))
                        }
                    }
                Text("\(nickName.count)/20")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)
                Button(action: {
                    //TODO: 버튼 액션 추가해야됨
                    print("시작하기 버튼이 눌렸습니다.")
                }) {
                    Text("시작하기")
                        .typography(.title3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(.gray1)
                        .foregroundColor(.gray4)
                        .cornerRadius(4)
                }
                .padding(.vertical)
                NavigationLink(destination: RecoverAccountView()) {
                    Text("이전 기록을 불러오려면 여기를 눌러주세요")
                        .typography(.body4)
                        .foregroundColor(.gray4)
                        .underline()
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    SignInView()
}
