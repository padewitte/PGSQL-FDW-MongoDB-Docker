# vim:set ft=dockerfile:
FROM ubuntu:trusty

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r postgres && useradd -r -g postgres postgres
# grab gosu for easy step-down from root
# Adding ca-certificates git & make
RUN apt-get update && apt-get install -y curl libossp-uuid-dev wget ca-certificates git make && rm -rf /var/lib/apt/lists/* \
&& curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
&& chmod +x /usr/local/bin/gosu \
&& apt-get purge -y --auto-remove curl
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
ENV PG_MAJOR 9.3
ENV PG_VERSION 9.3.5-1
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update \
&& apt-get install -y postgresql-common \
&& sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && apt-get install -y postgresql-$PG_MAJOR postgresql-contrib-$PG_MAJOR postgresql-server-dev-$PG_MAJOR && rm -rf /var/lib/apt/lists/* && mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

#Compiling & Installing MongoDB Forwarder module
RUN mkdir -p /home/root && cd /home/root && git clone https://github.com/citusdata/mongo_fdw.git && cd /home/root/mongo_fdw/ && make install

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]




