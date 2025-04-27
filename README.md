# Agora Flutter Web Remote Video Bug Repro

Minimal Flutter project demonstrating an issue with `agora_rtc_engine` on Web where the remote `<video>` element is not created correctly.

## Steps to Reproduce:

1. Replace `APP_ID`, `TEMP_TOKEN`, and `CHANNEL_NAME` in `main.dart`.
2. Run on Web:
   ```bash
   flutter run -d chrome
3.	Join the same channel from another device (mobile or another browser).
4.	Observe:
- Local video renders properly (with <video> in DOM).
- Remote audio works.
- Remote video does NOT appear and no <video> element is added to DOM.

Versions:
- Flutter: 3.29.3
- agora_rtc_engine: 6.5.1
