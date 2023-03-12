# CutBox shell command

To use the CutBox history on the command line you can use the `cutbox` shell command.

## Print history

List all the items from CutBox history:

``` sh
cutbox
```

List the 10 most recent items from CutBox history:

``` sh
cutbox 10
```

## Installation

Build from source from the repo:

``` sh
cd cutbox_command
swift build -c release
cp .build/release/cutbox /usr/local/bin/cutbox
```

