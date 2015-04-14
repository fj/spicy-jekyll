# SpicyJekyll: enhanced custom collection behavior for Jekyll

SpicyJekyll is a Jekyll plugin that adds sensible default behaviors to your custom collections. Like real spices, SpicyJekyll makes your custom collections tastier to consume. :hotsprings: :+1:

## Installation

Copy `spicy_collections.rb` to your Jekyll plugins directory. That's it!

## Usage

For each custom collection you have, add an entry to your `collections` hash in `_config.yml`:

```yaml
collections:
  authors:
  recipes:
```

SpicyJekyll expects to see the members of that collection as files in `_{collection-name}` in your configured source directory. For example, each recipe would be a file in `_recipes`.

Then provide a `refname` key to tell SpicyJekyll how to find these files. SpicyJekyll will look for files named `...<refname>-...` in this file and process them (see "Behavior" below).

```
collections:
  authors:
    refname: author
```

For example, you can organize your authors like this:

```
_authors/
  author-smith-alice.markdown
  author-feminella-john.markdown
  author-gupta-steve.markdown
  author-breckenridge-jen.markdown
```

The portion before the refname is reserved for your use so that you can have a convenient filename-based id-number sort if that's relevant to your collection. For example, if your authors have employee ID numbers and it's more useful to sort by those, then you can do that:


```
_authors/
  000001-author-smith-alice.markdown
  000002-author-feminella-john.markdown
  000003-author-gupta-steve.markdown
  000004-author-breckenridge-jen.markdown
```

If not, you can just ignore that, and use the first example.

## Behavior

Running SpicyJekyll on a custom collection has the following effects. Your collection will:

* **Be ordered** by a `date` field. If you would rather sort by a different field, set the `sort_by` key on your collection. For example, to sort by a field called `last_name`, add `sort_by: last_name` to your collection's metadata in `_config.yml`. The sorting is in ascending order. If you want to sort by descending, use the `reverse` filter.

* **Have its documents augmented with `next` and `previous` references.** The aforementioned ordering will be used to sort your collection. The first document will have a `nil` reference to `previous` and the last document will have a `nil` reference to `next. Each navigation reference is a hash containing `title` and `url` fields. This is helpful for showing next/previous navigation links in your templates, for instance.

* **Be rigorously checked for a `title` property on each document.** This prevents Jekyll's silent errors for missing keys. If a title is missing from any document, it will be considered a fatal error and your site's build will halt.

* **Have stable permalinks.** Every collection gets a permalink slug based on the filename. This lets you change the title or headline of the document without affecting its slug, so long as you leave the filename alone. This is helpful when you don't want to break URLs inadvertently.

* **Log what it's doing.** For each member of the collection, Jekyll will log useful output to let you know that your element was processed. This lets you more quickly diagnose any issues that might be present in your collections.
