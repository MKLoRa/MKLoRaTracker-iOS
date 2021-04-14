#
# Be sure to run `pod lib lint MKLoRaTracker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaTracker'
  s.version          = '1.0.0'
  s.summary          = 'A short description of MKLoRaTracker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MKLoRa/MKLoRaTracker-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MKLoRa/MKLoRaTracker-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKLoRaTracker' => ['MKLoRaTracker/Assets/*.png']
  }
  
  s.subspec 'ApplicationModule' do |ss|
    ss.source_files = 'MKLoRaTracker/Classes/ApplicationModule/**'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaTracker/Classes/CTMediator/**'
    
    ss.dependency 'CTMediator'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CustomCell' do |ss|
    ss.subspec 'MKLTNormalTextCell' do |sss|
      sss.source_files = 'MKLoRaTracker/Classes/CustomCell/MKLTNormalTextCell/**'
    end
    ss.subspec 'MKLTGPSReportInterval' do |sss|
      sss.source_files = 'MKLoRaTracker/Classes/CustomCell/MKLTGPSReportInterval/**'
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaTracker/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaTracker/Classes/Target/**'
    ss.dependency 'MKLoRaTracker/Functions'
  end
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaTracker/Classes/ConnectModule/**'
    
    ss.dependency 'MKLoRaTracker/SDK'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AdvertiserPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AdvertiserPage/Controller/**'
        
        ssss.dependency 'MKLoRaTracker/Functions/AdvertiserPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AdvertiserPage/Model/**'
      end
    end
    
    ss.subspec 'AxisPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AxisPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/AxisPage/Model'
        ssss.dependency 'MKLoRaTracker/Functions/AxisPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AxisPage/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/AxisPage/Model/**'
      end
    end
    
    ss.subspec 'DevicePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/DevicePage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/DevicePage/Model'
        ssss.dependency 'MKLoRaTracker/Functions/DevicePage/View'
        
        ssss.dependency 'MKLoRaTracker/Functions/UpdatePage'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/DevicePage/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/DevicePage/Model/**'
      end
    end
    
    ss.subspec 'FilterCondition' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/FilterCondition/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/FilterCondition/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/FilterCondition/Model/**'
      end
    end
    
    ss.subspec 'FilterOptions' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/FilterOptions/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/FilterOptions/Model'
        ssss.dependency 'MKLoRaTracker/Functions/FilterOptions/View'
        
        ssss.dependency 'MKLoRaTracker/Functions/FilterCondition'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/FilterOptions/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/FilterOptions/Model/**'
      end
    end
    
    ss.subspec 'GPSPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/GPSPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/GPSPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/GPSPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/LoRaPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/LoRaPage/Model'
        
        ssss.dependency 'MKLoRaTracker/Functions/LoRaSettingPage'
        ssss.dependency 'MKLoRaTracker/Functions/NetworkCheck'
        ssss.dependency 'MKLoRaTracker/Functions/PayloadPage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/LoRaPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/LoRaSettingPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/LoRaSettingPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/LoRaSettingPage/Model/**'
      end
    end
    
    ss.subspec 'NetworkCheck' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/NetworkCheck/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/NetworkCheck/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/NetworkCheck/Model/**'
      end
    end
    
    ss.subspec 'PayloadPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/PayloadPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/PayloadPage/Model'
        ssss.dependency 'MKLoRaTracker/Functions/PayloadPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/PayloadPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/PayloadPage/View/**'
      end
    end
    
    ss.subspec 'Scanner' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/Scanner/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/Scanner/Model'
        ssss.dependency 'MKLoRaTracker/Functions/Scanner/View'
        
        ssss.dependency 'MKLoRaTracker/Functions/FilterOptions'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/Scanner/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/Scanner/Model/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/ScanPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/ScanPage/Model'
        ssss.dependency 'MKLoRaTracker/Functions/ScanPage/View'
        
        ssss.dependency 'MKLoRaTracker/Functions/TabBarPage'
        ssss.dependency 'MKLoRaTracker/Functions/AboutPage'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKLoRaTracker/Functions/ScanPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/ScanPage/Model/**'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/SettingPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/SettingPage/Model'
        
        ssss.dependency 'MKLoRaTracker/Functions/AdvertiserPage'
        ssss.dependency 'MKLoRaTracker/Functions/VibrationSetting'
        ssss.dependency 'MKLoRaTracker/Functions/SOSPage'
        ssss.dependency 'MKLoRaTracker/Functions/GPSPage'
        ssss.dependency 'MKLoRaTracker/Functions/AxisPage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/SettingPage/Model/**'
      end
    end
    
    ss.subspec 'SOSPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/SOSPage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/SOSPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/SOSPage/Model/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKLoRaTracker/Functions/LoRaPage'
        ssss.dependency 'MKLoRaTracker/Functions/Scanner'
        ssss.dependency 'MKLoRaTracker/Functions/SettingPage'
        ssss.dependency 'MKLoRaTracker/Functions/DevicePage'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/UpdatePage/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/UpdatePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.subspec 'VibrationSetting' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/VibrationSetting/Controller/**'
        ssss.dependency 'MKLoRaTracker/Functions/VibrationSetting/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaTracker/Classes/Functions/VibrationSetting/Model/**'
      end
    end
  
    ss.dependency 'MKLoRaTracker/SDK'
    ss.dependency 'MKLoRaTracker/CustomCell'
    ss.dependency 'MKLoRaTracker/CTMediator'
    ss.dependency 'MKLoRaTracker/ConnectModule'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary','4.6.1'
  
  end
  
end
