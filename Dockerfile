FROM ruby:2.6.2

# Copy application code
COPY . /application
# Change to the application's directory
WORKDIR /application

# Install gems
RUN bundle install --deployment --without development test

# Set Rails environment to production
# TODO ask Reid about it
ENV RAILS_ENV production

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs

# Start the application server
ENTRYPOINT ./entrypoint.sh

