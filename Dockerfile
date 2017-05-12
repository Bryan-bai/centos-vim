FROM garryzhengkj/centos-clang

ADD .vimrc /root/.vimrc
ADD .ycm_extra_conf.py /root/.ycm_extra_conf.py

RUN rpm --rebuilddb \
	&& yum -y install vim git ctags mlocate \
	&& git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim \
	&& vim -c PluginInstall -c q -c q \
	&& cd /tmp \
	&& mkdir ycm_build \
	&& cd ycm_build \
	&& source /opt/rh/devtoolset-3/enable \
	&& source /opt/rh/rh-python35/enable \
	&& cmake -G "Unix Makefiles" \ 
		-DUSE_PYTHON2=OFF \
		-DPYTHON_INCLUDE_DIR=/opt/rh/rh-python35/root/usr/include/python3.5m \
		-DPYTHON_LIBRARY=/opt/rh/rh-python35/root/usr/lib64/libpython3.5m.so \
		-DPYTHON_EXECUTABLE=/opt/rh/rh-python35/root/usr/bin/python \
		-DPATH_TO_LLVM_ROOT=/usr/local \
		-DCMAKE_BUILD_TYPE=Release \
		. \
		/root/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp \
	&& cmake --build . --target ycm_core --config Release \
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
	&& rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/devtoolset-3/root/usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh-python35/root/usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*
