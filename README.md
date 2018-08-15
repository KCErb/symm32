# symmetry

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  symmetry:
    gitlab: kcerb/symmetry
```

## Usage

```crystal
require "symmetry"
```

TODO: Write usage inclassions here

## Development

TODO: Write development inclassions here

## Contributing

1. Fork it (<https://gitlab.com/kcerb/symmetry/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kcerb](https://gitlab.com/kcerb) KC Erb - creator, maintainer

## Notes

* Point groups look at possible parents rather than possible children. Computationally these aren't importantly different, but from a design standpoint a child has <= members of the parent, so in either case the child must be iterated over. It is better to iterate over "self" than "stranger".

* Right now species classification is hardcoded to 2-fold rotations and mirror planes in the axial and cubic settings. It could be done generally pretty easily. You'd just let each family know who it's summit is (most isometries) and then each family would only know which directions it distinguishes (for axial its axial vs planar, for cubic its on vs off axes) then the summit group, can separate multiples (like multiple 2s or ms) based on direction and we'd have a 1:1 map for each possible child to a parent isometry and classify that way. I wanted to jot that down in case in the future we want to trade a little bit of complexity for generality.
