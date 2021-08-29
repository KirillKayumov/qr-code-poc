# Setup
```
bundle install --path .bundle
```

# Test in browser
```
ruby code.rb
open qr.html
```

# Save image
```
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --screenshot --window-size=418,522 --default-background-color=00000000 qr.html
open screenshot.png
```
