# Symm32

Symm32 is a [Crystal](https://crystal-lang.org/) library for working with the 32 crystallographic point groups in terms of their spatially-oriented symmetry operations (isometries). I say "spatially-oriented" to emphasize that this library focuses less on the abstract definitions of the groups and more on the tangible application of those groups to physical systems where the relative spatial orientations are important.

A simple example of this is the notion of [Aizu species](https://journals.aps.org/prb/abstract/10.1103/PhysRevB.2.754) where we are interested in the specific, symmetrically distinct, orientations of the point groups "within" one another.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  symm32:
    gitlab: fzu-hlinka/symm32
```

## Usage

To simply use the Symm32 library you need only require it like so:

```crystal
require "symm32"
```

This gives you access to `Symm32::POINT_GROUPS` an array of the 32 point groups, as well as the helper method for selecting a point group: `Symm32.point_group(name)`.

You may also be interested in using the species library. To include both symm32 (as above) and the species feature set just use

```crystal
require "symm32/species"
```

this now adds the array `Symm32::SPECIES` and the helper methods `Symm32.species(num)` to get a species by number and `Symm32.species_for(parent)` for accessing the species where the point group `parent` is a parent.

### Documentation

For further documentation, please see the docs. If you're new to Crystal, then let me be the first to tell you that Crystal automatically generates documentation from code comments. You can browse those docs nicely by serving the root of the `docs` folder in this project.

If you're new to serving local files to your browser, I recommend [serve](https://www.npmjs.com/package/serve) (you'll need to install [Node](https://nodejs.org/en/)). With `serve` you can browse the docs like so:

```
$ cd /path/to/symm32/docs
$ serve
```

## Examples

For examples of this library in action, have a look at the `species` project contained here or the following projects. If you'd like to add your project to this list please open an issue or submit a pull request (see **Contributing** below).

* [Limit Groups](https://gitlab.com/fzu-hlinka/limit_groups) - Classification of the 4 time-invariant limit groups for all 212 "nonmagnetic" species.
* [Hasse](https://gitlab.com/fzu-hlinka/hasse) - Generate a Hasse diagram from any point group to point group "1".

## Contributing

Please feel free to discuss bugs and possible features in the [issue tracker](https://gitlab.com/fzu-hlinka/symm32/issues). If you'd like to contribute code please do the following:

1. Fork this project (<https://gitlab.com/kcerb/symm32/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Ensure that all tests pass and the project conforms to the [Crystal conventions](https://crystal-lang.org/docs/conventions/)
6. Create a new Pull Request

## Contributors

- [kcerb](https://gitlab.com/kcerb) KC Erb - creator, maintainer
