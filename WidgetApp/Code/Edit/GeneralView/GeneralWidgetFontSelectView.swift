//
//  GeneralWidgetFontSelectView.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/25.
//

import SwiftUI

struct GeneralWidgetFontSelectView: View {
    
    @Binding var selectedFont: String?
    
    let fontNames: [String] = [""]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("字体")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#333333"))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button {
                        selectedFont = nil
                    } label: {
                        Image("general_edit_font_default_icon")
                    }
                    .frame(width: 28, height: 28, alignment: .center)
                    
                    ForEach(fontNames, id: \.self) { fontName in
                        Button {
                            selectedFont = fontName
                        } label: {
                            Text("Font")
                                .font(Font.custom(fontName, size: 20))
                                .foregroundColor(Color.white)
                                .frame(width: 65, height: 32, alignment: .center)
                                .background(fontName == selectedFont ? Color(hex:"#644BFF") : .white)
                                .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }
}

//struct GeneralWidgetFontSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeneralWidgetFontSelectView()
//    }
//}
