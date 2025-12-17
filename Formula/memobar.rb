class Memobar < Formula
  desc "CLI tool for memoBar - display messages in macOS menu bar"
  homepage "https://memobar.app"
  url "https://github.com/code-bio/homebrew-memobar/releases/download/v0.8.0/memobar-cli-0.8.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256_WILL_BE_UPDATED_BY_BUMP_VERSION"
  license "MIT"

  depends_on :macos

  def install
    # Install CLI binary to bin
    bin.install "memobar"

    # Install frameworks to libexec/Frameworks
    (libexec/"Frameworks").install Dir["Frameworks/*"]

    # Update binary rpath to find frameworks in libexec
    system "install_name_tool", "-delete_rpath", "@executable_path/Frameworks", bin/"memobar"
    system "install_name_tool", "-add_rpath", "#{libexec}/Frameworks", bin/"memobar"
  end

  def caveats
    <<~EOS
      The memobar CLI requires the memoBar app to be running.
      Get the app from: https://memobar.app

      Usage:
        memobar set "Your message"       # Set message in default channel
        memobar get                      # Get current message
        memobar list                     # List all messages
        memobar --help                   # Show all commands
    EOS
  end

  test do
    # Test that version command runs without error
    assert_match(/memobar|version/i, shell_output("#{bin}/memobar version", 0))
  end
end
