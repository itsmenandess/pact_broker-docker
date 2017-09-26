# ubuntu:14.04 -- https://hub.docker.com/_/ubuntu/
# |==> phusion/baseimage:0.9.17 -- https://goo.gl/ZLt61q
#      |==> phusion/passenger-ruby22:0.9.17 -- https://goo.gl/xsnWOP
#           |==> HERE
#FROM phusion/passenger-ruby22:0.9.17

FROM zlp11313.vci.att.com:5100/com.att.dockercentral.public/phusion/passenger-ruby22:0.9.20

EXPOSE 80
ENV APP_HOME=/home/app/pact_broker
CMD ["/sbin/my_init"]
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD container /

ADD pact_broker/config.ru $APP_HOME/
ADD pact_broker/Gemfile $APP_HOME/
ADD pact_broker/Gemfile.lock $APP_HOME/
RUN chown -R app:app $APP_HOME

# Update system gems for:
# https://www.ruby-lang.org/en/news/2017/08/29/multiple-vulnerabilities-in-rubygems/
RUN gem update --http-proxy=http://one.proxy.att.com:8080 --system
RUN gem install  --http-proxy=http://one.proxy.att.com:8080 bundler
#RUN su app -c "cd $APP_HOME && bundle install --deployment --without='development test'"
RUN su -c "cd $APP_HOME && https_proxy=https://one.proxy.att.com:8080 http_proxy=http://one.proxy.att.com:8080 bundle install --deployment --without='development test'"
#RUN bundle install
ADD pact_broker/ $APP_HOME/
RUN chown -R app:app $APP_HOME



