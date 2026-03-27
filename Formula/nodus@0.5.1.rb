class NodusAT051 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.5.1"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.1/nodus-v0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "5a68038fe7ba3f37cbf2847ae8f9a854ad6cf1d29842d3edb47cfaa3565638c7"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.1/nodus-v0.5.1-x86_64-apple-darwin.tar.gz"
      sha256 "eb2a108f5df35d615bbcd46039d11c207f6430f71b849009c9216546307acf3f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.1/nodus-v0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d928389f5db6ca821dc5c9c4228def106891e95807c5f3dd1dc7a05d32c25cca"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.5.1/nodus-v0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f592cc8d3ac600498d431d92f2dc3d35b3d4a9ef10ea47b04ce50663a6fbc8d4"
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
