FROM ruby:3.0

RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
    git \
    curl \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev

RUN npm install -g yarn

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler

# IMPORTANT: isolate errors clearly
RUN bundle install --verbose

COPY . /app

CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p $PORT"]