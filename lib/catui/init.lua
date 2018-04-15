--[[
The MIT License (MIT)

Copyright (c) 2016 WilhanTian  田伟汉

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]] --

utf8 = require "utf8"
class = require "lib/catui.libs.30log"

require "lib/catui.Core.UIDefine"

theme = require "lib/catui.UITheme"

point = require "lib/catui.Utils.Utils"
Rect = require "lib/catui.Core.Rect"
UIEvent = require "lib/catui.Core.UIEvent"
UIControl = require "lib/catui.Core.UIControl"
UIRoot = require "lib/catui.Core.UIRoot"
UIManager = require "lib/catui.Core.UIManager"
UILabel = require "lib/catui.Control.UILabel"
UIButton = require "lib/catui.Control.UIButton"
UIImage = require "lib/catui.Control.UIImage"
UIScrollBar = require "lib/catui.Control.UIScrollBar"
UIContent = require "lib/catui.Control.UIContent"
UICheckBox = require "lib/catui.Control.UICheckBox"
UIProgressBar = require "lib/catui.Control.UIProgressBar"
UIEditText = require "lib/catui.Control.UIEditText"
