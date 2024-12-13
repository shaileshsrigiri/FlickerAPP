//
//  ExtractData.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/13/24.
//

import Foundation

extension String {
   
    func asPlainText() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self
    }

    func extractAuthorName() -> String {
        let regex = "\\((.*?)\\)"
        guard let range = self.range(of: regex, options: .regularExpression) else { return self }
        return String(self[range])
            .trimmingCharacters(in: CharacterSet(charactersIn: "()\""))
    }
}


