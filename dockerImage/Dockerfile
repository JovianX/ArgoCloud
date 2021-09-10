FROM argoproj/argocd
USER root
RUN apt-get update && apt-get install -y curl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /home/argocd/kubectl && mv /home/argocd/kubectl /usr/local/bin/
ADD setup.sh /myscript/
RUN chmod +x /myscript/setup.sh
USER argocd
CMD ["/myscript/setup.sh"]
