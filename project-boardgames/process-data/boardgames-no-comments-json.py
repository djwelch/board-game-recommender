import ijson
import sys
import json
import decimal

def decimal_default(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError

f = open('./data/boardgames.json')
fo = open('./data/boardgames-no-comments.json', 'w')
parser = ijson.items(f, 'item._source')

fo.write('[')

first = False
for p in parser:
    if first: fo.write(',')
    del p['comments']
    fo.write(json.dumps(p, default=decimal_default))
    first = True

fo.write(']')
