class NodusAT040 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/WendellXY/nodus"
  version "0.4.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/WendellXY/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WendellXY/nodus/releases/download/v0.4.0/nodus-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "758cadd776d825bcf03c08a2a62f977c5f04458735512442a0e01b6b6e2d10c8"
    else
      url "https://github.com/WendellXY/nodus/releases/download/v0.4.0/nodus-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "c743aa48e1a560d90f9f2ef473d86855f085bd79dc87e1f2765d2a2b2c8fc99c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WendellXY/nodus/releases/download/v0.4.0/nodus-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c68087e8356dfa6f58b256453ea0f47f4fa59904be8f94b8cc27c75ee4803a36"
    else
      url "https://github.com/WendellXY/nodus/releases/download/v0.4.0/nodus-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a63b08c8ccd77a3f6e60b9e09243b51fe1136f2da4a8f1fa6c063225b8d7617"
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
