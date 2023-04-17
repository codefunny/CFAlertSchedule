Pod::Spec.new do |s|
  s.name     = 'CFAlertSchedule'
  s.version  = '1.0.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'CFAlertSchedule'
  s.homepage = 'https://githuya.com/codefunny/CFAlertSchedule.git'
  s.author   = { 'zhengwenchao' => 'zhengwenchao163@163.com' }
  s.source   = { :http => "@source@/#{s.name}.zip" }

  s.description = s.name

  s.source_files = 'Sources/**/*.{h,m}'
  s.public_header_files    = "Sources/**/*.{h}"
  s.vendored_framework     = "Library/#{s.name}.xcframework"
  s.vendored_libraries     = "Library/lib#{s.name}.a"
  s.prefix_header_file     = false
  s.requires_arc           = true

  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.deployment_target = '11.0'
end

