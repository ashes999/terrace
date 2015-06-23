# Used to keep relative paths DRY
require 'test/unit'
$LOAD_PATH.unshift '../lib'

TEST_ROOT = Dir.pwd
Dir.chdir('../lib')
SOURCE_ROOT = Dir.pwd
