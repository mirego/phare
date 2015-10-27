<p align="center">
  <a href="https://github.com/mirego/phare">
    <img src="http://i.imgur.com/9Pa2RgE.png" alt="Phare" />
  </a>
  <br />
  Phare looks into your files and check for coding style errors.
  <br /><br />
  <a href="https://rubygems.org/gems/phare"><img src="http://img.shields.io/gem/v/phare.svg" /></a>
  <a href="https://travis-ci.org/mirego/phare"><img src="http://img.shields.io/travis/mirego/phare.svg" /></a>
  <a href="https://codeclimate.com/github/mirego/phare"><img src="http://img.shields.io/codeclimate/github/mirego/phare.svg" /></a>
</p>

## Installation

Add these lines to your application’s `Gemfile` as development dependencies:

```ruby
group :development do
  gem 'rubocop' # to check Ruby code
  gem 'scss-lint' # to check SCSS code

  gem 'phare'
end
```

```shell
$ bundle install
```

If you wish to check for JavaScript code style using JSHint and JSCS, you must
specify them in your `package.json` file:

```json
{
  "name": "foo",
  "version": "0.0.1",
  "devDependencies": {
    "jshint": "latest",
    "jscs": "latest"
  }
}
```

```shell
$ npm install
```

### Shims

Phare uses top-level commands in its checks (eg. `$ rubocop` and not `$ bundle exec rubocop`).
You’ll need to run these commands in order to use the shims provided by either
Bundler or NPM.

#### Bundler

```shell
$ bundle install
$ bundle binstub rubocop scss-lint
$ export PATH="./bin:$PATH"
```

#### npm

```shell
$ npm install
$ export PATH="./node_modules/.bin:$PATH"
```

## Usage

Phare provides an executable named `phare`. You can just use it as is:

```bash
$ phare
```

### Version control hook

One of the best ways to use Phare is by hooking it to your version control
commit process. For example, with `git`:

```bash
$ bundle binstubs phare
$ ln -s "`pwd`/bin/phare" .git/hooks/pre-commit
```

That way, every time `git commit` is ran, `phare` will be executed and the
commit will be aborted if there are some errors. However, you can skip this
check altogether by specifying `SKIP_PHARE=1` before your command.

```bash
$ git commit -m 'Add stuff'
$ SKIP_PHARE=1 git commit -m 'Add stuff and I don’t care about Phare'
```

### Options

#### Command-line

| Option      | Description
|-------------|-------------------------------------------------------------------------------------------------------------------------
| `directory` | The directory in which to run the checks (default is the current directory
| `only`      | The specific checks to run (e.g. `--only=rubocup,jscs`)
| `skip`      | The checks to skip (e.g. `--skip=scsslint`)

#### `.phare.yml`

Instead of using command-line arguments when running the `phare` command, you
can create a `.phare.yml` file at the root of your project and hard-code options
in that file.

```yaml
skip:
  - scsslint
  - jshint
```

## Contributors

* [@remiprev](https://github.com/remiprev)
* [@garno](https://github.com/garno)

## License

`Phare` is © 2014-2015 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/phare/blob/master/LICENSE.md) file.

The lighthouse logo is based on [this lovely icon](http://thenounproject.com/term/lighthouse/11608/) by [Nick Lacke](http://thenounproject.com/nicklacke), from The Noun Project.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
