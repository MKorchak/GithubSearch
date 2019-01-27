target 'GithubSearch' do
  
  pod 'Alamofire'
  pod 'RxSwift', '4.2.0'
  pod 'RxCocoa', '4.2.0'
  pod 'RealmSwift', :modular_headers => true
  pod 'Realm', :modular_headers => true

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.1'
    end
  end
end
