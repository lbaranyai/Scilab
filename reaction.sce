// Biochemical reaction
// Author: lbaranyai@github
//
// [E] + [S] <=> [ES] -> [E] + [P]
//
// Input:
// (1) [E]
// (2) [S]
// (3) [ES]
// (4) kon
// (5) koff
// (6) kprod
// Output:
// (1) dE/dt
// (2) dS/dt
// (3) dES/dt
// (4) dP/dt
function RV = Reaction(dv)
 RV = zeros(1,4);
 // dE = -kon*[E]*[S] + (koff + kprod)*[ES]
 RV(1) = -dv(4)*dv(1)*dv(2)+(dv(5)+dv(6))*dv(3);
 // dS = -kon*[E]*[S] + koff*[ES]
 RV(2) = -dv(4)*dv(1)*dv(2)+dv(5)*dv(3);
 // dES = +kon*[E]*[S] - (koff + kprod)*[ES]
 RV(3) = dv(4)*dv(1)*dv(2)-(dv(5)+dv(6))*dv(3);
 // dP = +kprod*[ES]
 RV(4) = dv(6)*dv(3);
endfunction
