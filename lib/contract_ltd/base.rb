Shrimp.configure do |config|
  config.format = 'A4'
  config.margin = '1cm'
  config.zoom = 1
  config.orientation = 'portrait'
  config.rendering_time = 1000
  config.rendering_timeout = 20000
end

I18n.load_path << "#{File.dirname(__FILE__)}/en.yml"
I18n.t('date.formats').each do |key, value|
  Date::DATE_FORMATS[key] = value
end

def write_pdf(template)
  html = Slim::Template.new(template.name('slim')).render(template)
  File.write(template.name('html'), html)
  phantom = Shrimp::Phantom.new("file:///#{Dir.pwd}/#{template.name('html')}")
  phantom.to_pdf(template.filename)
  FileUtils.rm_f(template.name('html'))
end

