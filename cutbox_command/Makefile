build ::
	swift build

test ::
	swift test --enable-code-coverage

coverage_report :: build test
	xcrun llvm-cov show -format html -ignore-filename-regex="checkouts|CutBoxCLITests" -instr-profile .build/x86_64-apple-macosx/debug/codecov/default.profdata .build/x86_64-apple-macosx/debug/CutBoxCLIPackageTests.xctest/Contents/MacOS/CutBoxCLIPackageTests > coverage.html

test_bin ::
	cp .build/x86_64-apple-macosx/debug/CutBoxCLI ../test_bin/cutbox

install :: build
	cp .build/x86_64-apple-macosx/debug/CutBoxCLI /usr/local/bin/cutbox

clean ::
	swift package clean
