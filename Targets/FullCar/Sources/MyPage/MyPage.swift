//
//  MyPage.swift
//  FullCar
//
//  Created by Sunny on 2/10/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

import Dependencies
import FullCarUI
import FullCarKit

struct MyPage {
    enum MyCarpool { }
    enum MyCar { }
    enum Question { }
    enum TermsAndPolicies { }
    enum Setting { }
}

extension MyPage {
    @MainActor
    @Observable
    final class ViewModel {
        @ObservationIgnored
        @Dependency(\.myPageAPI) private var myPageAPI

        let fullCar = FullCar.shared

        var isShowLeaveCompletionAlert = false
        var isShowLeaveErrorAlert = false
        var isShowLogoutErrorAlert = false
        
        enum Destination: Hashable {
            case myCarpull
            case detail(CarPullDetailViewModel)
        }
        
        var paths: [Destination] = []

        func logout() async {
            do {
                try await myPageAPI.logout()

                fullCar.appState = .login
            } catch {
                print(error)

                isShowLogoutErrorAlert = true
            }
        }

        func leave() async {
            do {
                try await myPageAPI.leave()

                isShowLeaveCompletionAlert = true
            } catch {
                print(error)

                isShowLeaveErrorAlert = true
            }
        }

        func completeLeave() {
            fullCar.appState = .login
        }
        
        func moveMyCarPull() {
            guard paths.isEmpty else { return }
            let detailViewModel = MyCarPullListViewModel()
            // TODO: 먼저 지워지는거 수정
//            detailViewModel.onBackButtonTapped = {
//                self.paths.removeAll()
//            }
            paths.append(.myCarpull)
        }
    }
}

extension MyPage {
    @MainActor
    struct BodyView: View {
        @Bindable var viewModel: ViewModel

        var body: some View {
            NavigationStack(path: $viewModel.paths) {
                bodyView
                    .navigationBarStyle(
                        leadingView: { },
                        centerView: {
                            Text("마이페이지")
                                .font(.pretendard18(.bold))
                        },
                        trailingView: { }
                    )
                    .alert(
                        "로그아웃할 수 없음",
                        isPresented: $viewModel.isShowLogoutErrorAlert,
                        actions: {
                            Button(action: { }, label: { Text("확인") })
                        },
                        message: { Text("에러가 발생했어요. 다시 시도해주세요.") })
                    .alert(
                        "탈퇴할 수 없음",
                        isPresented: $viewModel.isShowLeaveErrorAlert,
                        actions: {
                            Button(action: { }, label: { Text("확인") })
                        },
                        message: { Text("에러가 발생했어요. 다시 시도해주세요.") })
                    .navigationDestination(for: MyPage.ViewModel.Destination.self) { destination in
                        switch destination {
                        case .myCarpull:
                            MyCarPullListView(viewModel: .init(), paths: $viewModel.paths)
                        case let .detail(detailViewModel):
                            CarPullDetailView(viewModel: detailViewModel)
                        }
                    }
            }
        }

        private var bodyView: some View {
            VStack(alignment: .leading, spacing: .zero) {
                profile

                listButton(destination: .myCarpull, icon: .car, text: "내 카풀")
                navigationItemLink(Text("차량 정보 관리"), icon: .userCard, text: "차량 정보 관리")

                Divider()
                    .overlay(Color.gray30)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                navigationItemLink(Text("1:1 문의"), icon: .chat, text: "1:1 문의")
                navigationItemLink(Text("약관 및 정책"), icon: .shield_check, text: "약관 및 정책")
                navigationItemLink(MyPage.Setting.BodyView(viewModel: viewModel), icon: .setting, text: "설정")
            }
        }

        private var profile: some View {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 4) {
                    Text(viewModel.fullCar.member?.nickname ?? "")
                        .font(.pretendard16(.bold))

                    Text("· \(viewModel.fullCar.member?.company.name ?? "")")
                        .font(.pretendard14(.medium))
                        .foregroundStyle(Color.gray60)
                }
                .padding(20)

                Divider()
                    .frame(height: 8)
                    .overlay(Color.gray10)
            }
        }

        private func navigationItemLink<Destination: View>(
            _ destination: Destination,
            icon: FCIcon.Symbol,
            text: String
        ) -> some View {
            NavigationLink(destination: destination) {
                HStack(alignment: .center, spacing: 6) {
                    Image(icon: icon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(iconSize: ._24)
                        .foregroundStyle(Color.black80)

                    Text(text)
                        .font(.pretendard16(.medium))
                        .foregroundStyle(Color.black80)

                    Spacer()

                    Image(icon: .chevron_right)
                        .frame(iconSize: ._20)
                        .foregroundStyle(Color.gray60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 18)
            }
        }
        
        private func listButton(destination: MyPage.ViewModel.Destination, icon: FCIcon.Symbol, text: String) -> some View {
            Button(action: {
                switch destination {
                //case .detail(l)
                case .myCarpull:
                    viewModel.moveMyCarPull()
                default:
                    break
                }
            }, label: {
                HStack(alignment: .center, spacing: 6) {
                    Image(icon: icon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(iconSize: ._24)
                        .foregroundStyle(Color.black80)

                    Text(text)
                        .font(.pretendard16(.medium))
                        .foregroundStyle(Color.black80)

                    Spacer()

                    Image(icon: .chevron_right)
                        .frame(iconSize: ._20)
                        .foregroundStyle(Color.gray60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 18)
            })
            
        }
    }
}

#if DEBUG
#Preview {
    MyPage.BodyView(viewModel: .init())
}
#endif
