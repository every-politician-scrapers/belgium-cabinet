module.exports = (...positions) => {
  positions = positions.map(value => `wd:${value}`).join(' ')

  return `SELECT DISTINCT ?person ?personLabel ?position ?positionLabel ?birth ?death
    WHERE {
      VALUES ?position { ${positions} }
      ?person wdt:P31 wd:Q5 ; p:P39 ?ps .
      ?ps ps:P39 ?position .
      FILTER NOT EXISTS { ?ps wikibase:rank wikibase:DeprecatedRank }
      FILTER NOT EXISTS { ?ps pq:P580 [] }
      FILTER NOT EXISTS { ?ps pq:P582 [] }
      FILTER NOT EXISTS { ?ps pq:P2937 [] }
      FILTER NOT EXISTS { ?ps pq:P5054 [] }
      OPTIONAL { ?person wdt:P569 ?birth }
      OPTIONAL { ?person wdt:P570 ?death }
      FILTER (!BOUND(?death) || (YEAR(?death) > 2000))
      SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
    } # ${new Date().toISOString()}
    ORDER BY DESC(?birth) ?positionLabel`
}

