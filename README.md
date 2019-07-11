# Symm32

Symm32 is a [Crystal (programming language)](https://crystal-lang.org/) library for working with the 32 crystallographic point groups. It provides classes, isometries, and other logic related to exploring their symmetries.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  symm32:
    gitlab: crystal-symmetry/symm32
```

## Usage

To use the Symm32 library, you need only require it like so:

```crystal
require "symm32"
```

This gives you access to `Symm32::POINT_GROUPS` an array of the 32 point groups, as well as a helper method for selecting a point group by name: `Symm32.point_group(name)`. Please see [the docs](https://crystal-symmetry.gitlab.io/symm32) for more details.

## Contributing

Contributions are welcome! To get things started you can [open an issue](https://gitlab.com/crystal-symmetry/symm32/issues/new) and post a comment, correction, or feature request. From there we can talk about how best to incorporate (or not) your feedback.

Please note! Your contribution should include tests and be well documented. If you're new to crystal then you might want to at least read this section of the docs: [Writing Shards](https://crystal-lang.org/docs/guides/writing_shards.html). Also, beware, **the docs are generated in this project like so: `crystal docs src/symm32.cr`** since the initialization of this module is order-dependent.

In general, if you want, you can just pull this code down, start hacking on it, and then push it back here as a "Pull Request", then we can discuss your proposed changes.

1. Fork it (<https://gitlab.com/crystal-symmetry/symm32/forks/new>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

But I recommend you start off by opening an issue so that you don't waste time on a potentially unwelcome change.

## Contributors

- [KCErb](https://gitlab.com/kcerb) KC Erb - creator, maintainer
