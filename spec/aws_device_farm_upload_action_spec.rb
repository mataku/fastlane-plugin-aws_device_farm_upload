describe Fastlane::Actions::AwsDeviceFarmUploadAction do
  describe '#run' do
    context 'No params given' do
      it 'raises an error' do
        expect {
          Fastlane::Actions::AwsDeviceFarmUploadAction.run(
            {
              aws_access_key_id: 'aws_access_key_id',
              aws_secret_access_key: 'aws_secret_access_key'
            }
          )
        }.to raise_error
      end
    end
  end
end
