Pod::Spec.new do |spec|
  spec.name                     = "ReduxKit"
  spec.version                  = "0.0.1"
  spec.summary                  = "A short description of ReduxKit."
  spec.description              = "A complete description of ReduxKit."
  spec.homepage                 = "https://github.com/BARETFabrice/ReduxKit"
  spec.license                  = "MIT"
  spec.author                   = { "Baretfabrice" => "baretfabrice974@gmail.com" }
  spec.ios.deployment_target    = "5.0"
  spec.osx.deployment_target    = "10.7"
  spec.source                   = { :git => "https://github.com/BARETFabrice/ReduxKit.git", :tag => "#{spec.version}" }
  spec.source_files             = "ReduxKit/*swift"
end
