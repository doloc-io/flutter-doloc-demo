# Demo for using doloc.io with flutter

This is a simple demo for using [doloc.io](https://doloc.io) with Flutter.

It is recommended to follow our dedicated guide for [Flutter](https://doloc.io/getting-started/frameworks/flutter/) to get started.

## Pre-requisites

To update the translations, you need to set the `API_TOKEN` environment variable to your doloc.io API token.
You can get a free API token by signing up at [doloc.io](https://doloc.io/account).

```bash
export API_TOKEN=YOUR_API_TOKEN
```

## Running the demo

This demo can be run on an emulator or a physical device.

The easiest way to run the demo is to use the `flutter run` command:

```bash
flutter run -d chrome
```

Generally, the Flutter runtime selects the language based on the device's language settings.
For testing different locales, please refer to [Flutter Localization Testing](https://docs.flutter.dev/development/accessibility-and-localization/internationalization#testing).
When running the app in Chrome, you can override the locale in the DevTools "Sensors" tab.

## Adding translations

You can add new strings manually to `lib/l10n/app_en.arb` or use the Flutter localization tools.
If you use the integrated tools, make sure to _not_ add the new string resource to translated files (`lib/l10n/app_de.arb`).

An example could be:

```json
{
  "your_id": "some new string"
}
```

After adding the new message, you need to run doloc to translate and add it to the translated files.
There are two alternative ways to do that:

- Local workflow
- CI workflow

### Local workflow

Run the following command to extract the new message:

```bash
export API_TOKEN=YOUR_API_TOKEN
dart run tool/doloc.dart
```

Observe that the new message is added to `lib/l10n/app_de.arb` and already translated!

### CI workflow

If you are using the CI workflow, you can simply push your changes to the repository.
Check out the workflow definition in `.github/workflows/localization.yml` to see how the translations are updated.

When your change is merged into the main branch, the translations will be updated automatically and a new commit will be created with the updated translations.

**Note:** This workflow expects the `DOLOC_API_TOKEN` to be set as a [secret](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions) in your repository.
