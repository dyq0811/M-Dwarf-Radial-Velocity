; FUNCTION jitter_pixels_by_error
; Jitter a spectrum by each point's standard errors
; The inputs are 1-d arrays corresponding to the wavelength, flux, and error for one spectral order

FUNCTION jitter_pixels_by_error, wl_in, fl_in, er_in
  wl = double(wl_in) ; make sure the inputs are all double precision
  fl = double(fl_in)
  er = double(er_in)

  nel = N_ELEMENTS(wl)
  deviates = RANDOMU(seed,nel,/normal,/double) * er
  newvals = fl + deviates
  RETURN, newvals
END

;============================================
; FUNCTION jitter_pixels_by_error
; Jitter a spectrum by each point's standard errors
; The inputs are 1-d arrays corresponding to the wavelength, flux, and error for one spectral order

FUNCTION jitter_pixels_by_error, fits_data

  wl_in = fits_data[*,0,*]
  fl_in = fits_data[*,1,*]
  er_in = fits_data[*,2,*]

  wl = double(wl_in)
  fl = double(fl_in)
  er = double(er_in)

  nel = N_ELEMENTS(wl)
  deviates = RANDOMU(seed,nel,/normal,/double) * er
  newvals = fl + deviates

  jittered_data = fits_data
  jittered_data[*,1,*] = newvals
  RETURN, jittered_data
END

;============================================