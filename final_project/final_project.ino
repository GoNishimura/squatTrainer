/********************************************************************************
  ADXL345 Library Examples- pitch_roll.ino
*                                                                               *
  Copyright (C) 2012 Anil Motilal Mahtani Mirchandani(anil.mmm@gmail.com)
*                                                                               *
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.
*                                                                               *
*********************************************************************************/

#include <Wire.h>
#include "ADXL345.h"

const float alpha = 0.5;
double fXg[2];
double fYg[2];
double fZg[2];

ADXL345 acc1(0x53); // lower SDO
ADXL345 acc2(0x1D); // higher SDO

void setup()
{
  acc1.begin();
  acc2.begin();
  Serial.begin(9600);
  delay(100);
}


void loop()
{
  double pitch[2], roll[2], Xg[2], Yg[2], Zg[2], hpv[2];

  acc1.read(&Xg[0], &Yg[0], &Zg[0]);
  acc2.read(&Xg[1], &Yg[1], &Zg[1]);

  //Low Pass Filter
  fXg[0] = Xg[0] * alpha + (fXg[0] * (1.0 - alpha));
  fYg[0] = Yg[0] * alpha + (fYg[0] * (1.0 - alpha));
  fZg[0] = Zg[0] * alpha + (fZg[0] * (1.0 - alpha));
  fXg[1] = Xg[1] * alpha + (fXg[1] * (1.0 - alpha));
  fYg[1] = Yg[1] * alpha + (fYg[1] * (1.0 - alpha));
  fZg[1] = Zg[1] * alpha + (fZg[1] * (1.0 - alpha));

//  Roll & Pitch Equations
  pitch[0] = (atan2(fXg[0], sqrt(fYg[0] * fYg[0] / 100 + fZg[0] * fZg[0])) * 180.0) / M_PI;
  pitch[1] = (atan2(fXg[1], sqrt(fYg[1] * fYg[1] + fZg[1] * fZg[1])) * 180.0) / M_PI;

  Serial.print(int(100 * pitch[0]));
  Serial.print(":");
  Serial.println(int(100 * pitch[1]));

  delay(1000);
}

