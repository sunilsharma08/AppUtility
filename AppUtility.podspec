Pod::Spec.new do |s|
  s.name         = "AppUtility"
  s.version      = "0.1.0"
  s.summary      = "A collection of useful methods that we need in almost all projects"
  s.description  = "AppUtility is a library which contains small code snippets that we need in almost every project like converting color hex to rgb, checking internet connectivity, etc."
  s.homepage     = "https://github.com/sunilsharma08/AppUtility"
  s.license      = "MIT"
  s.author             = { "Sunil Sharma" => "sunilsharma.ss08@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/sunilsharma08/AppUtility.git", :commit => "fa2643d3f523ee240b0a7aa4d7be7aa0ca9065d6" }
  s.source_files  = "AppUtility", "AppUtility/**/*.{h,m,swift}"

end
