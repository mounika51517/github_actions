FROM amazonlinux:latest
ENV git_owner "mounika51517"
ARG runner_version="2.298.2"
ARG git_persoal_access_token
ENV git_repository "github_actions"
ENV git_persoal_access_token "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"
RUN yum update -y \
	&& yum install -y \
		curl \
		sudo \
		git \
		vim \
		jq \
		tar \
		openssl \
		gnupg2 \
		apt-transport-https \
		ca-certificates \
		libicu60 \
		maven* \
		gradle 
RUN useradd -m github && \
    usermod -aG wheel github && \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER github
WORKDIR /home/github
RUN curl -O -L https://github.com/actions/runner/releases/download/v$runner_version/actions-runner-linux-x64-$runner_version.tar.gz
RUN tar xzf ./actions-runner-linux-x64-$runner_version.tar.gz
COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]


