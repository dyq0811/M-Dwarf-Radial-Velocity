PRO print_group_rv, ccorr=ccorr, contf=contf, showplot=showplot
  quiet = 1
  showplot = 0

  atrans = MRDFITS('/home/dingy/Desktop/dingy_07_03/idl_lib/tellrv_new/atrans.fits', 0, silent=quiet)
  READCOL, '/home/dingy/Desktop/dingy_07_03/idl_lib/groups/group1_stars.txt', stars, stars_T, skipline=1, format='(A,A)', silent=quiet
  spec_dir = '/home/dingy/Desktop/dingy_07_03/idl_lib/tellrv_new/all_stars/'

  ; ; METHOD 1: use the standard spectrum as-is
     file = spec_dir+stars[0]
     std0 = MRDFITS(file,0,shdr)
     file_tc = spec_dir+stars_T[0]
     std_tc0 = MRDFITS(file_tc, /silent)
     std_tc0[*,0,*] = std0[*,0,*]  ; want to use original wavelength array
     stdrv = -15.334

  ; ; METHOD 3: use the at-rest standard star created by makemeastandwich
;  wlcal = 1
;  atrest = 1
;  file_tc = spec_dir+'J0727+0513_rest.fits'
;  std_tc0 = MRDFITS(file_tc,0, shdr, silent=quiet)
;  std0 = std_tc0

  print, "STAR RV_NIR "
  FOR i=0,N_ELEMENTS(stars)-1 DO BEGIN
    std = std0
    std_tc = std_tc0

    file = spec_dir+stars[i]
    data = MRDFITS(file,0,hdr, silent=quiet)
    file_tc = spec_dir+stars_T[i]
    data_tc = MRDFITS(file_tc, silent=quiet)

    ;print, "Star is: ", star
    ;print, "File is: ", file

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

    print, stars_T[i], " ", median(temp)
  ENDFOR

END