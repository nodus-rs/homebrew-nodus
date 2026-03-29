class Nodus < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.6.0"
  license "Apache-2.0"
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.6.0/nodus-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "da4dc37c0806cec8b49469b90644c5b44103d44a5b848c78db487ae68b86f6a7"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.6.0/nodus-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "3414e587787ff9ce12b8fe8b936925150339946da5ffac1dc392ff8967f3aae6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.6.0/nodus-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "214bc886e011e825508f2c4a64092b63fc012332c08c24dbcd667dd1c0f63b3d"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.6.0/nodus-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a1ed6e6ee7c65f1bd294990562ed8571482c4ee13a8904fcbf6e1c13943e606"
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
