# Lucee QR Code generator

Lucee CFML Utilty for creating QR Codes

This utility uses ZXing ("zebra crossing") Java library [https://github.com/zxing/zxing/releases](https://github.com/zxing/zxing/releases)

---

## Sample Usage

```cfm
<div>
    <cfscript>
        zxing = new com.google.zxing();

        logoPath = expandPath("/images/github-mark.jpg");

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
```

![Sample QR Code](images/github-webonix-qr-repo.png)

### API to create an image

```cfm
<cfparam name="url.content" default="https://webonix.net">
<cfparam name="url.size" default="200" type="integer">
<cfparam name="url.margin" default="10" type="integer">
<cfparam name="url.fgColorHex" default="000000">
<cfparam name="url.bgColorHex" default="ffffff">
<cfparam name="url.errorCorrection" default="L" hint="L=low H=high">

<cfscript>
    zxing = new com.google.zxing();
    base64String = zxing.createQRByteArray(
        content         = url.content,
        size            = url.size,
        margin          = url.margin,
        fgColorHex      = url.fgColorHex,
        bgColorHex      = url.bgColorHex,
        errorCorrection = url.errorCorrection
    )
</cfscript>


<cfheader name="Content-Disposition" value='inline;filename="#url.content#"'>
<cfcontent type="image/png" variable="#base64String#">
```  
