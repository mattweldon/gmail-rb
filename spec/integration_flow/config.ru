# config.ru
$: << File.expand_path(File.dirname(__FILE__))

require 'app'

use Rack::Session::Cookie
run App.new