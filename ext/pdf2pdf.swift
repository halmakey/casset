//
//  main.swift
//  pdf2pdf
//
//  Created by Ryo Kikuchi on 2016/11/02.
//  Copyright © 2016年 rubi3. All rights reserved.
//

import Foundation
import AppKit
import Quartz

enum PDFError : Error {
    case fileNotFound
    case fileBroken
}

func splitPdf(infile:String, index:Int, outfile:String) throws {
  let inurl = URL(fileURLWithPath: infile)
  let outurl = URL(fileURLWithPath: outfile)

  let pdf = PDFDocument(url: inurl)
  if pdf == nil {
      throw PDFError.fileNotFound
  }

  let page = pdf?.page(at: index)
  try page?.dataRepresentation.write(to: outurl, options: NSData.WritingOptions.atomicWrite)
}
