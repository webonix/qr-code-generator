
/*
    https://github.com/zxing/zxing/tree/master

        https://jar-download.com/artifacts/com.google.zxing/core
        https://jar-download.com/artifacts/com.google.zxing/javase
*/
component {
    variables.cfcPath = expandPath(GetDirectoryFromPath(getCurrentTemplatePath()));

    variables.jarFiles = [
        "#variables.cfcPath#/lib/core-3.5.1.jar",
        "#variables.cfcPath#/lib/javase-3.5.1.jar" 
    ];

    function init () {
        return this;
    }

    function createQRBinary (
        required string content,
                 number size            = 200,
                 number margin          = 10,
                 string fgColorHex      = "00000",
                 string bgColorHex      = "FFFFFF",
                 string errorCorrection = "L"
    ) localmode= true {
        image = createQRImage(argumentcollection = arguments);

        byte = createQRByteArray(argumentcollection = arguments);

        // Encode the byte array to Base64
        base64Encoder = createObject("java", "java.util.Base64").getEncoder();
        base64String = base64Encoder.encodeToString(byte);

        return base64String;
    }

    
    function createQRByteArray(
        required string content,
                 number size = 200,
                 number margin = 10,
                 string fgColorHex = "00000",
                 string bgColorHex = "FFFFFF",
                 string errorCorrection="L"
    ) localmode= true {
        image = createQRImage(argumentcollection = arguments);

        // Create a ByteArrayOutputStream
        baos = createObject("java", "java.io.ByteArrayOutputStream").init();

        // Write the image to the ByteArrayOutputStream
        ImageIO = createObject("java", "javax.imageio.ImageIO");
        ImageIO.write(image, "PNG", baos);

        // Convert the ByteArrayOutputStream to a byte array
        byte = baos.toByteArray();

        return byte;
    }
    
    private function createQRImage (
        required string content,
        required number size,
        required number margin,
        required string fgColorHex,
        required string bgColorHex,
        required string errorCorrection,
        required string logoPath
    ) localmode= true {
        Paths = createObject("java", "java.nio.file.Paths" ); //dump(Paths);

        // Create a QR Code writer
        BarcodeFormat        = createObject("java", "com.google.zxing.BarcodeFormat", jarFiles);
        MatrixToImageWriter  = createObject("java", "com.google.zxing.client.j2se.MatrixToImageWriter", jarFiles );
        qrWriter             = createObject("java", "com.google.zxing.qrcode.QRCodeWriter", jarFiles).init();
        EncodeHintType       = createObject("java", "com.google.zxing.EncodeHintType", jarFiles);
        Hashtable            = createObject("java", "java.util.Hashtable");
        ErrorCorrectionLevel = createObject("java", "com.google.zxing.qrcode.decoder.ErrorCorrectionLevel", jarFiles);

        // Create a hashtable to store the encoding hints
        hints = Hashtable.init();
        hints.put(EncodeHintType.MARGIN, javaCast("int", arguments.margin));  // Set the margin to 1 module
        
        if (ARGUMENTS.errorCorrection == 'H') {
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H); // use high correction level so image can be placed in the centre
        }
        // Set the QR Code data and encoding details
        bitMatrix = qrWriter.encode(
            arguments.content,
            BarcodeFormat.QR_CODE,
            arguments.size, 
            arguments.size,
            hints
        );

        // Create a buffered image to draw the QR Code
        BufferedImage = createObject("java", "java.awt.image.BufferedImage");
        qrImage       = createObject("java", "java.awt.image.BufferedImage").init(
            bitMatrix.getWidth(), 
            bitMatrix.getHeight(), 
            BufferedImage.TYPE_INT_RGB
        );

        // Convert hex to RGB
        fgColor = createObject("java", "java.awt.Color").init(
            javaCast("int", inputBaseN(arguments.fgColorHex, 16))
        );
        bgColor = createObject("java", "java.awt.Color").init(
            javaCast("int", inputBaseN(arguments.bgColorHex, 16))
        );

        // Draw the QR Code on the image
        for ( i = 0; i < bitMatrix.getWidth(); i++) {
            for ( j = 0; j < bitMatrix.getHeight(); j++) {
                qrImage.setRGB(i, j, bitMatrix.get(i, j) ? fgColor.getRGB() : bgColor.getRGB());
            }
        }

        if ( arguments.logoPath != '') {
            // Load the overlay image (e.g., a logo)
            overlayImage = imageRead(arguments.logoPath);

            // Given QR code size of 200x200 pixels, calculate the overlay size to be 1/5 of the QR code's dimensions
            maxWidth = qrImage.getWidth() / 4; // 200 / 5 = 40 pixels
            maxHeight = qrImage.getHeight() / 4; // 200 / 5 = 40 pixels

            // Scale the overlay image to fit within the calculated size while maintaining aspect ratio
            imageScaleToFit(overlayImage, maxWidth, maxHeight);

            // Calculate the position for the overlay (centering the overlay on the QR code)
            x = (qrImage.getWidth() - overlayImage.getWidth()) / 2; // Center horizontally
            y = (qrImage.getHeight() - overlayImage.getHeight()) / 2; // Center vertically

            // Overlay the image onto the QR code
            imagePaste(qrImage, overlayImage, x, y);
        }

        return qrImage;
    }
}
