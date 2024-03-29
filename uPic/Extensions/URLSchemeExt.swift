//
//  URLSchemeExt.swift
//  uPic
//
//  Created by Svend Jin on 2019/12/27.
//  Copyright © 2019 Svend Jin. All rights reserved.
//

import Cocoa

class URLSchemeExt {
    public static var shared = URLSchemeExt()
    
    func handleURL(_ urlStr: String) {
        Logger.shared.verbose("开始解析 URLScheme 参数-\(urlStr)")

        guard let url = NSURL(string: urlStr) else {
            Logger.shared.error("URLScheme 参数解析失败")
            return
        }
        
        // 解析出参数
        var param = urlStr
        let i = "\(url.scheme!)://".count
        param.removeFirst(i)

        Logger.shared.verbose("URLScheme 参数解析成功-\(param)")

        /// 解析参数类型
        let keyValue = param.split(separator: "?")
        switch keyValue.first {
        case "files":
            if (keyValue.count == 2) {
                let pathStr = String(keyValue.last ?? "")
                (NSApplication.shared.delegate as? AppDelegate)?.uploadFilesFromPaths(pathStr.urlDecoded())
            }
        case "url":
            if (keyValue.count == 2) {
                let url = String(keyValue.last ?? "")
                if let fileUrl = URL(string: url.urlDecoded()), let data = try? Data(contentsOf: fileUrl)  {
                    (NSApplication.shared.delegate as? AppDelegate)?.uploadFiles([data])
                }
            }
        default:
            debugPrint(keyValue)
        }
    }
}
