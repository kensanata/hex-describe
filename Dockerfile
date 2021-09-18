FROM perl:latest
# install build dependency for the GD module
RUN apt-get update
RUN apt-get install --yes libgd-dev
# checkout the three applications from git
RUN mkdir /app
RUN cd /app && git clone https://alexschroeder.ch/cgit/face-generator
RUN cd /app && git clone https://alexschroeder.ch/cgit/text-mapper
RUN cd /app && git clone https://alexschroeder.ch/cgit/hex-describe
RUN cd /app && cpanm --notest File::ShareDir::Install ./face-generator ./text-mapper ./hex-describe
# create a config file that points to text-mapper and face-generator in the same container
RUN echo "{ text_mapper_url => 'http://localhost:3010', face_generator_url => 'http://localhost:3020' }" > hex-describe.conf
