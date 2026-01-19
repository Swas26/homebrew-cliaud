class Cliaud < Formula
  desc "CLI audio output switcher + hotkey agent for macOS"
  homepage "https://github.com/swas/cliaud"
  url "https://github.com/swas/cliaud/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  depends_on :macos

  def install
    system "clang++", "-std=c++17", "cliaud.cpp", "-o", "cliaud",
           "-framework", "CoreFoundation", "-framework", "CoreAudio"
    bin.install "cliaud"

    system "clang++", "-std=c++17", "agent.cpp", "-o", "cliaud-agent",
           "-framework", "Carbon", "-framework", "ApplicationServices"
    bin.install "cliaud-agent"
  end

  service do
    run [opt_bin/"cliaud-agent"]
    keep_alive true
    log_path var/"log/cliaud-agent.log"
    error_log_path var/"log/cliaud-agent.err.log"
  end

  def caveats
    <<~EOS
      To run the hotkey agent at login:
        brew services start cliaud

      To stop it:
        brew services stop cliaud

      Hotkey: Cmd + Option + 9
    EOS
  end

  test do
    system "#{bin}/cliaud", "list"
  end
end
