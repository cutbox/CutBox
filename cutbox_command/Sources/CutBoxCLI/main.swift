import Foundation
import CutBoxCLICore

func main() {
    let plist = loadPlist(path: "\(NSHomeDirectory())/Library/Preferences/info.ocodo.CutBox.plist")
    cutBoxCliMain(out: Output(), plist: plist)
}

main()
