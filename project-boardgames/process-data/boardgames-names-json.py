import ijson
import sys
import json
import decimal

def decimal_default(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError

f = open('./data/boardgames.json')
fo = open('./data/boardgames-names.json', 'w')
parser = ijson.items(f, 'item._source')

fo.write('[')

first = False
for p in parser:
    if first: fo.write(',')
    for k, v in p.items():
        if k not in ['id', 'name']:
            del p[k]
    fo.write(json.dumps(p, default=decimal_default))
    first = True

fo.write(']')
