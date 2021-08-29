require 'bundler/setup'
require 'rqrcode_core'
require 'pry'
require 'erb'

# qr = RQRCodeCore::QRCode.new("https://www.uula.com/backend/countries/1/schools/1/courses/1/quizzes/1/questions/1")
qr = RQRCodeCore::QRCode.new("https://www.uula.com")
qr_size = qr.modules.size

qr_modules = qr.modules.map.with_index do |row, row_index|
  row.map.with_index do |col, col_index|
    next false if (0..6).include?(row_index) && (0..6).include?(col_index)
    next false if (0..6).include?(row_index) && ((qr_size - 7)..(qr_size - 1)).include?(col_index)
    next false if ((qr_size - 7)..(qr_size - 1)).include?(row_index) && (0..6).include?(col_index)
    next false if (((qr_size / 2) - 4)..((qr_size / 2) + 4)).include?(row_index) && (((qr_size / 2) - 4)..((qr_size / 2) + 4)).include?(col_index)

    col
  end
end

vertical_lines_info = Array.new(qr_size).map { Array.new(qr_size) }

qr_modules.each.with_index do |row, row_index|
  row.each.with_index do |col, col_index|
    next unless col

    is_checked_above = row_index > 0 && qr_modules[row_index - 1][col_index]
    is_checked_below = row_index < qr_size - 1 && qr_modules[row_index + 1][col_index]

    vertical_lines_info[row_index][col_index] = if !is_checked_above && !is_checked_below
      :dot
    elsif !is_checked_above
      :line_head
    elsif !is_checked_below
      :line_tail
    end
  end
end

qr_html = qr_modules.map.with_index do |row, row_index|
  row_html = row.map.with_index do |col, col_index|
    "<div class=\"col #{col ? 'filled' : ''} #{vertical_lines_info[row_index][col_index]}\"></div>"
  end.join

  "<div class=\"row\">#{row_html}</div>"
end.join

result = ERB.new(File.read("template.html.erb")).result(binding)
File.write("qr.html", result)
