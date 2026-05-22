FROM ruby:3.0

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

WORKDIR /app

# Copy gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle install --jobs 4 --retry 3 --without development test

# Copy app code
COPY . ./

# Production environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Precompile assets
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Start command with debug info
CMD ["bash", "-c", "echo '=== ENVIRONMENT CHECK ===' && echo 'DATABASE_URL:' && echo ${DATABASE_URL:0:100}... && echo '=== Running migrations ===' && bundle exec rails db:migrate 2>&1 && echo '=== Migrations completed ===' && bundle exec puma -C config/puma.rb"]