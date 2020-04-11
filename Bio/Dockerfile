FROM langelog/langbox:0.1.6_base

WORKDIR /app

# prepare stuff for OpenMM 7.4.1
RUN cd $HOME \
    && wget -c https://github.com/openmm/openmm/archive/7.4.1.tar.gz \
    && tar zxvf 7.4.1.tar.gz \
    && rm 7.4.1.tar.gz \
    && apt install -y doxygen swig \
    && pip install cython \
    && apt install -y fftw-dev

# Compile and install OpenMM
RUN cd $HOME \
    && mkdir openmm && cd openmm \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt/openmm ../openmm-7.4.1 \
    && make -j$(nproc) \
    && make install \
    && pip install numpy \
    && make PythonInstall




