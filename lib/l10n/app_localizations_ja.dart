// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'スマート充電＆バッテリーガーディアン';

  @override
  String get batteryLevel => 'バッテリー残量';

  @override
  String get batteryCharging => '充電中';

  @override
  String get batteryDischarging => '放電中';

  @override
  String get batteryFull => '満充電';

  @override
  String get batteryNotCharging => '充電していません';

  @override
  String get batteryUnknown => '不明';

  @override
  String get hyperCharging => '超急速充電';

  @override
  String get batteryFullCaps => '充電完了';

  @override
  String get dischargingCaps => '放電中';

  @override
  String get targetAlertLimit => '目標充電アラート上限';

  @override
  String get targetAlertSubtitle => 'この割合に達した時にアラームを鳴らします';

  @override
  String get chargingAlarm => '充電アラーム';

  @override
  String get chargingAlarmSubtitle => '目標パーセントに達した時にアラームを鳴らす';

  @override
  String get continuousAlarm => '連続アラーム';

  @override
  String get continuousAlarmSubtitle => '手動で停止するまで鳴らし続けます';

  @override
  String get lowBatteryAlert => '低残量アラート';

  @override
  String get lowBatteryAlertSubtitle => 'バッテリー低下時にアラームを鳴らす';

  @override
  String get lowBatteryWarning => '低バッテリー警告';

  @override
  String get guardianTitle => '盗難防止ガーディアン';

  @override
  String get guardianSubtitle => '充電器が抜かれた時に大音量サイレンを鳴らします';

  @override
  String get guardianArmed => 'ガーディアン警戒中';

  @override
  String get guardianDisarmed => 'ガーディアン解除中';

  @override
  String get guardianArmedStatus => '警戒中・安全保護';

  @override
  String get guardianDisarmedStatus => '解除済み / 待機中';

  @override
  String get armGuardian => 'ガーディアンを起動';

  @override
  String get disarmGuardian => 'ガーディアンを解除';

  @override
  String get guardianDescription => '警戒中に充電器が抜かれると、4桁のPINが入力されるまでサイレンが鳴り響きます。';

  @override
  String get guardianDisarmPrompt => '4桁のPINを入力してガーディアンを解除してください。';

  @override
  String get setPinTitle => 'セキュリティPIN設定';

  @override
  String get setPinPrompt => '盗難防止保護用の4桁のPINを作成してください。';

  @override
  String get confirmPin => 'セキュリティPIN確認';

  @override
  String get enterPin => '4桁のPINを入力';

  @override
  String get wrongPin => 'PINが違います。再試行してください。';

  @override
  String get pinsDoNotMatch => 'PINが一致しません';

  @override
  String get savePin => 'PINを保存';

  @override
  String get theftAlarmActive => '盗難アラーム発動！';

  @override
  String get alarmRinging => 'アラーム鳴動中！';

  @override
  String get theftAlarmSubtitle => '充電器が抜かれました！PINが必要です。';

  @override
  String get targetReachedSubtitle => '目標到達またはアラートが有効です';

  @override
  String get stop => '停止';

  @override
  String get disarm => '解除';

  @override
  String get temperature => '温度';

  @override
  String get voltage => '電圧';

  @override
  String get health => '状態';

  @override
  String get healthGood => '良好';

  @override
  String get plugged => '接続状況';

  @override
  String get pluggedAc => 'AC充電器';

  @override
  String get pluggedUsb => 'USBポート';

  @override
  String get pluggedWireless => 'ワイヤレス';

  @override
  String get pluggedNone => '未接続';

  @override
  String get technology => 'バッテリー技術';

  @override
  String get theme => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeSystem => 'システム標準';

  @override
  String get language => '言語';

  @override
  String get languageSelect => '言語を選択';

  @override
  String get chargeHistory => '充電履歴';

  @override
  String get noHistory => '履歴がありません';

  @override
  String get clearHistory => '履歴を消去';

  @override
  String get about => 'アプリについて';

  @override
  String get contribute => '開発者を支援';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get faq => 'よくある質問';

  @override
  String get shareApp => 'アプリをシェア';

  @override
  String get close => '閉じる';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get voltEnergized => '✨ 全システム正常に稼働中！';

  @override
  String get voltCharging => '⚡ エネルギー充電中！スムーズに給電中！';

  @override
  String get voltTargetReached => '🎉 目標到達！バッテリー寿命を守るため抜いてください！';

  @override
  String get voltLowBattery => '🪫 パワー低下中…充電してください！';

  @override
  String get voltOverheating => '🔥 熱くなっています！少し冷ましてください！';

  @override
  String get voltGuardianArmed => '🛡️ ガーディアン警戒中。抜くとサイレンが鳴ります！';

  @override
  String get voltTheftAlarm => '🚨 盗難アラート！アラームを止めてください！';

  @override
  String get quickFaqTitle => 'クイックFAQ';

  @override
  String get faqWhyNoAlarm => 'アラームが鳴らないのはなぜ？';

  @override
  String get faqWhyNoAlarmDesc => 'バックグラウンド実行、自動起動、通知音が許可されていることを確認してください。';

  @override
  String get faqBackgroundActivity => 'バックグラウンド実行';

  @override
  String get faqAutostart => '自動起動';

  @override
  String get faqNotifications => '通知設定';

  @override
  String get faqOemSettings => '自動起動の許可方法';

  @override
  String get faqOemSettingsDesc => 'メーカー（Xiaomi/OPPO/Vivo等）によって設定箇所が異なります。';

  @override
  String get replaySplashScreen => 'スプラッシュ画面を再再生';

  @override
  String get introWalkthrough => '紹介とチュートリアル';

  @override
  String get armedCaps => '警戒中';

  @override
  String get idleCaps => '待機中';

  @override
  String get guardianSirenWarning => 'プラグを抜くとサイレンが鳴り画面がロックされます';

  @override
  String get guardianUnplugWarning => '誰かがスマホを抜いた場合にアラームを鳴らす';

  @override
  String get protectedWithPin => '🔒 4桁のPINで保護されています';

  @override
  String get changePin => 'PINを変更';

  @override
  String get changeSecurityPin => 'セキュリティPINを変更';

  @override
  String get pinUpdatedSuccess => 'セキュリティPINが正常に更新されました！';

  @override
  String get runningWarm => 'やや高温';

  @override
  String get nominalTemp => '正常温度';

  @override
  String get operatingWell => '良好';

  @override
  String get powerSource => '電源';

  @override
  String get activeInput => '接続中';

  @override
  String get disconnected => '未接続';

  @override
  String get alertMeWhenReaches => 'バッテリーが次に達したら通知：';

  @override
  String get enableAlarmSound => 'アラーム音を有効にする';

  @override
  String get continuousAlarmDesc => '抜くか停止するまで鳴り続けます';

  @override
  String get lowBatteryAlertDesc => '放電中に目標値を下回ったときに警告';

  @override
  String get lowTarget => '低残量ターゲット';

  @override
  String get allowBackgroundActivity => 'バックグラウンド実行を許可';

  @override
  String get allowBackgroundActivityDesc => 'アプリのバッテリー設定を開く：制限なし/許可に設定';

  @override
  String get autostartStartup => '自動起動 / スタートアップ';

  @override
  String get autostartStartupDesc => '起動時の自動実行を許可するためOEM設定を開く';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationSettingsDesc => 'アラート音が許可されていることを確認';

  @override
  String get stopAlarmNow => '今すぐアラームを停止';

  @override
  String get testAlarmNow => '今すぐアラームをテスト';

  @override
  String get plugInChargerFirst => '⚠️ ガーディアンモードを設定する前に充電器を接続してください！';

  @override
  String get guardianArmedSnack => '🛡️ ガーディアンモード警戒中！プラグが抜かれると鳴ります。';

  @override
  String get guardianDisarmedSnack => 'ガーディアンモード解除。';

  @override
  String targetReached(int pct) {
    return '目標 $pct% に到達しました！';
  }

  @override
  String targetLabel(int pct) {
    return '目標：$pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '$pct% まで約 $mins 分';
  }

  @override
  String get aboutDesc => '設定した残量に達した時、および残量低下時に通知します。';

  @override
  String get keyFeatures => '主な機能：';

  @override
  String get readPrivacyPolicy => 'プライバシーポリシーを読む';

  @override
  String get contributeOnGitHub => 'GitHubで貢献する';

  @override
  String get couldNotOpenBrowser => 'ブラウザで開けませんでした';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get openInUpiApp => 'UPIアプリで開く';

  @override
  String get couldNotOpenUpi => 'UPIアプリを開けませんでした。QRをスキャンするか下部をコピーしてください。';

  @override
  String get upiIdCopied => 'UPI IDをコピーしました';

  @override
  String get upiIntentCopied => 'UPIインテントをコピーしました';

  @override
  String get privacyAssurance => '個人データは収集しません。アプリはお使いの端末上でローカルに動作します。';

  @override
  String get openTooltip => '開く';

  @override
  String get copyTooltip => 'コピー';

  @override
  String get scanToContribute => 'スキャンして支援';

  @override
  String get scanUsingUpi => 'UPIアプリまたはカメラでスキャン';

  @override
  String get voltAwake => '⚡ ボルトが目覚めました！バッテリーガーディアン準備完了！';

  @override
  String get voltCleanJuice => '⚡ クリーンな電力を充電中！バッテリーコアは快調です！';

  @override
  String get voltFastFlow => '🚀 急速充電を検出。もうすぐフル充電になります！';

  @override
  String get voltHealthTip => '💡 85%未満に維持することでバッテリー寿命が延びます！';

  @override
  String get voltPhoneCovered => '🛡️ ガーディアン警戒中！スマホは僕が見守っています！';

  @override
  String get voltUnplugWarning => '🚨 警告: 許可なく抜くと大音量サイレンが鳴ります！';

  @override
  String get voltAllHealthy => '✨ バッテリーセル、電圧、温度すべて完璧に健全です！';

  @override
  String get voltGreetingCompanion => '🤖 やあ！僕はボルト、君のバッテリーガーディアンだよ！';

  @override
  String get voltStandingBy => '💚 いつでもスタンバイしてハードウェアを見守っています！';

  @override
  String get meetVolt => 'ボルトの紹介';

  @override
  String get meetVoltDesc => 'スマートなバッテリー相棒。ボルトが端末を見守り、状態を知らせてくれます。';

  @override
  String get tapVoltToSayHi => '👆 ボルトをタップして挨拶してみよう！';
}
