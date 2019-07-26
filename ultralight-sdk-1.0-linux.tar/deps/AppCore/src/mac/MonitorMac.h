#pragma once
#include <AppCore/Monitor.h>
#import "Cocoa/Cocoa.h"

namespace ultralight {
    
class MonitorMac : public Monitor {
public:
  MonitorMac();
  virtual ~MonitorMac() {}

  virtual double scale() const override;

  virtual int width() const override;

  virtual int height() const override;

protected:
  NSScreen* screen_;
};

}  // namespace ultralight

