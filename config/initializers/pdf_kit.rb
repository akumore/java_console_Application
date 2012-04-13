PDFKit.configure do |config|
  if RUBY_PLATFORM =~ /darwin/
    config.wkhtmltopdf = Rails.root.join('vendor/wkhtmltopdf/bin/wkhtmltopdf.app/Contents/MacOS/wkhtmltopdf').to_s
  else
    config.wkhtmltopdf = Rails.root.join('vendor/wkhtmltopdf/bin/wkhtmltopdf-amd64').to_s
  end

  config.default_options = {
    :page_size     => 'A4'
  }
end