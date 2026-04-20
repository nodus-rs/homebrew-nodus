class NodusAT0100 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.10.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.0/nodus-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "3a22c29a919bc815fe2e37857c8933e0c7ae473e27737b84f3fa36bb042cf65f"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.0/nodus-v0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "bcac468b6d01b52a7091b7202f88d4df9a99a2c96656e656a8767f03407608e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.0/nodus-v0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f13115cd8e2d61a0018ba36776a6bf3f38385b7ddb609461b807b2338d141cc5"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.0/nodus-v0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c69a1c1fe1886fc76fe08bad1a6cd7f181e2e9da7b204fdc19cc635583ba5662"
    end
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
