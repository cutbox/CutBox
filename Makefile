setup ::
	bin/setup

test ::
	bin/test

test_ci ::
	set -o pipefail && bin/test 2>&1 | xcpretty -f bin/markdown_xcpretty_formatter.rb \
	| sed -n -e '/^# Started: CutBoxUnitTests.xctest$/,/^      Executed/p' \
	| tee markdown_test_report.md
	cat markdown_test_report.md >> $GITHUB_STEP_SUMMARY
	rm markdown_test_report.md

build ::
	bin/build

cli_test ::
	bin/command_line_test

dmg ::
	bin/cutbox_make_dmg CutBox.dmg

ci_get_release_info ::
	bin/ci_get_release_info
