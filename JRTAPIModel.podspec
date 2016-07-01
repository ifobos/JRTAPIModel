Pod::Spec.new do |s|
  s.name         = "JRTAPIModel"
  s.version      = "0.0.5"
  s.summary      = "JRTAPIModel is a model class that implements JSONModel and AFNetWorking."
  s.homepage     = "https://github.com/ifobos/JRTAPIModel"
  s.license      = "MIT"
  s.author       = { "ifobos" => "juancarlos.garcia.alfaro@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ifobos/JRTAPIModel.git", :tag => "0.0.5" }
  s.source_files = "JRTAPIModel/JRTAPIModel/PodFiles/*.{h,m}"
  s.requires_arc = true
  s.dependency 'JSONModel', '~> 1.2.0'
  s.dependency 'AFNetworking', '~> 3.1.0'
end
