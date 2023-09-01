//
//  GeneralWidgetEditView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/25.
//

import SwiftUI

struct GeneralWidgetEditView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            
        }
        .navigationTitle("组件编辑")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()

        }, label: {
            Image("general_back_icon")
                .aspectRatio(contentMode: .fit)
        }), trailing: Button(action: {
            //预览
            previewWidget()
        }, label: {
            Text("预览")
                .foregroundColor(Color(hex: "#644BFF"))
                .font(Font.system(size: 15,weight: .semibold))
        }))
        .onAppear {
            // 页面出现时可以在此初始化数据
        }
            
    }
    
    
//MARK: - privacy method
    
    // 预览
    func previewWidget() {
        
    }
}



