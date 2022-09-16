# R_utilities

This repo is a fork of [R_utilities](https://github.com/ChristopherEeles/R_utilities.git). It's modified for compiling R on machines running on Apple silicon. Currently `compile_R.sh` still doesn't work properly on Monterey due to `grDevices` package failling to build. I'm new to MacOS so I'm posting the error message here and hoping someone with expert knowledge of MacOS can help figure out the cause of this (I doubt the issue is upstream with the latest version of Xcode SDK).
```
In file included from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGContext.h:21,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGBitmapContext.h:9,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CoreGraphics.h:11,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Headers/ApplicationServices.h:35,
                 from ../../../../include/R_ext/QuartzDevice.h:103,
                 from devQuartz.c:36:
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPath.h:391:15: error: expected identifier or ‘(’ before ‘^’ token
  391 | typedef void (^CGPathApplyBlock)(const CGPathElement * element);
      |               ^
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPath.h:393:53: error: unknown type name ‘CGPathApplyBlock’
  393 | CG_EXTERN void CGPathApplyWithBlock(CGPathRef path, CGPathApplyBlock CF_NOESCAPE block)
      |                                                     ^~~~~~~~~~~~~~~~
In file included from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFDictionary.h:14,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFPage.h:15,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFDocument.h:16,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGContext.h:23:
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFArray.h:103:15: error: expected identifier or ‘(’ before ‘^’ token
  103 | typedef bool (^CGPDFArrayApplierBlock)(size_t index,
      |               ^
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFArray.h:113:5: error: unknown type name ‘CGPDFArrayApplierBlock’
  113 |     CGPDFArrayApplierBlock cg_nullable block, void * __nullable info)
      |     ^~~~~~~~~~~~~~~~~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFDictionary.h:116:15: error: expected identifier or ‘(’ before ‘^’ token
  116 | typedef bool (^CGPDFDictionaryApplierBlock)(const char * key,
      |               ^
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreGraphics.framework/Headers/CGPDFDictionary.h:126:5: error: unknown type name ‘CGPDFDictionaryApplierBlock’; did you mean ‘CGPDFDictionaryApplierFunction’?
  126 |     CGPDFDictionaryApplierBlock cg_nullable block, void * __nullable info)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |     CGPDFDictionaryApplierFunction
In file included from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreText.framework/Headers/CoreText.h:23,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Headers/ApplicationServices.h:39:
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/CoreText.framework/Headers/CTFontManager.h:380:34: error: expected ‘)’ before ‘^’ token
  380 |         bool                    (^ _Nullable registrationHandler)(CFArrayRef errors, bool done) ) CT_AVAILABLE(ios(13.0)) API_UNAVAILABLE(macos, watchos, tvos);
      |                                  ^
      |                                  )
In file included from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ImageIO.framework/Headers/ImageIO.h:20,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Headers/ApplicationServices.h:47:
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ImageIO.framework/Headers/CGImageAnimation.h:42:15: error: expected identifier or ‘(’ before ‘^’ token
   42 | typedef void (^CGImageSourceAnimationBlock)(size_t index, CGImageRef image, bool* stop);
      |               ^
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ImageIO.framework/Headers/CGImageAnimation.h:50:107: error: unknown type name ‘CGImageSourceAnimationBlock’
   50 | IMAGEIO_EXTERN OSStatus CGAnimateImageAtURLWithBlock(CFURLRef url, CFDictionaryRef _iio_Nullable options, CGImageSourceAnimationBlock block) IMAGEIO_AVAILABLE_STARTING(10.15, 13.0);
      |                                                                                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ImageIO.framework/Headers/CGImageAnimation.h:58:108: error: unknown type name ‘CGImageSourceAnimationBlock’
   58 | IMAGEIO_EXTERN OSStatus CGAnimateImageDataWithBlock(CFDataRef data, CFDictionaryRef _iio_Nullable options, CGImageSourceAnimationBlock block) IMAGEIO_AVAILABLE_STARTING(10.15, 13.0);
      |                                                                                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
devQuartz.c: In function ‘RQuartz_Font’:
devQuartz.c:660:13: warning: ‘ATSFontFindFromName’ is deprecated [-Wdeprecated-declarations]
  660 |             atsFont = ATSFontFindFromName(cfFontName, kATSOptionFlagsDefault);
      |             ^~~~~~~
In file included from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATS.h:32,
                 from /opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Headers/ApplicationServices.h:27:
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:811:1: note: declared here
  811 | ATSFontFindFromName(
      | ^~~~~~~~~~~~~~~~~~~
devQuartz.c:662:17: warning: ‘ATSFontFindFromPostScriptName’ is deprecated [-Wdeprecated-declarations]
  662 |                 atsFont = ATSFontFindFromPostScriptName(cfFontName, kATSOptionFlagsDefault);
      |                 ^~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:828:1: note: declared here
  828 | ATSFontFindFromPostScriptName(
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
devQuartz.c:689:17: warning: ‘ATSFontFindFromName’ is deprecated [-Wdeprecated-declarations]
  689 |                 atsFont = ATSFontFindFromName(cfFontName, kATSOptionFlagsDefault);
      |                 ^~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:811:1: note: declared here
  811 | ATSFontFindFromName(
      | ^~~~~~~~~~~~~~~~~~~
devQuartz.c:690:17: warning: ‘ATSFontFindFromPostScriptName’ is deprecated [-Wdeprecated-declarations]
  690 |                 if (!atsFont) atsFont = ATSFontFindFromPostScriptName(cfFontName, kATSOptionFlagsDefault);
      |                 ^~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:828:1: note: declared here
  828 | ATSFontFindFromPostScriptName(
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
devQuartz.c:696:25: warning: ‘ATSFontFindFromName’ is deprecated [-Wdeprecated-declarations]
  696 |                         atsFont = ATSFontFindFromName(cfFontName, kATSOptionFlagsDefault);
      |                         ^~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:811:1: note: declared here
  811 | ATSFontFindFromName(
      | ^~~~~~~~~~~~~~~~~~~
devQuartz.c:702:29: warning: ‘ATSFontFindFromName’ is deprecated [-Wdeprecated-declarations]
  702 |                             atsFont = ATSFontFindFromName(cfFontName, kATSOptionFlagsDefault);
      |                             ^~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:811:1: note: declared here
  811 | ATSFontFindFromName(
      | ^~~~~~~~~~~~~~~~~~~
devQuartz.c:710:25: warning: ‘ATSFontFindFromName’ is deprecated [-Wdeprecated-declarations]
  710 |                         atsFont = ATSFontFindFromName(cfFontName, kATSOptionFlagsDefault);
      |                         ^~~~~~~
/opt/R/arm64/gfortran/SDK/System/Library/Frameworks/ApplicationServices.framework/Frameworks/ATS.framework/Headers/ATSFont.h:811:1: note: declared here
  811 | ATSFontFindFromName(
      | ^~~~~~~~~~~~~~~~~~~
```
