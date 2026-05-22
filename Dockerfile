FROM ruby:3.0

RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
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

# Force migration with better error handling
CMD ["bash", "-c", "set -e; echo '=== Starting App ==='; echo 'Running db:migrate...'; bundle exec rails db:migrate; echo 'Migrations completed successfully!'; exec bundle exec puma -C config/puma.rb"]