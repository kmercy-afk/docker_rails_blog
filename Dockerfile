FROM ruby:3.2

# System dependencies (critical for pg, nokogiri, etc.)
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    libpq-dev \
    build-essential \
    git \
    curl \
    libyaml-dev \
    libxml2-dev \
    libxslt1-dev

# Install Yarn (Rails asset support)
RUN npm install -g yarn

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Upgrade bundler explicitly
RUN gem install bundler

# Install gems with clean output for debugging
RUN bundle install --jobs 4 --retry 3

COPY . /app

# Render uses dynamic PORT
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p $PORT"]