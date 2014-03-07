# node-librarianowl

[![Build Status](https://travis-ci.org/owl-stars/node-librarianowl.png?branch=master)](https://travis-ci.org/owl-stars/node-librarianowl)
[![Coverage Status](https://coveralls.io/repos/owl-stars/node-librarianowl/badge.png?branch=master)](https://coveralls.io/r/owl-stars/node-librarianowl?branch=master)
[![Dependency Status](https://gemnasium.com/owl-stars/node-librarianowl.png)](https://gemnasium.com/owl-stars/node-librarianowl)
[![NPM version](https://badge.fury.io/js/librarianowl.png)](http://badge.fury.io/js/librarianowl)

> Simple toolkit to generates Less, Sass/Scss & Stylus libraries defined through YAML.

## Getting Started

Install the module with: `npm install librarianowl`

```
librarianowl = require 'librarianowl'

# compile the library
librarianowl.library "src", "lib",
  helpers: "helpers.js"
  template: "template-lib.hbs"

# compile the documenation
librarianowl.documentation "src", "docs",
  helpers: "helpers.js"
  template: "template-docs.hbs"
  
# compile the examples
librarianowl.examples "src", "examples",
  helpers: "helpers.js"
  template: "template-examples.hbs"
  imports: (syntax) ->
    switch syntax
      when "sass" then return "@import '../../lib/#{syntax}/cssowl'"
      when "scss" then return "@import '../../lib/#{syntax}/cssowl';"
      when "less" then return "@import '../../lib/#{syntax}/cssowl';"
      when "styl" then return "@import '../../lib/#{syntax}/cssowl'"
```

## Documentation

Librarianowl is based on the simple idea to write one *YAML* file per mixin with it's
code in each syntax together with a shared documentation and example. Librarianowl will
then generate each library with your custom *Handlebars* template or a default one.

The same can be done with the documentation. This too will be rendered with your custom
*Handlebars* template or the default one. With this approach we try to keep it as simple
as possible to make it easier to integrate the documentations into you own layout.

### Namespaces

Librarianowl was built to work with the same namespace concept that has been used
to generate cssowl. Thus you'll need to structure your *YAML* file in the same way like:

```
src
└── cssowl
    ├── _imports.yml
    ├── position
    │   ├── absolute-inside.yml
    │   ├── absolute-outside.yml
    │   └── absolute.yml
    └── sprite
        ├── _imports.yml
        ├── absolute-inside.yml
        ├── absolute-outside.yml
        ├── absolute.yml
        ├── after-absolute-inside.yml
        ├── after-absolute-outside.yml
        ├── after-absolute.yml
        ├── after-float.yml
        ├── after-inline.yml
        ├── after.yml
        ├── before-absolute-inside.yml
        ├── before-absolute-outside.yml
        ├── before-absolute.yml
        ├── before-float.yml
        ├── before-inline.yml
        ├── before.yml
        ├── display-block.yml
        ├── display-inline.yml
        ├── display.yml
        ├── float-left.yml
        ├── float-right.yml
        ├── replace-block.yml
        ├── replace-inline.yml
        └── replace.yml
```

Compiled as library this will look like:

```
lib
├── less
│   ├── cssowl
│   │   ├── position.less
│   │   └── sprite.less
│   └── cssowl.less
├── sass
│   ├── cssowl
│   │   ├── position.sass
│   │   └── sprite.sass
│   └── cssowl.sass
├── scss
│   ├── cssowl
│   │   ├── position.scss
│   │   └── sprite.scss
│   └── cssowl.scss
└── styl
    ├── cssowl
    │   ├── position.styl
    │   └── sprite.styl
    └── cssowl.styl
```

And compiled as documentation it'll look like:

```
docs
└── cssowl
    ├── position
    │   ├── absolute-inside.html
    │   ├── absolute-outside.html
    │   └── absolute.html
    └── sprite
        ├── absolute-inside.html
        ├── absolute-outside.html
        ├── absolute.html
        ├── after-absolute-inside.html
        ├── after-absolute-outside.html
        ├── after-absolute.html
        ├── after-float.html
        ├── after-inline.html
        ├── after.html
        ├── before-absolute-inside.html
        ├── before-absolute-outside.html
        ├── before-absolute.html
        ├── before-float.html
        ├── before-inline.html
        ├── before.html
        ├── display-block.html
        ├── display-inline.html
        ├── display.html
        ├── float-left.html
        ├── float-right.html
        ├── replace-block.html
        ├── replace-inline.html
        └── replace.html
```

### YAML mixin definition

Taking the `src/cssowl/sprite/display.yml` file as an example a definition might look like this:

```
description: |
  Displays an element with it's *width*, *height*, *background-image* and *background-position*.
mixin:
  parameters:
    x: position of the element
    y: position of the element
    width: element width
    height: element height
    src: background image source
  less: |
    .cssowl-sprite-display(@x, @y, @width, @height, @src) {
      width: @width;
      height: @height;
      background-image: @src;
      background-position: @x @y;
      background-repeat: no-repeat;
    }
  sass: |
    @mixin cssowl-sprite-display($x, $y, $width, $height, $src)
      width: $width
      height: $height
      background-image: $src
      background-position: $x $y
      background-repeat: no-repeat
  scss: |
    @mixin cssowl-sprite-display($x, $y, $width, $height, $src) {
      width: $width;
      height: $height;
      background-image: $src;
      background-position: $x $y;
      background-repeat: no-repeat;
    }
  styl: |
    cssowl-sprite-display(x, y, width, height, src)
      width: width
      height: height
      background-image: src
      background-position: x y
      background-repeat: no-repeat
examples:
  sass: |
    .example-display
      +cssowl-sprite-display(-10px, -10px, 91px, 95px, url("sprite.png"));
  scss: |
    .example-display {
      @include cssowl-sprite-display(-10px, -10px, 91px, 95px, url("sprite.png"));
    }
  less: |
    .example-display {
      .cssowl-sprite-display(-10px, -10px, 91px, 95px, url("sprite.png"));
    }
  styl: |
    .example-display
      cssowl-sprite-display(-10px, -10px, 91px, 95px, url("sprite.png"))
  html: |
    .example-display

```

To *import* other files and to insure the import definitions are at the top of the file you can place a `_imports.yml` file into the directory that looks something like:

```
imports:
  less: |
    @import "cssowl/position";
    @import "cssowl/sprite";
  sass: |
    @import "cssowl/position"
    @import "cssowl/sprite"
  scss: |
    @import "cssowl/position";
    @import "cssowl/sprite";
  styl: |
    @import "cssowl/position"
    @import "cssowl/sprite"
```

### Generating the library

#### Method:

```
###
@param {String} source Source directory
@param {String} target Target directory
@param {Object} options Optional options
###
library: (source, target, options={}) ->
 ...
```

#### Options

##### template

Type: `String`
Default: `librarianowl/templates/library.hbs`

*Handlebars* template file to render the library file.

```
// {{{description}}}
{{#each mixin.parameters}}
// {{@key}}: {{{this}}}
{{/each}}
{{{mixin.syntax}}}
```

##### helpers

Type: `Object` `String`
Default: `{}`

You can define you custom helpers that will be available with the *Handlebars* template rendering. It can be either a object containing each helper or a external file in which you define your helpers:

```
# Helpers as an object
librarianowl.library "src", "docs",
  helpers:
    "trim": (val) ->
      return val.trim()

# Helpers in a seperate file
librarianowl.library "src", "docs",
  helpers: "helpers.js"

```

##### filename

Type: `Function`
Default: false

You can modify the target filename.

```
librarianowl.library "src", "docs",
  filename: (item, syntax) ->
      return "#{item.basename}.#{syntax}"
```

### Generating the documentation

#### Method:

```
###
@param {String} source Source directory
@param {String} target Target directory
@param {Object} options Optional options
###
documentation: (source, target, options={}) ->
 ...
```

#### Options

##### template

Type: `String`
Default: `librarianowl/templates/documentation.hbs`

*Handlebars* template file to render the documentation file.

```
<h2>{{mixinName}}</h2>

<p>{{{description}}}</p>

<ul class="nav nav-tabs">
  <li class="active">
    <a href="#example-{{{basename}}}-sass">Sass</a>
  </li>
  <li>
    <a href="#example-{{{basename}}}-scss">Scss</a>
  </li>
  <li>
    <a href="#example-{{{basename}}}-less">Less</a>
  </li>
  <li>
    <a href="#example-{{{basename}}}-styl">Stylus</a>
  </li>
  <li>
    <a href="#example-{{{basename}}}-html">Html</a>
  </li>
</ul>

<div class="tab-content">
  <code id="#example-{{{basename}}}-sass" class="tab-pane active">
    {{examples.sass}}
  </code>
  <code id="#example-{{{basename}}}-scss" class="tab-pane">
    {{examples.scss}}
  </code>
  <code id="#example-{{{basename}}}-less" class="tab-pane">
    {{examples.less}}
  </code>
  <code id="#example-{{{basename}}}-styl" class="tab-pane">
    {{examples.styl}}
  </code>
  <code id="#example-{{{basename}}}-html" class="tab-pane">
    {{examples.html}}
  </code>
</div>
```

##### helpers

Type: `Object` `String`
Default: `{}`

You can define you custom helpers that will be available with the *Handlebars* template rendering. It can be either a object containing each helper or a external file in which you define your helpers:

```
# Helpers as an object
librarianowl.documentation "src", "docs",
  helpers:
    "trim": (val) ->
      return val.trim()

# Helpers in a seperate file
librarianowl.documentation "src", "docs",
  helpers: "helpers.js"

```

##### filename

Type: `Function`
Default: false

You can modify the target filename.

```
librarianowl.documentation "src", "docs",
  filename: (item, syntax) ->
      return "#{item.basename}.#{syntax}"
```


### Generating the examples

#### Method:

```
###
@param {String} source Source directory
@param {String} target Target directory
@param {Object} options Optional options
###
examples: (source, target, options={}) ->
 ...
```

#### Options

##### template

Type: `String`
Default: `librarianowl/templates/examples.hbs`

*Handlebars* template file to render the documentation file.

```
{{{examples.syntax}}}
```

##### helpers

Type: `Object` `String`
Default: `{}`

You can define you custom helpers that will be available with the *Handlebars* template rendering. It can be either a object containing each helper or a external file in which you define your helpers:

```
# Helpers as an object
librarianowl.examples "src", "examples",
  helpers:
    "trim": (val) ->
      return val.trim()

# Helpers in a seperate file
librarianowl.examples "src", "examples",
  helpers: "helpers.js"

```

##### filename

Type: `Function`
Default: false

You can modify the target filename.

```
librarianowl.examples "src", "examples",
  filename: (item, syntax) ->
      return "#{item.basename}.#{syntax}"
```

##### imports

Type: `Function`
Default: false

Return a string that should be prepended to the generated file.

```
librarianowl.examples "src", "examples",
  imports: (syntax) ->
    switch syntax
      when "sass" then return "@import 'path/to/file'"
      when "scss" then return "@import 'path/to/file';"
      when "less" then return "@import 'path/to/file';"
      when "styl" then return "@import 'path/to/file'"
```


## Contributing
[![I Love Open Source](http://www.iloveopensource.io/images/logo-lightbg.png)](http://www.iloveopensource.io/projects/5319a6a987659fce66000a34)

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright (c) Owl-Stars under the MIT license.
