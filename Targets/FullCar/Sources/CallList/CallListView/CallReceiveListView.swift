//
//  CallReceiveListView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

struct CallReceiveListView: View {
    
    @Binding var data: [Dummy]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], content: {
                
                ForEach(data, id: \.self) { item in
                    CallListItem(status: item.status,
                                 isLast: item.id == data.last?.id)
                }
            })
        }
    }
}
