Pod::Spec.new do |s|
  s.name          = 'ASJCollectionViewFillLayout'
  s.version       = '2.1'
  s.platform	    = :ios, '9.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/sdpjswl/ASJCollectionViewFillLayout'
  s.authors       = { 'Sudeep' => 'sdpjswl1@gmail.com' }
  s.summary       = 'A flow layout style UICollectionViewLayout that fills the full width of the collection view'
  s.source        = { :git => 'https://github.com/sdpjswl/ASJCollectionViewFillLayout.git', :tag => s.version }
  s.source_files  = 'ASJCollectionViewFillLayout/*.{h,m}'
  s.requires_arc  = true
end
