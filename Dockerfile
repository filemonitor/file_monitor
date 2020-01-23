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

#
# Build Connect Web Container.
#
FROM ruby:2.6.2

# Copy application code
COPY . /application
# Change to the application's directory
WORKDIR /application

# Install gems
RUN bundle install --deployment --without development test --jobs 4 --retry 5

# Set Rails environment to production
ENV RAILS_ENV production

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
# RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo
# RUN rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
# RUN yarn install --check-files

RUN apt-get install sshpass


# Compile the assets TODO
#RUN bundle exec rake assets:precompile
CMD ["bin/puma"]
EXPOSE 3000

