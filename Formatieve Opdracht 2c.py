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


def bereken_gemiddelde_prijs():
    gemiddelde_prijs = 0
    counter = 0
    product_info = retrieve_product_price()
    for product in product_info:
        gemiddelde_prijs += product['price']['selling_price']
        counter += 1
    return gemiddelde_prijs / counter


print(f"{bereken_gemiddelde_prijs():.2f}")


def grootste_afwijking_prijs():
    product_grootste_absolute_afwijking = ''
    grootste_absolute_afwijking = 0
    gemiddelde_prijs = bereken_gemiddelde_prijs()
    product_info = retrieve_product_price()
    for product in product_info:
        absolute_afwijking = product['price']['selling_price'] - gemiddelde_prijs
        if absolute_afwijking > grootste_absolute_afwijking:
            grootste_absolute_afwijking = absolute_afwijking
            product_grootste_absolute_afwijking = product['name']

    return product_grootste_absolute_afwijking


