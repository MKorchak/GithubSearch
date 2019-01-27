# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GithubSearch' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
#   use_frameworks!

  pod 'Alamofire'
  pod 'RxSwift', '4.2.0'
  pod 'RxCocoa', '4.2.0'
#  pod 'RealmSwift' 
  pod 'RealmSwift', :modular_headers => true
  pod 'Realm', :modular_headers => true

  
#  pod 'RealmSwift', :modular_headers => true
#  pod 'Realm', :modular_headers => true
#  pod 'Alamofire'
#  pod 'RxSwift'#, :modular_headers => true
##  pod 'RxAtomic', :modular_headers => false
#  pod 'RxCocoa'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.1'
    end
  end
end
