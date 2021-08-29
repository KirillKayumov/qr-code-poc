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
qr_size = qr.modules.size

vertical_lines_info = Array.new(qr_size).map { Array.new(qr_size) }

qr.modules.each.with_index do |row, row_index|
  row.each.with_index do |col, col_index|
    next unless col

    is_checked_above = row_index > 0 && qr.modules[row_index - 1][col_index]
    is_checked_below = row_index < qr_size - 1 && qr.modules[row_index + 1][col_index]

    vertical_lines_info[row_index][col_index] = if !is_checked_above && !is_checked_below
      :dot
    elsif !is_checked_above
      :line_head
    elsif !is_checked_below
      :line_tail
    else
      nil
    end
  end
end

qr_html = qr.modules.map.with_index do |row, row_index|
  row_html = row.map.with_index do |col, col_index|
    next "<div class=\"col\"></div>" if (0..6).include?(row_index) && (0..6).include?(col_index)
    next "<div class=\"col\"></div>" if (0..6).include?(row_index) && ((qr_size - 7)..(qr_size - 1)).include?(col_index)
    next "<div class=\"col\"></div>" if ((qr_size - 7)..(qr_size - 1)).include?(row_index) && (0..6).include?(col_index)

    next "<div class=\"col\"></div>" if (((qr_size / 2) - 4)..((qr_size / 2) + 4)).include?(row_index) && (((qr_size / 2) - 4)..((qr_size / 2) + 4)).include?(col_index)

    "<div class=\"col #{col ? 'filled' : ''} #{vertical_lines_info[row_index][col_index]}\"></div>"
  end.join

  "<div class=\"row\">#{row_html}</div>"
end.join

result = ERB.new(File.read("template.html.erb")).result(binding)
File.write("qr.html", result)
