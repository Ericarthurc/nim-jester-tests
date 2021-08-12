# Package

version       = "0.0.1"
author        = "Eric Christensen"
description   = "A new awesome nimble package"
license       = "ISC"
srcDir        = "src"
bin           = @["server"]


# Dependencies

requires "nim >= 1.4.8"
requires "jester >= 0.5.0"
requires "karax >= 0.4.4"
requires "nmark >= 0.1.9"