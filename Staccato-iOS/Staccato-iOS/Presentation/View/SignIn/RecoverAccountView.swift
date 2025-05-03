//
//  RecoverAccountView.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/23/25.
//

import SwiftUI

struct RecoverAccountView: View {

    @EnvironmentObject var viewModel: SignInViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var code: String = ""
    @State private var errorMessage: String?
    
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
                login()
            }
            .buttonStyle(.staccatoFullWidth)
            .padding(.vertical)
            .disabled(code.count != 36)
        }
        .alert(isPresented: Binding<Bool>(
            get: { errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            Alert(
                title: Text("로그인 실패"),
                message: Text(errorMessage ?? "알 수 없는 오류"),
                dismissButton: .default(Text("확인"))
            )
        }
        .padding(.horizontal, 24)
        .ignoresSafeArea(.all, edges: .bottom)

        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(.chevronLeft)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.leading, 16)
                            .foregroundStyle(.gray3)
                    }
                }
            }
        }
    }
}

extension RecoverAccountView {
    private func login() {
        Task {
            do {
                let _ = try await viewModel.login(withCode: code)
            } catch let error as NetworkError {
                switch error {
                case .badRequest(let message):
                    errorMessage = message
                default:
                    errorMessage = error.localizedDescription
                }
            } catch {
                errorMessage = "알 수 없는 오류"
            }
        }
    }
}

#Preview {
    RecoverAccountView()
}
