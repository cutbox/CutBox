//
//  SearchViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 14/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import CutBox

class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("SearchViewController") {
            var subject: SearchViewController!
            var mockHistoryService: HistoryService!
            var mockCutBoxPreferences: CutBoxPreferencesService!
            var mockFakeKey: FakeKey!
            var mockSearchAndPreviewView: SearchAndPreviewView!

            beforeEach {
                LoginItemsService.testing = true

                mockHistoryService = HistoryService()
                mockCutBoxPreferences = CutBoxPreferencesService()
                mockFakeKey = FakeKey()
                mockSearchAndPreviewView = SearchAndPreviewView()

                subject = SearchViewController(
                    pasteboardService: mockHistoryService,
                    cutBoxPreferences: mockCutBoxPreferences,
                    fakeKey: mockFakeKey,
                    searchView: mockSearchAndPreviewView
                )
            }

            context("when initialized") {
                it("should have the correct dependencies") {
                    expect(subject.searchView).to(be(mockSearchAndPreviewView))
                    expect(subject.historyService).to(be(mockHistoryService))
                    expect(subject.prefs).to(be(mockCutBoxPreferences))
                    expect(subject.fakeKey).to(be(mockFakeKey))
                }

                it("should set up event bindings") {
                    expect(subject.events.hasObservers).to(beTrue())
                }
            }

            context("SearchViewEvents") {
                /*
                    case .setSearchMode(let mode):
                        self.historyService.searchMode = mode

                    case .toggleSearchMode:
                        let mode = self.historyService.toggleSearchMode()
                        self.searchView.reloadData()
                        self.searchView.setSearchModeButton(mode: mode)

                    case .setTimeFilter(let seconds):
                        self.historyService.setTimeFilter(seconds: seconds)
                        self.searchView.reloadData()

                    case .toggleTimeFilter:
                        self.searchView.toggleTimeFilter()
                        self.historyService.setTimeFilter(seconds: nil)
                        self.searchView.reloadData()

                    case .cycleTheme:
                        self.prefs.cycleTheme()
                        self.searchView.applyTheme()
                        self.reloadDataWithExistingSelection()

                    case .toggleWrappingStrings:
                        self.prefs.useWrappingStrings.toggle()
                        self.updateSearchItemPreview()

                    case .toggleJoinStrings:
                        self.prefs.useJoinString.toggle()
                        self.updateSearchItemPreview()

                    case .toggleSearchScope:
                        self.historyService.favoritesOnly.toggle()
                        self.searchView.reloadData()
                        self.searchView.setSearchScopeButton(favoritesOnly: self.historyService.favoritesOnly)

                    case .togglePreview:
                        self.prefs.hidePreview.toggle()

                    case .scaleTextDown:
                        self.prefs.scaleTextDown()
                        self.reloadDataWithExistingSelection()

                    case .scaleTextUp:
                        self.prefs.scaleTextUp()
                        self.reloadDataWithExistingSelection()

                    case .scaleTextNormalize:
                        self.prefs.scaleTextNormalize()
                        self.reloadDataWithExistingSelection()

                    case .toggleFavorite:
                        self.toggleFavoriteItems()

                    case .justClose:
                        self.justClose()

                    case .closeAndPasteSelected:
                        self.closeAndPaste()

                    case .removeSelected:
                        self.removeSelectedItems()

                    default:
                        break
                    }
                }
                 */
            }
        }
    }
}
