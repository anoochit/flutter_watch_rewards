# Watch Rewards

A customizable Flutter widget that displays a circular progress indicator
with rewards functionality.

This widget shows a circular progress indicator that fills up over time,
and displays a reward value that increases at specified intervals.

## Example

Here's an example of how to use WatchRewards:

```dart
WatchRewards(
  radius: 32.0,
  foregroundColor: Colors.blue,
  backgroundColor: Colors.grey,
  buttonColorBegin: Colors.blue,
  buttonColorEnd: Colors.lightBlue,
  buttonTitle: 'Claim',
  value: 100.0,
  stepValue: 10.0,
  watchInteval: 5,
  icon: Icon(Icons.star),
  onValueChanged: (value) => print('New value: $value'),
  onTap: () => print('Button tapped'),
)
```

## Screenshot

<img src="https://raw.githubusercontent.com/anoochit/flutter_watch_rewards/master/screenshots/screenshot.gif" width="320">
