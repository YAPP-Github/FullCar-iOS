//
//  CallRequestListView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarKit

struct CallRequestListView: View {
    
    @Binding var data: [CarPull.Model.Information]
    
    var onTapGesture: ((CarPull.Model.Information) -> ())
    var refreashable: (() -> ())
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], content: {
                
                ForEach(data, id: \.self) { item in
                    CallListItem(isOpen: item.carpoolState ?? .OPEN,
                                 status: item.formState ?? .ACCEPT,
                                 item: item,
                                 isLast: item.id == data.last?.id)
                    .contentShape(Rectangle())
                    .clipShape(Rectangle())
                    .onTapGesture {
                        onTapGesture(item)
                    }
                }
            })
            
        }
        .refreshable {
            refreashable()
        }
    }
}
