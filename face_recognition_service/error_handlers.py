from flask import jsonify


def register_error_handlers(app):
    @app.errorhandler(Exception)
    def handle_exception(error):
        return jsonify({
            'title': 'Internal Server Error',
            'detail': str(error)
        }), 500

    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({
            'title': 'Bad Request',
            'detail': str(error)
        }), 400
