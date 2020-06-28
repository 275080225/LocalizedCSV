#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BRACalcChain.h"
#import "BRACalcChainCell.h"
#import "BRACell.h"
#import "BRACellFill.h"
#import "BRACellFormat.h"
#import "BRACellRange.h"
#import "BRAColumn.h"
#import "BRAComment.h"
#import "BRAComments.h"
#import "BRAContentTypes.h"
#import "BRAContentTypesDefaultExtension.h"
#import "BRAContentTypesOverride.h"
#import "BRADrawing.h"
#import "BRAElementWithRelationships.h"
#import "BRAImage.h"
#import "BRAMergeCell.h"
#import "BRANumberFormat.h"
#import "BRAOfficeDocument.h"
#import "BRAOfficeDocumentPackage.h"
#import "BRAOpenXmlElement.h"
#import "BRAOpenXmlSubElement.h"
#import "BRAPlatformSpecificDefines.h"
#import "BRARelatedToColumnAndRowProtocol.h"
#import "BRARelationship.h"
#import "BRARelationships.h"
#import "BRARow.h"
#import "BRASharedString.h"
#import "BRASharedStrings.h"
#import "BRASheet.h"
#import "BRAStyles.h"
#import "BRATheme.h"
#import "BRAVmlDrawing.h"
#import "BRAWorksheet.h"
#import "BRAWorksheetDrawing.h"
#import "NativeColor+HTML.h"
#import "NativeColor+OpenXML.h"
#import "NativeFont+BoldItalic.h"
#import "NSDictionary+DeepCopy.h"
#import "NSDictionary+OpenXMLDictionaryParser.h"
#import "NSDictionary+OpenXmlString.h"
#import "XlsxReaderWriter-swift-bridge.h"

FOUNDATION_EXPORT double XlsxReaderWriterVersionNumber;
FOUNDATION_EXPORT const unsigned char XlsxReaderWriterVersionString[];

