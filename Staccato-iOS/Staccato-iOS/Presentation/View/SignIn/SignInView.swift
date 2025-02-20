import SwiftUI

struct SignInView: View {
    
    @StateObject private var viewModel = SignInViewModel()
    
    @State private var nickName: String = "" {
        didSet {
            if nickName.count > 20 {
                nickName = String(nickName.prefix(20))
            }
        }
    }
    @State private var validationMessage: String = ""
    @State private var shakeOffset: CGFloat = 0
    
    private var isButtonDisabled: Bool {
        nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                
                HStack {
                    Text(validationMessage)
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
                    viewModel.validateText(nickName: nickName)
                    
                    if viewModel.isValid {
                        viewModel.login(nickName: nickName)
                    } else {
                        shakeAnimation()
                        validationMessage = "한글, 영어, 마침표, 언더바(_)만 사용 가능합니다"
                    }
                }
                .buttonStyle(.staccatoFullWidth)
                .padding(.vertical)
                .disabled(isButtonDisabled)
                
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
    }
}

#Preview {
    SignInView()
}

extension SignInView {
    private func shakeAnimation() {
        let shakeValues: [CGFloat] = [0, -10, 10, -8, 8, -5, 5, 0] // 흔들리는 값
        for (index, value) in shakeValues.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(index)) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    shakeOffset = value
                }
            }
        }
    }
}
