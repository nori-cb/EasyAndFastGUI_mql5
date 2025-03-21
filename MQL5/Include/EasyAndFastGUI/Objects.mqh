//+------------------------------------------------------------------+
//|                                                      Objects.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Enums.mqh"
#include "Defines.mqh"
#include "Fonts.mqh"
#include "Canvas\Charts\LineChart.mqh"
#include <ChartObjects\ChartObjectSubChart.mqh>
//--- List of classes in file for quick navigation (Alt+G)
class CImage;
class CRectCanvas;
class CLineChartObject;
class CSubChart;
//+------------------------------------------------------------------+
//| Class for storing the image data                                 |
//+------------------------------------------------------------------+
class CImage
  {
protected:
   uint              m_image_data[]; // Array of the image pixels (colors)
   uint              m_image_width;  // Image width
   uint              m_image_height; // Image height
   string            m_bmp_path;     // Path to the image file
   //---
public:
                     CImage(void);
                    ~CImage(void);
   //--- (1) Size of the data array, (2) set/return the data (pixel color)
   uint              DataTotal(void)                             { return(::ArraySize(m_image_data)); }
   uint              Data(const uint data_index)                 { return(m_image_data[data_index]);  }
   void              Data(const uint data_index,const uint data) { m_image_data[data_index]=data;     }
   //--- Set/return the image width
   void              Width(const uint width)                     { m_image_width=width;               }
   uint              Width(void)                                 { return(m_image_width);             }
   //--- Set/return the image height
   void              Height(const uint height)                   { m_image_height=height;             }
   uint              Height(void)                                { return(m_image_height);            }
   //--- Set/return the path to the image
   void              BmpPath(const string bmp_file_path)         { m_bmp_path=bmp_file_path;          }
   string            BmpPath(void)                               { return(m_bmp_path);                }
   //--- Read and store the data of the passed image
   bool              ReadImageData(const string bmp_file_path);
   //--- Copies the data of the passed image
   void              CopyImageData(CImage &array_source);
   //--- Deletes image data
   void              DeleteImageData(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CImage::CImage(void) : m_image_width(0),
                       m_image_height(0),
                       m_bmp_path("")
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CImage::~CImage(void)
  {
   DeleteImageData();
  }
//+------------------------------------------------------------------+
//| Store the passed image to an array                               |
//+------------------------------------------------------------------+
bool CImage::ReadImageData(const string bmp_file_path)
  {
//--- Leave, if an empty string
   if(bmp_file_path=="")
      return(false);
//--- Store the path to the image
   m_bmp_path=bmp_file_path;
//--- Reset the last error
   ::ResetLastError();
//--- Read and store the image data
   if(!::ResourceReadImage("::"+m_bmp_path,m_image_data,m_image_width,m_image_height))
     {
      ::Print(__FUNCTION__," > Error when reading the image ("+m_bmp_path+"): ",::GetLastError());
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Copies the data of the passed image                              |
//+------------------------------------------------------------------+
void CImage::CopyImageData(CImage &array_source)
  {
//--- Get the size of the source array
   uint source_data_total =array_source.DataTotal();
//--- Resize the receiver array
   ::ArrayResize(m_image_data,source_data_total);
//--- Copy the data
   for(uint i=0; i<source_data_total; i++)
      m_image_data[i]=array_source.Data(i);
  }
//+------------------------------------------------------------------+
//| Deletes the image data                                            |
//+------------------------------------------------------------------+
void CImage::DeleteImageData(void)
  {
   ::ArrayFree(m_image_data);
   m_image_width  =0;
   m_image_height =0;
   m_bmp_path     ="";
  }
//+------------------------------------------------------------------+
//| Class with additional properties for Rectangle Canvas object     |
//+------------------------------------------------------------------+
class CRectCanvas : public CCustomCanvas
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CRectCanvas(void);
                    ~CRectCanvas(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRectCanvas::CRectCanvas(void) : m_x(0),
                                 m_y(0),
                                 m_x2(0),
                                 m_y2(0),
                                 m_x_gap(0),
                                 m_y_gap(0),
                                 m_x_size(0),
                                 m_y_size(0),
                                 m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CRectCanvas::~CRectCanvas(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Line Chart object       |
//+------------------------------------------------------------------+
class CLineChartObject : public CLineChart
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
public:
                     CLineChartObject(void);
                    ~CLineChartObject(void);
   //---
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //---
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLineChartObject::CLineChartObject(void) : m_x(0),
                                           m_y(0),
                                           m_x2(0),
                                           m_y2(0),
                                           m_x_gap(0),
                                           m_y_gap(0),
                                           m_x_size(0),
                                           m_y_size(0),
                                           m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLineChartObject::~CLineChartObject(void)
  {
  }
//+------------------------------------------------------------------+
//| Class with additional properties for the Sub Chart object        |
//+------------------------------------------------------------------+
class CSubChart : public CChartObjectSubChart
  {
protected:
   int               m_x;
   int               m_y;
   int               m_x2;
   int               m_y2;
   int               m_x_gap;
   int               m_y_gap;
   int               m_x_size;
   int               m_y_size;
   bool              m_mouse_focus;
   //---
public:
                     CSubChart(void);
                    ~CSubChart(void);
   //--- Coordinates
   int               X(void)                      { return(m_x);           }
   void              X(const int x)               { m_x=x;                 }
   int               Y(void)                      { return(m_y);           }
   void              Y(const int y)               { m_y=y;                 }
   int               X2(void)                     { return(m_x+m_x_size);  }
   int               Y2(void)                     { return(m_y+m_y_size);  }
   //--- Margins from the edge point (xy)
   int               XGap(void)                   { return(m_x_gap);       }
   void              XGap(const int x_gap)        { m_x_gap=x_gap;         }
   int               YGap(void)                   { return(m_y_gap);       }
   void              YGap(const int y_gap)        { m_y_gap=y_gap;         }
   //--- Size
   int               XSize(void)                  { return(m_x_size);      }
   void              XSize(const int x_size)      { m_x_size=x_size;       }
   int               YSize(void)                  { return(m_y_size);      }
   void              YSize(const int y_size)      { m_y_size=y_size;       }
   //--- Focus
   bool              MouseFocus(void)             { return(m_mouse_focus); }
   void              MouseFocus(const bool focus) { m_mouse_focus=focus;   }
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSubChart::CSubChart(void) : m_x(0),
                             m_y(0),
                             m_x2(0),
                             m_y2(0),
                             m_x_gap(0),
                             m_y_gap(0),
                             m_x_size(0),
                             m_y_size(0),
                             m_mouse_focus(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSubChart::~CSubChart(void)
  {
  }
//+------------------------------------------------------------------+
