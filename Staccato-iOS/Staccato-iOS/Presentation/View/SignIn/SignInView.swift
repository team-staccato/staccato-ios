import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("staccato_login_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 176)
                    .foregroundStyle(.tint)
                    .padding(.bottom, 100)

                TextField("닉네임을 입력해주세요", text: $viewModel.nickName)
                    .padding()
                    .typography(.body4)
                    .background(.gray1)
                    .cornerRadius(4)
                
                Text("\(viewModel.nickName.count)/20")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)
                
                Button("시작하기") {
                    viewModel.login()
                }
                .buttonStyle(.staccatoFullWidth)
                .padding(.vertical)
                .disabled(viewModel.isButtonDisabled)

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
