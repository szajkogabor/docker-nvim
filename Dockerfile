FROM archlinux:latest
RUN pacman -Syu --needed --noconfirm git sudo fakeroot base-devel zsh python python-pip gcc clang gdb lldb cmake make rustup nodejs npm yarn wget

# makepkg user and workdir
ARG user=user
RUN useradd --shell /bin/zsh --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay

# install rust
RUN rustup install stable

# install neovim
RUN yay -S --noconfirm neovim-git neovim-plug-git
RUN pip3 install --user neovim

RUN yes | bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ENV PATH="/home/user/.local/bin:${PATH}"

VOLUME [ "/home/$user/src" ]
