//
//  SearchViewControllerMenuDelegate.swift
//  CutBox
//
//  Created by Carlos Enumo on 30/09/22.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

extension SearchViewController: NSMenuDelegate {

    func menuWillOpen(_ menu: NSMenu) {
        let clicked = searchView.itemsList.clickedRow

        guard !searchView.itemsList.isRowSelected(clicked), let flags = CGEvent(source: nil)?.flags else { return }

        let proposedSelection: IndexSet

        if flags.contains(.maskShift), let last = orderedSelection.all().last {
            proposedSelection = searchView.itemsList.selectedRowIndexes
                .union(IndexSet(integersIn: min(clicked, last)...max(clicked, last)))
        } else if flags.contains(.maskCommand) {
            proposedSelection = searchView.itemsList.selectedRowIndexes.union(IndexSet(integer: clicked))
        } else {
            proposedSelection = IndexSet(integer: clicked)
        }

        let indexes = tableView(searchView.itemsList, selectionIndexesForProposedSelection: proposedSelection)

        searchView.itemsList.selectRowIndexes(indexes, byExtendingSelection: false)
    }
}
