FROM ruby:3.0.6

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  postgresql-client

RUN npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]