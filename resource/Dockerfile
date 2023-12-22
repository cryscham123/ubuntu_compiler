FROM ubuntu

RUN \
apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
g++ \
&& apt-get clean

COPY tools/* /usr/bin/

CMD ["run.sh"]
