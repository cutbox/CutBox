//
//  CutBoxPreferencesService+HistoryLimitSpec.swift
//  CutBoxTests
//
//  Created by Jason on 14/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class CutBoxPreferencesServiceHistoryLimitSpec: QuickSpec {

    override func spec() {
        describe("CutBoxPreferencesService+HistoryLimit") {

            var subject: CutBoxPreferencesService!
            var defaults: UserDefaults!

            let disposeBag = DisposeBag()

            beforeEach {
                defaults = UserDefaultsMock()
                subject = CutBoxPreferencesService(defaults: defaults)
            }

            afterEach {
                defaults.removeObject(forKey: "historyLimit")
            }

            context("when history limit settings are changed") {
                var captured: CutBoxPreferencesEvent?
                beforeEach {
                    subject
                        .events
                        .subscribe(onNext: { captured = $0 })
                        .disposed(by: disposeBag)
                }

                it("fires a historyLimitChanged event when setting history limited") {
                    subject.historyLimited = true
                    if case .historyLimitChanged(let limit)? = captured {
                        expect(limit).to(equal(0))
                    } else {
                        XCTAssertFalse(true, "history limit changed test failed")
                    }

                    subject.historyLimit = 100
                    if case .historyLimitChanged(let limit)? = captured {
                        expect(limit).to(equal(100))
                    } else {
                        XCTAssertFalse(true, "history limit changed test failed")
                    }

                    subject.historyLimited = false
                    if case .historyLimitChanged(let limit)? = captured {
                        expect(limit).to(equal(0))
                    } else {
                        XCTAssertFalse(true, "history limit changed test failed")
                    }
                }
            }
        }
    }
}
