import ijson
import sys
import json
import decimal

def decimal_default(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError

f = open('./data/boardgames.json')
fo = open('./data/boardgames-comments.json', 'w')
parser = ijson.items(f, 'item._source')

def add_id(p, c):
    c['boardgameid'] = p['id']
    return c

allcomments = []

for p in parser:
    allcomments.extend([ add_id(p, c) for c in p['comments'] ])

fo.write(json.dumps(allcomments, default=decimal_default))
