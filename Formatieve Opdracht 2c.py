from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
database = client['huwebshop']


def retrieve_product_price():
    collection = database['products']
    response = []
    try:
        for product in collection.find({}, {'_id': 0, 'name': 1, 'price': 1}):
            if product != {} and product['name'] != '' and product['price']['selling_price'] != 0:
                response.append(product)
    except KeyError:
        pass

    return response


print(retrieve_product_price())