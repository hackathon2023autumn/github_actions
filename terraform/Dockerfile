FROM hashicorp/terraform:latest
# RUN wget https://releases.hashicorp.com/packer/1.9.1/packer_1.9.1_linux_amd64.zip
# RUN unzip packer_1.9.1_linux_amd64.zip
# RUN mv packer /usr/local/bin
WORKDIR /app

COPY . .

RUN chmod +x build_ph1.sh
RUN chmod +x destroy.sh
ENTRYPOINT ["/bin/sh", "-c"]
#CMD ["./terraform.sh && tail -f /dev/null"]
CMD ["tail -f /dev/null"]