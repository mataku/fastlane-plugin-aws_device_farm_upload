# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/aws_device_farm_upload/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-aws_device_farm_upload'
  spec.version       = Fastlane::AwsDeviceFarmUpload::VERSION
  spec.author        = 'Takuma Homma'
  spec.email         = 'nagomimatcha@gmail.com'

  spec.summary       = 'Uploads specified file to AWS Device Farm project'
  spec.homepage      = "https://github.com/mataku/fastlane-plugin-aws_device_farm_upload"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane')
end
