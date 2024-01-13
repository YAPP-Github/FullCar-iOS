//
//  CallDetail.swift
//  FullCar
//
//  Created by Tabber on 2024/01/08.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI
import FullCarKit
import Observation

@MainActor
@Observable
final class CallDetailViewModel {
    var viewType: FullCar.CallListTab
    var collapsible: Bool = false
    
    init(viewType: FullCar.CallListTab) {
        self.viewType = viewType
    }
    
    func downButtonAction() {
        withAnimation(.smooth(duration: 0.3)) {
            collapsible.toggle()
        }
        
    }
}

struct CallDetail: View {
    
    @Bindable var viewModel: CallDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                carpoolCollapsibleView
            }
        }
    }
}

extension CallDetail {
   
    @MainActor
    var carpoolCollapsibleView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(viewModel.viewType == .request ? "카풀 상세" : "내가 등록한 카풀")")
                    .bold()
                    .font(.system(size: 17))
                
                Spacer()
                
                Button(action: {
                    viewModel.downButtonAction()
                }, label: {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(viewModel.collapsible ? -180 : 0))
                })
                .foregroundStyle(.black)
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            CollapsiableView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: viewModel.collapsible ? .none : 0, alignment: .top)
                .opacity(viewModel.collapsible ? 1 : 0)
                .clipped()
                .transition(.slide)
                .padding(.bottom, viewModel.collapsible ? 20 : 0)
            
            Rectangle()
                .foregroundStyle(.gray.opacity(0.1))
                .frame(height: 8)
            
            HStack {
                Text("\(viewModel.viewType == .request ? "요청한 내역" : "요청 받은내역")")
                    .bold()
                    .font(.system(size: 17))
                
                Spacer()
                
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            CollapsiableView()
                .padding(.top, 20)
            
            Spacer()
        }
        
        
    }
}

#Preview {
    CallDetail(viewModel: .init(viewType: .request))
}
