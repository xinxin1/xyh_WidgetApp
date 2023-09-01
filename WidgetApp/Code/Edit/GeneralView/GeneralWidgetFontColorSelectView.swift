//
//  GeneralWidgetFontColorSelectView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/27.
//

import SwiftUI

struct GeneralWidgetFontColorSelectView: View {
    
    @Environment(\.presentationMode) private var presentationMode

    @Binding var selectedColor: Color
    
    @State private var selectedColorName: String?
    
    let colors: [String] = ["#FFFFFF","#333333","#FE6B6B","#FE7540","#C56638","#FFA503","#FFC500","#FFF1BD","#C5E700","#22E34E","#01E2C7","#06DBF3","#04B5DC","#2C97FF","#4667BC","#8188D6","#7C60FC","#C46DEE","#F14AEC","#FF3EB1","#EF5B7F","#EEF3F5","#A9ABAD"]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("文字颜色")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#333333"))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 11) {
                    
                    // 颜色选择器
                    Button {
                        self.selectedColorName = nil
                        ColorPicker("", selection: $selectedColor)

                    } label: {
                        Image("widget_setting_none_icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 34, height: 34)
                    }
                    
                    ForEach(colors,id: \.self) {color in
                        Button {
                            selectedColor = Color(hex: color)!
                            self.selectedColorName = color
                            
                        } label: {
                            
                            if selectedColorName == color {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color)!)
                                        .frame(width: 32, height: 32)
                                    
                                    Image("general_edit_font_color_selected_icon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 24, height: 24)
                                }
                                
                            } else {
                                let storkeColor = color == "#FFFFFF" ? "#E5E5E5" : "#FFFFFF"
                             
                                setBackground(strokeColor: storkeColor, fillColor: color)
                             }
                        }
                    }
                }
                .frame(height: 32)
            }
        }
    }
    
    func setBackground(strokeColor: String, fillColor:String) -> some View {
        return ZStack {
            Circle()
                .stroke(Color(hex: strokeColor)!, lineWidth: 1)
                .foregroundColor(Color(hex: fillColor)!)
                .frame(width: 32, height: 32)
            
            Circle()
                .stroke(Color(hex: strokeColor)!, lineWidth: 1)
                .foregroundColor(.white)
                .frame(width: 16, height: 16)
        }
    }
}
