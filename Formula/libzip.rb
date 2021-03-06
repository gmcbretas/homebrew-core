class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.1.tar.gz"
  sha256 "47eaa45faa448c72bd6906e5a096846c469a185f293cafd8456abb165841b3f2"

  bottle do
    sha256 "4ffb9ac04f1fc2c98e5ba902999ed6f4bc5d7d9133d22fc183fd8fa13b7fd9be" => :high_sierra
    sha256 "a6d0dbd2370c97597948976414a48f544dc8a8e3e674e7faacef1bdc942d3161" => :sierra
    sha256 "312f87c8f28237b69080b511d696ba72027e774655eacdd159159001c7941c0d" => :el_capitan
    sha256 "34edb293e3b5a778f37f3614b86771c3dbb1ddaffd6075002c22896e49ba476d" => :x86_64_linux
  end

  depends_on "cmake" => :build

  conflicts_with "libtcod", :because => "both install `zip.h` header"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
    depends_on "openssl"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    zip = OS.mac? ? "/usr/bin/zip" : which("zip")
    if zip.nil?
      opoo "Not testing unzip, because it requires zip, which is unavailable."
      return
    end

    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
