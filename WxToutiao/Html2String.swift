//
//  Html2String.swift
//  WxToutiao
//
//  Created by chenxi on 2017/9/26.
//  Copyright © 2017年 chenxi. All rights reserved.
//

extension String {
    var html2AttributedString : NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options:[.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}
