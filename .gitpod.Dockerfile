FROM gitpod/workspace-full:latest

RUN curl -fsSL https://crystal-lang.org/install.sh | sudo bash
RUN sudo apt-get install -y fonts-firacode fonts-cascadia-code
