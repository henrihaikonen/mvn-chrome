FROM maven:3.5.4-jdk-8

# Google Chrome

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
&& apt-get update -qqy \
&& apt-get -qqy install google-chrome-stable \
&& rm /etc/apt/sources.list.d/google-chrome.list \
&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome 

# ChromeDriver

ARG CHROME_DRIVER_VERSION=2.43
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
&& rm -rf /opt/chromedriver \
&& unzip /tmp/chromedriver_linux64.zip -d /opt \
&& rm /tmp/chromedriver_linux64.zip \
&& mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
&& chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
&& ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

# Google Cloud SDK

RUN wget --no-verbose -O /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz \
&& tar -xvf /tmp/google-cloud-sdk.tar.gz -C /tmp/ \
&& /tmp/google-cloud-sdk/install.sh -q \
&& apt-get install -qqy install source \
&& source /tmp/google-cloud-sdk/path.bash.inc \
&& gcloud components install app-engine-java


WORKDIR /usr/src/app

