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

# Run in Docker
```
docker build . -t qrcode

# in terminal #1
docker run -it qrcode sh

# in terminal #2
docker container ls
docker cp 2103e3a513bf:/app/screenshot.png ./docker_qr.png
```
