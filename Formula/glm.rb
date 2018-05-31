class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.0/glm-0.9.9.0.zip"
  sha256 "e1c707407c43589e8eeb8b69b902f1a34aaaa59bda1ca144181c2d2d6e531246"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :high_sierra
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :sierra
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :el_capitan
    sha256 "35c1d32805b1c4515953dd8cb1eb264bf5dfa0a424ad017e7acac8db5d0534aa" => :x86_64_linux
  end

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    if build.with? "doxygen"
      cd "doc" do
        system "doxygen", "man.doxy"
        man.install "html"
      end
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
