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


PRO print_group_uncertainty, ccorr=ccorr, contf=contf, showplot=showplot
  quiet = 1
  showplot = 0

  atrans = MRDFITS('/home/dingy/Desktop/dingy/idl_lib/tellrv_new/atrans.fits', 0, silent=quiet)
  READCOL, '/home/dingy/Desktop/dingy/idl_lib/groups/late2_standard.txt', stars, stars_T, skipline=1, format='(A,A)', silent=quiet
  spec_dir = '/home/dingy/Desktop/dingy/idl_lib/tellrv_new/all_stars/'

  ; ; METHOD 1: use the standard spectrum as-is
     file = spec_dir+stars[0]
     std0 = MRDFITS(file,0,shdr)
     file_tc = spec_dir+stars_T[0]
     std_tc0 = MRDFITS(file_tc, /silent)
     std_tc0[*,0,*] = std0[*,0,*]  ; want to use original wavelength array
     stdrv = 19.320999999999998

  ; ; METHOD 3: use the at-rest standard star created by makemeastandwich
;  wlcal = 1
;  atrest = 1
;  file_tc = spec_dir+'J0727+0513_rest.fits'
;  std_tc0 = MRDFITS(file_tc,0, shdr, silent=quiet)
;  std0 = std_tc0

  print, "STAR      RV_NIR      RV_ERR_NIR"
  FOR i=0,N_ELEMENTS(stars)-1 DO BEGIN
    std = std0
    std_tc = std_tc0

    file = spec_dir+stars[i]
    data = MRDFITS(file,0,hdr, silent=quiet)
    file_tc = spec_dir+stars_T[i]
    data_tc = MRDFITS(file_tc, silent=quiet)
    data_tc[*,0,*]=data[*,0,*]
    
    rv_list = FltArr(200)
    FOR j=0, 199 DO BEGIN
      data = jitter_pixels_by_error(data)
      data_tc = jitter_pixels_by_error(data_tc)
      temp = FLTARR(3)
      FOR order=0,2 DO BEGIN
        order_variables, hdr, order, wrange, trange, pixscale, polydegree, instrument="spex"
        NIR_RV, data_tc[*,*,order],hdr, data[*,*,order], $
          std_tc[*,*,order],shdr, std[*,*,order], $
          wlcal=wlcal, atrest=atrest, stdrv=stdrv, $
          atrans=atrans, $
          pixscale=pixscale, polydegree=polydegree, $
          spixscale=pixscale, spolydegree=polydegree, $
          wrange=wrange, trange=trange, $
          ccorr=ccorr, contf=contf, $
          showplot=showplot, quiet=quiet, $
          rv = myrv
        if order LT 3 then temp[order] = myrv
      ENDFOR
      rv_list[j] = median(temp)
    ENDFOR

    file = spec_dir+stars[i]
    data = MRDFITS(file,0,hdr, silent=quiet)
    file_tc = spec_dir+stars_T[i]
    data_tc = MRDFITS(file_tc, silent=quiet)
    data_tc[*,0,*]=data[*,0,*]
    
    temp = FLTARR(3)
    FOR order=0,2 DO BEGIN
      order_variables, hdr, order, wrange, trange, pixscale, polydegree, instrument="spex"
      NIR_RV, data_tc[*,*,order],hdr, data[*,*,order], $
        std_tc[*,*,order],shdr, std[*,*,order], $
        wlcal=wlcal, atrest=atrest, stdrv=stdrv, $
        atrans=atrans, $
        pixscale=pixscale, polydegree=polydegree, $
        spixscale=pixscale, spolydegree=polydegree, $
        wrange=wrange, trange=trange, $
        ccorr=ccorr, contf=contf, $
        showplot=showplot, quiet=quiet, $
        rv = myrv
      if order LT 3 then temp[order] = myrv
    ENDFOR
    
    print, stars_T[i], " ", median(temp), " ", STDDEV(rv_list)
    ;print, rv_list
  ENDFOR

END