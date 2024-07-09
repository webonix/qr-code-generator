<!DOCTYPE html>
<html>
<head>
    <title>Lucee QR Code Generator</title>

    <style>
        pre {
            background-color: #f4f4f4;
            padding: 10px;
            border: 1px solid #ddd;
            overflow-x: auto;
        }
        code {
            font-family: monospace;
            color: #333;
        }
    </style>

</head>
<body>

<h1>Lucee QR Code Generator</h1>


<div>
    <cfscript>
        zxing = new com.google.zxing();

        logoPath = expandPath("/labs/qr-code/images/github-mark.jpg");

        base64String = zxing.createQRBinary(
            content         = "https://github.com/webonix/qr-code-generator/",
            size            = 600,
            margin          = 1,
            fgColorHex      = "25292e",
            bgColorHex      = "ffffff",
            errorCorrection = "H",
            logoPath        = logoPath
        );
    </cfscript>
    <cfoutput><img src="data:image/png;base64,#base64String#" height="600px"></cfoutput>
</div>

<pre><code>
    &lt;cfscript&gt;
        zxing = new com.google.zxing();

        logoPath = expandPath("/labs/qr-code/images/github-mark.jpg");

        base64String = zxing.createQRBinary(
            content         = "https://github.com/webonix/qr-code-generator/",
            size            = 600,
            margin          = 1,
            fgColorHex      = "25292e",
            bgColorHex      = "ffffff",
            errorCorrection = "H",
            logoPath        = logoPath
        );
    &lt;/cfscript&gt;
    &lt;cfoutput&gt;&lt;img src="data:image/png;base64,#base64String#" height="600px"&gt;&lt;/cfoutput&gt;
</code></pre>


</body>
</html>
