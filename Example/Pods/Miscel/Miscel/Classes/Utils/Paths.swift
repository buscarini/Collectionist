//
//  Paths.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public struct PathUtils {
	public static func docsDirUrl() -> URL? {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	public static func getFileName(name: String, pathExtension: String) -> String {
		return self.appendExtension(pathExtension)(self.escapeFileName(name))
	}
	
	public static func escapeFileName(_ string: String) -> String {
		let escapes = [ "/", "\\", "\n", ":" , "?", "&", "=" ]
		return escapes.reduce(string) {
			string, escape in
			return string.replacingOccurrences(of: escape, with: "")
//			return string.stringByReplacingOccurrencesOfString(escape, withString: "")
		}
	}
	
	public static func appendExtension(_ pathExtension: String) -> (_ fileName: String) -> String {
		return { fileName in
			let url = NSURL(fileURLWithPath: fileName)
			if url.pathExtension != nil {
				return fileName
			}
			else {
				return url.appendingPathExtension(pathExtension)?.path ?? fileName
			}
		}
	}
}

