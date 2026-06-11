FROM ruby:3.0.7-bullseye

RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client

RUN npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --ignore-engines

COPY . .

RUN RAILS_ENV=production DISABLE_SPRING=1 RUBYOPT='-rlogger' bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "DISABLE_SPRING=1 RUBYOPT='-rlogger' bundle exec rails db:migrate && DISABLE_SPRING=1 RUBYOPT='-rlogger' bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]