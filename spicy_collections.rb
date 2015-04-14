module Jekyll
  class SpicyCollections < Generator
    VERSION = '0.0.1'
    safe true
    priority :high

    def generate(site)
      site.collections.each do |name, collection|
        Jekyll.logger.info "found metadata for collection #{name}: #{collection.metadata}"
        generate_permalinks name, collection
        assign_navigation_links collection
      end
    end

    def generate_permalinks(collection_name, collection)
      refname = collection.metadata.fetch 'refname'
      r = %r{^(.*)-?#{refname}-(.*)$}

      collection.docs.each do |d|
        _, doc_id, doc_title = r.match(d.basename_without_ext).to_a
        raise ArgumentError, "couldn't find a title" unless doc_title

        constructed_slug = doc_title
        Jekyll.logger.info "writing slug for #{refname}: #{constructed_slug}"
        d.data['permalink'] = "/#{collection_name}/#{constructed_slug}/"
      end
    end

    def assign_navigation_links(collection)
      sorted_collection(collection).each_cons(2) do |d1, d2|
        d2.data['previous'] = navigation_hash_for_document d1
        d1.data['next']     = navigation_hash_for_document d2
      end
    end

    def sorted_collection(collection)
      sort_field = collection.metadata.fetch 'sort_by', 'date'
      collection_sorted_by_field(collection, sort_field)
    end

    def collection_sorted_by_field(collection, field)
      if collection.docs.all? { |d| !!d.data[field] }
        Jekyll.logger.info "sorting by data field: #{field}"
        collection.docs.sort_by { |d| d.data.fetch(field) }
      else
        Jekyll.logger.info "sorting by object field: #{field}"
        collection.docs.sort_by(&:"#{field}")
      end
    end

    def navigation_hash_for_document(d)
      {'title' => d.data['title'], 'url' => d.url}
    end
  end
end
