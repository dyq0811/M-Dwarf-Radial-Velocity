pro test_uvw 
        ra = 6.334727227   & dec = 22.88442282
        pmra = -233.85910499999997  &  pmdec = -463.66437069999995         ;mas/yr
        plx = 61.86627103    &  vrad = -29.63957
        gal_uvw,u,v,w,ra=ra,dec=dec,pmra=pmra,pmdec=pmdec,vrad=vrad,plx=plx,/lsr
        print, u, v, w
        
;        ra = 6.334727227   & dec = 22.88442282
;        pmra = -233.85910499999997  &  pmdec = -463.66437069999995         ;mas/yr
;        dis = 16.16389647139203    &  vrad = -29.63957
;        gal_uvw,u,v,w,ra=ra,dec=dec,pmra=pmra,pmdec=pmdec,vrad=vrad,plx=plx,/lsr
;        print, u, v, w
        
        ra = 61.02730355   & dec = 30.71199322
        pmra = 350.7459265  &  pmdec = -157.3174956       ;mas/yr
        plx = 49.03969581    &  vrad = 2.82716
        gal_uvw,u,v,w,ra=ra,dec=dec,pmra=pmra,pmdec=pmdec,vrad=vrad,plx=plx,/lsr
        print, u, v, w
        
        ra = 160.7532774   & dec = -9.209772971
        pmra = -1977.580318  &  pmdec = 370.1590867         ;mas/yr
        plx = 81.39939106    &  vrad = 42.07193
        gal_uvw,u,v,w,ra=ra,dec=dec,pmra=pmra,pmdec=pmdec,vrad=vrad,plx=plx,/lsr
        print, u, v, w
end