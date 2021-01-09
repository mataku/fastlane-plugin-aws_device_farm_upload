require 'fastlane/action'
require_relative '../helper/aws_device_farm_upload_helper'

module Fastlane
  module Actions
    class AwsDeviceFarmUploadAction < Action
      def self.run(params)

        file_path = params[:file_path]
        file_name = params[:file_name]
        file_type = params[:file_type]

        access_key_id = params[:aws_access_key_id]
        secret_access_key = params[:aws_secret_access_key]

        project_arn = params[:device_farm_project_arn]
        
        require 'aws-device-farm'
        device_farm_client = Aws::DeviceFarm::Client.new(
          region: 'us-west-2',
          credentials: Aws::Credentials.new(access_key_id, secret_access_key)
        )

        # Some files cannot update, so delete first when uploads file with same name.
        delete_file(device_farm_client, project_arn, file_name, file_type)
        upload_file(device_farm_client, project_arn, file_name, file_path, file_type)
      end

      def self.delete_file(device_farm_client, project_arn, file_name, file_type)
        uploaded_list = device_farm_client.list_uploads({
          arn: project_arn,
          type: file_type
        })
        uploaded_file = uploaded_list.uploads.find do |upload|
          upload.name == file_name && upload.status == 'SUCCEEDED'
        end

        unless uploaded_file.nil?
          devicefarm_client.delete_upload({
            arn: uploaded_file.arn
          })
        end
      end

      def self.upload_file(device_farm_client, project_arn, file_name, file_path, file_type)
        params = {
          project_arn: project_arn,
          name: file_name,
          type: file_type,
          content_type: 'application/octet-stream'
        }

        create_request_response = device_farm_client.create_upload(params)
        url = URI.parse(create_request_response.upload.url)
        target = File.open(file_path, 'rb').read

        response = Net::HTTP.start(url.host) do |http|
          http.send_request('PUT', url.request_uri, target, {'content-type' => 'application/octet-stream'})
        end
      end

      def self.description
        "Uploads specified file to AWS Device Farm project"
      end

      def self.authors
        ["Takuma Homma"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Uploads specified file to AWS Device Farm project"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "AWS_DEVICE_FARM_UPLOAD_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
