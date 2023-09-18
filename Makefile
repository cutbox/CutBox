setup ::
	bin/setup

test ::
	bin/test

test_ci ::
	bin/test_ci

test_themes ::
	bin/test_themes

build ::
	bin/build

swiftlint ::
	swiftlint

swiftlint_status ::
	echo $$(swiftlint 2>&1 | grep -E -o "Done linting.*")

dmg ::
	rm -f CutBox.dmg
	bin/cutbox_make_dmg CutBox.dmg

ci_get_release_info ::
	bin/ci_get_release_info

check_l7n_app ::
	bin/check_l7n_source

check_l7n_languages ::
	bin/check_all_localization

install :: swiftlint check_l7n_app check_l7n_languages test build
	bin/use_build_as_local_app
