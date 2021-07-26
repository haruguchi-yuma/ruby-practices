require 'pathname'
require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  TARGET_PATHNAME = 'test/sample-app'

  def test_run_ls_short_format
    ls = Ls.new(Pathname(TARGET_PATHNAME + '/*'),**{ detail: false, reverse: false, dot_match: false })
    expected = <<~TEXT.chomp
    Gemfile           config            postcss.config.js
    Gemfile.lock      config.ru         public
    README.md         db                storage
    Rakefile          lib               test
    app               log               tmp
    babel.config.js   node_modules      vendor
    bin               package.json      yarn.lock
    TEXT
    assert_equal expected, ls.run_ls
  end

  def test_run_ls_long_format
    ls = Ls.new(Pathname(TARGET_PATHNAME),**{ detail: true, reverse: false, dot_match: false })
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    assert_equal expected, ls.run_ls
  end

  def test_run_ls_reverse
    ls = Ls.new(Pathname(TARGET_PATHNAME + '/*'),**{ detail: false, reverse: true, dot_match: false })
    expected = <<~TEXT.chomp
    yarn.lock         package.json      bin
    vendor            node_modules      babel.config.js
    tmp               log               app
    test              lib               Rakefile
    storage           db                README.md
    public            config.ru         Gemfile.lock
    postcss.config.js config            Gemfile
    TEXT
    assert_equal expected, ls.run_ls
  end

  def test_run_ls_dot_match
    ls = Ls.new(Pathname(TARGET_PATHNAME + '/*'),**{ detail: false, reverse: false, dot_match: true })
    expected = <<~TEXT.chomp
    .                 Rakefile          node_modules
    ..                app               package.json
    .browserslistrc   babel.config.js   postcss.config.js
    .gitignore        bin               public
    .rubocop.yml      config            storage
    .ruby-version     config.ru         test
    Gemfile           db                tmp
    Gemfile.lock      lib               vendor
    README.md         log               yarn.lock
    TEXT
    assert_equal expected, ls.run_ls
  end

  def test_run_ls_all_options
    ls = Ls.new(Pathname(TARGET_PATHNAME),**{ detail: true, reverse: true, dot_match: true })
    expected = `ls -arl #{TARGET_PATHNAME}`.chomp
    assert_equal expected, ls.run_ls
  end
end
