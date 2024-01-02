Pod::Spec.new do |s|
  s.name = 'SwiftRuleEngine'
  s.version = '1.4.0'
  s.license = 'MIT'
  s.summary = 'A rule engine written in Swift where rules are defined in JSON format'
  s.homepage = 'https://github.com/santalvarez/swift-rule-engine'
  s.authors = { 'Santiago Alvarez' => 'santiagoalvarez264@gmail.com' }
  s.source = { :git => 'https://github.com/santalvarez/swift-rule-engine.git', :tag => s.version }

  s.osx.deployment_target = '10.15'

  s.swift_versions = ['5']

  s.source_files = 'Source/**/*'
end
