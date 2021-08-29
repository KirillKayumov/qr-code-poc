# require "bundler/inline"

# gemfile do
#   source "https://rubygems.org"
#   gem "rqrcode_core"
# end

require 'bundler/setup'
require 'rqrcode_core'
require 'pry'
require 'erb'

qr = RQRCodeCore::QRCode.new("https://www.uula.com")

qr_html = qr.modules.map do |row|
  row_html = row.map do |col|
    "<div class=\"col #{col ? 'filled' : ''}\"></div>"
  end.join

  "<div class=\"row\">#{row_html}</div>"
end.join

result = ERB.new(File.read("template.html.erb")).result(binding)
File.write("qr.html", result)
