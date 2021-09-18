FROM test/text-mapper:latest
# either clone the repo into /app and install from there
RUN cd /app && git clone https://github.com/kensanata/hex-describe.git
RUN cd /app/hex-describe && cpanm --notest .
# create a config file that points to text-mapper in the same container
RUN echo "{ text_mapper_url => 'http://localhost:3010' }" > hex-describe.conf
