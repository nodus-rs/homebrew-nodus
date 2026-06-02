class Nodus < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.17.0"
  license "Apache-2.0"
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.17.0/nodus-v0.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "50e92217e8e838c1cdc40e8d7235a4378e6f9da351bdba932780a21ae8abe61c"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.17.0/nodus-v0.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "88bf98711e87972c59302821e6511c82acb98b08b3b86d66f42fffc26226cd53"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.17.0/nodus-v0.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3035f86bf86e2b2abfe642d6d35746a34c008e0c4512b0b23b1932b545f10f00"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.17.0/nodus-v0.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8adb24f3c5b3b2a6f50efc4f7e9b94236c6fe25d958253df3603fe698aa869fd"
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
