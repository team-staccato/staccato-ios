import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @State private var nickName: String = ""
    @State private var errorMessage: String?
    @State private var validationMessage: String?
    @State private var isChanging: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var debounceWorkItem: DispatchWorkItem?
    
    private var isButtonDisabled: Bool {
        nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isChanging
    }
    
    var body: some View {
        NavigationStack {
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
                        isChanging = true
                        debounceValidation(text: nickName)
                    }
                
                HStack {
                    Text(validationMessage ?? "")
                        .typography(.body4)
                        .foregroundColor(.red)
                        .opacity(viewModel.isValid ? 0 : 1)
                    
                    Spacer()
                    
                    Text("\(nickName.count)/20")
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
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeView()
            }
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
                switch error {
                case .badRequest(let message):
                    errorMessage = message
                default:
                    errorMessage = error.description
                }
            } catch {
                errorMessage = "알 수 없는 오류"
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
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            viewModel.validateText(nickName: text)
            if !viewModel.isValid {
                shakeAnimation()
                validationMessage = "한글, 영어, 마침표, 언더바(_)만 사용 가능합니다"
            } else {
                validationMessage = ""
            }
            isChanging = false
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
}
