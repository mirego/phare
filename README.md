<p align="center">
  <a href="https://github.com/mirego/phare">
    <img src="http://i.imgur.com/9Pa2RgE.png" alt="Phare" />
  </a>
  <br />
  Phare looks into your files and check for coding style errors. 
  <br /><br />
  <a href="https://rubygems.org/gems/phare"><img src="https://badge.fury.io/rb/phare.png" /></a>
</p>

## Installation

Add these lines to your application’s Gemfile as development dependancies:

```ruby
group :development do
  gem 'rubocop' # to check Ruby code
  gem 'scss-lint' # to check SCSS code

  gem 'phare'
end
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
