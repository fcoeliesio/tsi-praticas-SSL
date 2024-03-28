from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
        return 'Hello! Este é um site flask.'

if __name__ == '__main__':
        app.run(ssl_context=('cert.pem', 'key.pem'))
