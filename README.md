# Agora Flutter Web Remote Video Bug Repro

Minimal Flutter project demonstrating an issue with `agora_rtc_engine` on Web where the remote `<video>` element is not created correctly.

## Steps to Reproduce:

1. Replace `APP_ID`, `TEMP_TOKEN`, and `CHANNEL_NAME` in `main.dart`.
2. Run on Web:
   ```bash
   flutter run -d chrome
