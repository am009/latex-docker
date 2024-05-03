FROM ubuntu:24.04

# docker build . --tag am009/latex --build-arg UBUNTU_MIRROR=mirrors.ustc.edu.cn --build-arg PYTHON_MIRROR=pypi.tuna.tsinghua.edu.cn --build-arg CTAN_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/2023/tlnet-final
ARG UBUNTU_MIRROR
# =mirrors.ustc.edu.cn
ARG PYTHON_MIRROR
# =pypi.tuna.tsinghua.edu.cn

SHELL ["/bin/bash", "-c"]
WORKDIR /root

RUN if [[ ! -z "$UBUNTU_MIRROR" ]] ; then sed -i "s/archive.ubuntu.com/$UBUNTU_MIRROR/g" /etc/apt/sources.list.d/ubuntu.sources && \
 sed -i "s/security.ubuntu.com/$UBUNTU_MIRROR/g" /etc/apt/sources.list.d/ubuntu.sources ; fi && \
 apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends wget curl make git unzip 7zip nano software-properties-common sudo pandoc texlive-full biber latexmk procps locales debconf-utils \
 build-essential wget net-tools unzip time imagemagick optipng strace git python3 python3-pip python-is-python3 zlib1g-dev libpcre3-dev gettext-base libwww-perl ca-certificates curl gnupg qpdf python3-pygments && \
 if [[ ! -z "$PYTHON_MIRROR" ]] ; then python3 -m pip config set global.index-url https://$PYTHON_MIRROR/simple ; fi && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# spell checking
# aspell aspell-en aspell-af aspell-am aspell-ar aspell-ar-large aspell-bg aspell-bn aspell-br aspell-ca aspell-cs aspell-cy aspell-da aspell-de aspell-de-1901 aspell-el aspell-eo aspell-es aspell-et aspell-eu-es aspell-fa aspell-fo aspell-fr aspell-ga aspell-gl-minimos aspell-gu aspell-he aspell-hi aspell-hr aspell-hsb aspell-hu aspell-hy aspell-id aspell-is aspell-it aspell-kk aspell-kn aspell-ku aspell-lt aspell-lv aspell-ml aspell-mr aspell-nl aspell-no aspell-nr aspell-ns  aspell-pa aspell-pl aspell-pt aspell-pt-br aspell-ro aspell-ru aspell-sk aspell-sl aspell-ss aspell-st aspell-sv aspell-tl aspell-tn aspell-ts aspell-uk aspell-uz aspell-xh aspell-zu && \

# # installing cpanm & missing latexindent dependencies
# RUN curl -L http://cpanmin.us | perl - --self-upgrade && \
#     cpanm Log::Dispatch::File YAML::Tiny File::HomeDir

# install mscorefonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
 apt update && apt install -y ttf-mscorefonts-installer fontconfig && fc-cache -fsv && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG CTAN_MIRROR
 # =https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/2023/tlnet-final
 # =https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet

# CTAN MIRROR and fonts
# https://tug.org/fonts/getnonfreefonts/
RUN mkdir -p ~/texmf && tlmgr init-usertree && \
 if [[ ! -z "$CTAN_MIRROR" ]] ; then tlmgr option repository $CTAN_MIRROR ; fi && \
 tlmgr install scheme-full && tlmgr path add && \
 curl -OL http://www.tug.org/fonts/getnonfreefonts/install-getnonfreefonts && \
 texlua ./install-getnonfreefonts && \
 rm -f install-getnonfreefonts && getnonfreefonts --sys arial-urw classico dayroman gandhi garamond garamondx lettergothic literaturnaya luximono vntex-nonfree webomints && \
 fc-cache -fsv && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# google fonts
 RUN wget https://github.com/google/fonts/archive/main.tar.gz -O gf.tar.gz && \
 tar -xf gf.tar.gz && \
 mkdir -p /usr/share/fonts/truetype/google-fonts && \
 find $PWD/fonts-main/ -name "*.ttf" -exec install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1 && \
 rm -f gf.tar.gz && \
 # Remove the extracted fonts directory
 rm -rf $PWD/fonts-main && \
 # Remove the following line if you're installing more applications after this RUN command and you have errors while installing them
 rm -rf /var/cache/* && \
 fc-cache -f
