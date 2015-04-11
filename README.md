# SpicyJekyll: enhanced custom collection behavior for Jekyll

SpicyJekyll is a Jekyll plugin that adds sensible default behaviors to your custom collections. Like real spices, SpicyJekyll makes your custom collections tastier to consume.

## Usage

For each custom collection you have, add an entry to your `collections` hash in `_config.yml`:

```yaml
collections:
  authors:
  recipes:
```

SpicyJekyll expects to see the members of that collection as files in `_{collection-name}`. For example, each recipe would be a file in `_recipes`.

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
  author-davison-jack.markdown
  author-gupta-steve.markdown
  author-breckenridge-jen.markdown
```

The portion before the refname is reserved for your use so that you can have a convenient filename-based id-number sort if that's relevant to your collection. For example, if your authors have employee ID numbers and it's more useful to sort by those, then you can do that:


```
_authors/
  000001-author-smith-alice.markdown
  000002-author-davison-jack.markdown
  000003-author-gupta-steve.markdown
  000004-author-breckenridge-jen.markdown
```

If not, you can just ignore that, and use the first example.

## Behavior

Running SpicyJekyll on a custom collection has the following effects:

* Your collection will be ordered by a `date` field. If you would rather sort by a different field, set the `sort_by` key on your collection. For example, to sort by a field called `last_name`, add `sort_by: last_name` to your collection's metadata in `_config.yml`.

* Your collection's documents will get `next` and `previous` references. The first document will have a `nil` reference to `previous` and the last document will have a `nil` reference to `next. Each navigation reference is a hash containing `title` and `url` fields. This is helpful for showing next/previous navigation links in your templates, for instance.

* Your
