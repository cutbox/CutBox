build ::
	swift build

test ::
	swift test --enable-code-coverage

coverage_report ::
	xcrun llvm-cov show \
		-format html \
		-output-dir=../docs/ \
		-ignore-filename-regex="checkouts|CutBoxCLITests|Output\.swift" \
		-instr-profile .build/x86_64-apple-macosx/debug/codecov/default.profdata \
		.build/x86_64-apple-macosx/debug/CutBoxCLIPackageTests.xctest/Contents/MacOS/CutBoxCLIPackageTests

test_bin :: build
	cp .build/x86_64-apple-macosx/debug/CutBoxCLI ../test_bin/cutbox

dmg_bin :: build
	cp .build/x86_64-apple-macosx/debug/CutBoxCLI ../CutBox/build/cutbox

install :: build
	cp .build/x86_64-apple-macosx/debug/CutBoxCLI /usr/local/bin/cutbox

clean ::
	swift package clean
