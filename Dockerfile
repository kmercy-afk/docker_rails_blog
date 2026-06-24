FROM ruby:3.0.6

RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]