from flask import jsonify


def register_error_handlers(app):
    @app.errorhandler(Exception)
    def handle_exception(error):
        return jsonify({
            'title': 'Internal Server Error',
            'detail': str(error)
        }), 500

    @app.errorhandler(404)
    def handle_404_error(error):
        return jsonify({
            'title': 'Not Found',
            'detail': str(error)
        }), 404
