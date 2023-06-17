FROM mcr.microsoft.com/devcontainers/base:bullseye

ENV TZ China/Shanghai

ARG USERNAME=vscode
# install curl git snmp
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl git sudo zsh python3-distutils \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install pip with get-pip.py
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py

# Install pip requirements
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir pre-commit && \
    python3 -m pip install --no-cache-dir wheel requests

# change user
USER $USERNAME

# # install oh-my-zsh
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# # install zsh plugins auto suggestions and syntax highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# # change default shell from bash to zsh
# RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

COPY config/zshrc /home/$USERNAME/.zshrc
