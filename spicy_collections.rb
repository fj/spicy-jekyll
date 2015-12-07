module Jekyll
  class SpicyCollections < Generator
    VERSION = '0.0.2'
    safe true
    priority :high

    def generate(site)
      site.collections.each do |name, collection|
        Jekyll.logger.info "found metadata for collection #{name}: #{collection.metadata}"
        generate_permalinks name, collection
        assign_navigation_links collection
        assign_asset_paths name, collection
      end
    end

    def generate_permalinks(collection_name, collection)
      collection.docs.each do |d|
        refname = refname_for(collection)
        _, doc_id, doc_title = collection_segments_for(d, refname)
        raise ArgumentError, "couldn't find a title" unless doc_title

        constructed_slug = doc_title
        Jekyll.logger.info "writing slug for #{refname}: #{constructed_slug}"
        if d.data['permalink']
          d.data['permalink'] = "/#{collection_name}/#{constructed_slug}/"
        end

        if !doc_id.empty?
          Jekyll.logger.info "writing document id for #{d.basename_without_ext}: #{collection_name}-#{doc_id}"
          d.data['doc_id'] = "#{collection_name}-#{doc_id}"
        end
      end
    end

    def refname_for(collection)
      collection.metadata.fetch 'refname'
    end

    def collection_segments_for(document, refname)
      r = %r{^(.*?)-?#{refname}-(.*)$}
      r.match(document.basename_without_ext).to_a
    end

    def assign_navigation_links(collection)
      sorted_collection(collection).each_cons(2) do |d1, d2|
        d2.data['previous'] = navigation_hash_for_document d1
        d1.data['next']     = navigation_hash_for_document d2
      end
    end

    def assign_asset_paths(collection_name, collection)
      collection.docs.each do |d|
        _, doc_id, doc_title = collection_segments_for(d, refname_for(collection))
        d.data['image_path'] = "/images/#{collection_name}/#{doc_id}"
        Jekyll.logger.info "adding image path for #{d.path}: #{d.data['image_path']}"
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
