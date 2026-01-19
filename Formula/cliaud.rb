class Cliaud < Formula
  desc "CLI audio output switcher + hotkey agent for macOS"
  homepage "https://github.com/Swas26/cliaud"
  url "https://github.com/Swas26/cliaud/archive/refs/tags/v0.1.0.tar.gz"

  sha256 "693b0718299e2e530bf21bae0e8c5c780c2545f1b6659f779d3e1416292d8cca"
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
