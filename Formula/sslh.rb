class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.19c.tar.gz"
  sha256 "bb11dfa88b27ae1ec825a1b8156000c3f17f7e8f042311f19b7a249193c47bf3"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "4f3429c456314ead9330497258f58dbc07c620a497101d451b37538f773e7138" => :high_sierra
    sha256 "4c02e4c94f732f382abb18e3831f629a0dd108211aca169ae7b93c3e387a6b70" => :sierra
    sha256 "a457cede9fdc5903b4d4cf390ccf34caf716c1cf8ddfef315197876c250438c0" => :el_capitan
    sha256 "fa720ca3303cf1b6b89a83313ca759c11184ea924698a9a9833a01c64c2ec543" => :x86_64_linux
  end

  depends_on "libconfig"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sslh -V")
  end
end
