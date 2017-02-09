FROM jupyter/scipy-notebook

MAINTAINER timo.heister@gmail.com

# install burnman

USER $NB_USER
RUN pip3 install burnman

# install notebooks
COPY *.ipynb /home/jovyan/work/
USER root
RUN chown jovyan:users /home/jovyan/work/*
USER $NB_USER
RUN jupyter trust /home/jovyan/work/*

# enable widgets:

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# build the font cache once (removes warnings):
RUN echo "import matplotlib.pyplot as plt" | python3 2>/dev/null || true

