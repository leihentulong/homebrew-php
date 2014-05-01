require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Apcu < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/apcu'
  url 'http://pecl.php.net/get/apcu-4.0.4.tgz'
  sha1 'c196548421fd7fdbbbc23050f0d786f0ae45f290'
  head 'https://github.com/krakjoe/apcu.git'

  option 'with-apc-bc', "Wether APCu should provide APC full compatibility support"
  depends_on 'pcre'

  def install
    Dir.chdir "apcu-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    args = []
    args << "--enable-apcu"
    args << "--enable-apc-bc" if build.with? 'apc-bc'

    safe_phpize

    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          *args
    system "make"
    prefix.install "modules/apcu.so"
    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<-EOS.undent
      apc.enabled=1
      apc.shm_size=64M
      apc.ttl=7200
      apc.mmap_file_mask=/tmp/apc.XXXXXX
      apc.enable_cli=1
    EOS
  end
end
