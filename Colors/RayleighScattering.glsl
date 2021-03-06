// https://www.shadertoy.com/view/ltSBRt
// perception = int( intensity(f) * coneResponse(f) )
// using very heuristical cone response. ( May try with: https://www.shadertoy.com/view/llKSDz )
// missing: solar spectrum ( cut some violet )
/*
https://en.wikipedia.org/wiki/Rayleigh_scattering
Rayleigh scattering (pronounced /ˈreɪli/ RAY-lee), named after the British physicist Lord Rayleigh (John William Strutt)
, is the (dominantly) elastic scattering of light or other electromagnetic radiation by particles much smaller than the 
wavelength of the radiation. Rayleigh scattering does not change the state of material and is, hence, a parametric proce
ss. The particles may be individual atoms or molecules. It can occur when light travels through transparent solids and l
iquids, but is most prominently seen in gases. Rayleigh scattering results from the electric polarizability of the parti
cles. The oscillating electric field of a light wave acts on the charges within a particle, causing them to move at the 
same frequency. The particle therefore becomes a small radiating dipole whose radiation we see as scattered light.
*/
#define N 50.            // spectrum sampling rate

#define RGB(f, fc) ( .5 + .5* cos(3.14*clamp(f-(fc),-1.,1.) ) ) // base lobe approximation
#define EQ(f,a) ( abs(f-(a)) < .5/N )

void mainImage( out vec4 O,  vec2 U )
{
    O -= O;
    vec2 R = iResolution.xy;
    U /= R;
    float y = 6.*U.y, a = fract(y),
          F = 2.*(2.*U.x-1.),
          I, v=0., r;    
    if (a < 6./R.y) return;                        // line separator
    
    for (float f=-2.; f<2.; f+=1./N) {             // --- color spectrum (normalized):
        r = 909.*pow(5.5-f,-4.);                   // Rayleigh scattering ~ 1/lambda^4
        I =   y > 5. ?   EQ(f,F) ? smoothstep(.04,0.,abs(a-r/3.)) : 0. // Rayleigh curve
            : y > 4. ?   EQ(f,F) ? 1. : 0.         // peak at F
            : y > 3. ?      f<F  ? 1. : 0.         // sum from IR to F
            : y > 2. ?      f<F  ? r  : 0.         // with Rayleigh intensity
            : y > 1. ?      f<F  ? 1. : 0.         // sames displayed with chrominance only
            :               f<F  ? r  : 0.;        
        v += I;
        O[0] += I * ( RGB(f, -2./3.)*.7 + RGB(f, 2./3.)*.3);  // perceptive integration
        O[1] += I * RGB(f,  0.   );
        O[2] += I * RGB(f,  2./3.);
    }
    
    if ( y > 2. && y < 4. ) O *= 2./v;
    if ( y < 2. ) O /= max(O.r,max(O.g,O.b));      // chrominance only
    O = pow(O,vec4(1./2.2));                       // RGB to sRGB transform
}
