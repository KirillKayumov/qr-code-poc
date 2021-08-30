FROM ruby:2.7.4-alpine3.13

ARG RAILS_ENV=production

# Dependencies:
# tzdata – required by rails
# postgresql-client – required by pg gem
RUN apk add --no-cache \
    tzdata \
    postgresql-client \
    libcurl \
    less \
    openssh-server \
    openssh-server-pam \
    openssh-client \
    && mkdir /root/.ssh \
    && chmod 0600 /root/.ssh \
    && ssh-keygen -A \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
    && sed -i s/^#UsePAM\ no/UsePAM\ yes/ /etc/ssh/sshd_config \
    && sed -i s/^#ChallengeResponseAuthentication\ yes/ChallengeResponseAuthentication\ no/ /etc/ssh/sshd_config \
    && sed -i s/^#Port\ 22/Port\ 42943/ /etc/ssh/sshd_config

ENV BUNDLE_APP_CONFIG /app/vendor/bundle
ENV BUNDLE_PATH /app/vendor/bundle
ENV EXECJS_RUNTIME Disabled
ENV LANG en_US.UTF-8
ENV PORT 5000
ENV RUBYOPT "-W:no-experimental"
ENV RAILS_ENV $RAILS_ENV

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --path .bundle

RUN apk add chromium

COPY . .
RUN ruby code.rb
RUN /usr/bin/chromium-browser --no-sandbox --headless --screenshot --window-size=418,522 --default-background-color=00000000 qr.html
