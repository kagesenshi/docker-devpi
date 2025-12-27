FROM python:3
RUN pip install "devpi-server==6.17" "devpi-client==7.2.0"
VOLUME /mnt
EXPOSE 3141
ADD run.sh /
CMD ["/run.sh"]
