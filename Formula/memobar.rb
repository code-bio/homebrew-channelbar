class Memobar < Formula
  desc "CLI tool for memoBar"
  homepage "https://memobar.app"
  # Real URL - post_install re-downloads to preserve code signature
  url "https://github.com/code-bio/homebrew-memobar/releases/download/v0.4.0/memobar-cli-0.4.0.tar.gz"
  sha256 "442dbe83e423bee82fe4410232d48007cb9adb5971290548b971a2b0378ce663"
  license "Copyright 2025 Christian Franzl, code.bio GmbH"

  depends_on :macos

  def install
    # Create directories only - files come in post_install
    libexec.mkpath
  end

  def post_install
    # Download and extract AFTER Homebrew's post-processing
    tarball_url = "https://github.com/code-bio/homebrew-memobar/releases/download/v#{version}/memobar-cli-#{version}.tar.gz"

    # Clear and re-extract to preserve signatures
    system "rm", "-rf", libexec/"memobar", libexec/"Frameworks"
    system "curl", "-L", tarball_url, "-o", "/tmp/memobar-cli.tar.gz"
    system "tar", "-xzf", "/tmp/memobar-cli.tar.gz", "-C", libexec
    system "rm", "/tmp/memobar-cli.tar.gz"
    system "chmod", "755", libexec/"memobar"

    # Create symlink manually after binary exists
    system "ln", "-sf", libexec/"memobar", HOMEBREW_PREFIX/"bin/memobar"
  end

  def caveats
    <<~EOS
      The memobar CLI requires the memoBar app to be running.
      Get the app from: https://memobar.app

      Usage:
        memobar version                  # Show current version
        memobar                          # Show all commands

      macOS Tahoe (26+):
        If you see a dialog about accessing data from other apps,
        grant Full Disk Access to your terminal:
        System Settings → Privacy & Security → Full Disk Access
    EOS
  end

  test do
    assert_match(/memobar|version/i, shell_output("#{bin}/memobar version", 0))
  end
end
