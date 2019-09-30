FROM postgres:10.3

RUN apt-get update && \
    apt-get -y install rsync && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT [ "/start.sh" ]

EXPOSE 5432
CMD ["postgres"]