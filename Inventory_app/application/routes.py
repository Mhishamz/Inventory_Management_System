from flask import render_template,request,redirect,url_for
from models import Product,Customer

def register_routes(app,db):
    
    @app.route('/')
    def index():
#        products = Product.query.all()
#        return render_template('index.html', products=products)
        return "homepage"

    @app.route('/login',methods=['GET', 'POST'])
    def login():
        if request.method == 'POST':
            # Retrieve the form data
            email = request.form['email']
            password = request.form['password']

            customer = Customer.query.filter_by(email=email).first()
            
            if customer and customer.check_password(password):
                return "login succeded"# Redirect to a home page or dashboard
            else:
                return('Login failed. Check your email and password.')
    
        else:
            return render_template('login.html')

         