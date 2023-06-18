FROM gcc:9.4

WORKDIR /usr/src/app
ARG USERNAME=demo
ARG USER_UID=2000
ARG USER_GID=$USER_UID

# create user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME