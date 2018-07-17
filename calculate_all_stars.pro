PRO calculate_all_stars, ccorr=ccorr, contf=contf, showplot=showplot
  quiet = 1
  showplot = 0

  atrans = MRDFITS('/home/dingy/Desktop/dingy_07_03/idl_lib/tellrv_new/atrans.fits', 0, silent=quiet)
  READCOL, '/home/dingy/Desktop/dingy_07_03/idl_lib/tellrv_new/594id_both_fits_found.txt', stars, skipline=1, format='(A)', silent=quiet
  spec_dir = '/home/dingy/Desktop/dingy_07_03/idl_lib/tellrv_new/all_stars/'

  ; ; METHOD 1: use the standard spectrum as-is
  ;   file = spec_dir+stars[0]+".fits"
  ;   std0 = MRDFITS(file,0,shdr)
  ;   file_tc = spec_dir+stars[0]+"_T.fits"
  ;   std_tc0 = MRDFITS(file_tc, /silent)
  ;   std_tc0[*,0,*]=std0[*,0,*]  ; want to use original wavelength array
  ;   stdrv = rvs[0]

  ; ; METHOD 2: use the wavelength-calibrated standard star
  ;  wlcal = 1
  ;  atrest = 0
  ;  stdrv = rvs[0]
  ;  file_tc = spec_dir+'J0727+0513_wlcal.fits'
  ;  std_tc0 = MRDFITS(file_tc,0, shdr, /silent)
  ;  std0 = std_tc0

  ; ; METHOD 3: use the at-rest standard star created by makemeastandwich
  wlcal = 1
  atrest = 1
  file_tc = spec_dir+'J0727+0513_rest.fits'
  std_tc0 = MRDFITS(file_tc,0, shdr, silent=quiet)
  std0 = std_tc0

  FOR i=0,N_ELEMENTS(stars)-1 DO BEGIN
    std = std0
    std_tc = std_tc0

    star = stars[i]
    file = spec_dir+star+".fits"
    data = MRDFITS(file,0,hdr, silent=quiet)
    file_tc = spec_dir+star+"_T.fits"
    data_tc = MRDFITS(file_tc, silent=quiet)

    print, "==========="
    print, "Star is: ", star
    print, "File is: ", file

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

    print, "RV NIR:  ", median(temp)
  ENDFOR
  print, "==========="
  print, "NOTE: RVs from Newton et al. (2014) include a -2.6 km/s systematic RV correction, not included here."

END