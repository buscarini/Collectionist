#
# Be sure to run `pod lib lint Collectionist.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Collectionist"
  s.version          = "0.1.0"
  s.summary          = "View Model based data sources for UITableView and UICollectionView."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
View Model based data sources for UITableView and UICollectionView. 
                       DESC

  s.homepage         = "https://github.com/buscarini/Collectionist"
  s.license          = 'MIT'
  s.author           = { "José Manuel" => "buscarini@gmail.com" }
  s.source           = { :git => "https://github.com/buscarini/Collectionist.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Collectionist/Classes/**/*'
  
end
