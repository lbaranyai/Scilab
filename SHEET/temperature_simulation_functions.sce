// SHEET Project - Fruit thermodynamic model
// Author: Baranyai @ MATE

//
// Model parameters
//

// Maximum solar radiation, J
RMAX = 2150;
// Envitonment temperature range, degree C
TMIN = 10;
TMAX = 38;
// Fruit parameters
// [Mass kg, Surface m2, Heat transfer W/m2K, Specific heat J/kgK]
FR = [0.25 0.0314 2.43 3829];


//
// Functions
//

// Solar radiation
// Input:
// (1) - sin [-1,+1]
// (2) - amplitude
// (3) - offset
function [RV] = mRadiation(dv)
 RV = max(0, dv(3)+dv(2)*dv(1));
endfunction

// Daily temperature fluctuation
// Input:
// (1) - sin [-1,+1]
// (2) - min T, °C
// (3) - max T, °C
function [RV] = mDTemperature(dv)
 RV = dv(2)+(dv(3)-dv(2))*(dv(1)/2+0.5).^2;
endfunction

// Fruit temperature change
// Input:
// (1) - daily temperature, °C
// (2) - solar radiation, J
// (3) - fruit mass, kg
// (4) - fruit surface, m2
// (5) - heat transfer, W/m2K
// (6) - specific heat, J/kgK
// (7) - current fruit temperature, °C
function [RV] = mFruit(dv)
 RV = (dv(2)+dv(4)*dv(5)*3600*(dv(1)-dv(7)))/(dv(6)*dv(3));
endfunction

// Fruit heat transfer function
// Input:
// (1) - temperature
// (2) - reference value, W/m2K
function [RV] = FruitHeatTransfer(dv)
 RV = dv(2);
endfunction

// Fruit specific heat function
// Input:
// (1) - temperature
// (2) - reference value, J/kgK
function [RV] = FruitSpecificHeat(dv)
 RV = dv(2);
endfunction
