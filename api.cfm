<cfparam name="url.content" default="https://webonix.net">
<cfparam name="url.size" default="600" type="integer">
<cfparam name="url.margin" default="10" type="integer">
<cfparam name="url.fgColorHex" default="000000">
<cfparam name="url.bgColorHex" default="ffffff">
<cfparam name="url.errorCorrection" default="L">


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
