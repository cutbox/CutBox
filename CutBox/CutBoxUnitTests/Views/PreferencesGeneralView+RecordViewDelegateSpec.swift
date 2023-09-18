//
//  PreferencesGeneralView+RecordViewDelegateSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import KeyHolder
import Magnet

class PreferencesGeneralView_RecordViewDelegateSpec: QuickSpec {
    override func spec() {
        describe("PreferencesGeneralView_RecordViewDelegate") {
            let subject: PreferencesGeneralView = PreferencesGeneralView(frame: .zero)

            it("returns true for can record key combo") {
                let result = subject.recordView(
                    RecordView(frame: .zero),
                    canRecordKeyCombo: KeyCombo(key: .return, cocoaModifiers: .command)!)

                expect(result) == true
            }

            it("returns void for recordViewDidEndRecording") {
                expect(subject.recordViewDidEndRecording(RecordView(frame: .zero))) == ()
            }
        }
    }
}
