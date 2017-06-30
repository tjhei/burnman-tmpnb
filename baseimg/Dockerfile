FROM jupyter/scipy-notebook

MAINTAINER timo.heister@gmail.com

# install burnman

USER $NB_USER
# RUN pip3 install burnman

RUN git clone https://github.com/geodynamics/burnman.git && \
    cd burnman && git fetch origin pull/294/head && git checkout FETCH_HEAD && \
    python3 setup.py install

# install notebooks
RUN cp /home/jovyan/work/burnman/contrib/ipython/* /home/jovyan/work/

COPY *.ipynb /home/jovyan/work/
COPY *.tab /home/jovyan/work/
USER root
RUN chown jovyan:users /home/jovyan/work/*.ipynb
USER $NB_USER
RUN jupyter trust /home/jovyan/work/*.ipynb

# enable widgets:

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# build the font cache once (removes warnings):
RUN echo "import matplotlib.pyplot as plt" | python3 2>/dev/null || true

