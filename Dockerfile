FROM python:3.9-slim
 
WORKDIR /app

COPY . .

RUN pip install Flask mysql-connector-python

ENV MYSQL_HOST=database \
    MYSQL_USER=root \
    MYSQL_PASSWORD=qwerty \
    MYSQL_DB=forms

EXPOSE 8000

CMD ["python","app.py"]
