FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

WORKDIR /app

# Copy gem files first
COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle install --jobs 4 --retry 3 --without development test

# Copy application code
COPY . ./

# Production settings
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Precompile assets
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Run migrations + start server with detailed logging
CMD ["bash", "-c", "echo '=== Running database migrations ===' && bundle exec rails db:migrate 2>&1 && echo '=== Migrations completed ===' && echo '=== Starting Puma server ===' && bundle exec puma -C config/puma.rb"]