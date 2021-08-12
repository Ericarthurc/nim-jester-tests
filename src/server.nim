import jester
import karax/[karaxdsl, vdom]
import nmark
import strutils, options, sequtils, sugar, os

proc sharedHead*(title: string): VNode =
  let vNode = buildHtml(head):
    title: text title & " - " & "testAPP"
    link(rel = "preconnect", href = "https://fonts.googleapis.com")
    link(rel = "preconnect", href = "https://fonts.gstatic.com",
        attrs = "crossorigin")
    link(href = "https://fonts.googleapis.com/css2?family=Rubik:wght@400;700&display=swap",
        rel = "stylesheet")
    link(rel = "stylesheet", href = "/styles/main.css")
    script(src = "/js/highlight.min.js")
  return vNode

proc indexSection*(title: string, parsedMarkdown: string): VNode =
  result = buildHtml(main(class = "content")):
    h3: text "TEST: " & title
    tdiv(): verbatim parsedMarkdown
    script(): text "hljs.highlightAll();"
    script(src = "/js/version.js")

proc indexPage*(title: string, parsedMarkdown: string): string =
  let head = sharedHead(title)
  let body = indexSection(title, parsedMarkdown)
  let vNode = buildHtml(html):
    head
    body

  result = "<!DOCTYPE html>\n" & $vNode

proc markdownParser(rawData: string): string =
  var lined = rawData.split("---")[2]
  return lined.markdown

proc getHTMLMarkdown*(): string =
  var data = readFile("./markdown/wild-memo-2019-9-9.markdown")
  return markdownParser(data)

proc indexHandler(): string =
  let parsedMarkdown = getHTMLMarkdown()
  return indexPage("InDeX", parsedMarkdown)

router myrouter:
  get "/":
    echo request.headers
    resp indexHandler()

proc main() =
  let port = Port(4010)
  let settings = newSettings(port = port, staticDir = "static")
  var jester = initJester(myrouter, settings = settings)
  jester.serve()

when isMainModule:
  main()
