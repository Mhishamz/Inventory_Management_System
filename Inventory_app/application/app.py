from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate



db = SQLAlchemy()

def create_app():

    app = Flask(__name__,template_folder='Templates')

    app.config['SQLALCHEMY_DATABASE_URI'] = (
        'mssql+pyodbc://PC-Hossam/InventoryManager?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
    )


    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)
     # Create tables based on the defined models
    with app.app_context():
        db.create_all()  # This creates the tables
  
  
    #########
    from routes import register_routes
    register_routes(app, db)
    
    migrate=Migrate(app,db)

    return app



