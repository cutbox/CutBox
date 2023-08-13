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

class SearchAndPreviewView: SearchPreviewViewBase {

    @IBOutlet weak var searchModeToggle: NSButton!
    @IBOutlet weak var jsIconButton: NSButton!

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
            .bind { [weak self] in self?.historyScopeClicked() }
            .disposed(by: disposeBag)
    }

    private func historyScopeClicked() {
        self.timeFilterLabel.isHidden = !self.timeFilterLabel.isHidden
        self.timeFilterText.isHidden = !self.timeFilterText.isHidden
         self.timeFilterText.isValid = !self.timeFilterText.isValid
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
                tooltip: "search_scope_tooltip_favorites".l7n
            )
        } else {
            colorizeMagnifier()
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
        self.timeFilterLabel.stringValue = "Time Filter On "

        // self.timeFilterText.delegate = self
        let timeFilterObservable = self.timeFilterText.rx.text.orEmpty.asObservable()
        timeFilterObservable.subscribe { [weak self] text in
            let filter = TimeFilterValidator(value: text)
            self?.timeFilterText.isValid = filter.isValid
            if let seconds = filter.seconds {
                /// ... do something with the seconds.
                print(seconds)
                print(TimeFilterValidator.secondsToTime(seconds: Int(seconds)))
            }
        }
        .disposed(by: disposeBag)

        self.timeFilterText.isHidden = true
        self.timeFilterText.placeholderString = "10min|1day|30sec etc".l7n
        self.timeFilterText.isValid = false
    }

    @objc func removeSelectedItems() {
        self.events.onNext(.removeSelected)
    }

    @objc func toggleFavoriteItems() {
        self.events.onNext(.toggleFavorite)
    }

    func setupClipItemsContextMenu() {
        let remove = NSMenuItem(title: "context_menu_remove_selected".l7n,
                                action: #selector(removeSelectedItems),
                                keyEquivalent: "")

        let favorite = NSMenuItem(title: "context_menu_favorite".l7n,
                                  action: #selector(toggleFavoriteItems),
                                  keyEquivalent: "")

        let contextMenu = NSMenu()
        contextMenu.addItem(remove)
        contextMenu.addItem(favorite)

        self.itemsList.menu = contextMenu
    }

    override func applyTheme() {
        super.applyTheme()

        colorizeHistoryScopeIcon(color: prefs.currentTheme.searchText.placeholderTextColor,
                                 alpha: 0.4)

        setSearchModeButton(mode: HistoryService.shared.searchMode)
        setSearchScopeButton(favoritesOnly: HistoryService.shared.favoritesOnly)
    }
}
