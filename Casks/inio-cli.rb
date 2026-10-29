# inio command-line tools: `inio` (CLI) and `inio-mcp` (MCP server).
#
# The release workflow (.github/workflows/release.yml) sets `version` and
# `sha256` from each published release; edit the rest by hand. The zip is
# built, signed and notarized in the app's repository
# (scripts/build-cli-tools.sh) and uploaded by scripts/publish-cli-tools.sh.
cask "inio-cli" do
  version "1.5.0"
  sha256 "da732af8679c84f06b7b2d3d3fa85f27d6a08d28e625d2dc4320a8c16547954c"

  url "https://github.com/flegfleg/homebrew-inio/releases/download/v#{version}/inio-cli-#{version}.zip"
  name "inio command-line tools"
  desc "Command-line tool and MCP server for the inio notes app"
  homepage "https://github.com/flegfleg/homebrew-inio"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  binary "inio"
  binary "inio-mcp"
end
