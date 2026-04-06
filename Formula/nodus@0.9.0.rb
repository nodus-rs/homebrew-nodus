class NodusAT090 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.9.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.0/nodus-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "34d7bd6da62943853fd238216020f5e0785b566e15b7d293bc85f90bd0c2a421"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.0/nodus-v0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "ef00ed5ee2bfbd69ad011556f853c0836a8195ec2051c3e66940f20d3c38f4b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.0/nodus-v0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8b310266e2cd199d9919b24b441bf601a0a698302517a6b451b660b2022f8d64"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.0/nodus-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d35cd8e34d61fe6c5f5d4ff56c5e7a16c26000549809cbc303eabc0a87221306"
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
