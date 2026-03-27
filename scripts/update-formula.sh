#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA_DIR="${ROOT_DIR}/Formula"
CURRENT_FORMULA_PATH="${FORMULA_DIR}/nodus.rb"
REPO_SLUG="${REPO_SLUG:-nodus-rs/nodus}"
FORMULA_NAME="nodus"

usage() {
  cat <<'USAGE'
Update the Nodus Homebrew formula from GitHub Release assets.

Usage:
  ./scripts/update-formula.sh <version>

Examples:
  ./scripts/update-formula.sh 0.3.4
  ./scripts/update-formula.sh v0.3.4
USAGE
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'error: missing required command: %s\n' "$1" >&2
    exit 1
  }
}

normalize_version() {
  local raw="$1"
  raw="${raw#v}"
  if [[ ! "$raw" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'error: expected version like 0.3.4 or v0.3.4\n' >&2
    exit 1
  fi
  VERSION="$raw"
  RELEASE_TAG="v${VERSION}"
}

formula_class_name() {
  local version="${1:-}"
  if [[ -z "$version" ]]; then
    printf 'Nodus\n'
    return
  fi

  printf 'NodusAT%s\n' "${version//./}"
}

current_formula_version() {
  awk '/^[[:space:]]*version[[:space:]]+"/ { gsub(/"/, "", $2); print $2; exit }' "$CURRENT_FORMULA_PATH"
}

fetch_sha256() {
  local url="$1"
  curl -fsSL "$url" | awk '{ print $1; exit }'
}

asset_exists() {
  local url="$1"
  curl -fsSIL "$url" >/dev/null 2>&1
}

archive_current_formula() {
  local previous_version="$1"
  local previous_formula_path="${FORMULA_DIR}/${FORMULA_NAME}@${previous_version}.rb"
  local versioned_class
  versioned_class="$(formula_class_name "$previous_version")"

  if [[ -f "$previous_formula_path" ]]; then
    printf 'note: %s already exists; leaving it unchanged\n' "$previous_formula_path"
    return
  fi

  cp "$CURRENT_FORMULA_PATH" "$previous_formula_path"
  perl -0pi -e 's/^class Nodus < Formula/class '"$versioned_class"' < Formula/m; if ($_ !~ /^\s*keg_only :versioned_formula$/m) { s/^(  license .*\n)/$1  keg_only :versioned_formula\n/m; }' "$previous_formula_path"
  ruby -c "$previous_formula_path" >/dev/null
  printf 'created %s\n' "$previous_formula_path"
}

build_linux_block() {
  if [[ "$LINUX_ARM64_SUPPORTED" -eq 1 ]]; then
    cat <<EOF
    if Hardware::CPU.arm?
      url "${LINUX_ARM64_URL}"
      sha256 "${LINUX_ARM64_SHA256}"
    else
      url "${LINUX_X86_64_URL}"
      sha256 "${LINUX_X86_64_SHA256}"
    end
EOF
  else
    cat <<EOF
    if Hardware::CPU.arm?
      odie "Linux ARM is not supported for nodus #{version}"
    else
      url "${LINUX_X86_64_URL}"
      sha256 "${LINUX_X86_64_SHA256}"
    end
EOF
  fi
}

write_current_formula() {
  local linux_block
  linux_block="$(build_linux_block)"

  cat >"$CURRENT_FORMULA_PATH" <<EOF
class Nodus < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/${REPO_SLUG}"
  version "${VERSION}"
  license "Apache-2.0"
  head "https://github.com/${REPO_SLUG}.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "${MACOS_ARM64_URL}"
      sha256 "${MACOS_ARM64_SHA256}"
    else
      url "${MACOS_X86_64_URL}"
      sha256 "${MACOS_X86_64_SHA256}"
    end
  end

  on_linux do
${linux_block}
  end

  def install
    bin.install "nodus"
    generate_completions_from_executable(bin/"nodus", "completion")
    doc.install "README.md" if File.exist?("README.md")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodus --version")
    assert_match "_nodus", shell_output("#{bin}/completion zsh")
  end
end
EOF

  ruby -c "$CURRENT_FORMULA_PATH" >/dev/null
  printf 'updated %s for %s\n' "$CURRENT_FORMULA_PATH" "$RELEASE_TAG"
}

main() {
  if [[ $# -ne 1 ]]; then
    usage >&2
    exit 1
  fi

  need_cmd curl
  need_cmd perl
  need_cmd ruby
  need_cmd awk

  normalize_version "$1"

  local previous_version=""
  if [[ -f "$CURRENT_FORMULA_PATH" ]]; then
    previous_version="$(current_formula_version)"
  fi

  MACOS_ARM64_URL="https://github.com/${REPO_SLUG}/releases/download/${RELEASE_TAG}/${FORMULA_NAME}-${RELEASE_TAG}-aarch64-apple-darwin.tar.gz"
  MACOS_X86_64_URL="https://github.com/${REPO_SLUG}/releases/download/${RELEASE_TAG}/${FORMULA_NAME}-${RELEASE_TAG}-x86_64-apple-darwin.tar.gz"
  LINUX_ARM64_URL="https://github.com/${REPO_SLUG}/releases/download/${RELEASE_TAG}/${FORMULA_NAME}-${RELEASE_TAG}-aarch64-unknown-linux-gnu.tar.gz"
  LINUX_X86_64_URL="https://github.com/${REPO_SLUG}/releases/download/${RELEASE_TAG}/${FORMULA_NAME}-${RELEASE_TAG}-x86_64-unknown-linux-gnu.tar.gz"

  MACOS_ARM64_SHA256="$(fetch_sha256 "${MACOS_ARM64_URL}.sha256")"
  MACOS_X86_64_SHA256="$(fetch_sha256 "${MACOS_X86_64_URL}.sha256")"
  LINUX_X86_64_SHA256="$(fetch_sha256 "${LINUX_X86_64_URL}.sha256")"

  if asset_exists "$LINUX_ARM64_URL"; then
    LINUX_ARM64_SUPPORTED=1
    LINUX_ARM64_SHA256="$(fetch_sha256 "${LINUX_ARM64_URL}.sha256")"
  else
    LINUX_ARM64_SUPPORTED=0
    LINUX_ARM64_SHA256=""
    printf 'note: Linux arm64 asset missing for %s; generating formula without Linux ARM support\n' "$RELEASE_TAG"
  fi

  if [[ -n "$previous_version" && "$previous_version" != "$VERSION" ]]; then
    archive_current_formula "$previous_version"
  fi

  write_current_formula
}

main "$@"
