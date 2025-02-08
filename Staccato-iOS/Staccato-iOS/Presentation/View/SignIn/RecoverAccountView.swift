//
//  RecoverAccountView.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/23/25.
//

import SwiftUI

struct RecoverAccountView: View {
    
    @State private var code: String = ""
    
    var body: some View {
        VStack {
            Text("이전 기록을 불러올게요\n고유 코드를 입력해주세요")
                .typography(.title1)
                .foregroundStyle(.staccatoBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                .padding(.top)
            TextField(
                "ex) bt2hnhd4-07kght-0pp2ln",
                text: $code
            )
            .padding()
            .background(.gray1)
            .cornerRadius(4)
            .onChange(of: code) { _, newValue in
                if newValue.count > 36 {
                    code = String(newValue.prefix(36))
                }
            }
            Text("\(code.count)/36")
                .typography(.body4)
                .foregroundStyle(.gray3)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom)
            Spacer()
            Button("시작하기") {
                print("불러오기 버튼 눌렸음")
            }
            .buttonStyle(.staccatoFullWidth)
            .padding(.vertical)
            .disabled(code.count != 36)
        }
        .padding(.horizontal, 24)
        .staccatoNavigationBar()
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    RecoverAccountView()
}
