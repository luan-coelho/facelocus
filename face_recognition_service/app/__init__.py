from flask import Flask

from app.df.views import df_bp
from app.dl.views import dl_bp
from app.fr.views import fr_bp
from error_handlers import register_error_handlers

app = Flask(__name__)

register_error_handlers(app)

app.register_blueprint(fr_bp)
app.register_blueprint(df_bp)
app.register_blueprint(dl_bp)

if __name__ == '__main__':
    app.run(debug=False)
