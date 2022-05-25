cask "cutbox" do
  version "1.4.11"

  sha256 "acc6df670f7922bb23c5bc472bc0a6c2fa8f36c0d9d4060f75e4a66a0f35bd4f"

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
