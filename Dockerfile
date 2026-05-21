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
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle install --jobs 4 --retry 3 --without development test

COPY . ./

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Improved command with logging
CMD ["bash", "-c", "echo '=== Starting migrations ===' && bundle exec rails db:migrate 2>&1 && echo '=== Migrations completed successfully ===' && bundle exec puma -C config/puma.rb"]