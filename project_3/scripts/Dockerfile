FROM rocker/verse:latest
RUN Rscript -e "install.packages('rgdal')"
RUN Rscript -e "install.packages('rgeos')"
RUN Rscript -e "install.packages('maptools')"
RUN Rscript -e "install.packages('ggalt')"
RUN Rscript -e "install.packages('ggthemes')"
RUN Rscript -e "install.packages('ggrepel')"
RUN Rscript -e "install.packages('RColorBrewer')"

FROM continuumio/anaconda3
