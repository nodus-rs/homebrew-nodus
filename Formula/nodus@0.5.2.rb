class NodusAT052 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.5.2"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.2/nodus-v0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "2deddca92e4c182447073ebe454eb0f4463c52d18da5d61f585d73755795c1d6"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.2/nodus-v0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "93bae2f056a2c3d83d8d2af447c9ca3c7071d90897b9adf255adf05cc547f57a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.2/nodus-v0.5.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "173fe56be791dfb7b648abdaa203b18b9ccb2425522e5ea6e245d4828134a4d6"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.2/nodus-v0.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "62482f770e21cacd2fec78492bfdf3127a0cdf3808e3b76775779eb9c3aed1cc"
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
