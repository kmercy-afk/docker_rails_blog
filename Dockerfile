FROM ruby:3.0

# Install system dependencies
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

# Install Yarn
RUN npm install -g yarn

WORKDIR /app

# Copy Gemfile first for better layer caching
COPY Gemfile Gemfile.lock ./

# Install Bundler and Ruby gems
RUN gem install bundler --no-document
RUN bundle install --jobs 4 --retry 3 --without development test

# Copy the rest of the application
COPY . ./

# Production environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Precompile assets with a dummy secret key (important for free tier Render)
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Final command: Run migrations then start the server
CMD ["bash", "-c", "bundle exec rails db:migrate && bundle exec puma -C config/puma.rb"]