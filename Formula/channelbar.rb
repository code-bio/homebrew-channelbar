class Channelbar < Formula
  desc "CLI tool for channelBar"
  homepage "https://channelbar.app"
  license "Copyright © 2026 code.bio GmbH"

  url "https://github.com/code-bio/homebrew-channelbar/releases/download/v1.2.1/channelbar-cli-1.2.1.tar.gz"
  sha256 "f01189b522fa873a0b9e0b342993ec947c5d809da09c9c90e49236c608fc8b6c"

  depends_on :macos

  def install
    libexec.mkpath
  end

  def post_install
    tarball_url = "https://github.com/code-bio/homebrew-channelbar/releases/download/v#{version}/channelbar-cli-#{version}.tar.gz"

    require "tempfile"
    tmpfile = Tempfile.new(["channelbar-cli", ".tar.gz"])
    tmppath = tmpfile.path
    tmpfile.close

    system "rm", "-rf", libexec/"channelbar", libexec/"Frameworks", libexec/"THIRD-PARTY-LICENSES.txt"
    system "curl", "-L", tarball_url, "-o", tmppath
    system "tar", "-xzf", tmppath, "-C", libexec
    system "rm", "-f", tmppath
    system "chmod", "755", libexec/"channelbar"

    system "ln", "-sf", libexec/"channelbar", HOMEBREW_PREFIX/"bin/channelbar"

    license_src = libexec/"THIRD-PARTY-LICENSES.txt"
    if File.exist?(license_src)
      doc.mkpath
      system "cp", "-p", license_src, doc/"THIRD-PARTY-LICENSES.txt"
    end
  end

  def caveats
    <<~EOS

      The channelbar CLI requires the channelBar app to be running.
      Get the app from: https://channelbar.app

      Usage:
        channelbar version               # Show current version
        channelbar                       # Show all commands
        channelbar --licenses            # Show third-party licenses

    EOS
  end

  test do
    assert_match(/channelbar|version/i, shell_output("#{bin}/channelbar version", 0))
  end
end
