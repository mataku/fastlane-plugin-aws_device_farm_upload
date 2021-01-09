describe Fastlane::Actions::AwsDeviceFarmUploadAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The aws_device_farm_upload plugin is working!")

      Fastlane::Actions::AwsDeviceFarmUploadAction.run(nil)
    end
  end
end
