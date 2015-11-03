import graphlab
sf = graphlab.SFrame.read_json('./data/boardgames-comments.json')
sf.save('./data/boardgames-comments')

sf = graphlab.SFrame.read_json('./data/boardgames-no-comments.json')
sf.save('./data/boardgames-no-comments')

sf = graphlab.SFrame.read_json('./data/boardgames-names.json')
sf.save('./data/boardgames-names')
