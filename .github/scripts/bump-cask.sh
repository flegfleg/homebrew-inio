#!/bin/sh
set -eu

# Point Casks/inio-cli.rb at a published release: its version and the
# sha256 of its zip. Run by .github/workflows/release.yml with GH_TOKEN set;
# also runs by hand from the tap's root:  .github/scripts/bump-cask.sh v1.5.0
#
# It changes only the `version` and `sha256` lines.

TAG="${1:?usage: $0 <tag, e.g. v1.5.0>}"
VERSION="${TAG#v}"
ASSET="inio-cli-${VERSION}.zip"
CASK="Casks/inio-cli.rb"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/bump-cask.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

case "$VERSION" in
    *[!0-9.]*|"") echo "error: tag '${TAG}' is not v<major>.<minor>.<patch>" >&2; exit 1 ;;
esac

gh release download "$TAG" --pattern "$ASSET" --dir "$WORK"

# The zip holds exactly the two tools, at its root (the cask's `binary`
# stanzas name them there).
CONTENTS="$(unzip -Z1 "${WORK}/${ASSET}" | sort | tr '\n' ' ')"
if [ "$CONTENTS" != "inio inio-mcp " ]; then
    echo "error: ${ASSET} holds '${CONTENTS}', expected 'inio inio-mcp'" >&2
    exit 1
fi

SHA256="$(shasum -a 256 "${WORK}/${ASSET}" | cut -d ' ' -f 1)"
sed -e "s/^  version \".*\"$/  version \"${VERSION}\"/" \
    -e "s/^  sha256 \".*\"$/  sha256 \"${SHA256}\"/" \
    "$CASK" > "${WORK}/cask.rb"
mv "${WORK}/cask.rb" "$CASK"

grep -q "^  version \"${VERSION}\"$" "$CASK" && grep -q "^  sha256 \"${SHA256}\"$" "$CASK" || {
    echo "error: ${CASK} has no version or sha256 line to update" >&2
    exit 1
}
echo "${CASK}: ${VERSION} ${SHA256}"
