//
//  NSTableView_GetRowViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 6/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Cocoa

class NSTableViewGetRowViewSpec: QuickSpec {
    override func spec() {
        describe("NSTableView+getRowView") {
            var tableView: NSTableView!

            beforeEach {
                tableView = NSTableView()
            }

            context("Getting a ClipItemTableRowTextView") {
                it("will return a view of the specified type") {
                    let customRowView: ClipItemTableRowTextView = tableView.getRowView()
                    expect(customRowView).to(beAKindOf(ClipItemTableRowTextView.self))
                }
            }

            context("Getting a ClipItemTableRowImageView") {
                it("will return a view of the specified type") {
                    let customRowView: ClipItemTableRowImageView = tableView.getRowView()
                    expect(customRowView).to(beAKindOf(ClipItemTableRowImageView.self))
                }
            }

            context("Getting an view type without an associated xib") {
                it("will throw an assertion") {
                    expect {
                        let _: NSView = tableView.getRowView()
                    }.to(throwAssertion())
                }
            }
        }
    }
}
