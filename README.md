# aws_device_farm_upload plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-aws_device_farm_upload)

## About aws_device_farm_upload

Uploads a specified file like IPA, APK to AWS Device Farm project.

For example, use to manage app in Device Farm remote access sessions.

## Getting Started

1. Generate IAM user with policy which grants access to below.

    - devicefarm:CreateUpload
    - devicefarm:DeleteUpload
    - devicefarm:GetProject
    - devicefarm:ListUploads


    If a file with the specified name exists in the project, it will be overwritten.

    Because some upload types like `ANDROID_APP` cannot use `devicefarm:UpdateUpload` to update, it needs to do the create action after the delete action to update. Therefore, it requires `devicefarm:CreateUpload` and `devicefarm:DeleteUpload` permissions instead of `devicefarm:UpdateUpload`.

2. Add plugin to fastlane

```shell
bundle exec fastlane add_plugin aws_device_farm_upload
```

3. Add `aws_device_farm_upload` action to your lane in `Fastfile`.

```ruby
lane :upload_apk_to_device_farm do
  aws_device_farm_upload(
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    device_farm_project_arn: ENV['DEVICE_FARM_PROJECT_ARN'],
    file_path: '/home/mataku/app/build/outputs/universal_apk/debug/app-debug-universal.apk',
    file_name: 'android-app-debug.apk',
    file_type: 'ANDROID_APP' # See: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateUpload.html#API_CreateUpload_RequestSyntax
  )
end
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
