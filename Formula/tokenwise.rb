class Tokenwise < Formula
  desc "Code intelligence MCP server for AI agents"
  homepage "https://github.com/sauravtom/tokenwise"
  url "https://github.com/sauravtom/tokenwise/archive/refs/heads/main.tar.gz"
  version "main"
  sha256 :no_check
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "tokenwise", shell_output("#{bin}/tokenwise --version")
  end
end
