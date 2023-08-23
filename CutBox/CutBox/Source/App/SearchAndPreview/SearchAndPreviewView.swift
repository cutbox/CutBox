//
//  SearchView.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

/// Main view of CutBox, displayed via `PopupController`
/// communicates with the `CutBoxController` via events<`SearchViewEvents`>
/// Extends `SearchPreviewViewBase`
class SearchAndPreviewView: SearchPreviewViewBase {

    @IBOutlet weak var searchModeToggle: NSButton!
    @IBOutlet weak var jsIconButton: NSButton!
    @IBOutlet weak var timeFilterText: ValidIndicatorTextField!
    @IBOutlet weak var timeFilterLabel: NSTextField!
    @IBOutlet weak var historyScopeImageButton: NSButton!

    var events = PublishSubject<SearchViewEvents>()

    override func awakeFromNib() {
        self.setAccessibilityIdentifier("searchAndPreviewView")
        setupSearchText()
        setupSearchModeToggle()
        setupSearchScopeToggle()
        setupHistoryScopeButton()
        setupTimeFilter()
        setupJSIconButton()
        super.awakeFromNib()
        applyTheme()
    }

    func setupJSIconButton() {
        jsIconButton.setAccessibilityIdentifier("jsIconButton")

        jsIconButton
            .rx
            .tap
            .map { _ in
                .selectJavascriptFunction
            }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    func setSearchModeButton(mode: HistorySearchMode) {
        let color = [NSAttributedString.Key.foregroundColor: prefs.currentTheme.clip.textColor]
        let titleString = NSAttributedString(string: mode.name(), attributes: color)

        self.searchModeToggle.attributedTitle = titleString
        self.searchModeToggle.toolTip = mode.toolTip()
    }

    private func setupHistoryScopeButton() {
        colorizeHistoryScopeIcon(color: prefs.currentTheme.searchText.placeholderTextColor,
                                 alpha: 0.4)

        self.historyScopeImageButton.rx.tap
            .bind(onNext: historyScopeClicked)
            .disposed(by: disposeBag)
    }

    private func colorizeHistoryScopeIcon(image: NSImage = #imageLiteral(resourceName: "history-clock-face-white.png"),
                                          tooltip: String = "search_time_filter_label_hint".l7n,
                                          color: NSColor,
                                          alpha: Double = 0.75) {
        let image = image
        let blended = image.tint(color: color)

        self.historyScopeImageButton.alphaValue = alpha
        self.historyScopeImageButton.image = blended
        self.historyScopeImageButton.toolTip = tooltip
    }

    private func historyScopeClicked() {
        self.events.onNext(.toggleTimeFilter)
    }

    func toggleTimeFilter() {
        self.timeFilterLabel.isHidden = !self.timeFilterLabel.isHidden
        self.timeFilterText.isHidden = !self.timeFilterText.isHidden
        self.timeFilterText.stringValue = ""

        if self.timeFilterText.isHidden {
            self.window?.makeFirstResponder(self.searchText)
        } else {
            self.window?.makeFirstResponder(self.timeFilterText)
        }
    }

    private func setupSearchModeToggle() {
        let mode = HistoryService.shared.searchMode
        setSearchModeButton(mode: mode)

        self.searchModeToggle
            .rx
            .tap
            .map { .toggleSearchMode }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    func setSearchScopeButton(favoritesOnly: Bool) {
        if favoritesOnly {
            colorizeMagnifier(
                image: #imageLiteral(resourceName: "star.png"),
                tooltip: "search_scope_tooltip_favorites".l7n,
                color: prefs.currentTheme.searchText.placeholderTextColor
            )
        } else {
            colorizeMagnifier(color: prefs.currentTheme.searchText.placeholderTextColor)
        }
    }

    private func setupSearchScopeToggle() {
        let favoritesOnly = HistoryService.shared.favoritesOnly
        setSearchScopeButton(favoritesOnly: favoritesOnly)

        self.searchScopeImageButton
            .rx
            .tap
            .map { .toggleSearchScope }
            .bind(to: self.events)
            .disposed(by: disposeBag)
    }

    private func setupSearchText() {
        self.searchText.delegate = self
        self.searchText.isFieldEditor = true
    }

    private func setupTimeFilter() {
        self.timeFilterLabel.isHidden = true

        self.timeFilterText.rx.text
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] (text: String) in
                self?.onTimeFilterTextChanged(text: text)
            })
            .disposed(by: disposeBag)

        self.timeFilterText.keyUp
            .subscribe(onNext: { event in
                // on Enter key
                if event.keyCode == 36 {
                    self.window?.makeFirstResponder(self.searchText)
                }
            })
            .disposed(by: disposeBag)

        self.timeFilterText.isHidden = true
        self.timeFilterText.placeholderString = "...".l7n
        self.timeFilterText.isValid = false
    }

    func onTimeFilterTextChanged(text: String) {
        let filter = TimeFilterValidator(value: text)
        self.timeFilterText.isValid = filter.isValid

        if let seconds = filter.seconds {
            let formatted = TimeFilterValidator.secondsToTime(seconds: Int(seconds))
            self.timeFilterLabel.stringValue = String(format: "search_time_filter_label_active".l7n, formatted)
            self.events.onNext(.setTimeFilter(seconds: seconds))
        } else {
            self.timeFilterLabel.stringValue = "search_time_filter_label_hint".l7n
            self.events.onNext(.setTimeFilter(seconds: nil))
        }
    }

    @objc func removeSelectedItems() {
        self.events.onNext(.removeSelected)
    }

    @objc func toggleFavoriteItems() {
        self.events.onNext(.toggleFavorite)
    }

    func setupClipItemsContextMenu() {
        let removeItem = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                action: #selector(removeSelectedItems),
                                keyEquivalent: "")

        let favoriteItem = NSMenuItem(title: "context_menu_favorite".l7n,
                                  action: #selector(toggleFavoriteItems),
                                  keyEquivalent: "")

        let contextMenu = NSMenu()
        contextMenu.addItem(removeItem)
        contextMenu.addItem(favoriteItem)

        self.itemsList.menu = contextMenu
    }

    override func applyTheme() {
        super.applyTheme()

        let theme = prefs.currentTheme

        timeFilterLabel.textColor = theme.searchText.placeholderTextColor

        colorizeHistoryScopeIcon(color: theme.searchText.placeholderTextColor,
                                 alpha: 0.6)
        setSearchModeButton(mode: HistoryService.shared.searchMode)
        setSearchScopeButton(favoritesOnly: HistoryService.shared.favoritesOnly)
    }
}
