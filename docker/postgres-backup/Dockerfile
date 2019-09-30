FROM postgres:10.3
LABEL maintainer="Max Schmidt <ma@datapath.io>"

RUN apt-get update && apt-get install -y python python-pip
RUN pip install awscli

ENV POSTGRES_DB=""
ENV POSTGRES_USER=""
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_HOST=""
ENV ENVIRONMENT="local"

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""

ADD entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]