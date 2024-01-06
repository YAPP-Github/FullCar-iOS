//
//  CallReceiveListView.swift
//  FullCar
//
//  Created by Tabber on 2024/01/06.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

struct CallReceiveListView: View {
    
    @Binding var data: [String]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], content: {
                
                ForEach(data.indices, id:\.self) { idx in
                    CallListItem()
                }
            })
        }
    }
}
