# Build the container
#
#   docker build . -t file-monitor
#
# Run container
#
#  Start Web Server:
#   docker run -it --rm -p 127.0.0.1:3000:3000 --env-file config/local.env file-monitor
#
#  Start Rocket Job:
#   docker run -it --rm  --env-file config/local.env file-monitor bin/rocketjob

#  Run some load: # TODO figure out healthcheck
#    ab -n 100 -c 3 127.0.0.1:3000/inquiries/health_check
#
#  Start a shell:
#   docker run -it --rm --env-file config/local.env file-monitor bash
#
#  Start a console:
#   docker run -it --rm --env-file config/local.env file-monitor bin/rails c
#
# Kill running container
#   docker ps
#   docker kill `container_id`
#
# Debug partial build
#   docker images
#   docker run -it --rm `image_id` bash
#
# To cleanup local partial and untagged builds.
#   docker system prune -f
#

FROM ruby:2.6.2

# The best practice is to put commands together to avoid the layers within the image
# and decrease the image size, but it my case image size stayed the same.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install sshpass && \
    gem install bundler

RUN mkdir /application

# Note that installing OS-specific tools and copying only Gemfile and Gemfile.lock
# to app folder before running bundle install has tremendous advantage. Changes to the other
# files within the application folder do not trigger bundle install.
# Only if the Gemfile or Gemfile.lock changes, bundle install will be triggered.
# from https://auth0.com/blog/ruby-on-rails-killer-workflow-with-docker-part-1/

COPY Gemfile Gemfile.lock /application/

# Change to the application's directory
WORKDIR /application

# Install gems
RUN bundle install --deployment --without development test --jobs 4 --retry 5

# Copy application code
COPY . /application

# Set Rails environment to production
ENV RAILS_ENV production

# Compile the assets TODO
#RUN bundle exec rake assets:precompile
CMD ["bin/puma"]
EXPOSE 3000

