FROM rocker/r-ver:4.5.1

ARG TEXLIVE_SOURCE_URL="https://mirror.ctan.org"
ENV TEXLIVE_REPO=${TEXLIVE_SOURCE_URL}/systems/texlive/tlnet

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        perl \
        xz-utils \
        unzip \
        gnupg \
        fontconfig \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# TexLive mirror repos are a disaster, and tend to fail a lot. Unfortunately, the mirror list is performing questionable health checks and 
# returning problematic ones.
RUN curl -L -o install-tl-unx.tar.gz "${TEXLIVE_REPO}/install-tl-unx.tar.gz" && \
    tar -xzf install-tl-unx.tar.gz && \
    rm -f install-tl-unx.tar.gz && \
    cd install-tl-* && \
    echo "selected_scheme scheme-basic" > texlive.profile && \
    echo "tlpdbopt_install_docfiles 0" >> texlive.profile && \
    echo "tlpdbopt_install_srcfiles 0" >> texlive.profile && \
    ./install-tl -profile texlive.profile -repository "${TEXLIVE_REPO}" && \
    cd .. && \
    rm -rf install-tl-*

ENV PATH=$PATH:/usr/local/texlive/2025/bin/x86_64-linux

# If you need more packages, add them here
RUN tlmgr option repository "${TEXLIVE_REPO}" && \
    tlmgr install cormorantgaramond \
    ragged2e footmisc lipsum \
    xcolor ulem contour paracol \
    contour fontspec eso-pic fontawesome5 \
    luatexbase enumitem arydshln || true

# Adding Source Serif 4 system fonts
WORKDIR /usr/local/share/fonts/source-serif-4
ADD https://github.com/adobe-fonts/source-serif/releases/download/4.004R/source-serif-4.004.zip /tmp/source-serif.zip

RUN apt-get update && apt-get install -y unzip && \
    unzip /tmp/source-serif.zip -d /usr/local/share/fonts/source-serif-4 && \
    fc-cache -f -v && \
    rm /tmp/source-serif.zip && \
    luaotfload-tool --update --force

WORKDIR /tex
ENTRYPOINT [ "lualatex" ]