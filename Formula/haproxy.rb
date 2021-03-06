class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.8/src/haproxy-1.8.10.tar.gz"
  sha256 "c93bd1a2d4595810a38315de9687b813bf7df790bd807faf8982a13596b0bc60"

  bottle do
    cellar :any
    sha256 "c3c6ee76083d9874682c7ed0bebc9b6a804198a4a3460c6f6a7c671e38c081d9" => :high_sierra
    sha256 "915234c7f175438c32edc61bbe86cded2702a75711cfc0501a606bff5dc6ba2f" => :sierra
    sha256 "e807efde1cd570189e8f09f6b838ba9807dc2b07f28aceb8d84ac0b519918537" => :el_capitan
    sha256 "979b46d4a11c2180df2553cb2651b35e648d13e1e1eb0c812486f4977899f576" => :x86_64_linux
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua" => :optional

  def install
    args = %W[
      TARGET=#{OS.mac? ? "generic" : "linux2628"}
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    args << "USE_KQUEUE=1" if OS.mac?

    if build.with?("lua")
      lua = Formula["lua"]
      args << "USE_LUA=1"
      args << "LUA_LIB=#{lua.opt_lib}"
      args << "LUA_INC=#{lua.opt_include}"
      args << "LUA_LD_FLAGS=-L#{lua.opt_lib}"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options :manual => "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/haproxy</string>
          <string>-f</string>
          <string>#{etc}/haproxy.cfg</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/haproxy.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/haproxy.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
