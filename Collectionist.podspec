#
# Be sure to run `pod lib lint Collectionist.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Collectionist"
  s.version          = "0.1.4"
  s.summary          = "View Model based data sources for UITableView and UICollectionView."

  s.description      = <<-DESC
View Model based data sources for UITableView and UICollectionView.

Uses views instead of cells, which allows to reuse the same view for a table, a collection or insert it in a regular view hierarchy. 

                       DESC

  s.homepage         = "https://github.com/buscarini/Collectionist"
  s.license          = 'MIT'
  s.author           = { "José Manuel" => "buscarini@gmail.com" }
  s.source           = { :git => "https://github.com/buscarini/Collectionist.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Collectionist/Classes/**/*'

  s.dependency 'Layitout'
  s.dependency 'Miscel'

end
