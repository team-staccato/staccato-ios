import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var viewModel: SignInViewModel
    @Environment(StaccatoAlertManager.self) var alertManager
    @State private var nickName: String = ""
    @State private var validationMessage: String?
    @State private var isChanging: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var validationTask: Task<Void, Never>?
    
    private var isButtonDisabled: Bool {
        nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isChanging
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image("staccato_login_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .foregroundStyle(.tint)
                        .padding(.bottom, 100)
                    
                    TextField("닉네임을 입력해주세요", text: $nickName)
                        .padding()
                        .typography(.body4)
                        .background(.gray1)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(viewModel.isValid ? Color.clear : Color.red, lineWidth: 2)
                        )
                        .offset(x: viewModel.isValid ? 0 : shakeOffset)
                        .onChange(of: nickName) {
                            if nickName.count > 10 {
                                nickName = String(nickName.prefix(10))
                            } else {
                                isChanging = true
                                debounceValidation(text: nickName)
                            }
                        }
                    
                    HStack {
                        Text(validationMessage ?? "")
                            .typography(.body4)
                            .foregroundColor(.red)
                            .opacity(viewModel.isValid ? 0 : 1)
                        
                        Spacer()
                        
                        Text("\(nickName.count)/10")
                            .typography(.body4)
                            .foregroundStyle(.gray3)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.bottom)
                    }
                    
                    Button("시작하기") {
                        login()
                    }
                    .buttonStyle(.staccatoFullWidth)
                    .padding(.vertical)
                    .disabled(isButtonDisabled || !viewModel.isValid)
                    
                    NavigationLink(destination: RecoverAccountView()) {
                        Text("이전 기록을 불러오려면 여기를 눌러주세요")
                            .typography(.body4)
                            .foregroundColor(.gray4)
                            .underline()
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal, 24)
                .onAppear {
                    viewModel.checkAutoLogin()
                }
                
                if alertManager.isPresented {
                    StaccatoAlertView()
                }
            }
        }
    }
}

#Preview {
    SignInView()
}

//MARK: Login
extension SignInView {

    private func login() {
        Task {
            do {
                let _ = try await viewModel.login(nickName: nickName)
            } catch let error as NetworkError {
                let message: String
                switch error {
                case .badRequest(let errorMessage):
                    message = errorMessage
                default:
                    message = error.localizedDescription
                }
                
                await MainActor.run {
                    alertManager.show(.loginFailAlert(message: message))
                }
            } catch {
                await MainActor.run {
                    alertManager.show(.loginFailAlert(message: "알 수 없는 오류"))
                }
            }
        }
    }

}

//MARK: Animation
extension SignInView {
    private func shakeAnimation() {
        let shakeValues: [CGFloat] = [0, -10, 10, -8, 8, -5, 5, 0]
        for (index, value) in shakeValues.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(index)) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    shakeOffset = value
                }
            }
        }
    }
}

//MARK: Debounce
extension SignInView {
    private func debounceValidation(text: String) {
        isChanging = true
        validationTask?.cancel()
        
        validationTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            if Task.isCancelled { return }
            
            await MainActor.run {
                viewModel.validateText(nickName: text)
                if !viewModel.isValid {
                    shakeAnimation()
                    validationMessage = "닉네임은 한글, 영어, 숫자, 띄어쓰기 마침표(.), 밑줄(_)만 사용할 수 있어요."
                } else {
                    validationMessage = ""
                }
                isChanging = false
            }
        }
    }
}
