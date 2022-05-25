cask "cutbox" do
  version "1.4.11"

  sha256 "68ba878d6fa140d38d25fc97468129d0492b56f2b602b970e8daa992917b236e"

  url "https://github.com/cutbox/CutBox/releases/download/#{version}/CutBox.dmg",
      verified: "github.com/cutbox/CutBox/"
  name "cutbox"
  desc "Clipboard manager"
  homepage "https://cutbox.github.io"

  depends_on macos: ">= :el_capitan"

  app "CutBox.app"

  # I don't want to unexpectedly kill anyone's clipboard history!!
  # zap trash: "~/Library/Preferences/info.ocodo.CutBox.plist"
end
