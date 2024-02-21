//
//  MyCarPullListView.swift
//  FullCar
//
//  Created by Tabber on 2024/02/11.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit


@MainActor
struct MyCarPullListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var viewModel: MyCarPullListViewModel
    @Binding var paths: [MyPage.ViewModel.Destination]
    
    var body: some View {
        
        _body
        .navigationBarStyle(
            leadingView: {
                Button {
                    dismiss()
                } label: {
                    Image(icon: .back)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.black)
                        .frame(width: 24, height: 24)
                }
            }, centerView: {
                Text("내카풀")
                    .font(.pretendard18(.bold))
            }, trailingView: {
                
            }
        )
        .task {
            await viewModel.fetch()
        }
    }
    
    private var _body: some View {
        ScrollView {
            if viewModel.myCarPullList.isEmpty {
                errorView(imageName: "myCarpullisEmpty")
            } else {
                LazyVGrid(columns: [GridItem()], content: {
                    ForEach(viewModel.myCarPullList, id:\.id) { item in
                        Button(action: {
                            moveCarpullDetail(item)
                        }, label: {
                            MyCarPullItemView(item: item,
                                              isLast: item.id == viewModel.myCarPullList.last?.id)
                        })
                        
                    }
                })
            }
        }
    }
    
    private func errorView(imageName: String) -> some View {
        VStack(spacing: .zero) {
            Image(imageName)
                .padding(.top, 160)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func moveCarpullDetail(_ item: CarPull.Model.Information) {
        let detailViewModel = CarPullDetailViewModel(openType: .MyPage, carPull: item)
        // TODO: 먼저 지워지는거 수정
        detailViewModel.onBackButtonTapped = {
            self.paths.removeLast()
        }
        paths.append(.detail(detailViewModel))
    }
}
