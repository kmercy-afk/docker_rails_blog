FROM ruby:3.2

# Install system dependencies required for Rails + native gems
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
    git \
    curl

# Install Yarn (important for Rails asset pipeline in many apps)
RUN npm install -g yarn

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Upgrade bundler to avoid version mismatch
RUN gem install bundler

# Install gems
RUN bundle install

COPY . /app

# IMPORTANT: Render requires dynamic port
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p $PORT"]