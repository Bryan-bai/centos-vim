FROM garryzhengkj/centos-gcc

ADD .vimrc /root/.vimrc
ADD .ycm_extra_conf.py /root/.ycm_extra_conf.py

RUN rpm --rebuilddb \
    && yum -y install \
        lua \
        lua-devel \
        luajit \
        luajit-devel \
        perl \
        perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed \
        perl-ExtUtils-ParseXS \
        perl-devel \
        ruby \
        ruby-devel \
        tcl \
        tcl-devel \
        ncurses \
        ncurses-devel \
    && yum -y remove vim-minimal \
    && cd /tmp \
    && git clone https://github.com/vim/vim.git \
    && cd vim \
    && ./configure \ 
        --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/opt/rh/python27/root/usr/lib64/python2.7/config \
        --enable-python3interp=yes \
        --with-python3-config-dir=/opt/rh/python33/root/usr/lib64/python3.3/config \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-cscope \
        --prefix=/usr \
    && make -j4 \
    && make install \
    && update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1 \
    && update-alternatives --set editor /usr/bin/vim \
    && update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1 \
    && update-alternatives --set vi /usr/bin/vim \
    && cd .. \
    && git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim \
    && vim -c PluginInstall -c q -c q \
    && cd /root/.vim/bundle/YouCompleteMe \
    && ./install.py --clang-completer \
    && sed -i 's/^colorscheme default/"colorscheme default/g' /root/.vimrc \
    && sed -i 's/^"colorscheme solarized/colorscheme solarized/g' /root/.vimrc \
    && yum clean all \
    && find /usr/share \
        -type f \
        -regextype posix-extended \
        -regex '.*\.(jpg|png)$' \
        -delete \
    && rm -rf /etc/ld.so.cache \
    && rm -rf /sbin/sln \
    && rm -rf /usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    && rm -rf /opt/python27/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    && rm -rf /opt/python33/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    && rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*
