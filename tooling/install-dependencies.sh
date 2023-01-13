apk add --update py-pip \
py-setuptools \
ca-certificates \
gcc \
libffi-dev \
openssl-dev \
musl-dev \
linux-headers

pip install -r requirements.txt

apk del py-pip \
py-setuptools \
ca-certificates \
gcc \
libffi-dev \
openssl-dev \
musl-dev \
linux-headers
