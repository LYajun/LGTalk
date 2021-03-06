Pod::Spec.new do |s|

  s.name         = "LGTalk"
  s.version      = "1.2.3"
  s.summary      = "在线讨论"


  s.homepage     = "https://github.com/LYajun/LGTalk"
 

  s.license      = "MIT"
 
  s.author             = { "刘亚军" => "liuyajun1999@icloud.com" }
 

  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/LYajun/LGTalk.git", :tag => s.version }


  s.source_files  = "LGTalk/LGTalk.h","LGTalk/Enter/*.{h,m}","LGTalk/Module/**/*.{h,m}","LGTalk/Utils/Network/*.{h,m}","LGTalk/Common/**/*.{h,m}"

  s.subspec "Category" do |ss|
    ss.source_files =  "LGTalk/Category/*.{h,m}"
    ss.dependency "LGTalk/Const"
    ss.dependency "YJExtensions"
  end

  s.subspec "Const" do |ss|
    ss.source_files =  "LGTalk/Const/*.{h,m}"
  end

 s.subspec "Utils" do |ss|
    
    ss.subspec "ImagePickerController" do |sss|
      sss.source_files =  "LGTalk/Utils/ImagePickerController/*.{h,m}"
      sss.dependency 'LGAlertHUD'
    end

    ss.subspec "Photo" do |sss|
      sss.source_files =  "LGTalk/Utils/Photo/*.{h,m}"

      sss.dependency "LGTalk/Const"
      sss.dependency "LGTalk/Category"

      sss.dependency 'YJImageBrowser'
      sss.dependency 'Masonry'
    end

    ss.subspec "ActivityIndicatorView" do |sss|
      sss.source_files =  "LGTalk/Utils/ActivityIndicatorView/*.{h,m}"
    end

  end

  s.resources = "LGTalk/LGTalk.bundle"

  s.requires_arc = true

  s.dependency 'Masonry'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'
  s.dependency 'SDWebImage'
  s.dependency 'LGAlertHUD'
  s.dependency 'YJExtensions'
  s.dependency 'XMLDictionary'
  s.dependency 'YJNetManager'
  s.dependency 'YJPresentAnimation'
  s.dependency 'LGBundle/Bundle'
end
