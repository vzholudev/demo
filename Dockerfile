FROM ruby:2.4 

MAINTAINER vzholudiev@gmail.com


RUN apt-get update && apt-get install -y \ 
  build-essential \ 
curl libssl-dev \
  git \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  mysql-client \
  nodejs

RUN mkdir -p /myapp 
WORKDIR /myapp

COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5


# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000
# Configure an entry point, so we don't need to specify 
# "bundle exec" for each of our commands.
#ENTRYPOINT ["bundle", "exec"]

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD [ "bundle", "exec","rails", "server", "-b", "0.0.0.0"]

