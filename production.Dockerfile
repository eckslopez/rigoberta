# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.10

FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH="/usr/local/bundle"


# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
# This example intentionally does not require or install node.js

RUN --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    libyaml-dev \
    libpq-dev \
    zlib1g-dev

RUN gem update --system 4.0.5 && gem install bundler -v 4.0.5

# Install application gems
COPY Gemfile Gemfile.lock ./

# TODO: consolidate bundle config better, currently split between ENV and `bundle config`
RUN bundle config set --local frozen true \
 && bundle config set --local jobs 4 \
 && bundle config set --local deployment true \
 && bundle config set --local without 'development test' \
 && bundle install \
 && bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && apt-get upgrade -yq \
  && apt-get install -yq --no-install-recommends \
  libpq-dev

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Remove vulnerable default gemspecs superseded by patched versions in the
# application bundle.
RUN ruby -e '%w[erb-4.0.3 net-imap-0.4.21 zlib-3.1.1].each { |gem| [Gem.default_specifications_dir, File.join(Gem.default_dir, "specifications")].each { |dir| path = File.join(dir, "#{gem}.gemspec"); File.delete(path) if File.exist?(path) } }'

# Run and own only the runtime files as a non-root user for security
RUN mkdir -p tmp/pids tmp/cache tmp/prometheus_metrics log storage && \
    useradd rails --home /rails --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# TODO: migrate/consolidate to have all database migrations in here
# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

#ARG DATABASE_URL
#ARG SECRET_KEY_BASE

# Start Server
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
