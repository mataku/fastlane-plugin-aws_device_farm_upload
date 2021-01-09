require 'fastlane/action'

module Fastlane
  module Actions
    class AwsDeviceFarmUploadAction < Action
      def self.run(params)
        file_path = params[:file_path]
        file_name = params[:file_name]
        file_type = params[:file_type]

        if (file_path.to_s.empty? || file_name.to_s.empty? || file_type.to_s.empty?)
          UI.user_error!("No file_path, file_name, file_type given. Specify them.")
        end

        access_key_id = params[:aws_access_key_id]
        secret_access_key = params[:aws_secret_access_key]

        project_arn = params[:device_farm_project_arn]
        
        require 'aws-sdk-devicefarm'
        device_farm_client = Aws::DeviceFarm::Client.new(
          region: 'us-west-2',
          credentials: Aws::Credentials.new(access_key_id, secret_access_key)
        )

        begin
          # Some files (e.g. ANDROID_APP) cannot be updated, so delete them first when uploading a file with the same name.
          delete_file(device_farm_client, project_arn, file_name, file_type)
          upload_file(device_farm_client, project_arn, file_name, file_path, file_type)
          UI.success('Successfully uploaded file to AWS Device Farm project')
        rescue => e
          UI.user_error!("#{e}")
        end
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
          FastlaneCore::ConfigItem.new(key: :aws_access_key_id,
                                       env_name: '',
                                       description: 'AWS Access Key ID',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :aws_secret_access_key,
                                       env_name: '',
                                       description: 'AWS Secret Access Key',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :device_farm_project_arn,
                                       env_name: '',
                                       description: 'The ARN of the project for the upload',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                       env_name: '',
                                       description: 'The upload\'s file name',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: '',
                                       description: 'Full path to the file. e.g. /home/user/app/build/outputs/universal_apk/debug/app-debug-universal.apk',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :file_type,
                                       env_name: '',
                                       description: 'Device Farm upload\'s upload type. e.g. ANDROID_APP, IOS_APP. See: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateUpload.html#API_CreateUpload_RequestSyntax',
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
