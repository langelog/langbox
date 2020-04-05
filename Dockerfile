FROM python:3.8.1

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python python-dev python-pip build-essential swig git libpulse-dev \
    locales zip unzip vim curl cmake

RUN echo "alias ll='ls -lah'" >> /root/.bashrc

# install golang
RUN wget -c https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.14.1.linux-amd64.tar.gz && echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.bashrc

# install nasm
RUN apt-get install nasm less libxpm-dev -y

# install jupyter
RUN pip install jupyter metakernel

# Enable go in jupyter
RUN /bin/bash -c "source $HOME/.bashrc && env GO111MODULE=on go get github.com/gopherdata/gophernotes"
RUN mkdir -p $HOME/.local/share/jupyter/kernels/gophernotes
RUN ["/bin/bash", "-c", "source $HOME/.bashrc \
    && cd $HOME/.local/share/jupyter/kernels/gophernotes \
    && cp $(go env GOPATH)/pkg/mod/github.com/gopherdata/gophernotes@v0.7.0/kernel/* . \
    && chmod +w ./kernel.json \
    && sed \"s|gophernotes|$(go env GOPATH)/bin/gophernotes|\" < kernel.json.in > kernel.json"]

# Compile Root from source
RUN cd $HOME \
    && wget -c https://root.cern/download/root_v6.20.04.source.tar.gz \
    && tar zxvf root_v6.20.04.source.tar.gz \
    && mkdir root && cd root \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt/root ../root-6.20.04 \
    && cmake --build . --target install

# Requirements for crosscompiler
RUN apt-get install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libisl-dev

# Download and extract the source files
RUN cd $HOME \
    && mkdir cross && cd cross \
    && wget -c https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz \
    && wget -c https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz \
    && tar zxvf binutils-2.34.tar.gz \
    && tar zxvf gcc-9.3.0.tar.gz

# compile gcc for i686
RUN cd $HOME/cross \
    && export PREFIX="/opt/cross" \
    && export TARGET=i686-elf \
    && export PATH="$PREFIX/bin:$PATH" \
    && mkdir build-binutils \
    && cd build-binutils \
    && ../binutils-2.34/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror \
    && make \
    && make install \
    && cd $HOME/cross \
    && which -- $TARGET-as || echo $TARGET-as is not in the PATH \
    && mkdir build-gcc \
    && cd build-gcc \
    && ../gcc-9.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-header \
    && make all-gcc \
    && make all-target-libgcc \
    && make install-gcc \
    && make install-target-libgcc

# publish the files for crosscompile gcc
RUN echo "export PATH='/opt/cross/bin:$PATH'" >> $HOME/.bashrc
RUN echo "source /opt/root/bin/thisroot.sh" >> $HOME/.bashrc


