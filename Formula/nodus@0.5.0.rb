class NodusAT050 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.5.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.0/nodus-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "eb6e107f5d5ebee7150f8fb7614a0ae54dabba85fe11ae26caf8740408628c73"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.0/nodus-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "5e9ce869d2d8e1211972261bb7d84f1975f128fa8728673b673337bb0e71848d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.0/nodus-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f6395beb5a0e9e057c3dcaab72747238a7491c393239f28d394d00d85144914c"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.0/nodus-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4a2ecb6d1a13dc6e760c78feb6304f3f770a9f81be2c9e127ce6780529a7022a"
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
