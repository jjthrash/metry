= Metry

* http://terralien.com

== DESCRIPTION:

Metry aims to close the gap between knowing you ought to be making decisions based on hard data about how visitors are using your site, and actually doing it. It currently provides fast and robust visitor tracking and easy to run experiments.

== FEATURES:

* Easy to plug in Rack middleware for tracking site usage.
* Uses ultra-fast Tokyo Cabinet storage.
* Includes a Radiant extension for running experiments.

== SYNOPSIS:

  With the Radiant extension installed, you can run experiments like this:
  
    <r:metry:experiment name="test">
      Control
      <r:alternative name="one">
        Alternative 1
      </r:alternative>
      <r:alternative name="two">
        Alternative 2
      </r:alternative>
    </r:metry:experiment>

== REQUIREMENTS:

* Tokyo Cabinet
* Tokyo Cabinet Ruby Binding
* Rack
* ffi gem

== INSTALL:

* sudo gem install metry
* Symlink the Radiant extension

== LICENSE:

(The MIT License)

Copyright (c) 2009 Terralien, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
