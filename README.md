# Phare

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'phare'
```

If you wish to check for JavaScript code style using JSHint and JSCS, you must install them too:

```bash
$ npm install -g jshint jscs
```

## Usage

Phare provides an executable named `phare`. You can just use it as is:

```bash
$ phare
```

One of the best way to use Phare is by hooking it before your version control commits. For example, with `git`:

```bash
$ bundle binstubs phare
$ ln -s "`pwd`/bin/phare" .git/hooks/pre-commit
```
