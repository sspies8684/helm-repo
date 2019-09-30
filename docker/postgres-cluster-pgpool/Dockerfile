FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y install pgpool2 curl && \
    rm -rf /var/lib/apt/lists/*

COPY start-attach-dead-nodes-cronjob.sh /
RUN chmod +x /start-attach-dead-nodes-cronjob.sh
COPY crontab /etc/cron.d/pgpool-maintenance
RUN chmod 0644 /etc/cron.d/pgpool-maintenance
RUN crontab /etc/cron.d/pgpool-maintenance

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT [ "/start.sh" ]

EXPOSE 5432
CMD ["pgpool", "-n"]