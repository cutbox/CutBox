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

class PreferencesGeneralView_KeyRecorderSpec: QuickSpec {
    override func spec() {
        describe("PreferencesGeneralView_RecordViewDelegate") {
            let subject: PreferencesGeneralView = PreferencesGeneralView(frame: .zero)

            it("returns true for can record key combo") {
                let result = subject.recordView(
                    RecordView(frame: .zero),
                    canRecordKeyCombo: KeyCombo(key: .return, cocoaModifiers: .command)!)

                expect(result) == true
            }

            it("recordViewShouldBeginRecording returns true after unregistering an existing key combo") {
                expect(subject.recordViewShouldBeginRecording(RecordView(frame: .zero)))
                .to(beTrue())
            }

            it("returns void for recordViewDidEndRecording") {
                expect(subject.recordViewDidEndRecording(RecordView(frame: .zero))) == ()
            }

            it("can record and didChangeKeyCombo keyCombo") {
                let keyRecorder = RecordView(frame: .zero)
                let keyCombo = KeyCombo(key: .p, cocoaModifiers: [.command, .shift])
                subject.mainKeyRecorder = keyRecorder

                subject.recordView(
                    subject.mainKeyRecorder,
                    didChangeKeyCombo: keyCombo)

                expect(subject.mainKeyRecorder) == keyRecorder

                // It needs a display...
                expect(subject.mainKeyRecorder.keyCombo).to(beNil())
            }
        }
    }
}
