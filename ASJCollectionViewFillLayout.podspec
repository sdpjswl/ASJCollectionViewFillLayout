Pod::Spec.new do |s|
  s.name         = 'ASJCollectionViewFillLayout'
  s.version      = '0.0.1'
  s.platform	 = :ios, '7.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/sudeepjaiswal/ASJCollectionViewFillLayout'
  s.authors      = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary      = 'A flow layout style UICollectionViewLayout that fills the full width of the collection view'
  s.source       = { :git => 'https://github.com/sudeepjaiswal/ASJCollectionViewFillLayout', :tag => '0.0.1' }
  s.source_files = 'ASJCollectionViewFillLayout/ASJCollectionViewFillLayout.{h,m}'
  s.requires_arc = true
end