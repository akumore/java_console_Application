PDFKit.configure do |config|
  if RUBY_PLATFORM =~ /darwin/
    config.wkhtmltopdf = Rails.root.join('vendor/wkhtmltopdf/bin/wkhtmltopdf.app/Contents/MacOS/wkhtmltopdf').to_s
  else
    config.wkhtmltopdf = Rails.root.join('vendor/wkhtmltopdf/bin/wkhtmltopdf-amd64').to_s
  end

  config.default_options = {
    page_size: 'A4',
    dpi: 300, # Seem not to have any effect
    margin_top: 10,
    margin_left: 10,
    margin_right: 10,
    margin_bottom: 15,
    print_media_type: true
  }
end
