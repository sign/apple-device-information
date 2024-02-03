# Apple Device Information

This repository contains information about Apple devices.

For each device type,
the device type, orientation, userAgent, and viewport are listed, including safe area specifications.
```json
{
  "deviceScaleFactor" : 3,
  "dimensions" : {
    "width" : 393,
    "height" : 852
  },
  "safeAreaInsets" : {
    "top" : 59,
    "bottom" : 34,
    "trailing" : 0,
    "leading" : 0
  },
  "isMobile" : true,
  "hasTouch" : true,
  "userAgent" : "Mozilla\/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit\/605.1.15 (KHTML, like Gecko) Mobile\/15E148"
}
```

## Automation

To collect the information for more devices, dependeing on simulators available on your machine, 
you can run the following command:
```bash
./collect_device_information.sh
```