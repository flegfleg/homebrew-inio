# inio command-line tools

`inio` and `inio-mcp` for the inio notes app on macOS:

- **`inio`** captures notes, opens pages and searches the library from Terminal.
- **`inio-mcp`** is an MCP server. It lets Claude Desktop, Claude Code and other MCP clients read and write your inio pages.

Both tools talk to the running inio app. They need macOS 26 or later.

## Install

With [Homebrew](https://brew.sh):

```sh
brew install --cask flegfleg/inio/inio-cli
```

Update:

```sh
brew upgrade --cask inio-cli
```

Remove:

```sh
brew uninstall --cask inio-cli
```

No step needs `sudo`. Homebrew links the tools into its own `bin` folder, which you own.

### Without Homebrew

1. Download `inio-cli-<version>.zip` from the [latest release](https://github.com/flegfleg/homebrew-inio/releases/latest).
2. Move `inio` and `inio-mcp` into a folder on your `PATH` that you own, for example `~/.local/bin`.

To update, replace both files. To remove, delete them.

After you install or update, run `inio --version` once. inio's Settings ▸ Integrations then shows the installed version.

## Use with an MCP client

Give the client the path of the Homebrew link, not the file in the Caskroom (`brew upgrade` deletes that one):

```json
{
  "mcpServers": {
    "inio": { "command": "/opt/homebrew/bin/inio-mcp" }
  }
}
```

On an Intel Mac, the path is `/usr/local/bin/inio-mcp`.

## For maintainers

The tools are built, signed and notarized in the app's repository, not here. This repository holds the cask and the release files.

1. In the app's repository, run `scripts/build-cli-tools.sh`. It needs the Developer ID Application certificate and the `AC_PASSWORD` notary profile.
2. Run `scripts/publish-cli-tools.sh`. It checks the zip (Developer ID signature, notarization accepted, versions), then makes the release `v<version>` here with the zip attached.
3. The **Release** workflow sets `version` and `sha256` in `Casks/inio-cli.rb`, commits the change to `main`, and then installs the cask on a clean macOS runner. It checks the signature, the team, the hardened runtime and `--version`, then removes the cask again.

To point the cask at an existing release again, run the Release workflow by hand with its tag.

The **CI** workflow checks the cask's style on each push and pull request. Run it by hand to install and check the current release.

### Repository settings

- **Actions ▸ General ▸ Workflow permissions:** the Release workflow asks for `contents: write` to push the cask update. If `main` is protected, allow `github-actions[bot]` to push to it.
- The repository must be **public**, so that `brew tap` and the release downloads work without a token.
