require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AwsDeviceFarmUploadHelper
      # class methods that you define here become available in your action
      # as `Helper::AwsDeviceFarmUploadHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the aws_device_farm_upload plugin helper!")
      end
    end
  end
end
