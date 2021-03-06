Attribute VB_Name = "MTests"
Option Explicit

' Copyright (c) 2017 Jason Peter Brown <jason@bitspaces.com>
'
' MIT License
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.

Public Sub TestHtml()
   Dim y As New CBuilders
   Dim x As CBuilderHtml
   Dim l_TagIndex As Long
   
   Set x = y.Builder(builder_Html)
   
   x.AppendDocType htmldoctype_Html5
   x.OpenTags "html"
   l_TagIndex = x.OpenTags("head")
   x.AppendWithTag "Test page", "title"
   x.CloseOpenedTagsToIndex l_TagIndex
   x.Append vbNewLine
   
   x.OpenTags "body"
   l_TagIndex = x.OpenTags("table", "tr")
   x.AppendWithTag "This is a test & stuff.", "td"
   x.CloseLastOpenedTag
   x.OpenTags "tr"
   x.AppendWithTag "This is a test2.", "td"
   x.CloseOpenedTagsToIndex l_TagIndex
   
   x.OpenHyperlinkTag "http://www.statslog.com"
   x.CloseAllOpenedTags ' Optional, calling Finished will also take care of this.
   
   x.Finish contentencoding_UTF16_LE
   
   Debug.Print stringIso88591ToVb(x.IBuilderInterface.HttpHeader.Content(True))
   Debug.Print y.Builder.Content
End Sub

Public Sub TestCollection()
   Dim x As vbRichClient5.cCollection
   
   Set x = libRc5Factory.C.Collection(False)
   
   x.Add "AD"
   
   Debug.Print x.KeyByIndex(0) = ""
End Sub
   
Public Sub TestTemplate()
   Dim xx As New CTests
   
   xx.TestTemplateInfiniteLoopProtection
End Sub

Sub TestJson()
   Dim lo_Json As VbFcgiLib.CBuilderJson
         
   ' Initialize to empty JSON Object collection
   Set lo_Json = New VbFcgiLib.CBuilderJson
   lo_Json.Initialize Nothing
   ' Add some data
   lo_Json.IJsonObject.AddJsonObjectByKeyValuePairs "Info", "status", 200, "message", "OK"
   lo_Json.IJsonObject.AddJsonObjectByKeyValuePairs "MyObject", "test", "test2"
   lo_Json.IJsonObject.AddJsonArrayByValues "A", "B", "C"
   
   lo_Json.Finish contentencoding_RecommendedDefault

   Debug.Print stringUtf8ToVb(lo_Json.Content)
   
   ' Initialize to empty JSON Array collection
   Set lo_Json = New VbFcgiLib.CBuilderJson
   lo_Json.Initialize Array() ' .AddJsonArrayByValues ""
   
   lo_Json.IJsonObject.AddJsonObjectByKeyValuePairs "status", 200, "message", "OK"
   lo_Json.IJsonObject.AddJsonObjectByKeyValuePairs "test", "test2"
   lo_Json.IJsonObject.AddJsonArrayByValues "A", "B", "C"
      
   lo_Json.Finish contentencoding_RecommendedDefault

   Debug.Print stringUtf8ToVb(lo_Json.Content)

   ' Initialize to empty JSON collection
   Set lo_Json = New VbFcgiLib.CBuilderJson
   ' Add some data
   lo_Json.IJsonObject.AddJsonObjectByKeyValuePairs "status", 200, "message", "OK"

   lo_Json.Finish contentencoding_RecommendedDefault

   Debug.Print stringUtf8ToVb(lo_Json.Content)
End Sub

Public Sub TestSimulator()
   Dim lo_App As New VbFcgiLib.CSimulatorFcgiApp
   Dim lo_Sim As New VbFcgiLib.CSimulator
   
   lo_Sim.SimulateRequest "http://localhost/vbfcgiapp.fgci?a=b&c=d", lo_App
End Sub
