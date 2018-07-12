# symm32

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  symm32:
    github: your-github-user/symm32
```

## Usage

```crystal
require "symm32"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/symm32/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [your-github-user](https://github.com/your-github-user) KC Erb - creator, maintainer

## Notes

* Point groups look at possible parents rather than possible children. Computationally these aren't importantly different, but from a design standpoint a child has <= members of the parent, so in either case the child must be iterated over. It is better to iterate over "self" than "stranger" so all symmetric resolvers actually operate in  the child->parent direction.

For example, point groups have a determine subgroup and determine supergroup method. The determine supergroup method just calls determine subgroup under the hood with the roles reversed.
