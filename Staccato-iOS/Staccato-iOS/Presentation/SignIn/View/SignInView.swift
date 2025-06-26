import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var viewModel: SignInViewModel
    
    @State private var alertManager = StaccatoAlertManager()
    @State private var nickName: String = ""
    @State private var validationMessage: String?
    @State private var isLoading: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var validationTask: Task<Void, Never>?
    @FocusState private var onFocusNicknameField: Bool
    
    private var isButtonDisabled: Bool {
        nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    logoView
                        .padding(.bottom, onFocusNicknameField ? 34 : 100)

                    textFieldView
                        .padding(.bottom, onFocusNicknameField ? 20 : 40)

                    startButton
                        .padding(.bottom, 32)

                    recoverAccountButton
                }
                .padding(24)
                .onAppear {
                    viewModel.checkAutoLogin()
                }

                if alertManager.isPresented {
                    StaccatoAlertView(alertManager: $alertManager)
                }
            }
            .dismissKeyboardOnGesture()
        }
    }
}


// MARK: - UI components

private extension SignInView {

    var logoView: some View {
        VStack(spacing: 0) {
            Image(.staccatoLogo)
                .resizable()
                .scaledToFit()
                .frame(width: onFocusNicknameField ? 100 : 160)
                .padding(.bottom, onFocusNicknameField ? 0 : 20)

            Text("단조로운 일상에 스타카토를 찍다")
                .foregroundStyle(.gray5)
                .typography(onFocusNicknameField ? .body5 : .body3)
        }
    }

    var textFieldView: some View {
        VStack {
            TextField("닉네임을 입력해주세요", text: $nickName)
                .focused($onFocusNicknameField)
                .padding()
                .typography(.body4)
                .background(.gray1)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(viewModel.isValid ? .clear : .accentRed, lineWidth: 1)
                )
                .offset(x: viewModel.isValid ? 0 : shakeOffset)

                .onChange(of: nickName) {
                    if nickName.count > 10 {
                        nickName = String(nickName.prefix(10))
                    } else {
                        viewModel.validateText(nickName: nickName)
                        if !viewModel.isValid {
                            shakeAnimation()
                        }
                    }
                }

            HStack {
                Text("닉네임은 한글, 영어, 숫자, 띄어쓰기\n마침표(.), 밑줄(_)만 사용할 수 있어요.")
                    .typography(.body4)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                    .opacity(viewModel.isValid ? 0 : 1)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text("\(nickName.count)/10")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
                    .padding(.bottom)
            }
        }
    }

    var startButton: some View {
        Button("시작하기") {
            login()
        }
        .buttonStyle(.staccatoFullWidth)
        .disabled(isButtonDisabled || !viewModel.isValid)
    }

    var recoverAccountButton: some View {
        NavigationLink(destination: RecoverAccountView()) {
            Text("이전 기록을 불러오려면 여기를 눌러주세요")
                .typography(.body4)
                .foregroundColor(.gray4)
                .underline()
        }
    }
}


//MARK: - Methods

private extension SignInView {

    // MARK: Login

    func login() {
        isLoading = true
        Task {
            defer { isLoading = false }

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


    //MARK: Animation

    func shakeAnimation() {
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
