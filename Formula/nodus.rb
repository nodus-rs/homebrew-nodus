class Nodus < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.9.1"
  license "Apache-2.0"
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.1/nodus-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "48d7e9fbd1621182838fdfe6e86313483bc69a938c8a28d5a6de3ff03fc7377c"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.1/nodus-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "9b203a7e42a7c14156b88b9bf7704be20e530cb772be901382e693ee8c0c30c1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.1/nodus-v0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dd4a0b5f3e172a171de320cf9258d01303d4d3de8da32bfd061b1b2c8f27a8b3"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.1/nodus-v0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c49ee6351e54c963827f0aa5066fd7486e675473f4551cc0358b756bba18663"
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
