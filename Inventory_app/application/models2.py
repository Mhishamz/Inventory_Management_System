


class Product (db.Model):
    __tablename__ = 'Products'

    product_id = db.Column(db.String(20), primary_key=True)
    product_name = db.Column(db.String(75), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    sub_category = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    size = db.Column(db.Numeric(10, 2), nullable=False)

    def __repr__(self):
        return f'<Product {self.product_name}>'
    

class Customer(db.Model):
    __tablename__ = 'Customers'

    customer_id = db.Column(db.String(20), primary_key=True)
    customer_name = db.Column(db.String(50), nullable=False)
    segment = db.Column(db.String(50))
    email = db.Column(db.String(255), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)

    def __repr__(self):
        return f'<Customer {self.customer_name}>'


class CustomerOrder(db.Model):
    __tablename__ = 'Customer_Orders'

    order_id = db.Column(db.String(20), primary_key=True)
    customer_id = db.Column(db.String(20), db.ForeignKey('Customers.Customer_ID'))
    order_date = db.Column(db.DateTime, default=db.func.now())
    order_status = db.Column(db.String(25))
    order_priority = db.Column(db.String(25))

    customer = db.relationship('Customer', backref='orders')

    def __repr__(self):
        return f'<Order {self.order_id}>'


class CustomerOrderItem(db.Model):
    __tablename__ = 'Customer_Order_Items'

    order_id = db.Column(db.String(20), db.ForeignKey('Customer_Orders.Order_ID'), primary_key=True)
    product_id = db.Column(db.String(20), db.ForeignKey('Products.Product_ID'), primary_key=True)
    quantity = db.Column(db.Integer, nullable=False)
    sales = db.Column(db.Numeric(10, 2), nullable=False)

    order = db.relationship('CustomerOrder', backref='order_items')
    product = db.relationship('Product', backref='order_items')

    def __repr__(self):
        return f'<OrderItem {self.order_id} - {self.product_id}>'


class Inventory(db.Model):
    __tablename__ = 'INVENTORY'

    product_id = db.Column(db.String(20), db.ForeignKey('Products.Product_ID'), primary_key=True)
    statee = db.Column(db.String(75), primary_key=True)  # Updated to 75 as per ALTER TABLE
    quantity_in_hand = db.Column(db.Integer, nullable=False)
    country = db.Column(db.String(75), nullable=False)  # Updated to 75 as per ALTER TABLE
    city = db.Column(db.String(75), nullable=False)  # Updated to 75 as per ALTER TABLE

    product = db.relationship('Product', backref='inventory_items')

    def __repr__(self):
        return f'<Inventory {self.product_id} - {self.statee}>'
