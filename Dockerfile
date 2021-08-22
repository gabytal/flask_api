FROM python:3.9
WORKDIR /usr/src/app
COPY flask_app.py ./
RUN pip install -r requirements.txt
RUN rm requirements.txt
CMD [ "python", "./flask_app.py" ]
