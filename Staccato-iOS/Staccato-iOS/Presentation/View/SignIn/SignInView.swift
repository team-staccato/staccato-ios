import SwiftUI

struct SignInView: View {
    
    @State private var nickName: String = ""
    @State private var isLoggedIn: Bool = false
    
    var isButtonDisabled: Bool {
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
                
                Button("시작하기") {
                    login(nickname: nickName)
                }
                .buttonStyle(.staccatoFullWidth)
                .padding(.vertical)
                .disabled(isButtonDisabled)
                NavigationLink(value: isLoggedIn) {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(destination: RecoverAccountView()) {
                    Text("이전 기록을 불러오려면 여기를 눌러주세요")
                        .typography(.body4)
                        .foregroundColor(.gray4)
                        .underline()
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            }
        }
    }
}

extension SignInView {
    func login(nickname: String) {
        NetworkService.shared.request(
            endpoint: AuthorizationAPI.login(nickname: nickname),
            responseType: LoginResponse.self
        ) { result in
            switch result {
            case .success(let response):
                AuthTokenManager.shared.saveToken(response.token)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            case .failure(let error):
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SignInView()
}
