function selectCommunity(element, community_slug) {
  var hidden_field = jQuery('<input>').attr({
      id: 'article_dspace_community_name_',
      name: 'article[dspace_communities_names][]',
      type: 'hidden',
      name: 'article[dspace_communities_names][]',
      value: community_slug
  });
  jQuery(hidden_field).insertAfter(element);
}

function selectCollection(element, collection_slug) {
  var hidden_field = jQuery('<input>').attr({
      id: 'article_dspace_collection_name_',
      name: 'article[dspace_collections_names][]',
      type: 'hidden',
      name: 'article[dspace_collections_names][]',
      value: collection_slug
  });
  jQuery(hidden_field).insertAfter(element);
}

