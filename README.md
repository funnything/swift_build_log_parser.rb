`swift_build_log_parser.rb`
======
**`swift_build_log_parser.rb`** is a script for parse xctool build-log to analyze swift source compile time. The usage is explained like this:

First, Add `-Xfrontend -debug-time-function-bodies` to `Other Swift Flags`

```
$ xctool -workspace './xyz.xcworkspace' -scheme 'SchemeName' -jobs 1 clean build | tee build_in_detail.txt
...

$ cat build_in_detail.txt | perl -pe 's/\x1b.*?[mGKH]//g' | ruby swift_build_log_parser.rb
...

=== File ===
  8294ms SomeView
  6729ms MainViewController
  6513ms MainViewController
  5469ms SomeView
  1067ms Fridge
  1051ms Fridge
   922ms AppDelegate
   914ms API
   869ms API
   609ms OneModel
...
...

=== Method ===
  5932.1ms SomeView.swift:98:10 func currentPosition(model: OneModel) -> CGPoint
  4896.7ms SomeView.swift:98:10 func currentPosition(model: OneModel) -> CGPoint
  3924.1ms MainViewController.swift:280:10 @objc func syncWithRemote(state: Int)
  3921.6ms MainViewController.swift:286:79 (closure)
  3911.8ms MainViewController.swift:326:56 (closure)
  3713.8ms MainViewController.swift:280:10 @objc func syncWithRemote(state: Int)
  3712.0ms MainViewController.swift:286:79 (closure)
  3705.3ms MainViewController.swift:326:56 (closure)
  1560.1ms MainViewController.swift:207:10 @objc func bindDynamically(isInit: Bool)
  1491.9ms MainViewController.swift:207:10 @objc func bindDynamically(isInit: Bool)
...
...

=== Build time ===
414618 ms
```
:clap:
